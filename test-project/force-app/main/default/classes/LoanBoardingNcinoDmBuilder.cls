public class LoanBoardingNcinoDmBuilder implements LoanBoarding.IDmBuilder {

    private final LoanBoarding.IDataProvider m_dataProvider;
    private final LoanBoarding.IDmBuilderHelper m_dmBuilderHelper;

    public LoanBoardingNcinoDmBuilder(LoanBoarding.IDataProvider dataProvider, LoanBoarding.IDmBuilderHelper dmBuilderHelper) {
        m_dataProvider = dataProvider;
        m_dmBuilderHelper = dmBuilderHelper;
    }

    public SObjectType isType() {
        return LLC_BI__Loan__c.SObjectType; 
    }
   
    public DmLoan buildDmLoan(String loanId) {
        PM_LLCBI_Loan_c pmLoan = m_dataProvider.getnCinoLoan(loanId);
        List<EB_Industry_Code__c> industryCodes = m_dataProvider.getIndustryCodes();
        List<PM_LLCBI_Pricing_Payment_Component_c> paymentStreams = m_dataProvider.getnCinoPayStreams(pmLoan.Id);
        List<PM_LLCBI_Pricing_Rate_Component_c> rateStreams = m_dataProvider.getnCinoRateStreams(pmLoan.Id);
        
        DmLoan dm = m_dmBuilderHelper.buildLoan(pmLoan);
        dm.RelatedEntities = buildRelatedEntities(pmLoan.LLCBI_Legal_Entities_r, industryCodes);
        dm.pledgedCollateral = buildPledgedCollateral(pmLoan.LLCBI_Loan_Collateral_r, dm.relatedEntities);
        dm.participations = buildParticipations(pmLoan.LLCBI_Participations_r);
        dm.memos = buildMemos(pmLoan.LLCBI_Change_Memos_r);
        dm.payStreams = buildPayStreams(paymentStreams);
        dm.rateStreams = buildRateStreams(rateStreams);
        return dm; 
    }

    private List<DmLoanEntityRelationship> buildRelatedEntities(List<PM_LLCBI_Legal_Entities_c> pms, List<EB_Industry_Code__c> industryCodes) {
        List<DmLoanEntityRelationship> dms = new List<DmLoanEntityRelationship>();
        
        if (pms == null) { return dms; }
        else {
            for(PM_LLCBI_Legal_Entities_c pm : pms) {
                dms.add(m_dmBuilderHelper.buildRelatedEntities(pm, industryCodes));
            }
        }
        return dms;
    }
    
    private List<DmLoanCollateralRelationship> buildPledgedCollateral(List<PM_LLCBI_Loan_Collateral2_c> pms, List<DmLoanEntityRelationship> relatedEntities) {
        List<DmLoanCollateralRelationship> dms = new List<DmLoanCollateralRelationship>();

        if (pms == null) { return dms; }
        else {
            for (PM_LLCBI_Loan_Collateral2_c pm : pms) {
                dms.add(m_dmBuilderHelper.buildPledgedCollateral(pm));
            }
        }
        updateOwnedByPrimaryBorrower(dms, relatedEntities);
        return dms;
    }

    private void updateOwnedByPrimaryBorrower(List<DmLoanCollateralRelationship> pledgeDms , List<DmLoanEntityRelationship> relatedEntities) {
        DmLoanEntityRelationship inv = new DmLoanEntityRelationship();
        for (DmLoanEntityRelationship r : relatedEntities) {
            if (r.RelationshipType == 'Primary Owner' || r.RelationshipType == 'Borrower') {
                inv = r;
            }
        }

        for (DmLoanCollateralRelationship pledge : pledgeDms) {
            pledge.IsOwnedByPrimaryBorrower = false;
            try {
                if (pledge.Collateral.PrimaryOwner.Id == inv.Entity.Id) {
                pledge.IsOwnedByPrimaryBorrower = true;
                }
            } catch (Exception ex) {
                
            }
        }
    }
    
    private List<DmParticipation> buildParticipations(List<PM_LLCBI_Participation_c> pms) {
        List<DmParticipation> dms = new List<DmParticipation>();

        if (pms == null) { return dms; }
        else {
            for (PM_LLCBI_Participation_c pm : pms) {
                dms.add(m_dmBuilderHelper.buildParticipation(pm));
            }
        }
        return dms;
    } 

    private List<DmMemo> buildMemos(List<PM_LLCBI_Change_Memo_c> pms) {
        List<DmMemo> dms = new List<DmMemo>();
        
        if (pms == null) { return dms; }
        else {
            for (PM_LLCBI_Change_Memo_c pm : pms) {
                if (pm.LLCBI_Memo_Type_c == 'Change Memo') {
                    dms.add(m_dmBuilderHelper.buildMemo(pm));
                }
            }
        }
        return dms;
    }

    private List<DmLoanPaymentStream> buildPayStreams(List<PM_LLCBI_Pricing_Payment_Component_c> pms) {
        List<DmLoanPaymentStream> dms = new List<DmLoanPaymentStream>();
        
        if (pms == null) { return dms; }
        else {
            for (PM_LLCBI_Pricing_Payment_Component_c pm : pms) {
                dms.add(m_dmbuilderHelper.buildPayStream(pm));
            }
        }
        return dms;
    }

    private List<DmLoanRateStream> buildRateStreams(List<PM_LLCBI_Pricing_Rate_Component_c> pms) {
        List<DmLoanRateStream> dms = new List<DmLoanRateStream>();
        
        if (pms == null) { return dms; }
        else {
            for (PM_LLCBI_Pricing_Rate_Component_c pm : pms) {
                dms.add(m_dmbuilderHelper.buildRateStream(pm));
            }
        }
        return dms;
    }
}