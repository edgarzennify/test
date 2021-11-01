public class Entity360CreditCardDelegate implements Entity360.IEntity360Delegate
{
    private Entity360.ElementType m_type = Entity360.ElementType.CREDIT_CARD;

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
        Decimal creditCardCount = 0.0;
        if(ownedAccounts != null){  
            for (DmEbAccount a : ownedAccounts)
            {  
                if (a.application == 50 && (a.accountType == '50' || a.accountType == '10'))
                {
                    ++creditCardCount;
                }
            }
        }
        return creditCardCount;
    }

    private Decimal calculateOpportunityValue(List<DmOpportunity> allOpps)
    {
        Decimal totalOpportunityValues = 0.0;
        if(allOpps != null){ 
            for (DmOpportunity o : getCreditCardOpportunities(allOpps))
            {
                ++totalOpportunityValues;
            }
        }
        return totalOpportunityValues;
    }  

    private List<DmOpportunity> getCreditCardOpportunities(List<DmOpportunity> allOpps)
    {
        List<DmOpportunity> cardOpps = new List<DmOpportunity>();
        if(allOpps != null){
            for (DmOpportunity o : allOpps)
            {
                if (String.IsNotBlank(o.Products) && o.probability != null)
                {
                    if(o.Products.toLowerCase().contains('credit card')) {cardOpps.add(o);}
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
            for (DmOpportunity o : getCreditCardOpportunities(allOpps))
            {
                totalWeight += o.probability;
                ++totalCount;

            }
        }
        
        return (totalCount == 0.0) ? 0.0 : (totalWeight / totalCount);
    }
}