public with sharing class EbCollateral_InterstitialController {

    public EB_Collateral__c m_ebCollateral = null;
    private final ObjectForward.IManager m_forwardManager = null;
    private ObjectForward.IForwardingInfo m_forwardingInfo = null;
    private final Interstitial.IEbCollateral_InterstitialDataProvider m_dataProvider;
    private IStandardController m_standardControllerWrapper;
    
    public EbCollateral_InterstitialController(ObjectForward.IManager forwardMgr, ObjectForward.IForwardingInfo forwardingInfo, Interstitial.IEbCollateral_InterstitialDataProvider dataProvider, IStandardController controller) {
        m_standardControllerWrapper = controller;
        m_dataProvider = dataProvider;
        m_forwardManager = forwardMgr;
        m_forwardingInfo = forwardingInfo;
        init();
    }
    
    public EbCollateral_InterstitialController(ApexPages.StandardController controller) {
        m_standardControllerWrapper = new StandardControllerWrapper(controller);
        IUserInfoService userInfoSercice = UserInfoService.bootstrap();
        m_forwardManager = new ObjectForwardManager(new ObjectForwardDataProvider(new ObjectForwardDmBuilder()), new ObjectForward.ForwardingInfo(), userInfoSercice); 
        m_dataProvider = new EbCollateral_InterstitialDataProvider();
        init();
    }
    
    private void init(){
        List<EB_Collateral__c> ebColls = m_dataProvider.getEbCollateralById(m_standardControllerWrapper.getRecord().Id);
        if(ebColls != null && ebColls.size() == 1){
             m_ebCollateral = ebColls[0];
        }
    }

    public EB_Collateral__c ebCollateral{
        get {
            return m_ebCollateral;
        }
    }
    
    public ObjectForward.IForwardingInfo forwardingInfo{
        get {
            if(m_forwardingInfo == null){
                m_forwardingInfo = m_forwardManager.getForwardingInfo('EB_Collateral__c', '*', m_ebCollateral.Id);
            }
            return m_forwardingInfo;
        }
    }

    public String originalUrl{
        get{
            return '/' + String.valueOf(ebCollateral.Id) + '?nooverride=1';
        }
    }

    public PageReference redirect(){
        return m_forwardManager.redirect(forwardingInfo, originalUrl); 
    }
}