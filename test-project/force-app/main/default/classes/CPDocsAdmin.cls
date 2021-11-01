public  class CPDocsAdmin {
    
    public interface IDataProvider extends DataProvider.IDataProvider {
        List<CP_Document_Access__c> getAccessByUser(List<string> userIds);
        PM_User getUserFromContact(string contactId);
        List<CP_Document_Access__c> getAccessByObjectIds(List<string> objectIds);   
        List<CP_Document_Access__c> getAccessByObjectIdsAndUser(List<string> objectIds, string userId);    
    }

    public interface IRepository {
        DmUser getUserFromContact(string contactId);
        List<DmCpDocumentAccess> getObjectsForUser(string userId);
        List<DmCpDocumentAccess> getObjectsForObjectIds(List<string> objectIds);
        List<DmCpDocumentAccess> getObjectsForObjectIdsAndUser(List<string> objectIds, string userId);      
    }

    public interface IDmBuilder {
        List<DmCpDocumentAccess> build(List<CP_Document_Access__c> pms);
    }

    public interface IRelatedNcinoLoans{
        Map<DmLoan,List<DmLoan>> getRelatedLoanRenewals(List<DmLoanRenewal> relatedDms);
    }

    public interface IVmBuilder {
        List<CPDocsAdmin.DocumentAdminRequest> buildVms(Map<DmLoan, List<DmLoan>> relatedLoanDms, List<DmCpDocumentAccess> allAccessObject, DmUser userDm);
    }

    public interface IPresenter {
        List<DocumentAdminRequest> getRequests(string entityId);
    }

    public class DocumentAdminRequest {
        public string userName{get;set;}
        public string userEmail{get;set;}
        public boolean userIsPortalEnabled{get;set;}
        public string objectType{get;set;}
        public string objectId{get;set;}
        public string objectDescription{get;set;}
        public boolean selected{get;set;}
    }

    public class DocumentEnableRequest {
        public string objectId{get;set;}
        public boolean selected{get;set;}
    }
}