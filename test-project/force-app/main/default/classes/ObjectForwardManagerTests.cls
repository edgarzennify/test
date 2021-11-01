@IsTest
public class ObjectForwardManagerTests {

    private static ObjectForwardManager sut;
    private static final MockOfIDataProvider mockDataProvider;
    private static final MockOfIForwardingInfo mockForwardingInfo;
    private static final Mock.ofIUserInfoService mockUserInfo;
    
    static {
        mockDataProvider = new MockOfIDataProvider();
        mockForwardingInfo = new MockOfIForwardingInfo();
        mockUserInfo = new Mock.ofIUserInfoService();
        sut = new ObjectForwardManager(mockDataProvider, mockForwardingInfo, mockUserInfo);
    }
    
    @IsTest
    static void it_should_call_the_data_provider_to_getForwards() {
        String origObjName = 'EB_Account__c'; 
        String origObjRecordTypeName = 'Loan';
        Id origObjId = 'a02000000000000';
        mockDataProvider.setup('getForwards', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(new List<ObjectForward.DmForward>());
     
        ObjectForward.IForwardingInfo result = sut.getForwardingInfo(origObjName, origObjRecordTypeName, origObjId);
        
        mockDataProvider.verify('getForwards', new List<Object>{origObjName, origObjRecordTypeName}, Times.Once);
    }
    
    @IsTest
    static void it_should_return_nCino_loan_forwarding_info_given_ebAccount_loan_info() {
        EB_Account__c ebAccount = new EB_Account__c();
        ebAccount.Key__c = '616-15-1234';
        insert ebAccount;
        
        LLC_BI__Loan__c testNcinoLoan = new LLC_BI__Loan__c();
        testNcinoLoan.LLC_BI__lookupKey__c = '616-15-1234';
        testNcinoLoan.Name = '1234-15';
        insert testNcinoLoan;
        
        String origObjName = 'EB_Account__c'; 
        String origObjRecordTypeName = 'Loan';
        Id origObjId = ebAccount.Id;
        
        List<ObjectForward.DmForward> dmForwards = new List<ObjectForward.DmForward>();
        ObjectForward.DmForward dmForward1 = new ObjectForward.DmForward();
        dmForward1.originalObjectName = 'EB_Account__c'; 
        dmForward1.originalObjectLookupField = 'Key__c'; 
        Type t = Type.forName('LLC_BI__Loan__c');
        SObject o = (SObject)t.newInstance();
        dmForward1.sObjectType = o.getSObjectType();                
        dmForward1.lookupField = 'LLC_BI__lookupKey__c';
        dmForward1.showInterstitial = false;
        dmForwards.add(dmForward1);
        mockUserInfo.setup('isCurrentUserLicensed', new List<Object>{'LLC_BI'}).returns(true);
        mockDataProvider.setup('getForwards', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(dmForwards);
        mockDataProvider.setup('queryOne', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(ebAccount);
        mockDataProvider.setup('query', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new List<SObject>{testNcinoLoan});
     
        ObjectForward.IForwardingInfo result = sut.getForwardingInfo(origObjName, origObjRecordTypeName, origObjId);
        
        System.assertEquals('/' + testNcinoLoan.Id, result.getUrl());
        System.assertEquals('Loan', result.getObjectLabel());
        System.assertEquals('1234-15', result.getRecordName());
        System.assertEquals(false, result.getShowInterstitial());        
    }

    @IsTest
    static void it_should_return_empty_forwarding_info_when_no_ncino_loan_is_found_for_given_ebAccount() {
        EB_Account__c ebAccount = new EB_Account__c();
        ebAccount.Key__c = '616-15-1234';
        insert ebAccount;
        
        String origObjName = 'EB_Account__c'; 
        String origObjRecordTypeName = 'Loan';
        Id origObjId = ebAccount.Id;
        
        List<ObjectForward.DmForward> dmForwards = new List<ObjectForward.DmForward>();
        ObjectForward.DmForward dmForward1 = new ObjectForward.DmForward();
        dmForward1.originalObjectName = 'EB_Account__c'; 
        dmForward1.originalObjectLookupField = 'Key__c'; 
        Type t = Type.forName('LLC_BI__Loan__c');
        SObject o = (SObject)t.newInstance();
        dmForward1.sObjectType = o.getSObjectType();                
        dmForward1.lookupField = 'LLC_BI__lookupKey__c';
        dmForward1.showInterstitial = false;
        dmForwards.add(dmForward1);
        mockUserInfo.setup('isCurrentUserLicensed', new List<Object>{'LLC_BI'}).returns(true);
        mockDataProvider.setup('getForwards', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(dmForwards);
        mockDataProvider.setup('queryOne', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(ebAccount);
        mockDataProvider.setup('query', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE).returns(new List<SObject>());
     
        ObjectForward.IForwardingInfo result = sut.getForwardingInfo(origObjName, origObjRecordTypeName, origObjId);
        
        System.assertEquals(null, result.getUrl());
        System.assertEquals(null, result.getObjectLabel());
        System.assertEquals(null, result.getRecordName());
        System.assertEquals(null, result.getShowInterstitial());        
    }
    
    @IsTest
    static void it_should_return_the_correct_PageReference_when_Url_is_not_null_and_showInterstitial_is_false() {
        String testOriginalUrl = '';        
        mockForwardingInfo.setup('getUrl').returns('testUrl');
        mockForwardingInfo.setup('getShowInterstitial').returns(false);
        
        PageReference result = sut.redirect(mockForwardingInfo, testOriginalUrl);
        
        System.assertEquals('testUrl', result.getUrl());
    }
       
    @IsTest
    static void it_should_return_a_null_PageReference_when_Url_is_not_null_and_showInterstitial_is_true() {
        String testOriginalUrl = ''; 
        mockForwardingInfo.setup('getUrl').returns('testUrl');
        mockForwardingInfo.setup('getShowInterstitial').returns(true);
        
        PageReference result = sut.redirect(mockForwardingInfo, testOriginalUrl);
        
        System.assertEquals(null, result);
    }
    
    @IsTest
    static void it_should_return_a_PageReference_based_on_the_given_originalUrl_when_Url_is_null() {
        String testOriginalUrl = '/a07000000000000?nooverride=1'; 
        mockForwardingInfo.setup('getUrl').returns(null);
        mockForwardingInfo.setup('getShowInterstitial').returns(null);
        
        PageReference result = sut.redirect(mockForwardingInfo, testOriginalUrl);
        
        System.assertEquals('/a07000000000000?nooverride=1', result.getUrl());
    }
    
    public class MockOfIDataProvider extends ApexMoq implements ObjectForward.IDataProvider {
        public List<ObjectForward.DmForward> getForwards(String origObjName, String origObjRecordTypeName){
            return (List<ObjectForward.DmForward>)handleMethodInvocation('getForwards', new List<Object>{origObjName, origObjRecordTypeName});
        }
        public SObject queryOne(String queryString){
            return (SObject)handleMethodInvocation('queryOne', new List<Object>{queryString});
        }
        public List<SObject> query(String queryString){
            return (List<SObject>)handleMethodInvocation('query', new List<Object>{queryString});
        }
    } 
    
    public class MockOfIForwardingInfo extends ApexMoq implements ObjectForward.IForwardingInfo {
        public String getUrl(){
            return (String)handleMethodInvocation('getUrl');
        }
        public String getObjectLabel(){
            return (String)handleMethodInvocation('getObjectLabel');
        }
        public String getRecordName(){
            return (String)handleMethodInvocation('getRecordName');
        }
        public Boolean getShowInterstitial(){
            return (Boolean)handleMethodInvocation('getShowInterstitial');
        }
     }
}