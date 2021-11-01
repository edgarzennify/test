public class Entity360TreasuryDelegate implements Entity360.IEntity360Delegate
{
    private static final String TREASURY = 'TREASURY';
    private Entity360.ElementType m_type = Entity360.ElementType.TREASURY;

    public DmProductOverview assembleFrom(DmEntity dmEntity){
        DmProductOverview ov = new DmProductOverview();
        ov.type = m_type;
        ov.existingValue = getTreasuryExistingValue(dmEntity);
        ov.opportunityValue = getNumberOfProductsInTmOpportunities(getTreasuryOpportunities(dmEntity.opportunities));
        ov.opportunityProbability = calculateOpportunityProbability(getTreasuryOpportunities(dmEntity.opportunities));
        return ov;
    }    

    private Decimal getTreasuryExistingValue(DmEntity dmEntity){
        if(dmEntity.treasuryServices != null){
            return Decimal.ValueOf(dmEntity.treasuryServices.size());
        } 
        return 0.0;
    }

    private Integer getNumberOfProductsInTmOpportunities(List<DmOpportunity> tmOpps){
        Integer productCount = 0;
        if(tmOpps != null){
            for(DmOpportunity tmOpp : tmOpps){
                productCount += getNumberOfProductsInTmOpportunity(tmOpp);
            }
        }    
        return productCount;
    }
    
    private Integer getNumberOfProductsInTmOpportunity(DmOpportunity tmOpp){
        List<String> products = new List<String>();
        if(tmOpp != null && tmOpp.products != null){
            products = tmOpp.products.split(';');
        }
        return products.size();
    }

    private List<DmOpportunity> getTreasuryOpportunities(List<DmOpportunity> allOpps)
    {
        List<DmOpportunity> tmOpps = new List<DmOpportunity>();
        if(allOpps != null){
            for (DmOpportunity o : allOpps)
            {
                if (o.recordType.description == 'Treasury Management Opportunities')
                {
                    tmOpps.add(o);
                }
            }
        }
        return tmOpps;
    }
    
    private Decimal calculateOpportunityProbability(List<DmOpportunity> tmOpps)
    {
        Decimal totalWeightedProductCount = 0.0;
        Decimal totalProductCount = 0.0;
        if(tmOpps != null){
            for (DmOpportunity o : tmOpps){
                    Integer p = getNumberOfProductsInTmOpportunity(o);
                    totalWeightedProductCount += o.probability * p;
                    totalProductCount += p;
            }
        }

        return (totalProductCount == 0.0) ? 0.0 : (totalWeightedProductCount / totalProductCount);
    }
}