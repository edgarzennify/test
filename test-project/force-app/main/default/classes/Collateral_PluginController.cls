public with sharing class Collateral_PluginController {
    private Boolean m_wasEbCollateralLoaded = false;
    private LLC_BI__Collateral__c m_collateral = null;
    private EB_Collateral__c m_ebCollateral = null;
    private final Plugin.ICollateral_PluginDataProvider m_dataProvider;
    private final IStandardController m_standardControllerWrapper;  
    
    public Collateral_PluginController(Plugin.ICollateral_PluginDataProvider dataProvider, IStandardController controller) {
        m_standardControllerWrapper = controller;
        m_dataProvider = dataProvider;
    }
    
    public Collateral_PluginController(ApexPages.StandardController controller) {
        m_standardControllerWrapper = new StandardControllerWrapper(controller);
        m_dataProvider = new Collateral_PluginDataProvider();       
    }
    
    public LLC_BI__Collateral__c collateral{
        get {
            if(m_collateral == null){
                m_collateral = m_dataProvider.getNcinoCollateralById(m_standardControllerWrapper.getRecord().id);                                
            }
            return m_collateral;
        }
    }
    
    public EB_Collateral__c ebCollateral{
        get{
            if(!m_wasEbCollateralLoaded){         
                List<EB_Collateral__c> ebCollateral = m_dataProvider.getEbCollateralByNameOrKey(collateral.Name, collateral.Sync_Key__c);
                if(ebCollateral != null && ebCollateral.size() == 1){
                    m_ebCollateral = ebCollateral[0];
                }
                m_wasEbCollateralLoaded = true;
            }
            return m_ebCollateral;
        }
    }
}