@isTest
public with sharing class LicenseControllerTest {

    private static final String SUCCESS_SFAID = '333333';

    @TestSetup
    private static void makeData() {
        // 取引先の作成
        Account acc = new Account(Name = 'ApecTestAccount',kana__c = 'てすとあかうんと');
        acc.BillingPostalCode = '1350007';
        acc.BillingState = '東京都';
        acc.BillingCity = '江東区';
        acc.BillingStreet = '新大橋';
        acc.sfaid__c = SUCCESS_SFAID;
        insert acc;

        List<license__c> licenseList = new List<license__c>();

        licenseList.add(new License__c(Account__c = acc.id, seihinnaiyo__c = 'クライアントライセンス（Cal)', license_name__c = 'Windows Server Device Cal 2022', suryo__c = 5 ));
        licenseList.add(new License__c(Account__c = acc.id, seihinnaiyo__c = 'クライアントライセンス（Cal)', license_name__c = 'Windows Server Device Cal 2019', suryo__c = 4 ));
        licenseList.add(new License__c(Account__c = acc.id, seihinnaiyo__c = 'クライアントライセンス（Cal)', license_name__c = 'Windows Server 2016', suryo__c = 3 ));
        licenseList.add(new License__c(Account__c = acc.id, seihinnaiyo__c = 'クライアントライセンス（Cal)', license_name__c = 'Windows Server 2016', suryo__c = 2 ));
        licenseList.add(new License__c(Account__c = acc.id, seihinnaiyo__c = 'サーバーライセンス', license_name__c = 'Windows Server Standard 16ｺｱﾗｲｾﾝｽ 2022', suryo__c = 5 ));
        licenseList.add(new License__c(Account__c = acc.id, seihinnaiyo__c = 'サーバーライセンス', license_name__c = 'Windows Server Standard Core 2ｺｱﾗｲｾﾝｽ 2019', suryo__c = 4 ));
        licenseList.add(new License__c(Account__c = acc.id, seihinnaiyo__c = 'サーバーライセンス', license_name__c = 'Windows Server Standard Core 2ｺｱﾗｲｾﾝｽ 2019', suryo__c = 3 ));
        licenseList.add(new License__c(Account__c = acc.id, seihinnaiyo__c = 'サーバーライセンス', license_name__c = 'Windows Server 2012R2', suryo__c = 2 ));
        licenseList.add(new License__c(Account__c = acc.id, seihinnaiyo__c = 'ターミナルサービスライセンス（TSE Cal）', license_name__c = 'Windows Server User Cal 2012', suryo__c = 5 ));
        licenseList.add(new License__c(Account__c = acc.id, seihinnaiyo__c = 'ターミナルサービスライセンス（TSE Cal）', license_name__c = 'Windows Server Device Cal 2019', suryo__c = 4 ));
        licenseList.add(new License__c(Account__c = acc.id, seihinnaiyo__c = 'ターミナルサービスライセンス（TSE Cal）', license_name__c = 'Windows Server Standard User Cal Core 2ｺｱﾗｲｾﾝｽ 2019', suryo__c = 3 ));
        licenseList.add(new License__c(Account__c = acc.id, seihinnaiyo__c = 'ターミナルサービスライセンス（TSE Cal）', license_name__c = 'Windows Rmt Dsktp Service User Cal 2022', suryo__c = 2 ));
        insert licenseList;
    }

    @isTest
    private static void getAccountLicenseTest() {
        // セットアップで作成したレコードを取得する
        List<Account> acc = [SELECT id FROM Account WHERE sfaid__c = :SUCCESS_SFAID];

        Test.startTest();

        List<license__c> accLicense = LicenseController.getAccountLicense(acc[0].Id);

        Test.stopTest();

        System.assertEquals(12, accLicense.size());

    }

    @isTest
    private static void getTotalingLicenseMapTest() {
        // セットアップで作成したレコードを取得する
        List<Account> acc = [SELECT id,sfaid__c FROM Account WHERE sfaid__c = :SUCCESS_SFAID];

        Test.startTest();

        Map<String,Integer> licenseMap = LicenseController.getTotalingLicenseMap(acc[0].Id);

        Test.stopTest();
        // System.assertEquals(1, licenseMap.size());
        for(String key : licenseMap.keySet()){
            System.debug('■'+ key +'-数量：' + licenseMap.get(key));
        }
        // System.assertEquals(5, licenseMap.get('WC05'));
    }

    @isTest
    private static void getTotalingLicenseMapSeeAllTest() {
        // セットアップで作成したレコードを取得する
        List<Account> acc = [SELECT id,sfaid__c FROM Account WHERE sfaid__c = :SUCCESS_SFAID];

        Test.startTest();

        Map<String,Integer> licenseMap = LicenseController.getTotalingLicenseMap(acc[0].Id);

        Test.stopTest();
        // System.assertEquals(1, licenseMap.size());
        for(String key : licenseMap.keySet()){
            System.debug('■'+ key +'-数量：' + licenseMap.get(key));
        }
        // System.assertEquals(5, licenseMap.get('WC05'));
    }
}