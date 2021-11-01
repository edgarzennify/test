public  class LoanAppBorrowerAddController {
    String url = '';
  
    Account entity;
    EB_Loan_Application__c loanApp ;
    Id LoanAppId;
    List<RecordType> recordTypeList = null;
    public String getLoanApplicationName{get;set;}
    public String searchParam{get;set;}
    public Id dropdownEntityId{get;set;}
    
    public LoanAppBorrowerAddController(ApexPages.StandardController controller) {
        string serverurl = Utility.getServerUrl() + '/';
        if(url == '') url = serverurl;
        getRefineSearchStatus = 'false';
        initialize();               
    }
    
    private void initialize(){
        
        try{
                
             this.LoanAppId = apexpages.currentpage().getparameters().get('aid');
                 
        }catch(exception ex){
                this.LoanAppId = null;
        }
        if(this.LoanAppId != null){
                try{
                                
                        this.loanApp = [SELECT Id, Account_Number__c, Name, Closing_Date__c FROM EB_Loan_Application__c WHERE Id =: this.LoanAppId limit 1 ];
                        getLoanApplicationName =loanApp.Name;
                               
                }catch(exception ex){
                        loanApp = null;
                        getLoanApplicationName = ' error';
                }
        }
    }
    
    public String getLoanAppSelected(){
        return loanApp.Name;
    }

    public List<Account> getEntityObjects(){
    	return getUnmatchedClientNameObjectList(searchParam);
    	
    }
    public Boolean getSearchClicked(){
        if(searchParam == null || searchParam == '') return false;
        return true;
    }

    public Boolean getMatchesFound(){
        if(getSearchClicked() == true){
            if(getEntityObjects().size() > 0) return true;
        }
        return false;
    }
    public Boolean getNoMatchesFound(){
        if(getSearchClicked() == true){
            if(getEntityObjects().size() == 0) return true;
        }
        return false;
    }
    public String getRefineSearchStatus{set;get;}
    
    private List<Account> getUnmatchedClientNameObjectList(String currentSelectedOption){
	            getRefineSearchStatus = 'false';
		        String searchTerm = currentSelectedOption;   
		         
		        if(searchTerm == null || searchTerm == '') return null;
		        if(searchTerm.length() == 1)  searchTerm =  searchTerm + '%' ;
     
                Map<Id , EB_Loan_App_Entity_Relationship__c> relMap = new Map<Id, EB_Loan_App_Entity_Relationship__c>();
                if(loanappid != null) {
               
	                for(EB_Loan_App_Entity_Relationship__c r : [SELECT Id, Entity_Name__c , Loan_Application_ID__c FROM EB_Loan_App_Entity_Relationship__c WHERE Loan_Application_ID__c =: loanApp.Id ]){
	                        relMap.put(r.Entity_Name__c, r);
	                }
                }else
                {
                        relMap.put(null,null);
                }
                                
               
                List<List<Account>> findaccts = [FIND :searchTerm IN ALL FIELDS RETURNING Account (Id ,  EB_Client_Name__c ,Entity_Name__c,BillingStreet ,BillingCity,BillingState ,Phone,  Name LIMIT :150)];
                List<Account> returnAccts = new List<Account>();
                for(Account a : findaccts[0]){
                	if(!relMap.containskey(a.Id)) returnAccts.add(a);
                }
                if(returnAccts.size() > 100) getRefineSearchStatus = 'true';
                return returnAccts;         
        }
        
        public PageReference SaveBorrower(){
                try{
                if(this.LoanAppId == null){ 
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Cannot find Loan Application');
                                        ApexPages.addMessage(myMsg);
                }else{
                       
                         ApexPages.Message[] msgs = ApexPages.getMessages();
                                 if (msgs.size() > 0){
                                 }else{
                                        
                                     String  newPageUrl = this.url + 'apex/LoanAppBorrowerEdit' + '?aid=' + this.LoanAppId + '&eid=' + dropdownEntityId;
                                     PageReference newPage = new PageReference(newPageUrl);
                                     newPage.setRedirect(true);
                                     return newPage;
                                 }
                }
        }catch(exception ex){
                 ApexPages.addMessages(ex);
        }
          return null;
        }
        public PageReference SaveNewBorrower(){
                 
          try{
                if(this.LoanAppId == null){ 
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Cannot find Loan Application');
                                        ApexPages.addMessage(myMsg);
                }else{
                       
                         ApexPages.Message[] msgs = ApexPages.getMessages();
                                 if (msgs.size() > 0){
                                 }else{
                                        
                                     String  newPageUrl = this.url + 'apex/LoanAppBorrowerEdit' + '?aid=' + this.LoanAppId;
                                     PageReference newPage = new PageReference(newPageUrl);
                                     newPage.setRedirect(true);
                                     return newPage;
                                 }
                }
        }catch(exception ex){
            ApexPages.addMessages(ex);
        }
          return null;
        }

        public PageReference CancelBorrower(){
            try{
                if(loanApp != null){
                    String newPageUrl = this.url  + loanApp.Id;
                    PageReference newPage = new PageReference(newPageUrl);
                    newPage.setRedirect(true);
                    return newPage;
                }
            }catch(exception ex){

            }
            return null;
        }

        public static testMethod void verifyLoanAppBorrowerAddPageReference(){
             String url = 'https://cs3.salesforce.com/LoanAppBorrowerAdd?aid=';
               
                
                                Account acctProspect = testObjectClass.getTestAccount();
                                EB_Loan_Application__c app = testObjectClass.getTestLoanApp(acctProspect);
                                
                                 PageReference pr = testhelper(url + app.ID);
                             test.setCurrentPage(pr);
                             ApexPages.StandardController sc = new Apexpages.Standardcontroller(app);
                             LoanAppBorrowerAddController testcontroller = new LoanAppBorrowerAddController(sc);
                             testcontroller.SaveBorrower();
                             testcontroller.SaveNewBorrower();
                             testcontroller.CancelBorrower();
        }
        
        public static testMethod void verifyLoanAppBorrowerAddPageReferenceSecond(){
             String url = 'https://cs3.salesforce.com/LoanAppBorrowerAdd?aid=';
            
                
                                Account acctProspect = testObjectClass.getTestAccount();
                                EB_Loan_Application__c app = testObjectClass.getTestLoanApp(acctProspect);
                                
                                 PageReference pr = testhelper(url);
                             test.setCurrentPage(pr);
                             ApexPages.StandardController sc = new Apexpages.Standardcontroller(app);
                             LoanAppBorrowerAddController testcontroller = new LoanAppBorrowerAddController(sc);
                             testcontroller.SaveBorrower();
                             testcontroller.SaveNewBorrower();
        }
        
        public static testMethod void verifyLoanAppBorrowerAddPageReferenceMethod(){
            String url = 'https://cs3.salesforce.com/LoanAppBorrowerAdd?aid=';
              
                 
            Account acctProspect = testObjectClass.getTestAccount();
            EB_Loan_Application__c app = testObjectClass.getTestLoanApp(acctProspect);
            
            
            PageReference pr = testhelper(url);
            test.setCurrentPage(pr);
            ApexPages.StandardController sc = new Apexpages.Standardcontroller(app);
            LoanAppBorrowerAddController testcontroller = new LoanAppBorrowerAddController(sc);
            testcontroller.initialize();
            testcontroller.searchParam = 'a';
            testcontroller.getSearchClicked();
            testcontroller.getMatchesFound();
            testcontroller.getNoMatchesFound();

            List<Account> accts = testcontroller.getUnmatchedClientNameObjectList('*a*');
            accts = testcontroller.getEntityObjects();
        }
                                                 
        
        public static PageReference testhelper(String url){
            PageReference newPage = new PageReference(url);
            newPage.setRedirect(true);
            return newPage;
        }

        public PageReference SetSearch(){
            return null;
        }

}