public class TmBoardingServiceClientInfoProvider implements TmBoarding.IServiceClientInfoProvider{
    
    private final String TMBOARDING_SIGNATURE_EMAIL_DEBUG = 'TmBoardingSignatureEmailDebug';
    private final String TMBOARDING_SIGNATURE_EMAIL = 'TmBoardingSignatureEmail';
    private final String TMBOARDING_SIGNATURE_EMAIL_FIRST_NAME = 'TmBoardingSignatureEmailFirstName';
    private final String TMBOARDING_SIGNATURE_EMAIL_INITIAL = 'TmBoardingSignatureEmailInitial';
    private final String TMBOARDING_SIGNATURE_EMAIL_LAST_NAME = 'TmBoardingSignatureEmailLastName';
    private final String TMBOARDING_SIGNATURE_TMSA_EMAIL = 'TmBoardingTMSASignatureEmail';
    private final String DEBUG_TRUE = 'true';
    
    private final Configurations.IConfigurations m_config;
    public TmBoardingServiceClientInfoProvider(Configurations.IConfigurations config){
        m_config = config;
    }
    
    public List<TmBoardingServiceProxy.ClientInfo> getClientInfo(Map<String, Contact> contacts, List<TmBoarding.SignerInfo> signers, String roleIdentifier){
        
        List<TmBoardingServiceProxy.ClientInfo> clientInfos = new List<TmBoardingServiceProxy.ClientInfo>();
        string isDebugStr = m_config.get(TMBOARDING_SIGNATURE_EMAIL_DEBUG);
        if(String.isBlank(isDebugStr)){throw new TmBoarding.SignerClientInfoException();}
        Boolean isDebug = String.isNotBlank(isDebugStr) && isDebugStr.toLowerCase() == DEBUG_TRUE?true:false;

        for(TmBoarding.SignerInfo i : signers){
        
            ValidateSigner(i);
            TmBoardingServiceProxy.ClientInfo cls = new TmBoardingServiceProxy.ClientInfo();
            if(i.tmo == null){
                Contact c = contacts.get(i.SignerId);
                if(isDebug == true){
                    cls = getDebugClientInfo(false);
                }else{
                    cls.firstName = c.firstName;
                    cls.lastName  = c.lastName;
                    cls.emailAddress = c.Email;
                    cls.Initial = '';
                }
            }else{
                if(isDebug == true){
                    cls = getDebugClientInfo(true);
                }else{
                    cls.firstName = i.tmo.firstName;
                    cls.lastName  = i.tmo.lastName;
                    cls.emailAddress = i.tmo.Email;
                    cls.Initial = '';
                }
            }
            cls.securityCode = i.securityCode;
            cls.SignatureRoleIdentifier = i.SignerCode;
            cls.SignatureRolePriority = i.Priority;
        
            clientInfos.add(cls);
        }
        return clientInfos;
    }

    private TmBoardingServiceProxy.ClientInfo getDebugClientInfo(boolean isTmsa){
        TmBoardingServiceProxy.ClientInfo cls = new TmBoardingServiceProxy.ClientInfo();
        cls.firstName = m_config.get(TMBOARDING_SIGNATURE_EMAIL_FIRST_NAME);
        cls.lastName  = m_config.get(TMBOARDING_SIGNATURE_EMAIL_LAST_NAME);
        cls.emailAddress = isTmsa == true? m_config.get(TMBOARDING_SIGNATURE_TMSA_EMAIL): m_config.get(TMBOARDING_SIGNATURE_EMAIL);
        String initial = m_config.get(TMBOARDING_SIGNATURE_EMAIL_INITIAL);
        cls.Initial = String.isBlank(initial)?'':initial;
        return cls;
    }

    private void ValidateSigner(TmBoarding.SignerInfo info){
        if(String.IsBlank(info.SignerCode) || info.Priority == null || info.Priority == 0){throw new TmBoarding.SignerException();}
    }
}