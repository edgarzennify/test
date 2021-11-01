@IsTest
private class DocumentControllerTests {

    private static final Mock.ofIDocumentDataService mockDocumentDataService;
    private static final Mock.ofIEbObjectLookup mockObjectLookup;
    private static final MockOfIRelNavDocument mockRelNavDocument;
    private static DocumentController sut;

    static {
        mockDocumentDataService = new Mock.ofIDocumentDataService();
        mockObjectLookup = new Mock.ofIEbObjectLookup();
        mockRelNavDocument = new MockOfIRelNavDocument();
        sut = new DocumentController(mockDocumentDataService, mockObjectLookup, mockRelNavDocument); 
    }

    @IsTest
    static void it_should_call_the_rest_service_to_get_account_url() {
        EB_Team_Member__c newMember = ObjectFactory.getTeamMember('Test Member');
        Id clientRecordTypeId = utility.recordTypeObject( 'Account','Client').Id;        
        Account testEntity = ObjectFactory.getEntity('testEntity',clientRecordTypeId, newMember);
        Eb_Account__c testEbAccount = ObjectFactory.getEBAccount('testEbAccount','1234', testEntity);
        testEbAccount.Key__c = '616-2-1234';
        update testEbAccount;        
        String queryUrl = 'DocumentsUrl';
        String baseUrl = 'http://testUrl';
        String keyType = 'Account';
        String key = testEbAccount.Key__c;
        String serviceUrl = AssembleServiceUrl(baseUrl, keyType, key);
        EbObjectLookup.KeyAndType kt = new EbObjectLookup.KeyAndType(key, keyType);
        mockObjectLookup.Setup('getObjectKeyAndType', new List<Object>{testEbAccount.Id}).Returns(kt);
        mockDocumentDataService.Setup('BuildKey', new List<Object>{keyType, key, false}).Returns(baseUrl);
        //act
        sut.objectIdAttribute = testEbAccount.Id;        
        //assert 
        mockDocumentDataService.Verify('BuildKey', new List<Object>{keyType, key, false}, Times.Once);      
    }

    @IsTest
    static void code_coverage_1() {
        EB_Team_Member__c newMember = ObjectFactory.getTeamMember('Test Member');
        Id clientRecordTypeId = utility.recordTypeObject( 'Account','Client').Id;        
        Account testEntity = ObjectFactory.getEntity('testEntity',clientRecordTypeId, newMember);
        Eb_Account__c testEbAccount = ObjectFactory.getEBAccount('testEbAccount','1234', testEntity);
        testEbAccount.Key__c = '616-2-1234';
        update testEbAccount;        
        String queryUrl = 'DocumentsUrl';
        String baseUrl = 'http://testUrl';
        String keyType = 'Account';
        String key = testEbAccount.Key__c;
        String serviceUrl = AssembleServiceUrl(baseUrl, keyType, key);
        EbObjectLookup.KeyAndType kt = new EbObjectLookup.KeyAndType(key, keyType);
        mockObjectLookup.Setup('getObjectKeyAndType', new List<Object>{testEbAccount.Id}).Returns(kt);
        mockDocumentDataService.Setup('BuildKey', new List<Object>{keyType, key, false}).Returns(baseUrl);
        mockRelNavDocument.Setup('LoadList', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).Returns(listOfRelNavs());
        //act
        sut.objectIdAttribute = testEbAccount.Id; 
        sut.nextPage();
        sut.previousPage();
        sut.skipToSelectedPage();
        sut.ClearFilter();
        sut.filterResults();
        sut.SortData();
        sut.LoadFilterLists();
        Boolean b = sut.showEditLink;      
    }
    
    @IsTest
    static void code_coverage_call_default_constructor() {
         DocumentController xsut = new DocumentController();
    }

    private static string AssembleServiceUrl(String serviceBaseUrl, String keyType, String keys) {
        return String.Format('{0}/documents/rel_nav?key_type={1}&keys={2}&include_related={3}',new string[]{serviceBaseUrl, keyType, keys, 'false'});
    }

    private static List<RelNavDocument> listOfRelNavs() {
        List<RelNavDocument> rns = new List<RelNavDocument>();
        for(Integer i=0; i< 1000; ++i){
            rns.add(new RelNavDocument());
        }
        return rns;
    }

    public class MockOfIRelNavDocument extends ApexMoq implements Documents.IRelNavDocument {
        public void SaveList(List<RelNavDocument> oList, String listKey){
            handleMethodInvocation('SaveList', new List<Object>{oList, listKey});
        }
        public List<RelNavDocument> LoadList(String listKey, String sortByProperty, String sortByDirection){
            return (List<RelNavDocument>)handleMethodInvocation('LoadList', new List<Object>{listKey, sortByProperty, sortByDirection});
        }
        public List<RelNavDocument> LoadList(String listKey, String sortByProperty, String sortByDirection, Integer pageSize, Integer pageNumber, String conditions){
            return (List<RelNavDocument>)handleMethodInvocation('LoadList', new List<Object>{listKey, sortByProperty, sortByDirection, pageSize, pageNumber, conditions});
        }
        public List<RelNavDocument> LoadList(String listKey, String sortByProperty, String sortByDirection, Integer pageSize, Integer pageNumber, RelNavDocument.RelNavDocumentFilter filter){
            return (List<RelNavDocument>)handleMethodInvocation('LoadList', new List<Object>{listKey, sortByProperty, sortByDirection, pageSize, pageNumber, filter});
        }
    }
}