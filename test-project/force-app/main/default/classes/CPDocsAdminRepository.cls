public class CPDocsAdminRepository implements CPDocsAdmin.IRepository{
    
    private CPDocsAdmin.IDmBuilder m_dmBuilder;
    private CPDocsAdmin.IDataProvider m_dataProvider;

    public CPDocsAdminRepository(CPDocsAdmin.IDmBuilder dmBuilder, CPDocsAdmin.IDataProvider dataProvider){
        m_dmBuilder = dmBuilder;
        m_dataProvider = dataProvider;
    }

    public List<DmCpDocumentAccess> getObjectsForUser(string userId){
        List<CP_Document_Access__c> pms = m_dataProvider.getAccessByUser(new List<string>{userId});
        return m_dmBuilder.build(pms);
    }

    public DmUser getUserFromContact(string contactId){
        PM_User pm = m_dataProvider.getUserFromContact(contactId);
        DmUser dm = new DmUser();
        dm.id = pm.id;
        dm.name = pm.Name;
        dm.Entity.Id = pm.Account.Id;
        dm.Entity.Name = pm.Account.Name;
        dm.IsPortalEnabled = pm.IsPortalEnabled;
        return dm;
    }

    public List<DmCpDocumentAccess> getObjectsForObjectIds(List<string> objectIds){
        List<CP_Document_Access__c> pms = m_dataProvider.getAccessByObjectIds(objectIds);
        return m_dmBuilder.build(pms);
    }

    public List<DmCpDocumentAccess> getObjectsForObjectIdsAndUser(List<string> objectIds, string userId){
        List<CP_Document_Access__c> pms = m_dataProvider.getAccessByObjectIdsAndUser(objectIds, userId);
        return m_dmBuilder.build(pms);
    }
}