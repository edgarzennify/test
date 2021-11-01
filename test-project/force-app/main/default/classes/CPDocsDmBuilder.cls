public class CPDocsDmBuilder implements CPDocs.IDmBuilder {
   
    public DmUser Build(PM_User pm){
        DmUser dm = new DmUser();
        dm.Contact = new DmContact();
        dm.Entity = new DmEntity();
        dm.Contact.Id = pm.Contact.Id;
        dm.Contact.FirstName = pm.Contact.firstName;
        dm.Contact.lastName = pm.Contact.LastName;
        dm.Entity.Id = pm.Account.Id;
        dm.Entity.Name = pm.Account.Name;
        dm.EmailAddress = pm.EmailAddress;
        dm.IsPortalEnabled = pm.IsPortalEnabled;
        return dm;
    }

    public List<DmCPDocumentRequest> Build(List<PM_CP_Document_Request_c> pms){       
        List<DmCPDocumentRequest> dms = new List<DmCPDocumentRequest>();
        if(pms == null || pms.size() == 0) return dms;
        for(PM_CP_Document_Request_c pm : pms){
            dms.add(BuildOne(pm));
        }
        return dms;
    }
    
    private DmCPDocumentRequest BuildOne(PM_CP_Document_Request_c pm){
        DmCPDocumentRequest dm = new DmCPDocumentRequest();
        dm.Id = pm.Id;
        dm.DocumentDueDate = pm.DocumentDueDate_c;
        dm.DocumentName = pm.DocumentName_c;
        dm.DocumentPortalName = pm.DocumentPortalName_c;
        dm.DocumentDescription = pm.DocumentDescription_c;
        dm.ObjectDescription = pm.ObjectDescription_c;
        dm.ObjectId = pm.ObjectId_c;
        dm.ObjectType = pm.ObjectType_c;
        dm.RecordId = pm.Record_Id_18_c;
        dm.SourceId = pm.SourceId_c;
        dm.Source = pm.Source_c;
        dm.Status = pm.Status_c;
        return dm;
    }
}