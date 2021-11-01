public class LoanAppCollateralAddController {
   String url = Utility.getServerUrl()+'/';//'https://cs3.salesforce.com/';

    Id LoanAppId;
   // Account entity;
    EB_Loan_Application__c loanApp ;
    public String getLoanApplicationName{get;set;}
    public Id selectedCollateralId{get;set;}   
    
   /* private boolean EnableLogging = true;
    private void debug_RecordLog(String event){
        if(EnableLogging = true){
            EventLog__c log = new EventLog__c();
            log.Message__c = event;
            insert log;
        }
    }*/
	public LoanAppCollateralAddController(ApexPages.StandardController controller) {
	   
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
               // return;
            }
	    }
    }
 
    public List<SelectOption> getCollateralNames(){               
        List<SelectOption> options = new List<SelectOption>();
        
        
        //List<Account> accts = [SELECT Id , Name FROM Account WHERE Id in (SELECT Entity_Name__c FROM  EB_Loan_App_Entity_Relationship__c WHERE Loan_Application_ID__c =: LoanAppId and Loan_Application_ID__c != null)];
        
        //Map<Id, Account> acctsMap = new Map<Id, Account>();
        Map<Id, Account> acctsMap = new Map<Id, Account>([SELECT Id , Name FROM Account WHERE Id in (SELECT Entity_Name__c FROM  EB_Loan_App_Entity_Relationship__c WHERE Loan_Application_ID__c =: LoanAppId and Loan_Application_ID__c != null )]);
       /* for(Account a : accts){
            acctsMap.put(a.Id, a);
        }*/
       
       // List<EB_Collateral__c> colls = [SELECT Id, Name, Collateral_Description__c, (SELECT Entity_Name__c FROM EB_Collateral_Client_Relationships__r) FROM EB_Collateral__c WHERE  Id in (SELECT EB_Collateral_ID__c  FROM EB_Collateral_Client_Relationship__c WHERE Client_ID__c in :acctsMap.KeySet() and Client_ID__c != null  ) and Id not in (SELECT EB_Collateral_ID__c FROM EB_Loan_App_Collateral_Relationship__c WHERE EB_Loan_Application_ID__c =: LoanAppId and EB_Loan_Application_ID__c != null ) ];
        for(EB_Collateral__c c : [SELECT Id, Name, Collateral_Description__c, (SELECT Entity_Name__c FROM EB_Collateral_Client_Relationships__r) FROM EB_Collateral__c WHERE  Id in (SELECT EB_Collateral_ID__c  FROM EB_Collateral_Client_Relationship__c WHERE Client_ID__c in :acctsMap.KeySet() and Client_ID__c != null  ) and Id not in (SELECT EB_Collateral_ID__c FROM EB_Loan_App_Collateral_Relationship__c WHERE EB_Loan_Application_ID__c =: LoanAppId and EB_Loan_Application_ID__c != null ) ]){                
             String Owner = getOwnerListForReadOnlyStatus(c.Id,c.EB_Collateral_Client_Relationships__r);
             String collateral = Owner + '  >>  ' + c.Collateral_Description__c  + '  >>  ' + c.Name;
             collateral = collateral.replace('\'', '`');
             collateral = collateral.replace('\n',' ');
             options.add(new SelectOption(c.Id , collateral));                         
        }        
        
    	return SortOptionList(options);         
    }
    
    public static List<SelectOption> SortOptionList(List<SelectOption> ListToSort)      {
    	 List<SelectOption> returnList = new List<SelectOption> ();
    	try{
        if(ListToSort == null || ListToSort.size() <= 1) return ListToSort;
        List<SelectOption> Less = new List<SelectOption>();
        List<SelectOption> Greater = new List<SelectOption>();
        integer pivot = 0;      
        SelectOption pivotValue = ListToSort[pivot];
        ListToSort.remove(pivot);
        for(SelectOption x : ListToSort){
            if(x.getLabel() <= pivotValue.getLabel())
                Less.add(x);
                //else if(x.getLabel() > ListToSort[pivot].getLabel()) Greater.add(x);
            else if(x.getLabel() > pivotValue.getLabel()) 
             	Greater.add(x);
		}
       
        returnList.addAll(SortOptionList(Less));
        returnList.add(pivotValue);
        returnList.addAll(SortOptionList(Greater));
    	}catch(exception ex){}
        return returnList;
    }
    
    public String getOwnerListForReadOnlyStatus(Id CollateralId, List<EB_Collateral_Client_Relationship__c> rels){
		String OwnerList = '';
		
		//List<EB_Collateral_Client_Relationship__c> acct_s = [SELECT Client_ID__c, Client_ID__r.Name, Entity_Name__c   FROM EB_Collateral_Client_Relationship__c  WHERE EB_Collateral_ID__c =: CollateralId and EB_Collateral_ID__c != null ];	
		try{
			for(EB_Collateral_Client_Relationship__c acct : rels){//[SELECT Client_ID__c, Client_ID__r.Name, Entity_Name__c   FROM EB_Collateral_Client_Relationship__c  WHERE EB_Collateral_ID__c =: CollateralId and EB_Collateral_ID__c != null ]){
				OwnerList += acct.Entity_Name__c + ',';
			}
			
		
		}catch(exception ex){}
		
		try{ //Remove the last comma ;
			
            Integer len = OwnerList.length();
			if(len > 1 &&  OwnerList.substring(len-1) == ',') OwnerList = OwnerList.substring(0, len-1);
			
			
		}catch(exception ex){
                
        }
       // debug_RecordLog( 'ownerlist' + OwnerList);
        return OwnerList;
    }
    
    public Boolean getCollateralFound(){
    	try{
    	if(getCollateralNames().size() > 0) return true;
 		
    	}catch(exception ex){
    		
    	}
    	//debug_RecordLog('getcollateralfound' + ' false');
    	return false;
    }
    
    public Boolean getNoCollateralFound(){
    	
 		return !getCollateralFound();
    }
    
    public String getLoanAppSelected(){
    	try{
        return loanApp.Name ; //entity.Name;
    	}catch(exception ex){}
    	return '';
    }
    
    public PageReference CancelCollateral(){
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
    
    public PageReference SaveCollateral(){
                try{
                if(this.LoanAppId == null){ 
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Cannot find Loan Application');
                                        ApexPages.addMessage(myMsg);
                }else{
                       
                         ApexPages.Message[] msgs = ApexPages.getMessages();
                                 if (msgs.size() > 0){
                                 }else{
                                        
                                     String  newPageUrl = this.url + 'apex/LoanAppCollateralEdit' + '?aid=' + this.LoanAppId + '&cid=' + selectedCollateralId;
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
        public PageReference SaveNewCollateral(){
          try{
                if(this.LoanAppId == null){ 
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Cannot find Loan Application');
                                        ApexPages.addMessage(myMsg);
                }else{
                       
                         ApexPages.Message[] msgs = ApexPages.getMessages();
                                 if (msgs.size() > 0){
                                 }else{
                                        
                                     String  newPageUrl = this.url + 'apex/LoanAppCollateralEdit' + '?aid=' + this.LoanAppId;
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
     
    public PageReference SetSearch(){
        return null;
    }
}