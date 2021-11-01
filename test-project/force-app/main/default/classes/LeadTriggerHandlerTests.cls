@IsTest
private class LeadTriggerHandlerTests {
    
    private static final TriggerHandlerTester tester;
    private static final MockOfILeadTriggerHandlerDataProvider mockDataProvider;
    private static final MockOfILeadTriggerHandlerHelper mockHelper;
    private static final MockOfIReferralHandler mockReferralHandler;
    private static final MockOfILeadTriggerUserRepository mockUserRepository;
    private static final LeadTriggerHandler sut;

    static {
        tester = new TriggerHandlerTester();
        mockDataProvider = new MockOfILeadTriggerHandlerDataProvider();
        mockHelper = new MockOfILeadTriggerHandlerHelper();
        mockReferralHandler = new MockOfIReferralHandler();
        mockUserRepository = new MockOfILeadTriggerUserRepository();
        sut = new LeadTriggerHandler(mockDataProvider, mockHelper, mockReferralHandler, mockUserRepository);
    }

    @IsTest
    static void bulkBeforeInsert_get_the_current_user_object() {
        PM_User currentUser = new PM_User();
        currentUser.Id = ObjectFactory.getFakeId(User.SObjectType, '1');
        Lead ld1 = new Lead(Id = ObjectFactory.getFakeId(Lead.SObjectType, '1'));
        Lead ld2 = new Lead(Id = ObjectFactory.getFakeId(Lead.SObjectType, '2'));
        tester.triggerOld.add(ld1);
        tester.triggerOld.add(ld2);
        
        mockUserRepository
            .setup('getCurrentUser')
            .returns(currentUser);

        mockUserRepository
            .setup('getPotentialOwners', new List<Object>{tester.triggerOld})
            .returns(new Map<Id, PM_User>());
        
        tester.beforeTriggerInsertSequence(sut);
        
        mockUserRepository.verify('getCurrentUser', Times.Once);
    }

    @IsTest
    static void bulkBeforeInsert_it_should_get_potential_owners() {
        Lead ld1 = new Lead(FirstName = 'first name1');
        Lead ld2 = new Lead(FirstName = 'first name2');
        tester.triggerOld.add(ld1);
        tester.triggerOld.add(ld2);
        
        mockUserRepository
            .setup('getPotentialOwners', new List<Object>{tester.triggerOld})
            .returns(new Map<Id, PM_User>());

        tester.beforeTriggerInsertSequence(sut);

        mockUserRepository.verify('getPotentialOwners', new List<Object>{tester.triggerOld}, Times.Once);
    }

    @IsTest
    static void bulkBeforeInsert_it_should_build_a_map_with_the_recordTypes() {
        Lead ld1 = new Lead(FirstName = 'first name1');
        Lead ld2 = new Lead(FirstName = 'first name2');
        tester.triggerOld.add(ld1);
        tester.triggerOld.add(ld2);
        
        RecordType testType = new RecordType(Name = 'test type');
        List<RecordType> recordTypes = new List<RecordType>{testType};

        mockUserRepository
            .setup('getPotentialOwners', new List<Object>{tester.triggerOld})
            .returns(new Map<Id, PM_User>());

        mockDataProvider
            .setup('getRecordTypes')
            .returns(recordTypes);

        mockHelper
            .setup('mapRecordTypes', new List<Object>{recordTypes})
            .returns(new Map<String, RecordType>{'some name' => testType});
        
        tester.beforeTriggerInsertSequence(sut);

        mockDataProvider.Verify('getRecordTypes', Times.Once);
        mockHelper.verify('mapRecordTypes', new List<Object>{recordTypes}, Times.Once);
    }

    @IsTest
    static void bulkBeforeInsert_it_should_populate_the_pardot_user_property() {
        String pardotUserId = '1234';
        Lead ld1 = new Lead(FirstName = 'first name1');
        Lead ld2 = new Lead(FirstName = 'first name2');
        tester.triggerOld.add(ld1);
        tester.triggerOld.add(ld2);

        mockUserRepository
            .setup('getPardotUserId')
            .returns(pardotUserId);
        
        tester.beforeTriggerInsertSequence(sut);

        mockUserRepository.verify('getPardotUserId', Times.Once);
    }

