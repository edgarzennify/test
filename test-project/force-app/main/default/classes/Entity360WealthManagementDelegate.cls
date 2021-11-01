public class Entity360WealthManagementDelegate implements Entity360.IEntity360Delegate
{
    //private static final String WEALTHMGMT = 'WEALTHMGMT';
    private Entity360.ElementType m_type = Entity360.ElementType.WEALTH_MANAGEMENT;

    public DmProductOverview assembleFrom(DmEntity dmEntity)
    {
        DmProductOverview ov = new DmProductOverview();
        ov.type = m_type;
        ov.existingValue = calculateExistingValue(dmEntity.ownedAccounts);
        ov.opportunityValue = calculateOpportunityValue(dmEntity.opportunities);
        ov.opportunityProbability = calculateOpportunityProbability(dmEntity.opportunities);
        return ov;
    }

    private Decimal calculateExistingValue(List<DmEbAccount> ownedAccounts){
        if(ownedAccounts != null){
            Decimal accountFees = 0.0;
            for(DmEbAccount a : ownedAccounts){
                if(a.application == 1 && a.accountFees != null){    
                    accountFees += a.accountFees;
                } 
            }
            return accountFees;
        }
        else{
            return 0.0;
        }    
    }

    private Decimal calculateOpportunityValue(List<DmOpportunity> opportunities){
        if(opportunities != null){
            Decimal potentialFeeIncome = 0.0;
            for(DmOpportunity o : opportunities){
                if(o.recordType.description == 'Wealth Management Opportunities' && o.potentialFeeIncome != null && o.probability != null){
                    potentialFeeIncome += o.potentialFeeIncome;
                }
            }
            return potentialFeeIncome;
        }
        else{
            return 0.0;
        }
    }

    private Decimal calculateOpportunityProbability(List<DmOpportunity> opportunities){
        if(opportunities != null){
            Decimal weightedPotentialFeeIncome = 0.0;
            Decimal totalPotentialFeeIncome = 0.0;
            for(DmOpportunity o : opportunities){
                if(o.recordType.description == 'Wealth Management Opportunities' && o.potentialFeeIncome != null && o.probability != null){
                    weightedPotentialFeeIncome += o.potentialFeeIncome * o.probability;
                    totalPotentialFeeIncome += o.potentialFeeIncome;
                }
            }
            return totalPotentialFeeIncome == 0.0 ? 0.0 : weightedPotentialFeeIncome / totalPotentialFeeIncome;
        }
        else{
            return 0.0;
        }
    }
}