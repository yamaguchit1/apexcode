@isTest
private class ShohinKouseiControllerTest {

    private static final String SUCCESS_SFAID = '444444';

    @TestSetup
    private static void makeData(){
        // 取引先の作成
        Account acc = new Account(Name = 'ApecTestAccount',kana__c = 'てすとあかうんと');
        acc.BillingPostalCode = '1130033';
        acc.BillingState = '東京都';
        acc.BillingCity = '文京区';
        acc.BillingStreet = '本郷';
        acc.sfaid__c = SUCCESS_SFAID;
        insert acc;

        // ライセンスの作成
        List<license__c> lcList = new List<license__c>();
        lcList.add(new license__c(seihinnaiyo__c='サーバーライセンス' , license_name__c = 'Windows Server Standard 16ｺｱﾗｲｾﾝｽﾊﾟｯｸ 2022', Account__c = acc.id, suryo__c = 1 ));
        lcList.add(new license__c(seihinnaiyo__c='サーバーライセンス' , license_name__c = 'Windows Server 2016', Account__c = acc.id, suryo__c = 1 ));
        insert lcList;

        // 納入商品の作成 電子カルテ
        Asset karute_asset = new Asset(Name = 'With', shohin_shubetsu__c = 'ICT製品', shohin_kubun__c = '電子カルテ', shohin_mei__c = 'With', kyakusaki_nouhinbi__c = Date.newInstance(2022, 4, 10) ,nonyusaki__c = acc.id, AccountId = acc.id);
        insert karute_asset;

        // 商品構成の作成
        List<ShohinKousei__c> withShohin = new List<shohinKousei__c>();
        withShohin.add(new shohinkousei__c(Name = '電子ｶﾙﾃｻｰﾊﾞｰ', kataban__c = 'N8100-2987Y', kyakusaki_nouhinbi__c = Date.newInstance(2022, 4, 10), Asset__c = karute_asset.id, pc__c = 'S01'));
        withShohin.add(new shohinkousei__c(Name = '電子ｶﾙﾃｻｰﾊﾞｰ', kataban__c = 'P12423Y-ME-2342', kyakusaki_nouhinbi__c = Date.newInstance(2022, 4, 10), Asset__c = karute_asset.id, pc__c = 'S02'));
        withShohin.add(new shohinkousei__c(Name = '電子ｶﾙﾃｻｰﾊﾞｰ', kataban__c = 'PY235235T-23523', kyakusaki_nouhinbi__c = Date.newInstance(2022, 4, 10), Asset__c = karute_asset.id, pc__c = 'S03'));
        withShohin.add(new shohinkousei__c(Name = '電子ｶﾙﾃｻｰﾊﾞｰ', kataban__c = 'PC-32532MK-52342', kyakusaki_nouhinbi__c = Date.newInstance(2022, 4, 10), Asset__c = karute_asset.id, pc__c = 'S04'));
        withShohin.add(new shohinkousei__c(Name = '電子ｶﾙﾃｻｰﾊﾞｰ', kataban__c = 'TX1345342320-249238', kyakusaki_nouhinbi__c = Date.newInstance(2022, 4, 10), Asset__c = karute_asset.id, pc__c = 'S05'));
        withShohin.add(new shohinkousei__c(Name = '電子ｶﾙﾃﾗｲｾﾝｽ', kyakusaki_nouhinbi__c = Date.newInstance(2022, 4, 10), Asset__c = karute_asset.id));
        withShohin.add(new shohinkousei__c(Name = '電子ｶﾙﾃﾗｲｾﾝｽ(5)', kyakusaki_nouhinbi__c = Date.newInstance(2022, 4, 10), Asset__c = karute_asset.id));
        withShohin.add(new shohinkousei__c(Name = '電子ｶﾙﾃﾗｲｾﾝｽ(10)', kyakusaki_nouhinbi__c = Date.newInstance(2022, 4, 10), Asset__c = karute_asset.id));
        withShohin.add(new shohinkousei__c(Name = '電子ｶﾙﾃﾗｲｾﾝｽ(15)', kyakusaki_nouhinbi__c = Date.newInstance(2022, 4, 10), Asset__c = karute_asset.id));
        withShohin.add(new shohinkousei__c(Name = '電子ｶﾙﾃﾗｲｾﾝｽ(20)', kyakusaki_nouhinbi__c = Date.newInstance(2022, 4, 10), Asset__c = karute_asset.id));
        withShohin.add(new shohinkousei__c(Name = '電子ｶﾙﾃﾗｲｾﾝｽ(25)', kyakusaki_nouhinbi__c = Date.newInstance(2022, 4, 10), Asset__c = karute_asset.id));
        withShohin.add(new shohinkousei__c(Name = '電子ｶﾙﾃﾗｲｾﾝｽ(30)', kyakusaki_nouhinbi__c = Date.newInstance(2022, 4, 10), Asset__c = karute_asset.id));
        withShohin.add(new shohinkousei__c(Name = '外部ﾂｰﾙ連携ｿﾌﾄｳｪｱ', kataban__c = 'MOTIRA', kyakusaki_nouhinbi__c = Date.newInstance(2022, 4, 10), Asset__c = karute_asset.id));
        insert withShohin;

        // 納入商品の作成 電子カルテ
        Asset vmax_asset = new Asset(Name = 'VM3', shohin_shubetsu__c = 'ICT製品', shohin_kubun__c = 'VM', shohin_mei__c = 'VM_3', kyakusaki_nouhinbi__c = Date.newInstance(2022, 4, 10) ,nonyusaki__c = acc.id, AccountId = acc.id);
        insert vmax_asset;

        // 商品構成の作成
        List<ShohinKousei__c> vmaxShohin = new List<shohinKousei__c>();
        vmaxShohin.add(new shohinkousei__c(Name = 'V-MAXｻｰﾊﾞｰ', kataban__c = 'PC-MK917497', kyakusaki_nouhinbi__c = Date.newInstance(2022, 4, 10), Asset__c = vmax_asset.id, pc__c = 'S01'));
        vmaxShohin.add(new shohinkousei__c(Name = 'V-MAXｻｰﾊﾞｰ', kataban__c = 'JacS1934530-1231297', kyakusaki_nouhinbi__c = Date.newInstance(2022, 4, 10), Asset__c = vmax_asset.id, pc__c = 'S02'));
        vmaxShohin.add(new shohinkousei__c(Name = 'V-MAXｻｰﾊﾞｰ', kataban__c = 'JEcsasc180-243t2412313', kyakusaki_nouhinbi__c = Date.newInstance(2022, 4, 10), Asset__c = vmax_asset.id, pc__c = 'S03'));
        vmaxShohin.add(new shohinkousei__c(Name = 'V-MAXｻｰﾊﾞｰ', kataban__c = 'EascHa-2324g45098', kyakusaki_nouhinbi__c = Date.newInstance(2022, 4, 10), Asset__c = vmax_asset.id, pc__c = 'S04'));
        vmaxShohin.add(new shohinkousei__c(Name = 'V-MAXｻｰﾊﾞｰ', kataban__c = 'EascaF-1245g4212', kyakusaki_nouhinbi__c = Date.newInstance(2022, 4, 10), Asset__c = vmax_asset.id, pc__c = 'S05'));
        vmaxShohin.add(new shohinkousei__c(Name = 'V-MAXライセンス', kyakusaki_nouhinbi__c = Date.newInstance(2022, 4, 10), Asset__c = vmax_asset.id));
        vmaxShohin.add(new shohinkousei__c(Name = 'ﾋﾞｼﾞｭｱﾙﾏｯｸｽﾗｲｾﾝｽ', kyakusaki_nouhinbi__c = Date.newInstance(2022, 4, 10), Asset__c = vmax_asset.id));
        vmaxShohin.add(new shohinkousei__c(Name = 'V-MAXﾗｲｾﾝｽ(5)', kyakusaki_nouhinbi__c = Date.newInstance(2022, 4, 10), Asset__c = vmax_asset.id));
        vmaxShohin.add(new shohinkousei__c(Name = 'V-MAXﾗｲｾﾝｽ(10)', kyakusaki_nouhinbi__c = Date.newInstance(2022, 4, 10), Asset__c = vmax_asset.id));
        vmaxShohin.add(new shohinkousei__c(Name = 'V-MAXﾗｲｾﾝｽ(15)', kyakusaki_nouhinbi__c = Date.newInstance(2022, 4, 10), Asset__c = vmax_asset.id));
        vmaxShohin.add(new shohinkousei__c(Name = 'V-MAXﾗｲｾﾝｽ(20)', kyakusaki_nouhinbi__c = Date.newInstance(2022, 4, 10), Asset__c = vmax_asset.id));
        vmaxShohin.add(new shohinkousei__c(Name = 'V-MAXﾗｲｾﾝｽ(25)', kyakusaki_nouhinbi__c = Date.newInstance(2022, 4, 10), Asset__c = vmax_asset.id));
        vmaxShohin.add(new shohinkousei__c(Name = 'V-MAXﾗｲｾﾝｽ(30)', kyakusaki_nouhinbi__c = Date.newInstance(2022, 4, 10), Asset__c = vmax_asset.id));
        vmaxShohin.add(new shohinkousei__c(Name = '外部ﾂｰﾙ連携ｿﾌﾄｳｪｱ', kataban__c = 'MOTIRA', kyakusaki_nouhinbi__c = Date.newInstance(2022, 4, 10), Asset__c = vmax_asset.id));
        insert vmaxShohin;

    }

