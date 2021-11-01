public class Entity360DepositDelegate implements Entity360.IEntity360Delegate
{
    private Entity360.ElementType m_type = Entity360.ElementType.DEPOSIT;

    public DmProductOverview assembleFrom(DmEntity entity)
    {
        DmProductOverview ov = new DmProductOverview();
        ov.type = m_type;
        ov.existingValue = calculateExistingValue(entity.ownedAccounts);
        ov.opportunityValue = calculateOpportunityValue(entity.opportunities);
        ov.opportunityProbability = calculateOpportunityProbability(entity.opportunities);
        return ov;
    }

    private Decimal calculateExistingValue(List<DmEbAccount> ownedAccounts)
    {
        Decimal totalDepositBalance = 0.0;
        if(ownedAccounts != null){ 
            for (DmEbAccount a : ownedAccounts)
            {
                if ((a.application == 2 || a.application == 4 || a.application == 6) && a.employeeAccountFlag != null && a.averageBalance != null) 
                {
                    totalDepositBalance += GetAverageBalance(a);
                }
            }
        }
        return totalDepositBalance;
    }
        
    private Decimal GetAverageBalance(DmEbAccount a)
    {
        return a.employeeAccountFlag == 'Yes' ? 0.0 : a.averageBalance;
    }

    private Decimal calculateOpportunityValue(List<DmOpportunity> allOpps)
    {
        Decimal totalOpportunityValues = 0.0;
        for (DmOpportunity o : getDepositOpportunities(allOpps))
        {
            totalOpportunityValues += o.potentialDeposits;
        }
        return totalOpportunityValues;
    }

    private List<DmOpportunity> getDepositOpportunities(List<DmOpportunity> allOpps)
    {
        List<DmOpportunity> depositOpps = new List<DmOpportunity>();
        if(allOpps != null){
            for (DmOpportunity o : allOpps)
            {
                if (o.potentialDeposits != null) 
                {
                    depositOpps.add(o);
                }
            }
        }
        return depositOpps;
    }

    private Decimal calculateOpportunityProbability(List<DmOpportunity> allOpps)
    {
        Decimal totalWeightedAmount = 0.0;
        Decimal totalPotentialDeposits = 0.0;
        if(allOpps != null){
            for (DmOpportunity o : getDepositOpportunities(allOpps))
            {
                totalWeightedAmount += o.probability * o.potentialDeposits;
                totalPotentialDeposits += o.potentialDeposits;
            }
        }
        return (totalPotentialDeposits == 0.0) ? 0.0 : (totalWeightedAmount / totalPotentialDeposits);
    }
}