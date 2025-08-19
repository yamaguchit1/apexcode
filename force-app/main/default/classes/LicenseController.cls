public with sharing class LicenseController {

    @AuraEnabled(cacheable=True)
    public static List<license__c> getAccountLicense(String AccountId){

        // 取引先のライセンス保有数を取得
        return [SELECT
        id,
        seihinnaiyo__c,
        sfaid__c,
        license_name__c,
        CalLicenseTag__c,
        TseLicenseTag__c,
        ServerLicensetag__c,
        suryo__c
        FROM license__c
        WHERE Account__r.Id = :AccountId
        WITH SECURITY_ENFORCED
        ];
    }

    @AuraEnabled(cacheable=True)
    public static Map<String,Integer> getTotalingLicenseMap(String AccountId){

        // 格納用のマップ
        Map<String,Integer> licenseMap = new Map<String,Integer>();
        // 格納用のマップ

        // 取引先のCALライセンス保有数を取得
        List<license__c> userLicense = [
            SELECT
            CalLicenseTag__c, suryo__c
            FROM license__c
            WHERE Account__r.Id = :accountId and CalLicenseTag__c != null
            WITH SECURITY_ENFORCED
            ORDER BY CalLicenseTag__c
        ];
        if(userLicense.size() > 0){
            System.debug('サイズ：' + userLicense.size());
            // licenseMap = tagTotalMap(licenseMap,userLicense,'CalLicenseTag__c','suryo__c');
            licenseMap = tagTotalMap(licenseMap,userLicense,'CalLicenseTag__c','suryo__c');
        }


        // 取引先のRDPライセンス保有数を取得
        List<license__c> tseLicense = [
            SELECT
            TseLicenseTag__c, suryo__c
            FROM license__c
            WHERE Account__r.Id = :accountId and TseLicenseTag__c != null
            WITH SECURITY_ENFORCED
            ORDER BY TseLicenseTag__c
        ];

        if(tseLicense.size() > 0){
            licenseMap = tagTotalMap(licenseMap,tseLicense,'TseLicenseTag__c','suryo__c');
        }

        // 取引先のサーバーライセンス保有数を取得
        List<license__c> severLicense =[
            SELECT
            ServerLicensetag__c, suryo__c
            FROM license__c
            WHERE Account__r.Id = :accountId and ServerLicensetag__c != null
            WITH SECURITY_ENFORCED
            ORDER BY ServerLicensetag__c
        ];

        if(severLicense.size() > 0){
            licenseMap = tagTotalMap(licenseMap,severLicense,'ServerLicensetag__c','suryo__c');
        }

        return licenseMap;
    }

    private static Map<String,Integer> tagTotalMap(Map<String,Integer> licenseMap, List<license__c> holdLicense, String tagName, String amountName){

        for(license__c lc : holdLicense){
            String tag = String.valueOf(lc.get(tagName));
            System.debug('タグ名：' + tag);
            if(licenseMap.containsKey(tag)){
                Integer suryo = Integer.valueOf(licenseMap.get(tag));
                System.debug('取出数量？：' + suryo);
                System.debug('数量カラム名：' + amountName);
                System.debug('追加数量？：' + lc.get(amountName));
                licenseMap.put(tag, Integer.valueOf(lc.get(amountName)) + suryo);
            } else {
                licenseMap.put(tag, Integer.valueOf(lc.get(amountName)) );
            }
        }

        return licenseMap;
    }
}