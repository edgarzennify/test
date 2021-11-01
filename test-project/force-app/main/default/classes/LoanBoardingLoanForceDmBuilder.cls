public class LoanBoardingLoanForceDmBuilder implements LoanBoarding.IDmBuilder {

    private Set<String> PRIMARY_BORROWER_TYPES = new Set<String> {'Primary Owner', 'Primary Borrower', 'Borrower'};
    private final LoanBoarding.IDataProvider m_dataProvider;
    private final LoanBoarding.IDmBuilderHelper m_dmHelper;

    public LoanBoardingLoanForceDmBuilder(LoanBoarding.IDataProvider dataProvider, LoanBoarding.IDmBuilderHelper dmHelper) {
        m_dataProvider = dataProvider;
        m_dmHelper = dmHelper;
    }

    public SObjectType isType() {
        return EB_Loan_Application__c.SObjectType;
    }

    public DmLoan buildDmLoan(String loanId) {
        PM_EB_Loan_Application_c pmLoan = m_dataProvider.getLoanForceLoan(loanId);
        List<EB_Industry_Code__c> industryCodes = m_dataProvider.getIndustryCodes();        
        
        DmLoan dm = m_dmHelper.buildLoan(pmLoan);        
        dm.relatedEntities = buildRelatedEntities(pmLoan.EB_Loan_App_Entity_Relationships_r, industryCodes);
        dm.primaryBorrower = getPrimaryBorrower(dm.relatedEntities);        
        dm.pledgedCollateral = buildPledgedCollateral(pmLoan.EB_Loan_App_Collateral_Relationships_r, dm.PrimaryBorrower);
        dm.participations = buildParticipations(pmLoan.EB_Loan_Participations_r);

        return dm;        
    }

    private List<DmLoanEntityRelationship> buildRelatedEntities(List<PM_EB_Loan_App_Entity_Relationship_c> pms, List<EB_Industry_Code__c> codes) {
        List<DmLoanEntityRelationship> dms = new List<DmLoanEntityRelationship>();
        if (pms == null) { return dms; }
        for (PM_EB_Loan_App_Entity_Relationship_c pm : pms) {
            dms.add(m_dmHelper.buildRelatedEntities(pm, codes));
        }
        return dms;
    }

    private DmEntity getPrimaryBorrower(List<DmLoanEntityRelationship> relatedEntities) {
        for (DmLoanEntityRelationship r : relatedEntities){
             if (PRIMARY_BORROWER_TYPES.contains(r.relationshipType)) {
                 return r.Entity;
             }
        }
        return null;
    }

    private List<DmLoanCollateralRelationship> buildPledgedCollateral(List<PM_EB_Loan_App_Collateral_Relationship_c> pms, DmEntity primaryBorrower) {
        List<DmLoanCollateralRelationship> dms = new List<DmLoanCollateralRelationship>();
        if (pms == null) { return dms; }
        for (PM_EB_Loan_App_Collateral_Relationship_c pm : pms) {
           	DmLoanCollateralRelationship dm = m_dmHelper.buildPledgedCollateral(pm);
            dm.isOwnedByPrimaryBorrower = isOwnedByPrimaryBorrower(dm, primaryBorrower);
            dms.add(dm);
        }        
        return dms;
    }

    private List<DmParticipation> buildParticipations(List<PM_EB_Loan_Participation_c> pms) {
        List<DmParticipation> dms = new List<DmParticipation>();
        if (pms == null) { return dms; }
        for (PM_EB_Loan_Participation_c pm : pms) {
            dms.add(m_dmHelper.buildParticipation(pm));
        }
        return dms;
    }

     private Boolean isOwnedByPrimaryBorrower(DmLoanCollateralRelationship pledge , DmEntity primaryBorrower) {
         try {
             if(pledge.collateral.primaryOwner.Id == primaryBorrower.id) {
                 return true;
             }             
         } catch(Exception ex) {
         }
         return false;
    }
}