public with sharing class ShohinKouseiController {

    @AuraEnabled(cacheable=True)
    public static Map<String, String> getWithProduct(String AccountId , String labelId , String label1, String label2, String label3, String label4, String label5 ){

        // 返り値用のMapクラス
        Map<String, String> denshiKarute = new Map<String,String>();

        List<ShohinKousei__c> withShohin = [
            SELECT Id, Name, kataban__c, Asset__r.Id, Asset__r.shohin_mei__c, accessLicenseCount__c, serverflg__c
            FROM ShohinKousei__c
            WHERE
            nonyusaki__c = :AccountId AND
            Asset__r.shohin_mei__c IN ('With','With_CS') AND
            Asset__r.kyakusaki_nouhinbi__c != null
        ];

        if(withShohin.size() == 0){
            return denshiKarute;
        }
        String assetId = '';
        String shohinmei = '';
        List<String> serverKataban = new List<String>();
        String exretnalTools = '';
        Decimal licenseCount = 0;
        Integer severCount = 0;

        for(ShohinKousei__c shohin : withShohin){

            // 納入商品IDと商品名を取得
            if(assetId == '' && shohinmei == '') {
                assetId = shohin.Asset__r.id;
                shohinmei = shohin.Asset__r.shohin_mei__c;
            }

            //アクセスライセンス数の加算
            licenseCount += shohin.accessLicenseCount__c;

            // 連携ソフトウェアの取得
            if(shohin.name.contains('連携')) {
                exretnalTools += shohin.Name;
                exretnalTools += '、';
            }

            // サーバーフラグが真の商品型番を取得
            if( shohin.serverflg__c == true ) {
                // 空白前の文字列をサーバー型番として入れる
                String kataban = shohin.kataban__c;
                if(kataban.contains(' ')){
                    kataban = kataban.substring(0,kataban.indexOf(' '));
                }
                if(kataban.contains('(')){
                    kataban = kataban.substring(0,kataban.indexOf('('));
                }
                serverKataban.add(kataban);
                severCount += 1;
            }
        }

        // 取得した値を返り値変数にセット
        denshiKarute.put(labelId , assetId);
        denshiKarute.put(label1 , shohinmei);
        denshiKarute.put(label2 , String.join(serverKataban, ','));
        denshiKarute.put(label3 , String.valueOf(severCount));
        denshiKarute.put(label4 , String.valueOf(licenseCount) );
        denshiKarute.put(label5 , exretnalTools.removeEnd('、'));

        return denshiKarute;

    }

    @AuraEnabled(cacheable=True)
    public static Map<String, String> getVisualmaxProduct(String AccountId, String labelId , String label1, String label2, String label3, String label4 ){

        // 返り値用のMapクラス
        Map<String, String> visualmax = new Map<String,String>();

        List<ShohinKousei__c> vmaxShohin = [
            SELECT Id, Name, kataban__c, Asset__r.Id, Asset__r.shohin_mei__c, accessLicenseCount__c, serverflg__c
            FROM ShohinKousei__c
            WHERE
            nonyusaki__c = :AccountId AND
            Asset__r.shohin_mei__c IN ('VM_3','VM_3プラス','VM_DH','VM_2') AND
            Asset__r.kyakusaki_nouhinbi__c != null
        ];

        if(vmaxShohin.size() == 0){
            return visualmax;
        }

        String assetId = '';
        String shohinmei = '';
        List<String> serverKataban = new List<String>();
        Decimal licenseCount = 0;
        Integer severCount = 0;

        // 納入商品IDと商品名を取得
        for(ShohinKousei__c shohin : vmaxShohin) {
            if(assetId == '' && shohinmei == '') {
                assetId = shohin.Asset__r.id;
                shohinmei = shohin.Asset__r.shohin_mei__c;
            }

            //アクセスライセンス数の加算
            licenseCount += shohin.accessLicenseCount__c;

            // サーバーフラグが真の商品型番を取得
            if( shohin.serverflg__c == true ) {
                String kataban = shohin.kataban__c;
                if(kataban.contains(' ')){
                    kataban = kataban.substring(0,kataban.indexOf(' '));
                }
                if(kataban.contains('(')){
                    kataban = kataban.substring(0,kataban.indexOf('('));
                }
                serverKataban.add(kataban);
                severCount += 1;
            }
        }

        // 取得した値を返り値変数にセット
        visualmax.put(labelId , assetId);
        visualmax.put(label1 , shohinmei);
        visualmax.put(label2 , String.join(serverKataban, ','));
        visualmax.put(label3 , String.valueOf(severCount));
        visualmax.put(label4 , String.valueOf(licenseCount) );

        return visualmax;

    }
}