public class EbtDocManagerPluginManager implements EbtDocManager.IPluginManager{   
    
    private final List<EbtDocManager.IPlugin> m_plugins;
    
    public EbtDocManagerPluginManager(List<EbtDocManager.IPlugin> plugins){
        m_plugins = plugins;
    }
    
    public EbtDocManager.IPlugin getPluginByObjectId(Id objectId){
        for(EbtDocManager.IPlugin plugin : m_plugins){
            if(objectId.getSObjectType() == plugin.getSObjectTypeHandled()) return plugin;
        }
        throw new PluginNotFoundException();
    }
    
    public class PluginNotFoundException extends Exception{}
}