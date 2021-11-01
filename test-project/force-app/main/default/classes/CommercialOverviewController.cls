global with sharing class CommercialOverviewController {
  private static final String WITHDRAWN = 'Withdrawn';
  public String stageCountJson {get; set;}
  public String stagesJson {get; set;}
  public List<Commercial_Overview__c> stages {get; set;}
  
  // This constructor is here for the test drivers
  public CommercialOverviewController() {
    setupData();
  }
    public CommercialOverviewController(ApexPages.StandardController stdController) {
      setupData();
    }
    private void setupData(){
      List<String> stageNames = new List<String>();
      Map<String, Integer> stageCount = new Map<String, Integer>();
    stages = getSLDConfig();

    for(Commercial_Overview__c c : stages){
      stageNames.add(c.Stage__c);
      stageCount.put(+c.Stage__c, 0);
    }

    List<aggregateResult> results = [
      SELECT 
        count(Id) counter, 
        LLC_BI__Stage__c stage 
      FROM 
        LLC_BI__Loan__c 
      WHERE 
         (LLC_BI__Product_Line__c = 'Commercial/Business'
        OR
          LLC_BI__Product_Line__c = 'Consumer'
        OR
          LLC_BI__Product_Line__c = 'EHL Mortgage')
      GROUP BY 
        LLC_BI__Stage__c];
    
    for (AggregateResult ar : results) {
      stageCount.put((String)ar.get('stage'), (Integer)ar.get('counter'));
    }
        
    stageCountJson = JSON.serialize(stageCount);
    stagesJson = JSON.serialize(stages);
    }
    
    private Commercial_Overview__c[] getSLDConfig(){
      return [
        SELECT 
          Name, 
          Stage__c, 
          Custom_Label_Key__c, 
          Link_URL__c, 
          IconImageName__c, 
          IconStyleClass__c, 
          Flow_Setting__c, 
          StaticResourceName__c
        FROM 
          Commercial_Overview__c
        WHERE 
          Active__c = true
        ORDER BY 
          Active__c, 
          Display_Order__c
        ];
    }
}