    // 納入商品・商品構成・ライセンスが全てある医院
    // With納入商品の取得テスト
    @isTest
    static void getWithExistProduct() {

        String AccountId = [SELECT id, Name, kana__c FROM Account WHERE sfaid__c = :SUCCESS_SFAID ].id;

        Test.startTest();
        System.debug('検索取引先：' + AccountId);
        Map<String, String> with = ShohinKouseiController.getWithProduct(AccountId, 'id' ,'shohin' ,'server'  ,'sCount'  ,'lCount', 'renkei');

        System.debug('サイズ結果:' + with.size());
        for(String key : with.keySet()) {
            System.debug('内容:' + key + '：' + with.get(key));
        }

        Test.stopTest();

        System.assert(with.size() > 0);
        System.assertEquals('With', with.get('shohin'));
        System.assertEquals('N8100-2987Y', with.get('server'));
        System.assertEquals('1', with.get('sCount'));
        System.assertEquals('106', with.get('lCount'));
        System.assertEquals('外部ﾂｰﾙ連携ｿﾌﾄｳｪｱ', with.get('renkei'));

    }

    // 納入商品・商品構成・ライセンスが全てある医院
    // VisualMax納入商品の取得テスト
    @isTest
    static void getVisualmaxExistProduct() {

        String AccountId = [SELECT id, Name, kana__c FROM Account WHERE sfaid__c = :SUCCESS_SFAID ].id;

        Test.startTest();
        System.debug('検索取引先：' + AccountId);
        Map<String, String> vmax = ShohinKouseiController.getVisualmaxProduct(AccountId, 'id' ,'shohin' ,'server'  ,'sCount'  ,'lCount');
        System.debug('サイズ結果:' + vmax.size());

        for(String key : vmax.keySet()) {
            System.debug('内容:' + key + '：' + vmax.get(key));
        }

        Test.stopTest();

        System.assert(vmax.size() > 0);
        System.assertEquals('VM_3', vmax.get('shohin'));
        System.assertEquals('PC-MK917497', vmax.get('server'));
        System.assertEquals('1', vmax.get('sCount'));
        System.assertEquals('107', vmax.get('lCount'));

    }

    // データのない取引先
    // With納入商品の取得テスト
    @isTest
    static void getWithNoneProduct() {

        String AccountId = 'NONEAC';

        Test.startTest();
        System.debug('検索取引先：' + AccountId);
        Map<String, String> with = ShohinKouseiController.getWithProduct(AccountId, 'id' ,'1'  ,'2'  ,'3'  ,'4'  , '5');

        System.debug('サイズ結果:' + with.size());

        for(String key : with.keySet()) {
            System.debug('内容:' + key + '：' + with.get(key));
        }

        Test.stopTest();

        System.assertEquals(0, with.size());

    }

    // データのない取引先
    // VisualMax納入商品の取得テスト
    @isTest
    static void getVisualmaxNoneProduct() {

        String AccountId = 'NONEAC';

        Test.startTest();
        System.debug('検索取引先：' + AccountId);
        Map<String, String> vmax = ShohinKouseiController.getVisualmaxProduct(AccountId , 'id' ,'1'  ,'2'  ,'3'  ,'4' );

        System.debug('サイズ結果:' + vmax.size());

        for(String key : vmax.keySet()) {
            System.debug('内容:' + key + '：' + vmax.get(key));
        }

        Test.stopTest();

        System.assertEquals(0, vmax.size());

    }

}