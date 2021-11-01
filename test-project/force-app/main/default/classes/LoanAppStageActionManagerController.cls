public class LoanAppStageActionManagerController {
    Id LoanAppId;
    EB_Loan_Application__c loanapp;
    EB_Loan_App_Stage__c loanappstage;
    EB_Stage_Action_Controller__c loanappStageActionController;
    
    public LoanAppStageActionManagerController(ApexPages.StandardController controller) {
        getQueryParameters();
        initialize();
    }
    @TestVisible
    private void getQueryParameters(){        
        try{
			this.LoanAppId = apexpages.currentpage().getparameters().get('id');
        }catch(exception ex){
            this.LoanAppId = null;
        }
    }
    @TestVisible
    private void initialize(){
        if(this.LoanAppId !=null){
            try{
                this.loanApp = [SELECT Id, Account_Number__c, Name, EB_Loan_Packet__c, Application_Stage__c   FROM EB_Loan_Application__c WHERE Id =: this.LoanAppId limit 1 ];
            }catch(exception ex){
                this.loanApp = null;
            }
        }else{this.loanApp = null;}
        if(this.LoanAppId !=null){
            try{
                this.LoanAppStage = [SELECT Id, Name, Loan_App_Stage_Action_Controller__c    FROM EB_Loan_App_Stage__c WHERE Id =: this.LoanApp.Application_Stage__c limit 1 ];
                this.loanappStageActionController = [SELECT Id, Name, Visual_Force_Action_Page__c  FROM EB_Stage_Action_Controller__c WHERE Id =: this.loanAppstage.Loan_App_Stage_Action_Controller__c limit 1];
            }catch(exception ex){
                this.LoanAppStage = null;
                this.loanappStageActionController = null;
            }
        }else{
            this.LoanAppStage = null;
            this.loanappStageActionController = null;
        }
    }
    
    public PageReference RedirectAction(){
        if(loanappStageActionController != null){
          String newPageUrl = this.loanappStageActionController.Visual_Force_Action_Page__c + '?id=' + this.LoanAppId;
          PageReference newPage = new PageReference(newPageUrl);
          newPage.setRedirect(true);
          return newPage;
        }else{
                
        }
        return null;
    }
   
    public String getUrl(){
        return this.loanappStageActionController.Visual_Force_Action_Page__c;
    }
}