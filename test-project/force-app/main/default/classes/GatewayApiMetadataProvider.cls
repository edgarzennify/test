public class GatewayApiMetadataProvider implements IGatewayApiMetadataProvider
{
    public interface IGatewayApiMetadataProvider{
        Map<string, DmGateway> GetAll();
        string GetResourceBy( string apiName );
    }
    
    private List<Gateway_Api__mdt> m_gateWayResources;
    
    public string GetResourceBy( string apiName )
    {
        DmGateway dm = GetAll().get(apiName);
        return dm == null ? '' : dm.Resource ;
    }
    
    public Map<string, DmGateway> GetAll()
    {
        return BuildDms(GetGatewayPms());
    }
    
    private Map<string, DmGateway> BuildDms(List<Gateway_Api__mdt> pms)
    {
        Map<string, DmGateway> dms = new Map<string, DmGateway>();
        
        for(Gateway_Api__mdt pm : pms)
        {      
            DmGateway dm = AssembleDm(pm);
            dms.put(dm.Name , dm);
        }
        
        return dms;
    }
    
    private DmGateway AssembleDm(Gateway_Api__mdt pm)
    {
        DmGateway dm = new DmGateway();
        dm.Name = pm.Label;
        dm.Resource = pm.Resource__c;
        return dm;
    }
    
    private List<Gateway_Api__mdt> GetGatewayPms()
    {
        if(m_gateWayResources == null) {
            m_gateWayResources = [
                 SELECT 
                      Label, 
                      Resource__c 
                      FROM Gateway_Api__mdt 
                 WHERE 
                      Active__c =: true
                ];
        }
        return m_gateWayResources; 
    }
    
    
}