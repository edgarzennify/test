public class Entity360DebitCardDelegate implements Entity360.IEntity360Delegate
{
    private Entity360.ElementType m_type = Entity360.ElementType.DEBIT_CARD;

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
        Decimal debitCardCount = 0.0;
        if(ownedAccounts != null){  
            for (DmEbAccount a : ownedAccounts)
            {  
                if (a.application == 83) 
                {
                    ++debitCardCount;
                }
            }
        }
        return debitCardCount;
    }

    private Decimal calculateOpportunityValue(List<DmOpportunity> allOpps)
    {
        Decimal totalOpportunityValues = 0.0;
        if(allOpps != null){ 
            for (DmOpportunity o : getDebitCardOpportunities(allOpps))
            {
                ++totalOpportunityValues;
            }
        }
        return totalOpportunityValues;
    }  

    private List<DmOpportunity> getDebitCardOpportunities(List<DmOpportunity> allOpps)
    {
        List<DmOpportunity> cardOpps = new List<DmOpportunity>();
        if(allOpps != null){
            for (DmOpportunity o : allOpps)
            {
                if (String.IsNotBlank(o.Products) && o.probability != null)
                {
                    if(o.Products.toLowerCase().contains('debit card')) {cardOpps.add(o);}
                }
            }
        }
        return cardOpps;
    }

    private Decimal calculateOpportunityProbability(List<DmOpportunity> allOpps)
    {
        Decimal totalWeight = 0.0;
        Decimal totalCount = 0.0;
        if(allOpps != null){
            for (DmOpportunity o : getDebitCardOpportunities(allOpps))
            {
                totalWeight += o.probability;
                ++totalCount;
            }
        }
        return (totalCount == 0.0) ? 0.0 : (totalWeight / totalCount);
    }
}