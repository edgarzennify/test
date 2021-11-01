public with sharing class EbAccount_InterstitialController  {
    
    public EB_Account__c m_ebAccount = null; 
    private final ObjectForward.IManager m_forwardManager = null;
    private ObjectForward.IForwardingInfo m_forwardingInfo = null;
    private final Interstitial.IEbAccount_InterstitialDataProvider m_dataProvider;
    private IStandardController m_standardControllerWrapper;
    
    public EbAccount_InterstitialController(ObjectForward.IForwardingInfo forwardingInfo, ObjectForward.IManager forwardManager, Interstitial.IEbAccount_InterstitialDataProvider dataProvider, IStandardController controller) {
        m_standardControllerWrapper = controller;
        m_dataProvider = dataProvider;
        m_forwardManager = forwardManager;
        m_forwardingInfo = forwardingInfo;
        init();
    }
    
    public EbAccount_InterstitialController(ApexPages.StandardController controller) {
        m_standardControllerWrapper = new StandardControllerWrapper(controller);
        IUserInfoService userInfoService = UserInfoService.bootstrap();
        m_forwardManager = new ObjectForwardManager(new ObjectForwardDataProvider(new ObjectForwardDmBuilder()), new ObjectForward.ForwardingInfo(), userInfoService); 
        m_dataProvider = new EbAccount_InterstitialDataProvider();    
        init();
    }
    
    private void init(){
        List<EB_Account__c> ebAccts = m_dataProvider.getEbAccountById(m_standardControllerWrapper.getRecord().Id);
        if(ebAccts != null && ebAccts.size() == 1){
             m_ebAccount = ebAccts[0]; 
        }
    }
  
    public EB_Account__c ebAccount{
        get {
            return m_ebAccount;
        }
    }
    
    public ObjectForward.IForwardingInfo forwardingInfo{
        get {
            if(m_forwardingInfo == null){
                m_forwardingInfo = m_forwardManager.getForwardingInfo('EB_Account__c', m_ebAccount.RecordType.Name, m_ebAccount.Id);
            }
            return m_forwardingInfo;
        }
    }

    public String originalUrl{
        get{
            return '/' + String.valueOf(ebAccount.Id) + '?nooverride=1';
        }
    }
   
    public PageReference redirect(){      
        return m_forwardManager.redirect(forwardingInfo, originalUrl);                  
    }
}