public class Entity360LoanDelegate implements Entity360.IEntity360Delegate
{
    //private static final String LOAN = 'LOAN';
    private Entity360.ElementType m_type = Entity360.ElementType.LOAN;

    public DmProductOverview assembleFrom(DmEntity entity)
    {
        DmProductOverview ov = new DmProductOverview();
        //ov.name = LOAN;
        ov.type = m_type;
        ov.existingValue = calculateExistingValue(entity.ownedAccounts);
        ov.opportunityValue = calculateOpportunityValue(entity.opportunities);
        ov.opportunityProbability = calculateOpportunityProbability(entity.opportunities);
        return ov;
    }

    private Decimal calculateExistingValue(List<DmEbAccount> ownedAccounts)
    {
        Decimal totalLoanBalance = 0.0;
        if(ownedAccounts != null){  
            for (DmEbAccount a : ownedAccounts)
            {  
                if ((a.application == 11 || a.application == 13 || a.application == 15) && a.averageBalance != null) 
                {
                    totalLoanBalance += a.averageBalance;
                }
            }
        }
        return totalLoanBalance;
    }

    private Decimal calculateOpportunityValue(List<DmOpportunity> allOpps)
    {
        Decimal totalOpportunityValues = 0.0;
        if(allOpps != null){ 
            for (DmOpportunity o : getLoanOpportunities(allOpps))
            {
                totalOpportunityValues += o.committedAmount;
            }
        }
        return totalOpportunityValues;
    }  

    private List<DmOpportunity> getLoanOpportunities(List<DmOpportunity> allOpps)
    {
        List<DmOpportunity> loanOpps = new List<DmOpportunity>();
        if(allOpps != null){
            for (DmOpportunity o : allOpps)
            {
                if (o.committedAmount != null && o.probability != null)
                {
                    loanOpps.add(o);
                }
            }
        }
        return loanOpps;
    }

    private Decimal calculateOpportunityProbability(List<DmOpportunity> allOpps)
    {
        Decimal totalWeightedAmount = 0.0;
        Decimal totalCommittedAmount = 0.0;
        if(allOpps != null){
            for (DmOpportunity o : getLoanOpportunities(allOpps))
            {
                totalWeightedAmount += o.probability * o.committedAmount;
                totalCommittedAmount += o.committedAmount;
            }
        }
        return (totalCommittedAmount == 0.0) ? 0.0 : (totalWeightedAmount / totalCommittedAmount);
    }

    
}