    @IsTest
    static void bulkBeforeInsert_call_dependencies_before_inserting_each_lead() {
        Lead ld1 = new Lead(FirstName = 'first name1');
        Lead ld2 = new Lead(FirstName = 'first name2');
        tester.triggerOld.add(ld1);
        tester.triggerOld.add(ld2);

        PM_User currentUser = new PM_User();
        currentUser.Id = '1';
        String pardotUserId = '1234';

        PM_User potentialOwner = new PM_User();
        potentialOwner.Id = ObjectFactory.getFakeId(User.SObjectType, '2');
        Map<Id, PM_User> potentialOwners = new Map<Id, PM_User>();
        potentialOwners.put(potentialOwner.Id, potentialOwner);

        RecordType testType = new RecordType(Name = 'test type');
        List<RecordType> recordTypes = new List<RecordType>{testType};
        Map<String, RecordType> rtMap = new Map<String, RecordType>{'test type' => testType};
        
        mockUserRepository
            .setup('getPotentialOwners', new List<Object>{tester.triggerOld})
            .returns(potentialOwners);

        mockUserRepository
            .setup('getCurrentUser')
            .returns(currentUser);

        mockUserRepository
            .setup('getPardotUserId')
            .returns(pardotUserId);

        mockDataProvider
            .setup('getRecordTypes')
            .returns(recordTypes);

        mockHelper
            .setup('mapRecordTypes', new List<Object>{recordTypes})
            .returns(rtMap);
        
        tester.beforeTriggerInsertSequence(sut);

        mockHelper.verify('initializeLeadOwner', new List<Object>{ld1, currentUser, pardotUserId, potentialOwners}, Times.Once);
        mockHelper.verify('validateCountryField', new List<Object>{ld1}, Times.Once);
        mockHelper.verify('validateCompanyField', new List<Object>{ld1}, Times.Once);
        mockReferralHandler.verify('handleReferrals', new List<Object>{ld1, potentialOwners, currentUser, rtMap}, Times.Once);
        mockHelper.verify('initializeLeadOwner', new List<Object>{ld2, currentUser, pardotUserId, potentialOwners}, Times.Once);
        mockHelper.verify('validateCountryField', new List<Object>{ld2}, Times.Once);
        mockHelper.verify('validateCompanyField', new List<Object>{ld2}, Times.Once);
        mockReferralHandler.verify('handleReferrals', new List<Object>{ld2, potentialOwners, currentUser, rtMap}, Times.Once);
    }

    @IsTest
    static void bulkBeforeUpdate_it_should_get_new_lead_referrers() {
        Id lead1Id = ObjectFactory.getFakeId(Lead.SObjectType, '1');
        Lead oldLd1 = new Lead(Id = lead1Id, LastName = 'last1');
        tester.triggerOld.add(oldLd1);
        Lead newLd1 = new Lead(Id = lead1Id, LastName = 'last1');
        tester.triggerNew.add(newLd1);
        
        tester.beforeTriggerUpdateSequence(sut);

        mockUserRepository.verify('getReferrers', new List<Object>{tester.triggerNew}, Times.Once);
    }

    @IsTest
    static void bulkBeforeUpdate_it_should_get_lead_owners() {
        Lead oldLd1 = new Lead(Id = ObjectFactory.getFakeId(Lead.SObjectType, '1'));
        Lead newLd1 = new Lead(Id = ObjectFactory.getFakeId(Lead.SObjectType, '1'));
        Lead oldLd2 = new Lead(Id = ObjectFactory.getFakeId(Lead.SObjectType, '2'));
        Lead newLd2 = new Lead(Id = ObjectFactory.getFakeId(Lead.SObjectType, '2'));
        tester.triggerOld.add(oldLd1);
        tester.triggerOld.add(oldLd2);
        tester.triggerNew.add(newLd1);
        tester.triggerNew.add(newLd2);
        
        tester.beforeTriggerUpdateSequence(sut);

        mockUserRepository.verify('getOwners', new List<Object>{tester.triggerOld, tester.triggerNew}, Times.Once);
    }

    @IsTest
    static void bulkBeforeUpdate_call_dependencies_before_updating_each_lead() {
        PM_User currentUser = new PM_User();
        currentUser.Id = ObjectFactory.getFakeId(User.SObjectType, '1');

        PM_User referrer = new PM_User();
        referrer.Id = ObjectFactory.getFakeId(User.SObjectType, '2');
        Set<Id> referrerIds = new Set<Id>{referrer.Id};
        List<PM_User> referrers = new List<PM_User>{referrer};
        Map<Id, PM_User> referrersMap = new Map<Id, PM_User>();
        referrersMap.put(referrer.Id, referrer);
        
        PM_User oldOwner = new PM_User();
        oldOwner.Id = ObjectFactory.getFakeId(User.SObjectType, '100');
        PM_User newOwner = new PM_User();
        newOwner.Id = ObjectFactory.getFakeId(User.SObjectType, '101');
        Set<Id> ownerIds = new Set<Id>{oldOwner.Id, newOwner.Id};
        List<PM_User> ownersList = new List<PM_User>{oldOwner, newOwner};
        Map<Id, PM_User> ownersMap = new Map<Id, PM_User>();
        ownersMap.put(oldOwner.Id, oldOwner);
        ownersMap.put(newOwner.Id, newOwner);

        Lead oldLd1 = new Lead(Id = ObjectFactory.getFakeId(Lead.SObjectType, '1'), OwnerId = oldOwner.Id);
        Lead newLd1 = new Lead(Id = ObjectFactory.getFakeId(Lead.SObjectType, '1'), OwnerId = newOwner.Id);
        tester.triggerOld.add(oldLd1);
        tester.triggerNew.add(newLd1);

        mockUserRepository
            .setup('getReferrers', new List<Object>{tester.triggerNew})
            .returns(referrersMap);
        
        mockUserRepository
            .setup('getOwners', new List<Object>{tester.triggerOld, tester.triggerNew})
            .returns(ownersMap);
        
        tester.beforeTriggerUpdateSequence(sut);

        mockHelper.verify('handleLeadHandoff', new List<Object>{oldLd1, newLd1, ownersMap}, Times.Once);
        mockReferralHandler.verify('handleReferrals', new List<Object>{oldLd1, newLd1, referrersMap}, Times.Once);
        mockHelper.verify('handleOwnerUpdates', new List<Object>{oldLd1, newLd1, ownersMap}, Times.Once);
    }

