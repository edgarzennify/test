public with sharing class MoreLoanObjectFactory implements IMoreLoanObjectFactory {

    public interface IMoreLoanObjectFactory {
        List<More_Loan__c> create(List<LLC_BI__Loan__c> loans);
    }

    public List<More_Loan__c> create(List<LLC_BI__Loan__c> loans) {
        List<More_Loan__c> moreLoanRecords = new List<More_Loan__c>();
        for (LLC_BI__Loan__c loan : loans) {
            moreLoanRecords.add(create(loan));
        }
        return moreLoanRecords;
    }

    private More_Loan__c create(LLC_BI__Loan__c loan) {
        return new More_Loan__c(Loan__c = loan.Id);
    }   
}