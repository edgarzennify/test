public class ReferralHandler implements IReferralHandler {
    
    public interface IReferralHandler {
        void handleReferrals(Lead ld, Map<Id, PM_User> potentialOwnersMap, PM_User currentUser, Map<String, RecordType> rtMap);
        void handleReferrals(Lead oldLd, Lead newLd, Map<Id, PM_User> referrersMap);
    }

    private final ReferralHandlerHelper.IReferralHandlerHelper m_helper;
    private final String INTERNAL_REFERRAL = 'Internal Referral';

    public ReferralHandler(ReferralHandlerHelper.IReferralHandlerHelper helper) {
        m_helper = helper;
    }

    public void handleReferrals(Lead ld, Map<Id, PM_User> potentialOwnersMap, PM_User currentUser, Map<String, RecordType> rtMap) {
        if (ld.RecordTypeId == rtMap.get(INTERNAL_REFERRAL).Id) {
            m_helper.setInternalReferralField(ld);
            m_helper.setLeadStatus(ld);
            m_helper.setReferringUser(ld, currentUser);
            m_helper.setRecordType(ld, rtMap);
            initializeOwner(ld, potentialOwnersMap, currentUser);
        }
    }
    
    private void initializeOwner(Lead ld, Map<Id, PM_User> potentialOwnersMap, PM_User currentUser) {
        String distributionChannel = m_helper.getDistributionChannel(ld);
        String routingTeam = m_helper.getRoutingTeam(ld, currentUser);
        PM_User owner = m_helper.getOwner(ld, potentialOwnersMap, distributionChannel, routingTeam);
        if (owner != null) {
            m_helper.setLeadOwnerFields(ld, owner);
        }
    }

    public void handleReferrals(Lead oldLd, Lead newLd, Map<Id, PM_User> referrersMap) {
        if (newLd.Is_Internal_Referral__c == true) {
            PM_User referrer = m_helper.getReferrer(newLd, referrersMap);
            m_helper.updateReferrerFields(newLd, referrer);
        }
    }

    public static IReferralHandler bootstrap() {
        ReferralHandlerHelper.IReferralHandlerHelper helper = ReferralHandlerHelper.bootstrap();
        return new ReferralHandler(helper);
    }
}