global class CPDocs {
    
    public interface IDataProvider extends DataProvider.IDataProvider{
        PM_User getUserDetail(string userId);
        List<PM_CP_Document_Request_c> getAllDocumentRequests();
        List<PM_CP_Document_Request_c> getDocumentRequestByObjectIds(List<string> ids);
        List<PM_CP_Document_Request_c> getDocumentRequestByObjectIdsAndDescription(List<string> ids, string objectDescription);
        List<PM_CP_Document_Request_c> getDocumentRequestByIds(List<string> ids);
        List<PM_CP_Document_Request_c> saveCpDocuments(List<PM_CP_Document_Request_c> pms);
        List<ContentDocumentLink> getComponentDocumentLinks(String parentId);
    }

    public interface INcinoDataProvider{
        List<PM_LLCBI_Legal_Entities_c> getLegalEntities(String entityId);
        List<PM_LLCBI_Loan_c> getLoans(List<string> legalEntityIds);
        List<PM_LLCBI_AccountDocument_c> getAccountDocuments(List<string> entityIds);
        List<PM_LLCBI_LLC_LoanDocument_c> getLoanDocuments(List<string> loanIds);
        List<PM_LLCBI_Document_PlaceHolder_c> getCollateralDocuments(List<string> collateralIds);
        List<PM_EB_Account_c> getRelatedEbAccounts(String entityId);
        List<PM_LLCBI_LoanRenewal_c> getRenewals(List<string> loanIds);
    }
    
    public interface IDmBuilder{
        DmUser build(PM_User pm);
        List<DmCPDocumentRequest> build(List<PM_CP_Document_Request_c> pms);
    }

    public interface INcinoDmBuilder{
        List<DmLoanEntityRelationship> buildLegalEntities(List<PM_LLCBI_Legal_Entities_c> pms);
        List<DmLoan> buildLoans(List<PM_LLCBI_Loan_c> loans);
        List<DmNcinoDocumentPlaceHolder> buildAccountDocuments(List<PM_LLCBI_AccountDocument_c> pms);
        List<DmNcinoDocumentPlaceHolder> buildLoanDocuments(List<PM_LLCBI_LLC_LoanDocument_c> pms);
        List<DmNcinoDocumentPlaceHolder> buildCollateralDocuments(List<PM_LLCBI_Document_PlaceHolder_c> pms, 
                                                                            Map<String,String> collateralLookup);
        List<DmEbAccount> buildEbAccounts(List<PM_EB_Account_c> pms);
        List<DmLoanRenewal> buildLoanRenewals(List<PM_LLCBI_LoanRenewal_c> pms);
    }
    
    public interface IVmBuilder{
        List<CPDocs.DocumentRequest> buildVm(List<DmCPDocumentRequest> dms);
    }

    public interface INcinoRepository{
        List<DmLoanEntityRelationship> getLoanEntityRelationship(string entityId);
        List<DmLoan> getLoans(List<string> loanIds);
        List<DmNcinoDocumentPlaceHolder> getAccountDocuments(List<String> entityIds);
        List<DmNcinoDocumentPlaceHolder> getLoanDocuments(List<string> loanIds);   
        List<DmNcinoDocumentPlaceHolder> getCollateralDocuments(List<string> collateralIds,  
                                                                        Map<String,String> collateralLookup); 
        List<DmEbAccount> getRelatedEbAccounts( String entityId);
        List<DmLoanRenewal> getRenewals(List<string> loanIds);
    }

    public interface ICPDocsRepository{
        DmUser getUser(string userId);
        List<DmCPDocumentRequest> getAllDocumentRequestDms();
        List<DmCPDocumentRequest> getDocumentRequestByIdsDms(List<string> ids);
        List<DmCPDocumentRequest> getDocumentRequestByObjectIdsDms(List<string> ids);
        List<DmCPDocumentRequest> getDocumentRequestByObjectIdsAndDescriptionDms(List<string> ids, string objectDescription);
        List<DmCPDocumentRequest> saveDocumentRequestPms(List<CPDocs.CPDocRequestSm> sms);
        void updateDocumentRequestStatus(List<CPDocRequestSm> sms);
        string getDocIndexIdAfterAddingComponentDocumentLinks(String docRequestId, String destinationObjectId);
        void save(List<Sobject> sobjs);
    }

    public interface IObjectTypeBuilder{
        ObjectType GetObjectType(string objectType);
        String GetObjectType(CPDocs.ObjectType o);
        ObjectType GetObjectTypeFromObjectId(string objectId);
    }

    public interface INcinoDocRequestBuilderHelper{
        List<CPDocs.CPDocRequestSm> buildDocRequests( List<DmNcinoDocumentPlaceHolder> placeHolderDms,List<CPDocs.RelatedObject> relObjects,
                                 List<DmCPDocumentRequest> cpDocs, String objectType);
        List<string> getIds(List<CPDocs.RelatedObject> rels);
        Map<String,String> getIdNameLookup(List<CPDocs.RelatedObject> relObjects);
    }

    public interface IDocRequestBuilder{
        boolean handle(ObjectType type);
        List<CPDocRequestSm> buildDocRequests(List<RelatedObject> relObjects, List<DmCPDocumentRequest> cpDocs);
    }

    public interface IDocumentSynchronizer{
        void sync(DmCPDocumentRequest dm);
    }

    public interface IDocRequestManager{
        List<DmCPDocumentRequest> getRequests(DmUser userDm);
        List<DmCPDocumentRequest> calculateRequests(DmUser userDm);
        List<DmCPDocumentRequest> getRequestByObjectDescription(DmUser userDm, string objectDescription);
        boolean updateRequestStatus(List<string> documentRequestIds);
        List<DmCPDocumentRequest> getRequestByIds(List<string> documentRequestIds);
    }

    public interface IRelatedObjectsProvider{
        Map<CPDocs.ObjectType, List<CPDocs.RelatedObject>> getRelatedObjects(DmUser userDm);
        Map<CPDocs.ObjectType, List<CPDocs.RelatedObject>> getRelatedObjectsByObjectName(DmUser userDm, String objectName);
        Map<CPDocs.ObjectType, List<CPDocs.RelatedObject>> getRelatedObjectsByAccessObjects(DmUser userDm, List<DmCpDocumentAccess> accessObjects);
    }
    
    public interface IPresenter{
        List<DocumentRequest> getAllDocumentRequests();
        List<DocumentRequest> getDocumentRequestsByFilter(string objectDescription);
        List<DocumentRequest> getDocumentRequestById(string documentRequestId);
        List<CPDocs.DocumentRequest> postUpload(String documentRequestId);
    }


    //vms

    global class DocumentRequest{
        @AuraEnabled public string documentRequestId{get;set;}
        @AuraEnabled public string objectType{get;set;}
        @AuraEnabled public string objectId{get;set;}
        @AuraEnabled public string objectDescription{get;set;}
        @AuraEnabled public string documentName{get;set;}
        @AuraEnabled public string documentDueDate{get;set;}
        @AuraEnabled public string documentDescription{get;set;}
        @AuraEnabled public string status{get;set;}
        @AuraEnabled public boolean isPastDueDate{get;set;}
        @AuraEnabled public string documentDueDateLabel{get;set;}
        @AuraEnabled public List<string> fileTypes{get;set;}
    }
    

    //presenter models
    public Enum ObjectType{
        Entity,
        Account,
        Collateral,
        Loan
    }

    public Enum SaveType{
        InsertType,
        UpdateType,
        NoneType
    }

    public class RelatedObject{
        public ObjectType objectType{get;set;}
        public String objectId{get;set;}
        public String objectName{get;set;}
        public String source{get;set;}
    }
    
    public class CPDocRequestSm{
        public PM_CP_Document_Request_c requestPm{get;set;}
        public SaveType saveType{get;set;}
    }

    /*public class RelatedLoan{
        public DmLoan originalLoan{get;set;}
        public List<DmLoan> Renewals{get;set;}
    }*/
}