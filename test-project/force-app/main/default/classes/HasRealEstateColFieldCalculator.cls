public with sharing class HasRealEstateColFieldCalculator implements IHasRealEstateColFieldCalculator {
    
    public interface IHasRealEstateColFieldCalculator {
        void calculate(List<LLC_BI__Loan__c> loans, List<LLC_BI__Loan_Collateral2__c> pledges);
    }

    public void calculate(List<LLC_BI__Loan__c> loans, List<LLC_BI__Loan_Collateral2__c> pledges) {
        Map<Id, List<LLC_BI__Loan_Collateral2__c>> mapped = mapPledgesToLoans(pledges);

        for (LLC_BI__Loan__c loan : loans) {
			List<LLC_BI__Loan_Collateral2__c> loanPledges = mapped.get(loan.Id);
            loan.HasRealEstateCollateral__c = calculate(loanPledges);
        }
    }

    private Map<Id, List<LLC_BI__Loan_Collateral2__c>> mapPledgesToLoans(List<LLC_BI__Loan_Collateral2__c> pledges) {
		Map<Id, List<LLC_BI__Loan_Collateral2__c>> mapped = new Map<Id, List<LLC_BI__Loan_Collateral2__c>>();
		if (pledges != null) {
			for (LLC_BI__Loan_Collateral2__c p : pledges) {
				Id loanId = p.LLC_BI__Loan__c;
				if (!mapped.containsKey(loanId)) {
					mapped.put(loanId, new List<LLC_BI__Loan_Collateral2__c>());
				}
				mapped.get(loanId).add(p);
			}
		}
        return mapped;
    }

    private Boolean calculate(List<LLC_BI__Loan_Collateral2__c> pledges) {
		if (pledges != null) {
			for (LLC_BI__Loan_Collateral2__c p : pledges) {
				if (isRealEstateCollateral(p)) {
					return true;
				}
			}
		}
		return false;
	}

    private Boolean isRealEstateCollateral(LLC_BI__Loan_Collateral2__c pledge) {
		try {
			return pledge.LLC_BI__Collateral__r.LLC_BI__Collateral_Type__r.Collateral_Record_Type__c == 'Real Estate';
		} catch (Exception ex) {
			return false;
		}
	}
}