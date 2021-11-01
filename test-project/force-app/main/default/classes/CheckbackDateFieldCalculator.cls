public with sharing class CheckbackDateFieldCalculator implements ICheckbackDateFieldCalculator {

    public interface ICheckbackDateFieldCalculator {
        void calculate(List<LLC_BI__Loan__c> loans);
        void calculate(List<LLC_BI__Loan__c> oldLoans, Map<Id, SObject> newLoans);
    }
    
    private final ISystem m_system;
    
    public CheckbackDateFieldCalculator(ISystem systemWrapper) {
        m_system = systemWrapper;
    }

    public void calculate(List<LLC_BI__Loan__c> loans) {
        for (LLC_BI__Loan__c loan : loans) {
            calculate(loan);
        }
    }

    @TestVisible
    private void calculate(LLC_BI__Loan__c loan) {
        loan.Checkback_in_Progress__c = loan.Checkback_in_progress_box__c == true ? m_system.today() : null;
    }

    public void calculate(List<LLC_BI__Loan__c> oldLoans, Map<Id, SObject> newLoans) {
        for (LLC_BI__Loan__c oldLoan : oldLoans) {
            LLC_BI__Loan__c newLoan = (LLC_BI__Loan__c)newLoans.get(oldLoan.Id);
            calculate(oldLoan, newLoan);
        }
    }

    @TestVisible
    private void calculate(LLC_BI__Loan__c oldLoan, LLC_BI__Loan__c newLoan) {
        if (oldLoan.Checkback_in_progress_box__c != newLoan.Checkback_in_progress_box__c) {
            newLoan.Checkback_in_Progress__c = newLoan.Checkback_in_progress_box__c == true ? m_system.today() : null;
        }
    }
}