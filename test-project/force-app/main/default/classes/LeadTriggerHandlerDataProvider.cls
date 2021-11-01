public class LeadTriggerHandlerDataProvider implements ILeadTriggerHandlerDataProvider {
    
    public interface ILeadTriggerHandlerDataProvider {
        PM_User getCurrentUser(Id currentUserId);
        List<PM_User> getNewReferrers(Set<Id> referrerIds);
        List<PM_User> getOriginalLeadOwners(Set<Id> ownerIds);
        List<PM_User> getOwners(Set<Id> ownerIds);
        List<RecordType> getRecordTypes();
        List<PM_User> getReferralMatrixOwners();
    }

    public PM_User getCurrentUser(Id currentUserId) {
        User u = [SELECT
                    Id
                    ,Department
                    ,Division
                    ,Email
                    ,My_Referral_Team__c
                    ,Title
                    ,UserRole.Name
                FROM
                    User
                WHERE
                    Id =: currentUserId
        ];

        PM_User pm = new PM_User();
        pm.Id = u.Id;
        pm.Department = u.Department;
        pm.Division = u.Division;
        pm.EmailAddress = u.Email;
        pm.My_Referral_Team_c = u.My_Referral_Team__c;
        pm.Title = u.Title;
        pm.UserRole = new PM_UserRole();
        pm.UserRole.Name = u.UserRole.Name;
        return pm;
    }

    public List<PM_User> getOriginalLeadOwners(Set<Id> ownerIds) {
        List<User> returnedUsers =  [SELECT
                    Id
                    ,Department
                    ,Distribution_Channel__c
                    ,Division
                    ,Email
                    ,My_Referral_Team__c
                    ,Referral_Routing_Team__c
                    ,Title
                    ,UserRole.Name
                FROM
                    User
                WHERE
                    IsActive = true
                    AND
                    Id IN :ownerIds
        ];

        List<PM_User> pms = new List<PM_User>();
        for (User u : returnedUsers) {
            PM_User pm = new PM_User();
            pm.Id = u.Id;
            pm.Department = u.Department;
            pm.Distribution_Channel_c = u.Distribution_Channel__c;
            pm.Division = u.Division;
            pm.EmailAddress = u.Email;
            pm.My_Referral_Team_c = u.My_Referral_Team__c;
            pm.Referral_Routing_Team_c = u.Referral_Routing_Team__c;
            pm.Title = u.Title;
            pm.UserRole = new PM_UserRole();
            pm.UserRole.Name = u.UserRole.Name;
            pms.add(pm);
        }
        return pms;
    }

    public List<PM_User> getReferralMatrixOwners() {
        List<User> returnedUsers =  [SELECT
                    Id
                    ,Department
                    ,Distribution_Channel__c
                    ,Division
                    ,Email
                    ,Referral_Routing_Team__c
                    ,Title
                    ,UserRole.Name
                FROM
                    User
                WHERE
                    IsActive = true
                    AND
                    Distribution_Channel__c != null
                    AND
                    Referral_Routing_Team__c != null
        ];

        List<PM_User> pms = new List<PM_User>();
        for (User u : returnedUsers) {
            PM_User pm = new PM_User();
            pm.Id = u.Id;
            pm.Department = u.Department;
            pm.Distribution_Channel_c = u.Distribution_Channel__c;
            pm.Division = u.Division;
            pm.EmailAddress = u.Email;
            pm.Referral_Routing_Team_c = u.Referral_Routing_Team__c;
            pm.Title = u.Title;
            pm.UserRole = new PM_UserRole();
            pm.UserRole.Name = u.UserRole.Name;
            pms.add(pm);
        }
        return pms;
    }

    public List<PM_User> getNewReferrers(Set<Id> referrerIds) {
        List<User> returnedUsers = [SELECT
                    Id
                    ,Department
                    ,Division
                    ,Email
                    ,Title
                    ,UserRole.Name
                FROM
                    User
                WHERE
                    Id IN : referrerIds
        ];

        List<PM_User> pms = new List<PM_User>();
        for (User u : returnedUsers) {
            PM_User pm = new PM_User();
            pm.Id = u.Id;
            pm.Department = u.Department;
            pm.Division = u.Division;
            pm.EmailAddress = u.Email;
            pm.Title = u.Title;
            pm.UserRole = new PM_UserRole();
            pm.UserRole.Name = u.UserRole.Name;
            pms.add(pm);
        }
        return pms;
    }

    public List<PM_User> getOwners(Set<Id> ownerIds) {
        List<User> returnedUsers =  [SELECT
                    Id
                    ,Department
                    ,Distribution_Channel__c
                    ,Division
                    ,Email
                    ,Referral_Routing_Team__c
                    ,Title
                    ,UserRole.Name
                FROM
                    User
                WHERE
                    Id IN :ownerIds
        ];

        List<PM_User> pms = new List<PM_User>();
        for (User u : returnedUsers) {
            PM_User pm = new PM_User();
            pm.Id = u.Id;
            pm.Department = u.Department;
            pm.Distribution_Channel_c = u.Distribution_Channel__c;
            pm.Division = u.Division;
            pm.EmailAddress = u.Email;
            pm.Referral_Routing_Team_c = u.Referral_Routing_Team__c;
            pm.Title = u.Title;
            pm.UserRole = new PM_UserRole();
            pm.UserRole.Name = u.UserRole.Name;
            pms.add(pm);
        }
        return pms;
    }

    public List<RecordType> getRecordTypes() {
        return Utility.recordTypeObjects('Lead');
    }
}