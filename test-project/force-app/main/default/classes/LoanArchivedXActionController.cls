public with sharing class LoanArchivedXActionController {

    Id ArchivedAppId;
    EB_Booked_Loan_App__c archivedapp;

    public LoanArchivedXActionController(ApexPages.StandardController controller) {
        try{
            this.ArchivedAppId = apexpages.currentpage().getparameters().get('id');
        }catch(exception ex){
            this.ArchivedAppId = null;
        }
    }

    public PageReference RedirectURL(){
        if(ArchivedAppId != null){
          String newPageUrl = '/apex/LoanArchivedStageAction' + '?id=' + this.ArchivedAppId;
          PageReference newPage = new PageReference(newPageUrl);
          newPage.setRedirect(true);
          return newPage;
        }
        return null;
    }

}