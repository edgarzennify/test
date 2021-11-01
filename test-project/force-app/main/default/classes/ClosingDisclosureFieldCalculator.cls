public with sharing class ClosingDisclosureFieldCalculator implements IClosingDisclosureFieldCalculator {

    public interface IClosingDisclosureFieldCalculator {
        void calculate(List<LLC_BI__Loan__c> loans);
    }
    
    private final Set<String> TRID_PRODUCTS = new Set<String>{
        '2nd Deed of Trust Home Personal Residence',
        'Bridge',
        'Construction With or Without Lot Purchase',
        'Portfolio Mortgage (QM & Non-QM)',
        'Secondary Market Mortgage (QM & Non-QM)',
        'Lot Purchase - No Construction'
    };

    public void calculate(List<LLC_BI__Loan__c> loans) {
        for (LLC_BI__Loan__c loan : loans) {
            calculate(loan);
        }
    }

    private void calculate(LLC_BI__Loan__c loan) {
        if (isEligibleForClosingDisclosure(loan)) {
            loan.Eligible_for_Closing_Disclosure__c = true;
            return;
        }
        loan.Eligible_for_Closing_Disclosure__c = false;
    }

    private Boolean isEligibleForClosingDisclosure(LLC_BI__Loan__c loan) {
        return
            loan.LLC_BI__Is_Modification__c == false
            && loan.LLC_BI__isRenewal__c == false
            && TRID_PRODUCTS.contains(loan.LLC_BI__Product__c);
    }
}