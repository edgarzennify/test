@IsTest
private class LeadTriggerUserRepositoryTests {
    
    private static final LeadTriggerUserRepository sut;
    private static final Mock.ofIUserInfoService mockUserInfoService;
    private static final MockOfILeadTriggerHandlerDataProvider mockDataProvider;
    private static final Mock.ofIUtility mockUtility;
    private static final Mock.ofIConfigurations mockConfigurations;

    static {
        mockUserInfoService = new Mock.ofIUserInfoService();
        mockDataProvider = new MockOfILeadTriggerHandlerDataProvider();
        mockUtility = new Mock.ofIUtility();
        mockConfigurations = new Mock.ofIConfigurations();
        sut = new LeadTriggerUserRepository(mockUserInfoService, mockDataProvider, mockUtility, mockConfigurations);
    }

    @IsTest
    static void it_should_return_the_current_user_pm() {
        Id userId = ObjectFactory.getFakeId(User.SObjectType, '1');
        PM_User currentUser = new PM_User();
        currentUser.Id = userId;

        mockUserInfoService
            .setup('getCurrentUserId')
            .returns(userId);
        
        mockDataProvider
            .setup('getCurrentUser', new List<Object>{userId})
            .returns(currentUser);
        
        PM_User results = sut.getCurrentUser();

        mockUserInfoService.verify('getCurrentUserId', Times.Once);
        mockDataProvider.verify('getCurrentUser', new List<Object>{userId}, Times.Once);
    }

    @IsTest
    static void it_should_return_all_potential_owner_pms_as_a_map() {
        Id id1 = ObjectFactory.getFakeId(User.SObjectType, '1');
        Id id2 = ObjectFactory.getFakeId(User.SObjectType, '2');
        Lead testLead1 = new Lead(OwnerId = id1);
        Lead testLead2 = new Lead(OwnerId = id2);
        List<Lead> leads = new List<Lead>{testLead1, testLead2};
        PM_User user1 = new PM_User();
        user1.Id = id1;
        PM_User user2 = new PM_User();
        user2.Id = id2;
        List<PM_User> referralOwners = new List<PM_User>{user1};
        List<PM_User> leadOwners = new List<PM_User>{user2};
        Set<Id> leadOwnerIds = new Set<Id>{id2};

        mockDataProvider
            .setup('getReferralMatrixOwners')
            .returns(referralOwners);
        mockUtility
            .setup('convertToIdSet', new List<Object>{leads, 'OwnerId'})
            .returns(leadOwnerIds);
        mockDataProvider
            .setup('getOriginalLeadOwners', new List<Object>{leadOwnerIds})
            .returns(leadOwners);
        
        Map<Id, PM_User> results = sut.getPotentialOwners(leads);

        Set<Id> keySet = results.keySet();
        System.assertEquals(2, keySet.size());
        System.assert(keySet.contains(id1));
        System.assert(keySet.contains(id2));
        List<PM_User> values = results.values();
        System.assertEquals(2, values.size());
        System.assert(values.contains(user1));
        System.assert(values.contains(user2));
    }

    @IsTest
    static void it_should_return_a_map_of_referring_user_pms() {
        Id id1 = ObjectFactory.getFakeId(User.SObjectType, '1');
        Id id2 = ObjectFactory.getFakeId(User.SObjectType, '2');
        Set<Id> referringIds = new Set<Id>{id1, id2};
        Lead lead1 = new Lead(Referring_User__c = id1);
        Lead lead2 = new Lead(Referring_User__c = id2);
        List<Lead> leads = new List<Lead>{lead1, lead2};
        PM_User user1 = new PM_User();
        user1.Id = id1;
        PM_User user2 = new PM_User();
        user2.Id = id2;
        List<PM_User> referrers = new List<PM_User>{user1, user2};

        mockUtility
            .setup('convertToIdSet', new List<Object>{leads, 'Referring_User__c'})
            .returns(referringIds);
        mockDataProvider
            .setup('getNewReferrers', new List<Object>{referringIds})
            .returns(referrers);

        Map<Id, PM_User> results = sut.getReferrers(leads);

        Set<Id> keySet = results.keySet();
        System.assertEquals(2, keySet.size());
        System.assert(keySet.contains(id1));
        System.assert(keySet.contains(id2));
        List<PM_User> values = results.values();
        System.assertEquals(2, values.size());
        System.assert(values.contains(user1));
        System.assert(values.contains(user2));
    }

