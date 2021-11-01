public class ReferralHandlerHelper implements IReferralHandlerHelper {
    
    public interface IReferralHandlerHelper {
        String getDistributionChannel(Lead ld);
        String getRoutingTeam(Lead ld, PM_User currentUser);
        PM_User getOwner(Lead ld, Map<Id, PM_User> potentialOwnersMap, String distributionChannel, String routingTeam);
        PM_User getReferrer(Lead ld, Map<Id, PM_User> referrersMap);
        void setLeadOwnerFields(Lead ld, PM_User owner);
        void setInternalReferralField(Lead ld);
        void setLeadStatus(Lead ld);
        void setRecordType(Lead ld, Map<String, RecordType> rtMap);
        void setReferringUser(Lead ld, PM_User currentUser);
        void updateReferrerFields(Lead ld, PM_User referrer);
    }

    private final ISObject m_SObjectWrapper;

    public ReferralHandlerHelper (ISObject sobj) {
        m_SObjectWrapper = sobj;
    }

    public PM_User getOwner(Lead ld, Map<Id, PM_User> potentialOwnersMap, String distributionChannel, String routingTeam) {
        List<PM_User> owners = new List<PM_User>();
        for (PM_User u : (List<PM_User>)potentialOwnersMap.values()) {
            if (userIsValidOwner(u, distributionChannel, routingTeam)) {
                owners.add(u);
            }
        }
        return ifOnlyOneOwnerWasFound(ld, owners, distributionChannel, routingTeam) ? owners[0] : null;
    }

    private Boolean userIsValidOwner(PM_User u, String distributionChannel, String routingTeam) {
        if (String.isBlank(u.Distribution_Channel_c) || String.isBlank(u.Referral_Routing_Team_c)) {
            return false;
        } else if (u.Distribution_Channel_c.containsIgnoreCase(distributionChannel) && u.Referral_Routing_Team_c.containsIgnoreCase(routingTeam)) {
            return true;
        }
        return false;
    }

    private Boolean ifOnlyOneOwnerWasFound(Lead ld, List<PM_User> owners, String distributionChannel, String routingTeam) {
        if (owners.size() == 0) {
            String errorMessage =   'No user has been found with a Distribution Channel of ' + distributionChannel +
                                    ' and a Referral Routing Team of ' + routingTeam + '.' +
                                    ' Therefore this lead has NOT been handed off to someone for initial processing.';
            m_SObjectWrapper.addError(ld, errorMessage);
            return false;
        }
        if (owners.size() > 1) {
            String errorMessage =   'Multiple users have been found with a Distribution Channel of ' + distributionChannel +
                                    ' and a Referral Routing Team of ' + routingTeam + '.' +
                                    ' Therefore this lead has NOT been handed off to someone for initial processing.';
            m_SObjectWrapper.addError(ld, errorMessage);
            return false;
        }
        return true;
    }

    public void setLeadOwnerFields(Lead ld, PM_User owner) {
        ld.OwnerId = owner.Id;
        ld.Branch_L_Original__c = owner.Division;
        ld.Owner_Branch_L_Original__c = owner.Division;
        ld.Owner_Department_Original__c = owner.Department;
        ld.Lead_Owner_Role_Original__c = owner.UserRole.Name;
        ld.Owner_Title_Original__c = owner.Title;
    }

    public void setRecordType(Lead ld, Map<String, RecordType> rtMap) {
        RecordType targetRt = rtMap.get('MQL');
        ld.RecordTypeId = targetRt.Id;
    }

    public void setReferringUser(Lead ld, PM_User currentUser) {
        setReferringUserId(ld, currentUser);
        setReferringUserFields(ld, currentUser);
    }
    
    private void setReferringUserId(Lead ld, PM_User currentUser) {
        ld.Referring_User__c = currentUser.Id;
    }
    
    private void setReferringUserFields(Lead ld, PM_User currentUser) {
        ld.Referrer_Email__c = currentUser.EmailAddress;
        ld.Referrer_Branch_L_Original__c = currentUser.Division;
        ld.Referrer_Department_Original__c = currentUser.Department;
        ld.Referrer_Role_Original__c = currentUser.UserRole.Name;
        ld.Referrer_Title_Original__c = currentUser.Title;
    }

    public void setInternalReferralField(Lead ld) {
        ld.Is_Internal_Referral__c = true;
    }

    public void setLeadStatus(Lead ld) {
       ld.Status = 'New Referral'; 
    }

    public PM_User getReferrer(Lead ld, Map<Id, PM_User> referrersMap) {
        PM_User output = new PM_User();
        for (PM_User u : (List<PM_User>)referrersMap.values()) {
            if (u.Id == ld.Referring_User__c) {
                output = u;
                break;
            }
        }
        return output;
    }

    public void updateReferrerFields(Lead ld, PM_User referrer) {
        setReferringUserFields(ld, referrer);
    }

    public String getDistributionChannel(Lead ld) {
        return ld.Opportunity_Type__c;
    }
    
    public String getRoutingTeam(Lead ld, PM_User currentUser) {
        List<String> consumerTypes = buildConsumerTypes();

        if (consumerTypes.contains(ld.Opportunity_Type__c)) {
            return ld.Client_Preferred_Branch__c;
        } else {
            return currentUser.My_Referral_Team_c;
        }
    }

    private List<String> buildConsumerTypes() {
        String consumerLoan = 'Consumer Deposits, Construction, and Non-Real Estate Loans';
        String privateBanking = 'Private Banking';
        String mortgage = 'Mortgage and Other Real Estate';
        return new List<String>{consumerLoan, privateBanking, mortgage};
    }

    public static IReferralHandlerHelper bootstrap() {
        ISObject sobj = new SObjectWrapper();
        return new ReferralHandlerHelper(sobj);
    }
}