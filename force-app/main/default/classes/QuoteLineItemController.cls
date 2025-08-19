public with sharing class QuoteLineItemController {

    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getProductsByUriage(String quoteId, String uriageKubun, String midCategory) {
        
        List<Map<String, Object>> productsWithPrice = new List<Map<String, Object>>();
        
        try {
            Quote q = [SELECT Pricebook2Id FROM Quote WHERE Id = :quoteId LIMIT 1];
            
            if (q != null && q.Pricebook2Id != null) {

                String queryCondition = '';
                if (String.isNotEmpty(midCategory) && String.isNotEmpty(uriageKubun)) {
                    queryCondition = 'Product2.product_group__c INCLUDES (:midCategory) AND uriagekubun__c = :uriageKubun';
                } else if (String.isNotEmpty(midCategory)) {
                    queryCondition = 'Product2.product_group__c INCLUDES (:midCategory)';
                } 

                String queryString = 
                        'SELECT Id, Product2.Name, Product2.kataban__c, Product2.Description, '
                        + 'UnitPrice, Genka__c, AdjustmentCost__c, uriagekubun__c, Product2.product_group__c, unitprice_change_accept_flg__c, except_arari__c, uriagekubun_category__c, Product2.hyojijun__c, Product2.product_exchange__c '
                        + 'FROM PricebookEntry '
                        + 'WHERE Pricebook2Id = \'' + q.Pricebook2Id + '\' '
                        + 'AND IsActive = TRUE '                                                                   //価格表エントリの有効フラグがTRUE、
                        + 'AND (startdate__c = null OR startdate__c <= TODAY) '                                    //利用開始日がBLANKもしくは未来日でないこと
                        + 'AND (Product2.hanbai_enddate_del__c = null OR Product2.hanbai_enddate_del__c > TODAY)' //商品の販売終了日がBLANKもしくは今日より未来であること
                        + 'AND  Product2.nogroup_flg__c = false '; //商品グループが設定済みであること
                if(String.isNotEmpty(queryCondition)) {
                    queryString += 'AND ' + queryCondition + ' ';
                }
                queryString += 'ORDER BY Product2.hyojijun__c ASC';

                List<PricebookEntry> entries = Database.query(queryString);

                for (PricebookEntry entry : entries) {
                    productsWithPrice.add(new Map<String, Object>{
                        'Id' => entry.Id,
                        'Name' => entry.Product2.Name,
                        'kataban__c' => entry.Product2.kataban__c,
                        'Description' => entry.Product2.Description,
                        'UnitPrice' => entry.UnitPrice,
                        'Genka__c' => entry.Genka__c,
                        'AdjustmentCost__c' => entry.AdjustmentCost__c,
                        'uriagekubun__c' => entry.uriagekubun__c,
                        'product_group__c' => entry.Product2.product_group__c,
                        'unitprice_change_accept_flg__c' => entry.unitprice_change_accept_flg__c,
                        'except_arari__c' => entry.except_arari__c,
                        'uriagekubun_category__c' => entry.uriagekubun_category__c,
                        'hyojijun__c' => entry.Product2.hyojijun__c,
                        'product_exchange__c' => entry.Product2.product_exchange__c
                    });
                }
            }
        } catch(Exception e) {
            System.debug('Error: ' + e.getMessage());
        }
        
        return productsWithPrice;
    }

    // 見積を取得
    @AuraEnabled
    public static Quote getQuote(Id quoteId){
        Quote quote = [
            SELECT Id, hardware_nebiki__c, software_nebiki__c, option_nebiki__c, zansai_cost__c,
            tuika_nebiki_genka__c, dairiten_shiharaigaku__c, shokaisha_tesuryo__c, lease_free_month__c, lease_free_month_campaign__c, hoshu_charge_genka__c, lease_rate__c, decide_flg__c,dairiten_commissionrate__c,
            Description, Status, Opportunity.AccountId, Opportunity.SalesAccountId__c
            FROM Quote
            WHERE Id = :quoteId
            LIMIT 1
        ];

        return quote;
    }

    // 関連する見積品目を取得
    @AuraEnabled
    public static List<QuoteLineItem> getQuoteLineItemList(Id quoteId){
        List<QuoteLineItem> quoteLineItemList = [
            SELECT Id, PricebookEntry.Id, orderNo__c, PricebookEntry.uriagekubun__c, PricebookEntry.Name, Product2.kataban__c, Product2.Description, UnitPrice, genka__c,
            adjustmentcost__c, Quantity, uriagekubun_category__c, PricebookEntry.unitprice_change_accept_flg__c, PricebookEntry.except_arari__c,
            PricebookEntry.Genka__c, PricebookEntry.AdjustmentCost__c, exchange_flg__c, changed_genka__c, changed_price__c, PricebookEntry.UnitPrice,
            systemkitting_cost__c
            FROM QuoteLineItem
            WHERE QuoteId = :quoteId
            ORDER BY orderNo__c ASC
            LIMIT 50000
        ];

        if (quoteLineItemList == null) {
            return null;
        }

        // 取得時に orderNo__c を上書きする処理
        for (Integer i = 0 ; i < quoteLineItemList.size() ; i++) {
            quoteLineItemList.get(i).orderNo__c = i + 1;
        }

        return quoteLineItemList;
    }
    
    @AuraEnabled // レコード数上限 合計10000件
    public static List<QuoteLineItem> saveRecords(List<QuoteLineItem> deleteRecords, List<QuoteLineItem> upsertRecords, Quote quoteRecord){
        System.debug(deleteRecords);
        if(deleteRecords != null) {
            delete deleteRecords; 
        }
        System.debug(upsertRecords);
        if(upsertRecords != null) {
            upsert upsertRecords;
        }
        System.debug(quoteRecord);
        if(quoteRecord != null) {
            update quoteRecord;
        }

        return upsertRecords;
    }
}