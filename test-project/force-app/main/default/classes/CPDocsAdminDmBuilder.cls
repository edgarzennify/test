public class CPDocsAdminDmBuilder implements CPDocsAdmin.IDmBuilder{
    public List<DmCpDocumentAccess> build(List<CP_Document_Access__c> pms){
        List<DmCpDocumentAccess> dms = new List<DmCpDocumentAccess>();
        for(CP_Document_Access__c pm: pms){
            DmCpDocumentAccess dm = new DmCpDocumentAccess();
            dm.objectId = pm.objectId__c;
            dm.objectType = pm.objecttype__c;
            dm.PortalUser = new DmUser();
            dm.PortalUser.id = pm.User__r.Id;
            dm.PortalUser.name = Pm.User__r.Name;
            dm.PortalUser.EmailAddress = pm.User__r.Email;
            dm.PortalUser.Name = pm.User__r.FirstName + pm.User__r.LastName;
            dm.PortalUser.IsPortalEnabled = pm.User__r.IsPortalEnabled;
            dms.add(dm);
        }
        return dms;
    }
}