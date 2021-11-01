public with sharing class LoanDefaultAppFieldCalculator implements ILoanDefaultAppFieldCalculator {
    
    public interface ILoanDefaultAppFieldCalculator {
        void calculate(List<LLC_BI__Loan__c> loans);
        void calculate(LLC_BI__Loan__c loan);
    }

    private final String BOOKED_STAGE = 'Booked';
    private final String COMPLETE_STAGE = 'Complete';
    private final String CLOSED_STAGE = 'Closed';
    private final List<String> BOOKED_STAGES = new List<String>{BOOKED_STAGE, COMPLETE_STAGE, CLOSED_STAGE};

    public void calculate(List<LLC_BI__Loan__c> loans) {
        for (LLC_BI__Loan__c ln : loans) {
            calculate(ln);
        }
    }

    public void calculate(LLC_BI__Loan__c loan) {
        if (loan.LLC_BI__Product__c == 'Credit Card') {
            if (BOOKED_STAGES.contains(loan.LLC_BI__Stage__c)) {
                loan.LLC_BI__Default_App__c = 'credit-booked-ui.dashboard-credit-booked-ui-loan';
                return;
            } 
            loan.LLC_BI__Default_App__c = 'Credit-ui.dashboard-credit-Loan';
            return;
        } 
        if (loan.LLC_BI__Product_Line__c == 'Commercial/Business') {
            if (BOOKED_STAGES.contains(loan.LLC_BI__Stage__c)) {
                loan.LLC_BI__Default_App__c = 'commercial-booked-ui.dashboard-commercial-booked-ui-loan';
                return;
            }
            loan.LLC_BI__Default_App__c = 'commercial-ui.dashboard-loan-ui';
            return;
        }
        if (loan.LLC_BI__Product_Line__c == 'Mortgage' || loan.LLC_BI__Product_Line__c == 'Consumer') {
            if (BOOKED_STAGES.contains(loan.LLC_BI__Stage__c)) {
                loan.LLC_BI__Default_App__c = 'consumer-booked-ui.dashboard-consumer-booked-ui-loan';
                return;
            }
            loan.LLC_BI__Default_App__c = 'consumer-ui.dashboard-consumer-ui-loan';
            return;
        }
        loan.LLC_BI__Default_App__c = 'Please contact IT Helpdesk.';
    }
}