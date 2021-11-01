public with sharing class LoanAppXActionController {
	public LoanAppXActionController(ApexPages.StandardController controller) {
		  
    }
    	
	public PageReference RedirectAction(){
		Id loanAppId = null;
		loanAppId = apexpages.currentpage().getparameters().get('id');
        
        EB_Loan_Application__c app = [SELECT Id, Application_Stage__r.Name, Application_Stage__r.Loan_App_Stage_Action_Controller__r.Name, Application_Stage__r.Loan_App_Stage_Action_Controller__r.Visual_Force_Action_Page__c FROM  EB_Loan_Application__c WHERE Id =: LoanAppId];
        EB_Loan_App_Stage__c stage = app.Application_Stage__r;
        EB_Stage_Action_Controller__c controller = stage.Loan_App_Stage_Action_Controller__r;
        
        if(IsStageAccessible(controller.Visual_Force_Action_Page__c)==true){
        	return getRedirectPage(loanAppId);
        }        
        return null;      
    }
    
    public static PageReference getRedirectPage(Id loanAppId){
    	String url = getBaseUrl() + '/apex/LoanAppStageAction?id=' + loanAppId;
        PageReference newPage = new PageReference(url);
        newPage.setRedirect(true);
        return newPage;
    }
    
	private static String getBaseUrl(){
		
    	return Utility.getServerUrl();
    }
    
    public boolean IsStageAccessible(String actionPage){
    	Schema.DescribeSObjectResult obj;
    	if(actionPage == '/apex/LoanAppApprovedAction'){
    		obj = Schema.Sobjecttype.pApprovedAction__c;
    		return obj.isAccessible();
    	}
    	if(actionPage == '/apex/LoanAppArchivedAction'){
    		obj = Schema.Sobjecttype.pArchivedAction__c;
    		return obj.isAccessible();
    	}
    	if(actionPage == '/apex/LoanAppBookedAction'){
    		obj = Schema.Sobjecttype.pBookedAction__c;
    		return obj.isAccessible();
    	}    	
    	if(actionPage == '/apex/LoanAppDocumentationAction'){
    		obj = Schema.Sobjecttype.pDocumentationAction__c;
    		return obj.isAccessible();
    	}
    	if(actionPage == '/apex/LoanAppNewAction'){
    		obj = Schema.Sobjecttype.pNewAction__c;
    		return obj.isAccessible();
    	}
    	if(actionPage == '/apex/LoanAppPendingApprovalAction'){
    		obj = Schema.Sobjecttype.pPendingApprovalAction__c;
    		return obj.isAccessible();
    	}
    	if(actionPage == '/apex/LoanAppUnderwritingAction'){
    		obj = Schema.Sobjecttype.pUnderwritingAction__c;
    		return obj.isAccessible();
    	}    	
    	return false;
    }
}