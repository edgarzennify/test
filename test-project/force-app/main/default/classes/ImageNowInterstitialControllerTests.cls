@isTest
public class ImageNowInterstitialControllerTests {
    private static ImageNowInterstitialController sut;
    private static Mock.ofIUserInfoService mockUserInfo;
    private static Mock.ofIApexPages mockApexPages;
    private static Mock.ofIConfigurations mockConfigs;
    
    static {
        mockUserInfo = new Mock.ofIUserInfoService();
        mockApexPages = new Mock.ofIApexPages();
        mockConfigs = new Mock.ofIConfigurations();
        sut = new ImageNowInterstitialController(mockUserInfo, mockApexPages, mockConfigs);
    }
    
    private static testMethod void it_should_return_a_page_reference_to_the_ImageNowDocumentLinkTemplate_with_documentId_replaced_when_user_doesnt_have_reqd_permission_set(){
        String template1 = 'aaaaa{documentId}';
        String docId = '123456';
        mockConfigs.setup('get', new List<object>{'ImageNowDocumentLinkTemplate'}).returns(template1);
        mockUserInfo.setup('hasPermissionSet', new List<object>{'Function - ImageNow Link BETA'}).returns(false);
        mockApexPages.setup('getParameter', new List<object>{'docid'}).returns(docId);
        
        PageReference results = sut.redirect();
        
        System.assertEquals('aaaaa123456', results.getUrl());
    }
    
    private static testMethod void it_should_return_a_page_reference_to_the_ImageNowDocumentLinkTemplate_BETA_with_documentId_replaced_when_user_has_reqd_permission_set(){
        String template1 = 'aaaaa{documentId}';
        String template2 = 'bbbbb{documentId}';
        String docId = '123456';
        mockConfigs.setup('get', new List<object>{'ImageNowDocumentLinkTemplate'}).returns(template1);
        mockConfigs.setup('get', new List<object>{'ImageNowDocumentLinkTemplate_BETA'}).returns(template2);
        mockUserInfo.setup('hasPermissionSet', new List<object>{'Function - ImageNow Link BETA'}).returns(true);
        mockApexPages.setup('getParameter', new List<object>{'docid'}).returns(docId);
        
        PageReference results = sut.redirect();
        
        System.assertEquals('bbbbb123456', results.getUrl());
    }
    
    private static testMethod void code_coverage(){
        ImageNowInterstitialController cc = new ImageNowInterstitialController();
    }
}