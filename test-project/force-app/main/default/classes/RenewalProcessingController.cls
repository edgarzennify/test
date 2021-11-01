public  class RenewalProcessingController {
    // Exceptions to handle any erroneous data  
       public RenewalProcessingController() {
       
         GraphOutput();
    } 
    
    public class EncodingException extends Exception {}
    public class UnsupportedEncodingTypeException 
           extends Exception {}  

    
    public String dataSet1 { get; set; }
    public String dataSet2 { get; set; }
     public String getDatasetTotal(){
     	 //dataset1 = '20,30,40|1,2,3';
     	//if (dataset2== '') dataset2 = '20,30,40|1,2,3';
    	String s = 't:' + dataset1 + '|' + dataset2 ;
    	return s;
    }
    
    private void LoanRenewal(){
        Datetime dT = System.now();
        Date ddate = date.newinstance(dT.year(), dT.month(), dT.day()); 
        Date dmax = ddate;
        ddate = ddate.addDays(-365);
        Datetime d = dT.addDays(-365);
        List<sObject> accts = [SELECT Last_Renewal_Date__c LoanRenewalDays , count(name) sumofaccount   FROM EB_Account__c where    Last_Renewal_Date__c  <: dmax and  Last_Renewal_Date__c  >: ddate and Application__c in (11,13,15) and Non_Accrual_Code__c  =: 'N' and Account_Class_Code__c <> '99'  Group By Last_Renewal_Date__c order by Last_Renewal_Date__c  ];
        String Days = '';
        String SumOfAmt = '';
        for(sObject s : accts){
            Days += String.valueOf(ddate.daysBetween(date.valueOf(s.get('LoanRenewalDays'))))  + ',';
            SumOfAmt  += String.valueOf(s.get('sumofaccount'))  + ',';
        //system.debug(logginglevel.info ,String.valueOf(s.get('LoanRenewalDays')) + '-' + String.valueOf(s.get('sumofaccount')) );


        }
        
        Integer i = Days.length();
         if (i > 1){

        Days = Days.substring(0,i - 1);
        Integer j = SumOfAmt.length();
        SumOfAmt = SumOfAmt.substring(0,j - 1);
        }

        Dataset2 = Days + '|' + SumOfAmt  ;
              }
      private void ContractDate(){
        Datetime dT = System.now();
        Date ddate = date.newinstance(dT.year(), dT.month(), dT.day()); 
        Date dmax = ddate;
        ddate = ddate.addDays(-365);
        Datetime d = dT.addDays(-365);
        List<sObject> accts = [SELECT Contract_Date__c LoanRenewalDays , count(name) sumofaccount   FROM EB_Account__c where   Contract_Date__c >: ddate and Contract_Date__c <: dmax and Application__c in (11,13,15) and Non_Accrual_Code__c  =: 'N' and Account_Class_Code__c <> '99' Group By Contract_Date__c order by Contract_Date__c ];
        String Days = '';
        String SumOfAmt = '';
        for(sObject s : accts){
            //Days += String.valueOf(Date.valueOf(s.get('LoanRenewalDays')))  + ',';
            Days += String.valueOf(ddate.daysBetween(date.valueOf(s.get('LoanRenewalDays')))) + ',';
            SumOfAmt  += String.valueOf(s.get('sumofaccount'))  + ',';
        //system.debug(logginglevel.info ,String.valueOf(s.get('LoanRenewalDays')) + '-' + String.valueOf(s.get('sumofaccount')) );


        }
        Integer i = Days.length();
        if (i > 1){
        Days = Days.substring(0,i - 1);
        Integer j = SumOfAmt.length();
        SumOfAmt = SumOfAmt.substring(0,j - 1);
        }

        Dataset1 = Days + '|' + SumOfAmt  ;
      }

    
    // Corresponds to the type of graph selected on the page   
    
    public String graph { get; set; }
    
    // The URL that renders the Google Chart  
    
    public String chartURL { get; set; }  

    // Indicates whether the chart should be displayed   
    
    public Boolean displayChart { get; set; }
    
 
      
    public void GraphOutput(){

        LoanRenewal();
        ContractDate();
        chartURL = 'https://chart.googleapis.com/chart?chxr=0,0,60|1,0,365'
                   + '&amp;chxt=y,x'
                   + '&amp;chs=400x205'
                   + '&amp;cht=lxy'
                   + '&amp;chco=3D7930,000000'
                   + '&amp;chds=0,365,0,60,0,365,0,60'
                   //+ '&amp;chd=t:0,30,60,90,120,150,180,210,240,270,300,330,365|'+ Dataset1 + '|0,30,60,90,120,150,180,210,240,270,300,330,365|'+ Dataset2
                   + '&amp;chd=t:' + Dataset1 + '|' + Dataset2
                   + '&amp;chdl=Loan+Renewal+Day+of+Year|Loan+Maturity+Day+of+Year'
                   + '&amp;chg=14.3,-1,1,6'
                   + '&amp;chls=2|1'
                   + '&amp;chma=0,0,0,5|5'
                   + '&amp;chtt=Historical+Renewal+Processing+Trends';
         //displayChart = true;

    }
   
    public static testMethod void verifyRenewalProcessingFunctions(){	
 		 RenewalProcessingController testcontroller = new RenewalProcessingController();
 		 testcontroller.chartURL = 'http://www.salesforce.com';
 		 testcontroller.dataSet1 = '12,12|23,45';
 		 testcontroller.dataSet2 = '30,40,50|10,45,23';
 		 testcontroller.GraphOutput();
    }
    
    
    
    
   
 
}