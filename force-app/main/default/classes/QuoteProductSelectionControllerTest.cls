@isTest
private class QuoteProductSelectionControllerTest {

    @TestSetup
    static void setup(){
        List<ProductGroup__c> testCategory = new List<ProductGroup__c>();

        ProductGroup__c testCategory1 = new ProductGroup__c(
            Name = 'TestName1',
            category__c = 'TestCategory1', 
            group__c = 'TestGroup1', 
            uriagekubun__c = 'TestUriage1',
            orderno__c = 1,
            displayflg_ippan__c = true
        );
        testCategory.add(testCategory1);

        ProductGroup__c testCategory2 = new ProductGroup__c(
            Name = 'TestName2',
            category__c = 'TestCategory2', 
            group__c = 'TestGroup2', 
            uriagekubun__c = 'TestUriage2',
            orderno__c = 1,
            displayflg_gazou__c = true
        );
        testCategory.add(testCategory2);
        
        ProductGroup__c testCategory3 = new ProductGroup__c(
            Name = 'TestName3',
            category__c = 'TestCategory3', 
            group__c = 'TestGroup3', 
            uriagekubun__c = 'TestUriage3',
            orderno__c = 1,
            displayflg_kansen__c = true
        );
        testCategory.add(testCategory3);

        ProductGroup__c testCategory4 = new ProductGroup__c(
            Name = 'TestName4',
            category__c = 'TestCategory4', 
            group__c = 'TestGroup4', 
            uriagekubun__c = 'TestUriage4',
            orderno__c = 1,
            displayflg_hattyusho__c = true
        );
        testCategory.add(testCategory4);

        insert testCategory;
    }

    @IsTest
    static void testGetCategoryTreeIppanQuote() {
        List<Map<String, Object>> result = QuoteProductSelectionController.getCategoryTree('ippan_quote');
        System.assertEquals(1, result.size(), '返されるレコードが1件ではありません');
    }

    @IsTest
    static void testGetCategoryTreeGazouQuote() {
        List<Map<String, Object>> result = QuoteProductSelectionController.getCategoryTree('gazou_quote');
        System.assertEquals(1, result.size(), '返されるレコードが1件ではありません');
    }

    @IsTest
    static void testGetCategoryTreekansenQuote() {
        List<Map<String, Object>> result = QuoteProductSelectionController.getCategoryTree('kansen_quote');
        System.assertEquals(1, result.size(), '返されるレコードが1件ではありません');
    }

    @IsTest
    static void testGetCategoryTreekaniQuote() {
        List<Map<String, Object>> result = QuoteProductSelectionController.getCategoryTree('kani_quote');
        System.assertEquals(1, result.size(), '返されるレコードが1件ではありません');
    }

    @IsTest
    static void testGetCategoryTreeNoRecordTypeName() {
        List<Map<String, Object>> result = QuoteProductSelectionController.getCategoryTree('');
        System.assertEquals(4, result.size(), '返されるレコードが4件ではありません');
    }

}