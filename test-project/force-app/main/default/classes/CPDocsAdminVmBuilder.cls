public class CPDocsAdminVmBuilder implements CPDocsAdmin.IVmBuilder{
    
    private string OBJECT_TYPE_LOAN = 'Loan';
    private string OBJECT_TYPE_ENTITY = 'Entity';

    public List<CPDocsAdmin.DocumentAdminRequest> buildVms(Map<DmLoan, List<DmLoan>> relatedLoanDms, List<DmCpDocumentAccess> allAccessObject, DmUser userDm){
        List<CPDocsAdmin.DocumentAdminRequest> requests = new List<CPDocsAdmin.DocumentAdminRequest>();
        List<DmLoan> origLoans = new List<DmLoan>(relatedLoanDms.keyset());

        Map<string, List<DmCpDocumentAccess>> accessObjectLookup = new Map<string, List<DmCpDocumentAccess>>();
        for(DmCpDocumentAccess dm: allAccessObject){
            if(!accessObjectLookup.containsKey(dm.objectId)){
                accessObjectLookup.put(dm.objectId, new List<DmCpDocumentAccess>());
            }
            accessObjectLookup.get(dm.objectId).add(dm);
        } 

        CPDocsAdmin.DocumentAdminRequest entityReq = new CPDocsAdmin.DocumentAdminRequest();
        DmEntity entity = userDm.Entity;
        entityReq.objectType = OBJECT_TYPE_ENTITY;
        entityReq.objectId = entity.id;
        entityReq.objectDescription = entity.name;
        entityReq.userName = userDm.Name;
        entityReq.userIsPortalEnabled = userDm.IsPortalEnabled;
        entityReq.userEmail = userDm.EmailAddress;
        if(accessObjectLookup.containsKey(entity.id)){
            entityReq.selected = true;           
        }
        requests.add(entityReq);
        

        for(DmLoan ln : origLoans){
            CPDocsAdmin.DocumentAdminRequest req = new CPDocsAdmin.DocumentAdminRequest();
            if(accessObjectLookup.containsKey(ln.id)){
                req.selected = true;
            }
            req.objectType = OBJECT_TYPE_LOAN;
            req.objectId = ln.id;
            req.objectDescription = ln.name;
            req.userName = userDm.Name;
            req.userIsPortalEnabled = userDm.IsPortalEnabled;
            req.userEmail = userDm.EmailAddress;
            requests.add(req);
        }

        return requests;
    }
}