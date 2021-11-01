public with sharing class AgreementLoanAppRelationshipEditCtrl {

    
    public Agreement_Loan_Application_Relationship__c AgmtLoapAppRel{get;set;} 
    public AgreementLoanAppRelationshipEditCtrl(ApexPages.StandardController controller) {
            AgmtLoapAppRel = [SELECT Id, Agreement__c FROM Agreement_Loan_Application_Relationship__c WHERE Id =: apexpages.currentpage().getparameters().get('id')]; 
    }
    public PageReference Redirect(){
             String newPageUrl = utility.getServerUrl() +  '/apex/Agreement?id=' + string.valueof(AgmtLoapAppRel.Agreement__c) ;
              PageReference newPage = new PageReference(newPageUrl);
              newPage.setRedirect(true);
              return newPage;
    }


}