public class Entity360Repository implements Entity360.IEntity360Repository
{
    private final Entity360.IEntity360DataProvider m_dataProvider;
    private final List<Entity360.IEntity360Delegate> m_accountDelegates;

    public Entity360Repository(Entity360.IEntity360DataProvider dataProvider, List<Entity360.IEntity360Delegate> accountDelegates)
    {
        m_dataProvider = dataProvider;
        m_accountDelegates = accountDelegates;
    }

    public List<DmEntity> getEntityDms(String entityId)
    {
        return getEntityDms(new List<String> {entityId});
    }

    public List<DmEntity> getEntityDms(List<String> entityIds)
    {
        List<DmEntity> filledEntityDms = m_dataProvider.GetDmEntities(entityIds);
        return buildProductOverviewsAndCm(filledEntityDms);
    }

    public List<DmEntity> getRelationshipEntityDmsByEntityId(String entityId)
    {
        List<DmEntity> relationshipEntityDms = m_dataProvider.getAllRelationshipEntitiesBySingleEntityId(entityId);
        return buildProductOverviewsAndCm(relationshipEntityDms);
    }

    private List<DmEntity> buildProductOverviewsAndCm(List<DmEntity> entityDms)
    {
        for (DmEntity entityDm : entityDms)
        {
            entityDm.productOverviews = GetProductOverviews(entityDm);
            entityDm.cm = CalculateTotalCm(entityDm.ownedAccounts);
        }
        return entityDms;
    }
   
    private List<DmProductOverview> GetProductOverviews(DmEntity dmEntity)
    {
        List<DmProductOverview> productOverviews = new List<DmProductOverview>();

        for (Entity360.IEntity360Delegate delegate : m_accountDelegates)
        {
            productOverviews.add(delegate.assembleFrom(dmEntity));
        }

        return productOverviews;
    }

    private Decimal CalculateTotalCm(List<DmEbAccount> ownedAccounts)
    {
        Decimal totalCm = 0.0;
        if(ownedAccounts != null){
            for(DmEbAccount a : ownedAccounts){
                if(a.ytdContributionMargin != null) {
                    totalCm += a.ytdContributionMargin;
                }
            }
        }
        return totalCm;
    }
}