    // @IsTest
    static void INTEGRATION_it_should_insert_this_valid_internal_referral_lead() {
        Lead testLead = new Lead(
            FirstName = 'test',
            LastName = 'name',
            LeadSource = 'Call In',
            Description = 'test Desc',
            COVID_19_Related_Loan__c = 'No',
            EB_Branch__c = 'a0I2i000000ERtC', //Support center ID from Dev
            Type__c = 'Personal',
            Is_Customer__c = 'Unknown',
            Email = 'some@fake.com.elkfnsdf',
            Opportunity_Type__c = 'Wealth Management',
            RecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('Internal Referral', 'Lead')
        );
        insert testLead;
    }

    // @IsTest
    static void INTEGRATION_bulkBeforeInsert_a_pardot_user_should_be_able_to_insert_a_lead_and_assign_the_owner() {
        User pardotUser = ObjectFactory.getUser('pard');
        User owner = ObjectFactory.getUser('jchad');
        Id mql = ObjectFactory.getRecordTypeIdByNameAndObject('MQL', 'Lead');
        Lead ld = new Lead(
                FirstName = 'Lauren',
                LastName = 'Hill',
                Company = 'HEC',
                Title = 'Education Advisor',
                RecordTypeId = mql,
                OwnerId = owner.Id
            );

        System.runAs(pardotUser) { insert ld; }

        Lead subjectLead = [SELECT Id, OwnerId FROM Lead WHERE Id =: ld.Id];

        System.assertEquals(owner.Id, subjectLead.OwnerId);
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

    public class MockOfILeadTriggerHandlerHelper extends ApexMoq implements LeadTriggerHandlerHelper.ILeadTriggerHandlerHelper {
        public void handleLeadHandoff(Lead oldLd, Lead newLd, Map<Id, PM_User> owners){
            handleMethodInvocation('handleLeadHandoff', new List<Object>{oldLd, newLd, owners});
        }
        public void handleOwnerUpdates(Lead oldLd, Lead newLd, Map<Id, PM_User> potentialOwnersMap){
            handleMethodInvocation('handleOwnerUpdates', new List<Object>{oldLd, newLd, potentialOwnersMap});
        }
        public void initializeLeadOwner(Lead ld, PM_User currentUser, String pardotUserId, Map<Id, PM_User> potentialOwners){
            handleMethodInvocation('initializeLeadOwner', new List<Object>{ld, currentUser, pardotUserId, potentialOwners});
        }
        public Map<String, RecordType> mapRecordTypes(List<RecordType> recordTypes){
            return (Map<String, RecordType>)handleMethodInvocation('mapRecordTypes', new List<Object>{recordTypes});
        }
        public void validateCompanyField(Lead ld){
            handleMethodInvocation('validateCompanyField', new List<Object>{ld});
        }
        public void validateCountryField(Lead ld){
            handleMethodInvocation('validateCountryField', new List<Object>{ld});
        }
    }

    public class MockOfIReferralHandler extends ApexMoq implements ReferralHandler.IReferralHandler {
        public void handleReferrals(Lead ld, Map<Id, PM_User> potentialOwnersMap, PM_User currentUser, Map<String, RecordType> rtMap){
            handleMethodInvocation('handleReferrals', new List<Object>{ld, potentialOwnersMap, currentUser, rtMap});
        }
        public void handleReferrals(Lead oldLd, Lead newLd, Map<Id, PM_User> referrersMap){
            handleMethodInvocation('handleReferrals', new List<Object>{oldLd, newLd, referrersMap});
        }
    }

    public class MockOfILeadTriggerUserRepository extends ApexMoq implements LeadTriggerUserRepository.ILeadTriggerUserRepository{
        public PM_User getCurrentUser(){
            return (PM_User)handleMethodInvocation('getCurrentUser');
        }
        public String getPardotUserId(){
            return (String)handleMethodInvocation('getPardotUserId');
        }
        public Map<Id, PM_User> getPotentialOwners(List<SObject> SObjects){
            return (Map<Id, PM_User>)handleMethodInvocation('getPotentialOwners', new List<Object>{SObjects});
        }
        public Map<Id, PM_User> getReferrers(List<SObject> SObjects){
            return (Map<Id, PM_User>)handleMethodInvocation('getReferrers', new List<Object>{SObjects});
        }
        public Map<Id, PM_User> getOwners(List<SObject> oldSObjects, List<SObject> newSObjects){
            return (Map<Id, PM_User>)handleMethodInvocation('getOwners', new List<Object>{oldSObjects, newSObjects});
        }
    }
}