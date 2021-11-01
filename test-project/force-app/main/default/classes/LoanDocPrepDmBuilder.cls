public class LoanDocPrepDmBuilder implements LoanDocPrep.IDmBuilder {

	private final LoanDocPrep.IDmBuilderHelper m_dmHelper;

	public LoanDocPrepDmBuilder(LoanDocPrep.IDmBuilderHelper dmHelper) {
		m_dmHelper = dmHelper;
	}

	public DmLoan build(LoanDocPrep.NcinoLoanPm pm){
		DmLoan loan = m_dmHelper.buildLoan(pm);
		loan.relatedEntities = buildRelatedEntities(pm.loanAppEntities);
		loan.pledgedCollateral = buildRelatedCollaterals(pm.loanAppCollaterals, pm.loanAppCollateralOwnerships);
		loan.fees = buildFees(pm.loanAppFees);

		return loan;
	}

	private List<DmLoanEntityRelationship> buildRelatedEntities(List<LLC_BI__Legal_Entities__c> entities) {
		List<DmLoanEntityRelationship> dms = new List<DmLoanEntityRelationship>();
		if(entities == null || entities.size() == 0) return dms;
		for(LLC_BI__Legal_Entities__c entity : entities) {
			dms.add(m_dmHelper.buildRelatedEntity(entity));
		}
		
		return dms;
	}

	private List<DmLoanCollateralRelationship> buildRelatedCollaterals(List<LLC_BI__Loan_Collateral2__c> relatedCollaterals, List<LLC_BI__Account_Collateral__c> ownerships) {
		List<DmLoanCollateralRelationship> collaterals = new List<DmLoanCollateralRelationship>();
		if(relatedCollaterals == null || relatedCollaterals.size() == 0) return collaterals;
		for(LLC_BI__Loan_Collateral2__c col : relatedCollaterals) {
			collaterals.add(m_dmHelper.buildRelatedCollateral(col, ownerships));
		}

		return collaterals;
	}

	private List<DmFee> buildFees(List<LLC_BI__Fee__c> fees) {
		List<DmFee> dmFees = new List<DmFee>();
		if(fees == null || fees.size() == 0) return dmFees;
		for(LLC_BI__Fee__c f : fees) {
			dmFees.add(m_dmHelper.buildFee(f));
		}

		return dmFees;
	}
}