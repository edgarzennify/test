public with sharing class LeadTriggerUserRepository implements ILeadTriggerUserRepository {
    
    public interface ILeadTriggerUserRepository {
        PM_User getCurrentUser();
        String getPardotUserId();
        Map<Id, PM_User> getPotentialOwners(List<SObject> SObjects);
        Map<Id, PM_User> getReferrers(List<SObject> SObjects);
        Map<Id, PM_User> getOwners(List<SObject> oldSObjects, List<SObject> newSObjects);
    }

    private final IUserInfoService m_userInfoService;
    private final LeadTriggerHandlerDataProvider.ILeadTriggerHandlerDataProvider m_dataProvider;
    private final Utility.IUtility m_utility;
    private final Configurations.IConfigurations m_configs;
    private final String PARDOT_USER_ID_CONFIG = 'PardotUserId';

    public LeadTriggerUserRepository(   IUserInfoService userInfoService
                                        ,LeadTriggerHandlerDataProvider.ILeadTriggerHandlerDataProvider dataProvider
                                        ,Utility.IUtility utility
                                        ,Configurations.IConfigurations configs) {
        m_userInfoService = userInfoService;
        m_dataProvider = dataProvider;
        m_utility = utility;
        m_configs = configs;
    }

    public PM_User getCurrentUser() {
        return m_dataProvider.getCurrentUser(m_userInfoService.getCurrentUserId());
    }

    public String getPardotUserId() {
        return m_configs.get(PARDOT_USER_ID_CONFIG);
    }

    public Map<Id, PM_User> getPotentialOwners(List<SObject> SObjects) {
        List<PM_User> potentialOwners = new List<PM_User>();
        potentialOwners.addAll(referralMatrixOwners());
        potentialOwners.addAll(originalLeadOwners(SObjects));
        return buildUserMap(potentialOwners);
    }

    private List<PM_User> referralMatrixOwners() {
        return m_dataProvider.getReferralMatrixOwners();
    }
    
    private List<PM_User> originalLeadOwners(List<SObject> SObjects) {
        Set<Id> ownerIds = m_utility.convertToIdSet(SObjects, 'OwnerId');
        return m_dataProvider.getOriginalLeadOwners(ownerIds);
    }

    public Map<Id, PM_User> getReferrers(List<SObject> newLeads) {
        Set<Id> referrerIds = m_utility.convertToIdSet(newLeads, 'Referring_User__c');
        List<PM_User> referrers = m_dataProvider.getNewReferrers(referrerIds);
        return buildUserMap(referrers);
    }

    public Map<Id, PM_User> getOwners(List<SObject> oldLeads, List<SObject> newLeads) {
        Set<Id> oldOwnersIds = m_utility.convertToIdSet(oldLeads, 'OwnerId');
        Set<Id> newOwnersIds = m_utility.convertToIdSet(newLeads, 'OwnerId');
        Set<Id> ownerIds = new Set<Id>();
        ownerIds.addAll(oldOwnersIds);
        ownerIds.addAll(newOwnersIds);
        List<PM_User> owners = m_dataProvider.getOwners(ownerIds);
        return buildUserMap(owners);
    }

    private Map<Id, PM_User> buildUserMap(List<PM_User> users) {
        Map<Id, PM_User> output = new Map<Id, PM_User>();
        for (PM_User u : users) {
            if (!output.containsKey(u.Id)) {
                output.put(u.Id, u);
            }
        }
        return output;
    }

    public static ILeadTriggerUserRepository bootstrap() {
        IUserInfoService userInfoService = UserInfoService.bootstrap();
        LeadTriggerHandlerDataProvider.ILeadTriggerHandlerDataProvider dataProvider = new LeadTriggerHandlerDataProvider();
        Utility.IUtility utility = new Utility();
        Configurations.IConfigurations configs = Configurations.bootstrap();
        return new LeadTriggerUserRepository(userInfoService, dataProvider, utility, configs);
    }  
}