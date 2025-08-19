public with sharing class QuoteProductSelectionController {

    @AuraEnabled(cacheable=true)
    public static List<Map<String, Object>> getCategoryTree(String recordTypeName) {
        List<Map<String, Object>> treeList = new List<Map<String, Object>>();
        List<ProductGroup__c> categories;

        if (recordTypeName.equals('gazou_quote')) { // 画像診断レコードタイプ
            categories = [SELECT category__c, group__c, uriagekubun__c FROM ProductGroup__c WHERE displayflg_gazou__c = true ORDER BY orderno__c ASC];    
        } else if(recordTypeName.equals('kansen_quote')) { // 感染商談レコードタイプ
            categories = [SELECT category__c, group__c, uriagekubun__c FROM ProductGroup__c WHERE displayflg_kansen__c = true ORDER BY orderno__c ASC];  
        } else if(recordTypeName.equals('ippan_quote')) { // 一般商談レコードタイプ
            categories = [SELECT category__c, group__c, uriagekubun__c FROM ProductGroup__c WHERE displayflg_ippan__c = true ORDER BY orderno__c ASC];    
        } else if(recordTypeName.equals('kani_quote')) { // 発注書商談レコードタイプ
            categories = [SELECT category__c, group__c, uriagekubun__c FROM ProductGroup__c WHERE displayflg_hattyusho__c = true ORDER BY orderno__c ASC]; 
        } else {
            categories = [SELECT category__c, group__c, uriagekubun__c FROM ProductGroup__c ORDER BY orderno__c ASC];
        }

        // カテゴリの階層構造を管理するためのマップを初期化
        // 大カテゴリ -> 中カテゴリ -> 売上区分 という階層を持つマップ
        Map<String, Map<String, List<String>>> categoryMap = new Map<String, Map<String, List<String>>>();

        // 取得したカテゴリのデータを階層的なマップに格納
        for (ProductGroup__c category : categories) {
            // 大カテゴリがマップにない場合、新たに追加
            if (!categoryMap.containsKey(category.category__c)) {
                categoryMap.put(category.category__c, new Map<String, List<String>>());
            }

            // 中カテゴリがマップにない場合、新たに追加
            if (!categoryMap.get(category.category__c).containsKey(category.group__c)) {
                categoryMap.get(category.category__c).put(category.group__c, new List<String>());
            }

            // 売上区分のデータを中カテゴリの下のリストに追加
            categoryMap.get(category.category__c).get(category.group__c).add(category.uriagekubun__c);
        }

        // 上記で作成したマップのデータをもとに、ツリーデータを構築
        for (String bigCategory : categoryMap.keySet()) {
            Map<String, Object> bigCategoryMap = new Map<String, Object>();
            bigCategoryMap.put('label', bigCategory); // ツリーの表示名
            bigCategoryMap.put('name', bigCategory);  // ツリーの内部識別名
            
            List<Map<String, Object>> midCategoryList = new List<Map<String, Object>>();
            for (String midCategory : categoryMap.get(bigCategory).keySet()) {
                Map<String, Object> midCategoryMap = new Map<String, Object>();
                midCategoryMap.put('label', midCategory); // 中カテゴリの表示名
                midCategoryMap.put('name', midCategory);  // 中カテゴリの内部識別名
                
                List<Map<String, Object>> uriageList = new List<Map<String, Object>>();
                for (String uriage : categoryMap.get(bigCategory).get(midCategory)) {
                    uriageList.add(new Map<String, Object>{ 
                        'label' => uriage, 
                        'name' => midCategory + '>' + uriage 
                    }); // 売上区分のデータを追加
                }
                
                // 中カテゴリの下に売上区分のリストを追加
                midCategoryMap.put('items', uriageList);
                midCategoryList.add(midCategoryMap);
            }

            // 大カテゴリの下に中カテゴリのリストを追加
            bigCategoryMap.put('items', midCategoryList);
            treeList.add(bigCategoryMap);
        }

        return treeList;
    }

}