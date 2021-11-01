public with sharing class PolicyExceptionsFieldCalculator implements IPolicyExceptionsFieldCalculator {

    public interface IPolicyExceptionsFieldCalculator {
        void calculate(List<LLC_BI__Loan__c> loans);
    }
    
    public void calculate(List<LLC_BI__Loan__c> loans) {
        for (LLC_BI__Loan__c loan : loans) {
            calculate(loan);
        }
    }

    private void calculate(LLC_BI__Loan__c loan) {
        if (policyExceptionFieldsNeedsUpdating(loan)) {
            if (loan.Policy_Exceptions__c == null) {
                loan.Policy_Exceptions_Description__c = 'Variable Pricing Floor Overridden';
                loan.Policy_Exceptions__c = 'Variable Pricing Floor Overridden';
                return;
            } 
            
            if (loan.Policy_Exceptions__c.contains('N/A')) {
                loan.Policy_Exceptions_Description__c = 'Variable Pricing Floor Overridden';
                loan.Policy_Exceptions__c = loan.Policy_Exceptions__c + ';Variable Pricing Floor Overridden;';
                loan.Policy_Exceptions__c = loan.Policy_Exceptions__c.remove('N/A');
                return;
            }
            
            if (loan.Policy_Exceptions_Description__c.length() < 220) {
                loan.Policy_Exceptions_Description__c = loan.Policy_Exceptions_Description__c + ' Variable Pricing Floor Overridden';
            }
            loan.Policy_Exceptions__c = loan.Policy_Exceptions__c + ';Variable Pricing Floor Overridden;';
        }
    }

    private Boolean policyExceptionFieldsNeedsUpdating(LLC_BI__Loan__c loan) {
        return loan.Channel__c == 'Commercial Banking' 
            && loan.LLC_BI__Pricing_Basis__c == 'Variable'
            && loan.Need_Rate_Floor__c == 'No'
            && (loan.Policy_Exceptions__c == null || !loan.Policy_Exceptions__c.contains('Variable Pricing Floor Overridden'));
    }
}