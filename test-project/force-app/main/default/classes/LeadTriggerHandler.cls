public with sharing class LeadTriggerHandler extends TriggerHandler {

    private final LeadTriggerHandlerDataProvider.ILeadTriggerHandlerDataProvider m_dataProvider;
    private final LeadTriggerHandlerHelper.ILeadTriggerHandlerHelper m_helper;
    private final ReferralHandler.IReferralHandler m_referralHandler;
    private final LeadTriggerUserRepository.ILeadTriggerUserRepository m_userRepository;

    public LeadTriggerHandler() {
        m_dataProvider = new LeadTriggerHandlerDataProvider();
        m_helper = LeadTriggerHandlerHelper.bootstrap();
        m_referralHandler = ReferralHandler.bootstrap();
        m_userRepository = LeadTriggerUserRepository.bootstrap();
    }

    public LeadTriggerHandler(  LeadTriggerHandlerDataProvider.ILeadTriggerHandlerDataProvider dataProvider,
                                LeadTriggerHandlerHelper.ILeadTriggerHandlerHelper helper,
                                ReferralHandler.IReferralHandler referralHandler,
                                LeadTriggerUserRepository.ILeadTriggerUserRepository userRepository) {
        m_dataProvider = dataProvider;
        m_helper = helper;
        m_referralHandler = referralHandler;
        m_userRepository = userRepository;
    }
    
    private Map<String, RecordType> m_rtMap;
    private Map<String, RecordType> rtMap {
        get {
            if (m_rtMap == null) {
                List<RecordType> recordTypes = m_dataProvider.getRecordTypes();
                m_rtMap = m_helper.mapRecordTypes(recordTypes);
            }
            return m_rtMap;
        }
    }

    private PM_User m_currentUser;
    private PM_User currentUser {
        get {
            if (m_currentUser == null) {
                m_currentUser = m_userRepository.getCurrentUser();
            }
            return m_currentUser;
        }
    }
    
    private String m_pardotUserId;
    private String pardotUserId {
        get {
            if (m_pardotUserId == null) {
                m_pardotUserId = m_userRepository.getPardotUserId();
            }
            return m_pardotUserId;
        }
    }
    
    public override void bulkBeforeInsert(List<SObject> SObjects) {
        Map<Id, PM_User> potentialOwners = m_userRepository.getPotentialOwners(SObjects);

        for (Lead ld : (List<Lead>)SObjects) {
            m_helper.initializeLeadOwner(ld, this.currentUser, this.pardotUserId, potentialOwners);
            m_helper.validateCountryField(ld);
            m_helper.validateCompanyField(ld);
            m_referralHandler.handleReferrals(ld, potentialOwners, this.currentUser, this.rtMap);
        }
    }

    public override void bulkBeforeUpdate(List<SObject> oldSos, Map<Id, SObject> newSosMap) {
        Map<Id, PM_User> referrers = m_userRepository.getReferrers(newSosMap.values());
        Map<Id, PM_User> owners = m_userRepository.getOwners(oldSos, newSosMap.values());

        for (Lead oldLd : (List<Lead>)oldSos) {
            Lead newLd = (Lead)newSosMap.get(oldLd.Id);
            m_helper.handleLeadHandoff(oldLd, newLd, owners);
            m_referralHandler.handleReferrals(oldLd, newLd, referrers);
            m_helper.handleOwnerUpdates(oldLd, newLd, owners);
        }
    }
}