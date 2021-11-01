@IsTest
private class ReferralHandlerTests {
    
    private static final MockOfIReferralHandlerHelper mockHelper;
    private static final ReferralHandler sut;

    static {
        mockHelper = new MockOfIReferralHandlerHelper();
        sut = new ReferralHandler(mockHelper);
    }

    @IsTest
    static void it_should_call_helper_when_the_lead_being_inserted_is_an_internal_referral() {
        RecordType internalReferral = ObjectFactory.getRecordTypeObjByNameAndObject('Internal Referral', 'Lead');
        Lead testLead = new Lead(RecordTypeId = internalReferral.Id);
        String distributionChannel = 'some distribution channel';
        String routingTeam = 'some routing team';
        Map<Id, PM_User> potentialOwnersMap = new Map<Id, PM_User>();
        PM_User currentUser = new PM_User();
        currentUser.Name = 'currentUser';
        PM_User owner = new PM_User();
        owner.Name = 'owner';
        Map<String, RecordType> rtMap = new Map<String, RecordType>();
        rtMap.put('Internal Referral', internalReferral);

        mockHelper
            .setup('getDistributionChannel', new List<Object>{testLead})
            .returns(distributionChannel);
        mockHelper
            .setup('getRoutingTeam', new List<Object>{testLead, currentUser})
            .returns(routingTeam);
        mockHelper
            .setup('getOwner', new List<Object>{testLead, potentialOwnersMap, distributionChannel, routingTeam})
            .returns(owner);

        sut.handleReferrals(testLead, potentialOwnersMap, currentUser, rtMap);

        mockHelper.verify('setInternalReferralField', new List<Object>{testLead}, Times.Once);
        mockHelper.verify('setLeadStatus', new List<Object>{testLead}, Times.Once);
        mockHelper.verify('setReferringUser', new List<Object>{testLead, currentUser}, Times.Once);
        mockHelper.verify('setRecordType', new List<Object>{testLead, rtMap}, Times.Once);
        mockHelper.verify('getDistributionChannel', new List<Object>{testLead});
        mockHelper.verify('getRoutingTeam', new List<Object>{testLead, currentUser}, Times.Once);
        mockHelper.verify('getOwner', new List<Object>{testLead, potentialOwnersMap, distributionChannel, routingTeam}, Times.Once);
        mockHelper.verify('setLeadOwnerFields', new List<Object>{testLead, owner}, Times.Once);
    }

    @IsTest
    static void it_should_not_call_helper_when_the_lead_being_inserted_is_not_an_internal_referral() {
        RecordType internalReferral = ObjectFactory.getRecordTypeObjByNameAndObject('Internal Referral', 'Lead');
        Lead testLead = new Lead();
        String distributionChannel = 'some distribution channel';
        String routingTeam = 'some routing team';
        Map<Id, PM_User> potentialOwnersMap = new Map<Id, PM_User>();
        PM_User currentUser = new PM_User();
        currentUser.Name = 'currentUser';
        PM_User owner = new PM_User();
        owner.Name = 'owner';
        Map<String, RecordType> rtMap = new Map<String, RecordType>();
        rtMap.put('Internal Referral',internalReferral);

        sut.handleReferrals(testLead, potentialOwnersMap, currentUser, rtMap);

        mockHelper.verify('setInternalReferralField', new List<Object>{testLead}, Times.Never);
        mockHelper.verify('setLeadStatus', new List<Object>{testLead}, Times.Never);
        mockHelper.verify('setReferringUser', new List<Object>{testLead, currentUser}, Times.Never);
        mockHelper.verify('setRecordType', new List<Object>{testLead, rtMap}, Times.Never);
        mockHelper.verify('getDistributionChannel', new List<Object>{testLead}, Times.Never);
        mockHelper.verify('getRoutingTeam', new List<Object>{testLead, currentUser}, Times.Never);
        mockHelper.verify('getOwner', new List<Object>{testLead, potentialOwnersMap, distributionChannel, routingTeam}, Times.Never);
        mockHelper.verify('initializeLeadOwnerFields', new List<Object>{testLead, owner}, Times.Never);
    }