    @IsTest
    static void it_should_return_a_map_of_owner_user_pms() {
        Id id1 = ObjectFactory.getFakeId(User.SObjectType, '1');
        Id id2 = ObjectFactory.getFakeId(User.SObjectType, '2');
        Set<Id> ownerIds = new Set<Id>{id1, id2};
        Lead oldLead1 = new Lead(OwnerId = id1);
        Lead oldLead2 = new Lead(OwnerId = id2);
        List<Lead> oldLeads = new List<Lead>{oldLead1, oldLead2};
        Lead newLead1 = new Lead(OwnerId = id1);
        Lead newLead2 = new Lead(OwnerId = id2);
        List<Lead> newLeads = new List<Lead>{newLead1, newLead2};

        PM_User user1 = new PM_User();
        user1.Id = id1;
        PM_User user2 = new PM_User();
        user2.Id = id2;
        List<PM_User> owners = new List<PM_User>{user1, user2};

        mockUtility
            .setup('convertToIdSet', new List<Object>{oldLeads, 'OwnerId'})
            .returns(ownerIds);
        mockUtility
            .setup('convertToIdSet', new List<Object>{newLeads, 'OwnerId'})
            .returns(ownerIds);
        mockDataProvider
            .setup('getOwners', new List<Object>{ownerIds})
            .returns(owners);

        Map<Id, PM_User> results = sut.getOwners(oldleads, newLeads);

        Set<Id> keySet = results.keySet();
        System.assertEquals(2, keySet.size());
        System.assert(keySet.contains(id1));
        System.assert(keySet.contains(id2));
        List<PM_User> values = results.values();
        System.assertEquals(2, values.size());
        System.assert(values.contains(user1));
        System.assert(values.contains(user2));
    }

    @IsTest
    static void it_should_call_configurations_and_return_the_pardot_user_id() {
        String pardotAppSettingLabel = 'PardotUserId';

        mockConfigurations
            .setup('get', new List<Object>{pardotAppSettingLabel})
            .returns('1234');

        String results = sut.getPardotUserId();

        mockConfigurations.verify('get', new List<Object>{pardotAppSettingLabel}, Times.Once);
        System.assertEquals('1234', results);
    }

    public class MockOfILeadTriggerHandlerDataProvider extends ApexMoq implements LeadTriggerHandlerDataProvider.ILeadTriggerHandlerDataProvider {
        public PM_User getCurrentUser(Id currentUserId){
            return (PM_User)handleMethodInvocation('getCurrentUser', new List<Object>{currentUserId});
        }
        public List<PM_User> getNewReferrers(Set<Id> referrerIds){
            return (List<PM_User>)handleMethodInvocation('getNewReferrers', new List<Object>{referrerIds});
        }
        public List<PM_User> getOriginalLeadOwners(Set<Id> ownerIds){
            return (List<PM_User>)handleMethodInvocation('getOriginalLeadOwners', new List<Object>{ownerIds});
        }
        public List<PM_User> getOwners(Set<Id> ownerIds){
            return (List<PM_User>)handleMethodInvocation('getOwners', new List<Object>{ownerIds});
        }
        public List<RecordType> getRecordTypes(){
            return (List<RecordType>)handleMethodInvocation('getRecordTypes');
        }
        public List<PM_User> getReferralMatrixOwners(){
            return (List<PM_User>)handleMethodInvocation('getReferralMatrixOwners');
        }
    }
}