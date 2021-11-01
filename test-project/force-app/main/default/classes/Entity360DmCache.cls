public class Entity360DmCache implements Entity360.IEntity360DmCache
{

    private static Map<String,DmEntity> m_entityDmsMap;
    
    public void setEntityDmsMap(Map<String,DmEntity> entityDmsMap)
    {
        m_entityDmsMap  = entityDmsMap;
    }
    
    public Map<String,DmEntity> getEntityDmsMap()
    {
        return m_entityDmsMap;
    }   
}