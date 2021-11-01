public  class RestCallTesterController {
	
	 public RestCallTesterController(ApexPages.StandardController controller) {
             
     }
     public String getCallOutResponse{get;set;}
     public String getStatus{get;set;}
	 public PageReference CalloutRest(){
	 	
	 	
	 	try{
	 	        HttpRequest req = new HttpRequest();

				//req.setTimeout(20000); 
				String url = 'https://app.enterprisebank.com/SFDCService/Service.asmx/GenerateLoanAppSnapshotForMinute?minuteId=a0g300000051nfx';// + EncodingUtil.urlEncode(idlong, 'UTF-8');
				req.setEndpoint(url);
				req.setMethod('GET');

				Http http = new Http();
				HttpResponse res = http.send(req);
				String body = res.getBody();
				getCallOutResponse = body;
				getStatus = res.getStatus();
	
 				}catch(exception ex){
				ApexPages.addMessages(ex);
			}
	 	 return null;
	 }
	   public static testMethod void verifyRestCallPageReference(){
	   		String url = 'https://cs3.salesforce.com/RestCallTester';
    		    
    		     
				
				 PageReference pr = testhelper(url);
			     test.setCurrentPage(pr);
			     Account acctProspect = testObjectClass.getTestAccount();
				 EB_Loan_Application__c app = testObjectClass.getTestLoanApp(acctProspect);
			     ApexPages.StandardController sc = new Apexpages.Standardcontroller(app);
			     RestCallTesterController testcontroller = new RestCallTesterController(sc);
			     testcontroller.CalloutRest();
	   }
	   public static PageReference testhelper(String url){
                        PageReference newPage = new PageReference(url);
                        newPage.setRedirect(true);
                        return newPage;
      }

}