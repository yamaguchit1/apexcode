public class KanaSearchController {
  /* 検索結果リスト */
  transient public List<Account> results {get;set;}

  /* 検索条件取得用 */
  public Account conditions {get;set;}
  public String kana {get;set;}
  public String address {get;set;}
    
  /* 結果表示フラグ */
  /* 0 - 初期 , 1 - 検索結果あり , 2 - 検索結果なし , 3 - 表示件数超過 */
  public Integer resultFlg {get;set;}
  
  /* 表示結果件数上限 1000件を超えるとVF側でエラー発生 */
  public Integer MaxResultLines {get;set;} 
  
    
  public KanaSearchController(){
      MaxResultLines = 500;
      this.conditions = new Account();
      this.results = new List<Account>();
      this.kana = '';
      this.address = '';
      resultFlg = 0;
  }
  public void search(){
    try {
        
        /* ふりがな未入力の場合、結果を空で返す */
        if(this.kana == ''){
            resultFlg = 2;
            return;
        }
        String conditionSql = this.getWhere();
        String soql = 
              'SELECT ' 
            + 'Id,sfaid__c,Name,address_hyoji__c,Phone '
            + 'FROM Account ' + conditionSql
            + 'ORDER BY BillingPostalCode';

        this.results = database.query(soql);

        if(this.results.size() == 0 ){
            resultFlg = 2;
        } else if(this.results.size() > MaxResultLines){
            resultFlg = 3;
        } else {
            resultFlg = 1;
        }
        return;

        } catch(Exception e) {
            ApexPages.addMessages(e);
            resultFlg = 2;
        }
   }
   private String getWhere() {
     List<String> param = new List<String>();
     if (this.kana != '') {
         param.add('kana__c LIKE \'%' + this.kana + '%\'');
     }
     if (this.address != '') {
         param.add('address_hyoji__c LIKE \'%' + this.address + '%\'');
     }
     return 'WHERE ' + String.join(param, ' AND ');
    }
 }