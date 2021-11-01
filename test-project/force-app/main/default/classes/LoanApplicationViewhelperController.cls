public with sharing class  LoanApplicationViewhelperController {
    public EB_Loan_Application__c loan;
    Id AppId;
    String url = '';
    public LoanApplicationViewhelperController(ApexPages.StandardController controller) {
        if(url == '') url = getServerUrl();
        AppId = apexpages.currentpage().getparameters().get('id');
        loan = [SELECT Id, Name,Record_Type_Description__c , Purpose_of_Loan__c,Loan_Type_For_Number_Generation__c, Account_Number_Assigned__c  FROM EB_Loan_Application__c WHERE Id =:AppId];
    }
    private static String  getServerUrl(){        
        return Utility.getServerUrl() + '/';
    }
    public pagereference GenerateNumber(){
        String newNumber = LoanApplicationViewController.GetNewLoanNumber(loan);
        if(newNumber != '' ){
            loan.Account_Number_Assigned__c = newNumber;
            update loan;
         }
        String newPageUrl = this.url  + 'apex/LoanApplicationView?id=' + loan.id;
        PageReference newPage = new PageReference(newPageUrl);
        newPage.setRedirect(true);
        return newPage;
    }
}