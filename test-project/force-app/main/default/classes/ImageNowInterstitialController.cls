public class ImageNowInterstitialController {
    
    private final IUserInfoService m_userInfo;
    private final IApexPages m_page;
    private final Configurations.IConfigurations m_configs;

    public ImageNowInterstitialController(){
        m_userInfo = UserInfoService.bootstrap();
        m_page = new ApexPagesWrapper();
        m_configs = Configurations.bootstrap();
    }
    
    public ImageNowInterstitialController(IUserInfoService userInfo, IApexPages page, Configurations.IConfigurations configs){
        m_userInfo = userInfo;
        m_page = page;
        m_configs = configs;
    }
    
    public PageReference redirect(){
        String urlTemplate = m_configs.get('ImageNowDocumentLinkTemplate');
        if(m_userInfo.hasPermissionSet('Function - ImageNow Link BETA')){
            urlTemplate = m_configs.get('ImageNowDocumentLinkTemplate_BETA');
        }
        return new PageReference(urlTemplate.replace('{documentId}', m_page.getParameter('docid')));
    }
}