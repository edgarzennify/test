public class LeadTriggerHandlerHelper implements ILeadTriggerHandlerHelper {
    
    public interface ILeadTriggerHandlerHelper {
        void handleLeadHandoff(Lead oldLd, Lead newLd, Map<Id, PM_User> owners);
        void handleOwnerUpdates(Lead oldLd, Lead newLd, Map<Id, PM_User> potentialOwnersMap);
        void initializeLeadOwner(Lead ld, PM_User currentUser, String pardotUserId, Map<Id, PM_User> potentialOwners);
        Map<String, RecordType> mapRecordTypes(List<RecordType> recordTypes);
        void validateCompanyField(Lead ld);
        void validateCountryField(Lead ld);
    }

    private final ISObject m_SObjectWrapper;
    private final String LEAD_TYPE_PERSONAL = 'Personal';
    private final String LEAD_TYPE_BUSINESS = 'Business';
    private final String INTERNAL_REFERRAL = 'Internal Referral';

    public LeadTriggerHandlerHelper(ISObject sobj) {
        m_SObjectWrapper = sobj;
    }

    public void handleLeadHandoff(Lead oldLd, Lead newLd, Map<Id, PM_User> owners) {
        if (referrerShouldBeUpdated(oldLd, newLd)) {
            PM_User oldOwner = owners.get(oldLd.OwnerId);
            setReferringUserFields(newLd, oldOwner);
        }
    }

    private Boolean referrerShouldBeUpdated(Lead oldLd, Lead newLd) {
        if (oldLd.OwnerId != newLd.OwnerId 
            && newLd.Lead_Handoff__c == true
            && String.isEmpty(oldLd.Referring_User__c)) {
                return true;
        }
        return false;
    }
    
    private void setReferringUserFields(Lead ld, PM_User oldOwner) {
        ld.Referring_User__c = oldOwner.Id;
        ld.Referrer_Email__c = oldOwner.EmailAddress;
        ld.Referrer_Branch_L_Original__c = oldOwner.Division;
        ld.Referrer_Department_Original__c = oldOwner.Department;
        ld.Referrer_Role_Original__c = oldOwner.UserRole.Name;
        ld.Referrer_Title_Original__c = oldOwner.Title;
    }

    public Map<String, RecordType> mapRecordTypes(List<RecordType> recordTypes) {
        Map<String, RecordType> output = new Map<String, RecordType>();
        for (RecordType rt : recordTypes) {
            if (!output.containsKey(rt.Name)) {
                output.put(rt.Name, rt);
            }
        }
        return output;
    }
    
    public void validateCountryField(Lead ld) {
        if (String.isBlank(ld.Country)) {
            ld.Country = 'US';
        }
    }

    public void validateCompanyField(Lead ld) {
        if (String.isEmpty(ld.Company) && ld.Type__c == LEAD_TYPE_PERSONAL) {
            if (String.isEmpty(ld.FirstName)) {
                ld.Company = ld.LastName;
            } else {
                ld.Company = ld.FirstName + ' ' + ld.LastName;
            }
        } else if (String.isEmpty(ld.Company) && ld.Type__c == LEAD_TYPE_BUSINESS) {
            String errorMessage = 'Company name is required for a Business lead.';
            m_SObjectWrapper.addError(ld, errorMessage);
        }
    }

    public void initializeLeadOwner(Lead ld, PM_User currentUser, String pardotUserId, Map<Id, PM_User> potentialOwners) {
        if (currentUser.Id == pardotUserId) {
            PM_User owner = potentialOwners.get(ld.OwnerId);
            setOriginalBranchField(ld, owner);
            setLeadOwnerFields(ld, owner);
        } else {
            setOriginalBranchField(ld, currentUser);
            setLeadOwnerFields(ld, currentUser);
        }
    }

    public void handleOwnerUpdates(Lead oldLd, Lead newLd, Map<Id, PM_User> potentialOwnersMap) {
        if (oldLd.OwnerId != newLd.OwnerId) {
            setLeadOwnerFields(newLd, potentialOwnersMap.get(newLd.OwnerId));
        }
    }

    private void setOriginalBranchField(Lead ld, PM_User currentUser) {
        ld.Branch_L_Original__c = currentUser.Division;
    }

    private void setLeadOwnerFields(Lead ld, PM_User currentUser) {
        ld.OwnerId = currentUser.Id;
        ld.Owner_Branch_L_Original__c = currentUser.Division;
        ld.Owner_Department_Original__c = currentUser.Department;
        ld.Lead_Owner_Role_Original__c = currentUser.UserRole.Name;
        ld.Owner_Title_Original__c = currentUser.Title;
    }

    public static ILeadTriggerHandlerHelper bootstrap() {
        ISObject sobj = new SObjectWrapper();
        return new LeadTriggerHandlerHelper(sobj);
    }
}