    @IsTest
    static void it_should_not_set_lead_owner_fields_when_the_inserted_leads_owner_cannot_be_established() {
        RecordType internalReferral = ObjectFactory.getRecordTypeObjByNameAndObject('Internal Referral', 'Lead');
        Lead testLead = new Lead(RecordTypeId = internalReferral.Id);
        String distributionChannel = 'some distribution channel';
        String routingTeam = 'some routing team';
        Map<Id, PM_User> potentialOwnersMap = new Map<Id, PM_User>();
        PM_User currentUser = new PM_User();
        currentUser.Name = 'currentUser';
        PM_User owner = new PM_User();
        owner.Name = 'owner';
        Map<String, RecordType> rtMap = new Map<String, RecordType>();
        rtMap.put('Internal Referral', internalReferral);

        mockHelper
            .setup('getDistributionChannel', new List<Object>{testLead})
            .returns(distributionChannel);
        mockHelper
            .setup('getRoutingTeam', new List<Object>{testLead, currentUser})
            .returns(routingTeam);
        mockHelper
            .setup('getOwner', new List<Object>{testLead, potentialOwnersMap, distributionChannel, routingTeam})
            .returns(null);

        sut.handleReferrals(testLead, potentialOwnersMap, currentUser, rtMap);

        mockHelper.verify('setLeadOwnerFields', new List<Object>{testLead, null}, Times.Never);
    }

    @IsTest
    static void it_should_call_helper_when_the_lead_being_updated_is_an_internal_referral() {
        Lead oldLd = new Lead(Is_Internal_Referral__c = true);
        Lead newLd = new Lead(Is_Internal_Referral__c = true);
        PM_User referrer = new PM_User();
        referrer.Id = ObjectFactory.getFakeId(User.SObjectType, '1');
        Map<Id, PM_User> referrersMap = new Map<Id, PM_User>{referrer.Id => referrer};

        mockHelper
            .setup('getReferrer', new List<Object>{newLd, referrersMap})
            .returns(referrer);

        sut.handleReferrals(oldLd, newLd, referrersMap);

        mockHelper.verify('getReferrer', new List<Object>{newLd, referrersMap}, Times.Once);
        mockHelper.verify('updateReferrerFields', new List<Object>{newLd, referrer}, Times.Once);
    }

    @IsTest
    static void it_should_not_call_helper_when_the_lead_being_updated_is_not_an_internal_referral() {
        Lead oldLd = new Lead(Is_Internal_Referral__c = false);
        Lead newLd = new Lead(Is_Internal_Referral__c = false);
        PM_User referrer = new PM_User();
        referrer.Id = ObjectFactory.getFakeId(User.SObjectType, '1');
        Map<Id, PM_User> referrersMap = new Map<Id, PM_User>{referrer.Id => referrer};

        mockHelper
            .setup('getReferrer', new List<Object>{newLd, referrersMap})
            .returns(referrer);

        sut.handleReferrals(oldLd, newLd, referrersMap);

        mockHelper.verify('getReferrer', new List<Object>{newLd, referrersMap}, Times.Never);
        mockHelper.verify('updateReferrerFields', new List<Object>{newLd, referrer}, Times.Never);
    }

    @IsTest
    static void it_should_bootstrap_successfully() {
        Object results = ReferralHandler.bootstrap();

        System.assertNotEquals(null, results);
    }

    public class MockOfIReferralHandlerHelper extends ApexMoq implements ReferralHandlerHelper.IReferralHandlerHelper{
        public void setReferringUser(Lead ld, PM_User currentUser){
            handleMethodInvocation('setReferringUser', new List<Object>{ld, currentUser});
        }
        public String getDistributionChannel(Lead ld){
            return (String)handleMethodInvocation('getDistributionChannel', new List<Object>{ld});
        }
        public String getRoutingTeam(Lead ld, PM_User currentUser){
            return (String)handleMethodInvocation('getRoutingTeam', new List<Object>{ld, currentUser});
        }
        public PM_User getOwner(Lead ld, Map<Id, PM_User> potentialOwnersMap, String distributionChannel, String routingTeam){
            return (PM_User)handleMethodInvocation('getOwner', new List<Object>{ld, potentialOwnersMap, distributionChannel, routingTeam});
        }
        public void setLeadOwnerFields(Lead ld, PM_User owner){
            handleMethodInvocation('setLeadOwnerFields', new List<Object>{ld, owner});
        }
        public void setRecordType(Lead ld, Map<String, RecordType> rtMap){
            handleMethodInvocation('setRecordType', new List<Object>{ld, rtMap});
        }
        public void setInternalReferralField(Lead ld){
            handleMethodInvocation('setInternalReferralField', new List<Object>{ld});
        }
        public void setLeadStatus(Lead ld){
            handleMethodInvocation('setLeadStatus', new List<Object>{ld});
        }
        public void updateReferrerFields(Lead ld, PM_User referrer){
            handleMethodInvocation('updateReferrerFields', new List<Object>{ld, referrer});
        }
        public PM_User getReferrer(Lead ld, Map<Id, PM_User> referrersMap){
            return (PM_User)handleMethodInvocation('getReferrer', new List<Object>{ld, referrersMap});
        }
    }
}