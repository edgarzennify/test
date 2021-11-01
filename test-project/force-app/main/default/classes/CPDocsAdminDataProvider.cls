public class CPDocsAdminDataProvider  extends DataProvider implements  CPDocsAdmin.IDataProvider {
    public List<CP_Document_Access__c> getAccessByUser(List<string> userIds){
        return [
            SELECT 
                Id
                ,Name
                ,User__c
                ,User__r.Name
                ,User__r.FirstName
                ,User__r.LastName
                ,User__r.IsPortalEnabled
                ,User__r.ContactId
                ,User__r.Contact.FirstName
                ,User__r.Contact.LastName
                ,User__r.AccountId
                ,User__r.Account.Name
                ,User__r.Email
                ,ObjectId__c
                ,ObjectType__c
            FROM 
                CP_Document_Access__c 
            WHERE 
                User__c in:userIds
        ];
    }

    public PM_User getUserFromContact(string contactId){

        User u = [
            SELECT 
                Id
                ,Name
                ,FirstName
                ,LastName
                ,IsPortalEnabled
                ,ContactId
                ,Contact.FirstName
                ,Contact.LastName
                ,AccountId
                ,Account.Name
                ,Email
            FROM 
                User
            LIMIT 1
        ];

        PM_User pm = new PM_User();
        if(u == null) return pm;
        pm.id = u.Id;
        pm.Name = u.Name;
        pm.IsPortalEnabled = u.IsPortalEnabled;
        pm.EmailAddress = u.Email;
        pm.Contact = new PM_Contact();
        if(String.isNotBlank(u.ContactId)){
            pm.Contact.Id = u.ContactId;
            pm.Contact.FirstName = u.Contact.FirstName;
            pm.Contact.LastName = u.Contact.LastName;
        }
        pm.Account = new PM_Account();
        if(String.isNotBlank(u.AccountId)){
            pm.Account.Id = u.AccountId;
            pm.Account.Name = u.Account.Name;
        }
        return pm;
    }

    public List<CP_Document_Access__c> getAccessByObjectIds(List<string> objectIds){
        return [
            SELECT 
                Id
                ,Name
                ,User__c
                ,User__r.Name
                ,User__r.FirstName
                ,User__r.LastName
                ,User__r.IsPortalEnabled
                ,User__r.ContactId
                ,User__r.Contact.FirstName
                ,User__r.Contact.LastName
                ,User__r.AccountId
                ,User__r.Account.Name
                ,User__r.Email
                ,ObjectId__c
                ,ObjectType__c
            FROM 
                CP_Document_Access__c 
            WHERE 
                ObjectId__c in:objectIds
        ];
    }

    public List<CP_Document_Access__c> getAccessByObjectIdsAndUser(List<string> objectIds, string userId){
        return [
            SELECT 
                Id
                ,Name
                ,User__c
                ,User__r.Name
                ,User__r.FirstName
                ,User__r.LastName
                ,User__r.IsPortalEnabled
                ,User__r.ContactId
                ,User__r.Contact.FirstName
                ,User__r.Contact.LastName
                ,User__r.AccountId
                ,User__r.Account.Name
                ,User__r.Email
                ,ObjectId__c
                ,ObjectType__c
            FROM 
                CP_Document_Access__c 
            WHERE 
                ObjectId__c in:objectIds
                AND User__c =: userId
        ];
    }
}