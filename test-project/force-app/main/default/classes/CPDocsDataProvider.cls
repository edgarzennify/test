public class CPDocsDataProvider extends DataProvider implements  CPDocs.IDataProvider{
	

    public PM_User getUserDetail(string userId){
        List<User> u = [
            SELECT
                Id
                ,Name
                ,ContactId
                ,Contact.FirstName
                ,Contact.LastName
                ,AccountId
                ,Account.Name
                ,Email
                ,IsPortalEnabled
            FROM
                User
            WHERE
                Id =: userId
                AND isPortalEnabled =: true
            LIMIT 1
        ];
        return buildOneUserPm(u[0]);
    }

    public List<PM_CP_Document_Request_c> getAllDocumentRequests(){
        List<CP_Document_Request__c> records = [
            SELECT
            	id
                ,name
                ,DocumentDueDate__c
                ,DocumentName__c
                ,DocumentPortalName__c
                ,DocumentDescription__c
                ,ObjectDescription__c
                ,ObjectId__c
                ,ObjectType__c
                ,Record_Id_18__c
                ,SourceId__c
                ,Source__c
                ,Status__c
            FROM
            	CP_Document_Request__c
            WHERE
            	(Status__c = 'Open' or Status__c = 'Document Uploaded')
            ORDER BY
                DocumentName__c,DocumentPortalName__c
        ];
        
        return buildCpDocPms(records);
    }

    public List<PM_CP_Document_Request_c> getDocumentRequestByIds(List<string> ids){
        List<CP_Document_Request__c> records = [
            SELECT
            	id
                ,name
                ,DocumentDueDate__c
                ,DocumentName__c
                ,DocumentPortalName__c
                ,DocumentDescription__c
                ,ObjectDescription__c
                ,ObjectId__c
                ,ObjectType__c
                ,Record_Id_18__c
                ,SourceId__c
                ,Source__c
                ,Status__c
            FROM
            	CP_Document_Request__c
            WHERE
                Id in :ids
            	AND (Status__c = 'Open' or Status__c = 'Document Uploaded')
            ORDER BY
                DocumentName__c,DocumentPortalName__c
                
        ];
        
        return buildCpDocPms(records);
    }

    public List<PM_CP_Document_Request_c> getDocumentRequestByObjectIds(List<string> ids){
        List<CP_Document_Request__c> records = [
            SELECT
            	id
                ,name
                ,DocumentDueDate__c
                ,DocumentName__c
                ,DocumentPortalName__c
                ,DocumentDescription__c
                ,ObjectDescription__c
                ,ObjectId__c
                ,ObjectType__c
                ,Record_Id_18__c
                ,SourceId__c
                ,Source__c
                ,Status__c
            FROM
            	CP_Document_Request__c
            WHERE
                ObjectId__c in :ids
            	AND (Status__c = 'Open' or Status__c = 'Document Uploaded')
            ORDER BY
                DocumentName__c,DocumentPortalName__c
                
        ];
        return buildCpDocPms(records);
    }

    public List<PM_CP_Document_Request_c> getDocumentRequestByObjectIdsAndDescription(List<string> ids, string objectDescription){
        List<CP_Document_Request__c> records = [
            SELECT
            	id
                ,name
                ,DocumentDueDate__c
                ,DocumentName__c
                ,DocumentPortalName__c
                ,DocumentDescription__c
                ,ObjectDescription__c
                ,ObjectId__c
                ,ObjectType__c
                ,Record_Id_18__c
                ,SourceId__c
                ,Source__c
                ,Status__c
            FROM
            	CP_Document_Request__c
            WHERE
                ObjectId__c in :ids
            	AND (Status__c = 'Open' or Status__c = 'Document Uploaded')
                AND ObjectDescription__c =: objectDescription
            ORDER BY
                DocumentName__c,DocumentPortalName__c
                
        ];
        return buildCpDocPms(records);
    }


    public List<PM_CP_Document_Request_c> saveCpDocuments(List<PM_CP_Document_Request_c> pms){
        List<PM_CP_Document_Request_c> result = new List<PM_CP_Document_Request_c>();
        List<CP_Document_Request__c> upserts = new List<CP_Document_Request__c>();
        for(PM_CP_Document_Request_c pm: pms){
            CP_Document_Request__c obj = new CP_Document_Request__c();
            if(String.isNotBlank(pm.id))obj.Id = pm.id;
            obj.ObjectId__c = pm.ObjectId_c;
            obj.ObjectDescription__c = pm.ObjectDescription_c;
            obj.DocumentName__c = pm.DocumentName_c;
            obj.DocumentPortalName__c = pm.DocumentPortalName_c;
            obj.DocumentDueDate__c = pm.DocumentDueDate_c;
            obj.DocumentDescription__c = pm.DocumentDescription_c;
            obj.ObjectType__c = pm.ObjectType_c;
            obj.Source__c = pm.Source_c;
            obj.SourceId__c = pm.SourceId_c;
            obj.Status__c = pm.Status_c;
            upserts.add(obj);
        }
        Save(upserts);
        return buildCpDocPms(upserts);
    }

    public List<ContentDocumentLink> getComponentDocumentLinks(String parentId){
        return [
            SELECT 
                Id
                ,ContentDocumentId
                ,LinkedEntityId
            FROM
                ContentDocumentLink
            WHERE 
                LinkedEntityId =:parentId
        ];
    }
    
    private List<PM_CP_Document_Request_c> buildCpDocPms(List<CP_Document_Request__c> records){
        List<PM_CP_Document_Request_c> pms = new List<PM_CP_Document_Request_c>();
        if(records == null || records.size() == 0) return pms;
        for(CP_Document_Request__c rec: records){
            pms.add(buildOneCpDoc(rec));
        }
        return pms;
    }
    
    private PM_CP_Document_Request_c buildOneCpDoc(CP_Document_Request__c rec){
        PM_CP_Document_Request_c pm = new PM_CP_Document_Request_c();
        pm.id = rec.id;
        pm.name = rec.name;
        pm.DocumentDueDate_c = rec.DocumentDueDate__c;
        pm.DocumentName_c = rec.DocumentName__c;
        pm.DocumentPortalName_c = rec.DocumentPortalName__c;
        pm.DocumentDescription_c = rec.DocumentDescription__c;
        pm.ObjectDescription_c = rec.ObjectDescription__c;
        pm.ObjectId_c = rec.ObjectId__c;
        pm.ObjectType_c = rec.ObjectType__c;
        pm.Record_Id_18_c = rec.Record_Id_18__c;
        pm.SourceId_c = rec.SourceId__c;
        pm.Source_c = rec.Source__c;
        pm.Status_c = rec.Status__c;
        return pm;
    }

    private PM_User buildOneUserPm(User u){
        PM_User pm = new PM_User();
        pm.Id = u.Id;
        pm.Name = u.Name;
        pm.EmailAddress = u.Email;
        pm.Account = new PM_Account();
        pm.Contact = new PM_Contact();
        if(String.IsNotBlank(u.AccountId)){
            pm.Account.Id = u.AccountId;
            pm.Account.Name = u.Account.Name;
        }
        if(String.IsNotBlank(u.ContactId)){
            pm.Contact.Id = u.ContactId;
            pm.Contact.FirstName = u.Contact.FirstName;
            pm.Contact.LastName = u.Contact.LastName;
        }      
        pm.IsPortalEnabled = u.IsPortalEnabled;
        return pm;
    }
}