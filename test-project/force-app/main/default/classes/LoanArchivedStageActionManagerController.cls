public class LoanArchivedStageActionManagerController {

	private Id ArchivedAppId;
    private EB_Booked_Loan_App__c archivedapp;
    private EB_Loan_App_Stage__c loanappstage;
    private EB_Stage_Action_Controller__c loanappStageActionController;

    public LoanArchivedStageActionManagerController(ApexPages.StandardController controller) {
        getQueryParameters();
        initialize();
    }
    
    private void getQueryParameters(){        
        try{
			this.ArchivedAppId = apexpages.currentpage().getparameters().get('id');
        }catch(exception ex){
            this.ArchivedAppId = null;
        }
    }
    
    private void initialize(){
        if(this.ArchivedAppId !=null){
            try{
                this.archivedapp = [SELECT Id, Account_Number__c, Name,  Application_Stage__c   FROM EB_Booked_Loan_App__c WHERE Id =: this.ArchivedAppId limit 1 ];
            }catch(exception ex){
                this.archivedapp = null;
            }
        }else{
            this.archivedapp = null;
        }
        if(this.ArchivedAppId !=null){
            try{
                this.LoanAppStage = [SELECT Id, Name, Loan_App_Stage_Action_Controller__c    FROM EB_Loan_App_Stage__c WHERE Id =: this.archivedapp.Application_Stage__c limit 1 ];
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
          String newPageUrl = this.loanappStageActionController.Visual_Force_Action_Page__c + '?id=' + this.ArchivedAppId;
          PageReference newPage = new PageReference(newPageUrl);
          newPage.setRedirect(true);
          return newPage;
        }
        return null;
    }
   
    public String getUrl(){
        return this.loanappStageActionController.Visual_Force_Action_Page__c;
    }

}