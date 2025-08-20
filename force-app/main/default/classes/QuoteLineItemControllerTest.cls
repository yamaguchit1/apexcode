@isTest
private class QuoteLineItemControllerTest {

    static Quote q;

    @TestSetup
    static void setup(){

        Account acc = new Account(Name = 'ApecTestAccount', kana__c = 'てすとあかうんと', BillingPostalCode = '1130033', BillingState = '東京都', BillingCity = '文京区', BillingStreet = '本郷');
        insert acc;
        Opportunity opp = new Opportunity(Name = 'TestOpp', CloseDate = Date.today(), StageName = 'Prospecting', AccountId = acc.Id);
        insert opp;
        Product2 prod = new Product2(Name = 'TestProduct', product_group__c = 'With版', kataban__c = 'TestKataban', Description = 'Test説明');
        insert prod;
        // 標準価格表のIDを取得
        Id standardPBId = System.Test.getStandardPricebookId();
        // 標準価格表にエントリを作成
        PricebookEntry standardPbEntry = new PricebookEntry();
        standardPbEntry.Pricebook2Id = standardPBId;
        standardPbEntry.Product2Id = prod.Id;
        standardPbEntry.UnitPrice = 10000;
        standardPbEntry.IsActive = TRUE;
        insert standardPbEntry;

        Pricebook2 customPricebook = new Pricebook2(Name='TestPricebook', Description='Test説明');
        insert customPricebook;

        // カスタム価格表にエントリを作成
        PricebookEntry customPbEntry = new PricebookEntry();
        customPbEntry.Pricebook2Id = customPricebook.Id;
        customPbEntry.Product2Id = prod.Id;
        customPbEntry.UnitPrice = 10000;
        customPbEntry.uriagekubun__c ='ｻｰﾊﾞｰ機器';
        customPbEntry.IsActive = TRUE;
        insert customPbEntry;

        // 見積
        Quote q = new Quote(Name='TestQuote', OpportunityId=opp.Id, Pricebook2Id=customPricebook.Id);
        insert q;

        // 見積品目名レコードの作成
        QuoteLineItem qli = new QuoteLineItem(
            QuoteId = q.Id,
            PricebookEntryId = customPbEntry.Id,
            Quantity = 2,
            UnitPrice = 10000,
            orderNo__c = 1
        );
        insert qli;

    }

    @isTest
    static void testGetProductsByUriage() {
        Quote q = [SELECT Id FROM Quote WHERE Name = 'TestQuote' LIMIT 1];
        // メソッドの実行
        List<Map<String, Object>> result = QuoteLineItemController.getProductsByUriage(q.Id, 'ｻｰﾊﾞｰ機器', 'With版');
        System.assertEquals(1, result.size(), '取得したレコードが１件ではありません');
    }

    @isTest
    static void testGetQuoteLineItemList() {
        Quote q = [SELECT Id FROM Quote WHERE Name = 'TestQuote' LIMIT 1];
        List<QuoteLineItem> result = QuoteLineItemController.getQuoteLineItemList(q.Id);
        System.assertEquals(1, result.size(), '取得したレコードが１件ではありません');
    }

    @isTest
    static void testSaveRecordsUpsert() {
        Quote q = [SELECT Id, Pricebook2Id FROM Quote WHERE Name = 'TestQuote' LIMIT 1];
        Product2 prod = [SELECT Id FROM Product2 WHERE Name = 'TestProduct' LIMIT 1];
        PricebookEntry pbEntry = [SELECT Id FROM PricebookEntry WHERE Product2Id = :prod.Id AND Pricebook2Id = :q.Pricebook2Id LIMIT 1];
        
        // upsert用の新しいレコードを作成
        QuoteLineItem newQli = new QuoteLineItem(QuoteId = q.Id, PricebookEntryId = pbEntry.Id, Quantity = 3, UnitPrice = 15000);
        List<QuoteLineItem> upsertRecords = new List<QuoteLineItem>{newQli};
        List<QuoteLineItem> result = QuoteLineItemController.saveRecords(new List<QuoteLineItem>(), upsertRecords, null);
        
        System.assertEquals(1, result.size(), 'upsertされたレコードが1件ではありません');
    }

    @isTest
    static void testSaveRecordsUpdate() {
        Quote q = [SELECT Id, Name FROM Quote WHERE Name = 'TestQuote' LIMIT 1];
        // 更新
        q.Name = 'UpdatedTestQuote';
        QuoteLineItemController.saveRecords(new List<QuoteLineItem>(), new List<QuoteLineItem>(), q);
        Quote updatedQuote = [SELECT Id, Name FROM Quote WHERE Id = :q.Id LIMIT 1];
        
        System.assertEquals('UpdatedTestQuote', updatedQuote.Name, 'Nameが正しく更新されていません');
    }

    @isTest
    static void testGetQuote() {
        Quote q = [SELECT Id FROM Quote WHERE Name = 'TestQuote' LIMIT 1];
        Quote resultQuote = QuoteLineItemController.getQuote(q.Id);
        
        System.assertNotEquals(null, resultQuote, '取得したQuoteがnullです');
    }

}