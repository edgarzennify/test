@IsTest
public class CPDocsMock { 
	
    public  class ofIDataProvider extends Mock.ofIDataProvider implements CPDocs.IDataProvider{
        public PM_User getUserDetail(string userId){
            return (PM_User)handleMethodInvocation('getUserDetail', new List<Object>{userId});
        }
        public List<PM_CP_Document_Request_c> getAllDocumentRequests(){
            return (List<PM_CP_Document_Request_c>)handleMethodInvocation('getAllDocumentRequests');
        }
        public List<PM_CP_Document_Request_c> getDocumentRequestByObjectIds(List<string> ids){
            return (List<PM_CP_Document_Request_c>)handleMethodInvocation('getDocumentRequestByObjectIds', new List<Object>{ids});
        }
        public List<PM_CP_Document_Request_c> getDocumentRequestByObjectIdsAndDescription(List<string> ids, string objectDescription){
            return (List<PM_CP_Document_Request_c>)handleMethodInvocation('getDocumentRequestByObjectIdsAndDescription', new List<Object>{ids, objectDescription});
        }
        public List<PM_CP_Document_Request_c> getDocumentRequestByIds(List<string> ids){
            return (List<PM_CP_Document_Request_c>)handleMethodInvocation('getDocumentRequestByIds', new List<Object>{ids});
        }
        public List<PM_CP_Document_Request_c> saveCpDocuments(List<PM_CP_Document_Request_c> pms){
            return (List<PM_CP_Document_Request_c>)handleMethodInvocation('saveCpDocuments', new List<Object>{pms});
        }
        public List<ContentDocumentLink> getComponentDocumentLinks(String parentId){
            return (List<ContentDocumentLink>)handleMethodInvocation('getComponentDocumentLinks', new List<Object>{parentId});
        }
    }

    public class ofINcinoDataProvider extends ApexMoq implements CPDocs.INcinoDataProvider{
        public List<PM_LLCBI_Legal_Entities_c> getLegalEntities(String entityId){
            return (List<PM_LLCBI_Legal_Entities_c>)handleMethodInvocation('getLegalEntities',new List<Object>{entityId});
        }
        public List<PM_LLCBI_Loan_c> getLoans(List<string> legalEntityIds){
            return (List<PM_LLCBI_Loan_c>)handleMethodInvocation('getLoans', new List<Object>{legalEntityIds});
        }
        public List<PM_LLCBI_LoanRenewal_c> getRenewals(List<String> objectIds){
            return (List<PM_LLCBI_LoanRenewal_c>)handleMethodInvocation('getRenewals', new List<Object>{objectIds});
        }
        public List<PM_LLCBI_AccountDocument_c> getAccountDocuments(List<string> entityIds){
            return (List<PM_LLCBI_AccountDocument_c>)handleMethodInvocation('getAccountDocuments', new List<object>{entityIds});
        }
        public List<PM_LLCBI_LLC_LoanDocument_c> getLoanDocuments(List<string> loanIds){
            return (List<PM_LLCBI_LLC_LoanDocument_c>)handleMethodInvocation('getLoanDocuments', new List<Object>{loanIds});
        }
        public List<PM_LLCBI_Document_PlaceHolder_c> getCollateralDocuments(List<string> collateralIds){
            return (List<PM_LLCBI_Document_PlaceHolder_c>)handleMethodInvocation('getCollateralDocuments', new List<Object>{collateralIds});
        }
        public List<PM_EB_Account_c> getRelatedEbAccounts(String entityId){
            return (List<PM_EB_Account_c>)handleMethodInvocation('getRelatedEbAccounts', new List<object>{entityId});
        }
    }
    
    public class ofIDmBuilder extends ApexMoq implements CPDocs.IDmBuilder{
        public DmUser build(PM_User pm){
            return (DmUser)handleMethodInvocation('build', new List<Object>{pm});
        }
        public List<DmCPDocumentRequest> build(List<PM_CP_Document_Request_c> pms){
            return (List<DmCPDocumentRequest>)handleMethodInvocation('build', new List<Object>{pms});
        }
    }

    public class ofINcinoDmBuilder extends ApexMoq implements CPDocs.INcinoDmBuilder{
        public List<DmLoanEntityRelationship> buildLegalEntities(List<PM_LLCBI_Legal_Entities_c> pms){
            return (List<DmLoanEntityRelationship>)handleMethodInvocation('buildLegalEntities', new List<Object>{pms});
        }
        public List<DmLoanRenewal> buildLoanRenewals(List<PM_LLCBI_LoanRenewal_c> pms) {
            return (List<DmLoanRenewal>)handleMethodInvocation('buildLoanRenewals', new List<Object>{pms});
        }
        public List<DmLoan> buildLoans(List<PM_LLCBI_Loan_c> loans){
            return (List<DmLoan>)handleMethodInvocation('buildLoans', new List<Object>{loans});
        }
        public List<DmNcinoDocumentPlaceHolder> buildAccountDocuments(List<PM_LLCBI_AccountDocument_c> pms){
            return (List<DmNcinoDocumentPlaceHolder>)handleMethodInvocation('buildAccountDocuments', new List<Object>{pms});
        }
        public List<DmNcinoDocumentPlaceHolder> buildLoanDocuments(List<PM_LLCBI_LLC_LoanDocument_c> pms){
            return (List<DmNcinoDocumentPlaceHolder>)handleMethodInvocation('buildLoanDocuments', new List<Object>{pms});
        }
        public List<DmNcinoDocumentPlaceHolder> buildCollateralDocuments(List<PM_LLCBI_Document_PlaceHolder_c> pms, 
                                                                            Map<String,String> collateralLookup){
            return (List<DmNcinoDocumentPlaceHolder>)handleMethodInvocation('buildCollateralDocuments', new List<Object>{pms,collateralLookup});
        }
        public List<DmEbAccount> buildEbAccounts(List<PM_EB_Account_c> pms){
            return (List<DmEbAccount>)handleMethodInvocation('buildEbAccounts', new List<Object>{pms});
        }
    }
    
    public class ofIVmBuilder extends ApexMoq implements CPDocs.IVmBuilder{
        public List<CPDocs.DocumentRequest> buildVm(List<DmCPDocumentRequest> dms){
            return (List<CPDocs.DocumentRequest>)handleMethodInvocation('buildVm', new List<Object>{dms});
        }
    }

    public class ofINcinoRepository extends ApexMoq implements CPDocs.INcinoRepository{
        public List<DmLoanEntityRelationship> getLoanEntityRelationship(string entityId){
            return (List<DmLoanEntityRelationship>)handleMethodInvocation('getLoanEntityRelationship', new List<Object>{entityId});
        }
        public List<DmLoanRenewal> getRenewals(List<String> objectIds){
            return (List<DmLoanRenewal>)handleMethodInvocation('getRenewals', new List<object>{objectIds});
        }
        public List<DmLoan> getLoans(List<string> loanIds){
            return (List<DmLoan>)handleMethodInvocation('getLoans', new List<Object>{loanIds});
        }
        public List<DmNcinoDocumentPlaceHolder> getAccountDocuments(List<String> entityIds){
            return (List<DmNcinoDocumentPlaceHolder>)handleMethodInvocation('getAccountDocuments', new List<Object>{entityIds});
        }
        public List<DmNcinoDocumentPlaceHolder> getLoanDocuments(List<string> loanIds){
            return (List<DmNcinoDocumentPlaceHolder>)handleMethodInvocation('getLoanDocuments', new List<Object>{loanIds});
        } 
        public List<DmNcinoDocumentPlaceHolder> getCollateralDocuments(List<string> collateralIds,  
                                                                        Map<String,String> collateralLookup){
            return (List<DmNcinoDocumentPlaceHolder>)handleMethodInvocation('getCollateralDocuments', new List<Object>{collateralIds,collateralLookup});
        } 
        public List<DmEbAccount> getRelatedEbAccounts( String entityId){
            return (List<DmEbAccount>)handleMethodInvocation('getRelatedEbAccounts', new List<Object>{entityId});
        }
    }

    public class ofICPDocsRepository extends ApexMoq implements CPDocs.ICPDocsRepository{
        public DmUser getUser(string userId){
            return (DmUser)handleMethodInvocation('getUser', new List<OBject>{userId});
        }
        public List<DmCPDocumentRequest> getAllDocumentRequestDms(){
            return (List<DmCPDocumentRequest>)handleMethodInvocation('getAllDocumentRequestDms');
        }
        public List<DmCPDocumentRequest> getDocumentRequestByIdsDms(List<string> ids){
            return (List<DmCPDocumentRequest>)handleMethodInvocation('getDocumentRequestByIdsDms', new List<object>{ids});
        }
        public List<DmCPDocumentRequest> getDocumentRequestByObjectIdsDms(List<string> ids){
            return (List<DmCPDocumentRequest>)handleMethodInvocation('getDocumentRequestByObjectIdsDms', new List<object>{ids});
        }
        public List<DmCPDocumentRequest> saveDocumentRequestPms(List<CPDocs.CPDocRequestSm> sms){
            return (List<DmCPDocumentRequest>)handleMethodInvocation('saveDocumentRequestPms', new List<object>{sms});
        }
        public void updateDocumentRequestStatus(List<CPDocs.CPDocRequestSm> sms){
            handleMethodInvocation('updateDocumentRequestStatus', new List<object>{sms});
        }
        public List<DmCPDocumentRequest> getDocumentRequestByObjectIdsAndDescriptionDms(List<string> ids, string objectDescription){
            return (List<DmCPDocumentRequest>)handleMethodInvocation('getDocumentRequestByObjectIdsAndDescriptionDms', new List<Object>{ids,objectDescription});
        }
        public string getDocIndexIdAfterAddingComponentDocumentLinks(String docRequestId, String destinationObjectId){
            return (string)handleMethodInvocation('getDocIndexIdAfterAddingComponentDocumentLinks', new List<OBject>{docRequestId,destinationObjectId});
        }
        public void save(List<Sobject> sobjs){
            handleMethodInvocation('save', new List<Object>{sobjs});
        }
    }

    public class ofIObjectTypeBuilder extends ApexMoq implements CPDocs.IObjectTypeBuilder {
        public CPDocs.ObjectType GetObjectType(string objectType){
            return (CPDocs.ObjectType)handleMethodInvocation('GetObjectType', new List<Object>{objectType});
        }
        public String GetObjectType(CPDocs.ObjectType o){
            return (String)handleMethodInvocation('GetObjectType', new List<Object>{o});
        }
        public CPDocs.ObjectType GetObjectTypeFromObjectId(string objectId){
            return (CPDocs.ObjectType)handleMethodInvocation('GetObjectTypeFromObjectId', new List<Object>{objectId});
        }
    }

    public class ofIDocumentSynchronizer extends ApexMoq implements CPDocs.IDocumentSynchronizer{
        public void sync(DmCPDocumentRequest dm){
            handleMethodInvocation('sync', new List<Object>{dm});
        }
    }


    public class ofINcinoDocRequestBuilderHelper extends ApexMoq implements CPDocs.INcinoDocRequestBuilderHelper{
        public List<CPDocs.CPDocRequestSm> buildDocRequests( List<DmNcinoDocumentPlaceHolder> placeHolderDms,List<CPDocs.RelatedObject> relObjects,
                                 List<DmCPDocumentRequest> cpDocs, String objectType){
            return (List<CPDocs.CPDocRequestSm>)handleMethodInvocation('buildDocRequests', new List<object>{placeHolderDms, relObjects, cpDocs, objectType});
        }
        public List<string> getIds(List<CPDocs.RelatedObject> rels){
            return (List<string>)handleMethodInvocation('getIds', new List<Object>{rels});
        }
        public Map<String,String> getIdNameLookup(List<CPDocs.RelatedObject> relObjects){
            return (Map<String,String>)handleMethodInvocation('getIdNameLookup', new List<Object>{relObjects});
        }
    }

    public class ofIDocRequestBuilder extends ApexMoq implements CPDocs.IDocRequestBuilder{
        public boolean handle(CPDocs.ObjectType type){
            return (boolean)handleMethodInvocation('handle', new List<Object>{type});
        }
        public List<CPDocs.CPDocRequestSm> buildDocRequests(List<CPDocs.RelatedObject> relObjects, List<DmCPDocumentRequest> cpDocs){
            return (List<CPDocs.CPDocRequestSm>)handleMethodInvocation('buildDocRequests', new List<Object>{relObjects, cpDocs});
        }
    }
    
    public class ofIDocRequestManager extends ApexMoq implements CPDocs.IDocRequestManager{
        public List<DmCPDocumentRequest> getRequests(DmUser userDm){
            return (List<DmCPDocumentRequest>)handleMethodInvocation('getRequests', new List<object>{userDm});
        }
        public List<DmCPDocumentRequest> calculateRequests(DmUser userDm){
            return (List<DmCPDocumentRequest>)handleMethodInvocation('calculateRequests', new List<object>{userDm});
        }
        public List<DmCPDocumentRequest> getRequestByObjectDescription(DmUser userDm, string objectDescription){
            return (List<DmCPDocumentRequest>)handleMethodInvocation('getRequestByObjectDescription', new List<Object>{userDm,objectDescription});
        }
        public boolean updateRequestStatus(List<string> documentRequestIds){
            return (boolean)handleMethodInvocation('updateRequestStatus', new List<object>{documentRequestIds});
        }
        public List<DmCPDocumentRequest> getRequestByIds(List<string> documentRequestIds){
            return (List<DmCPDocumentRequest>)handleMethodInvocation('getRequestByIds', new List<Object>{documentRequestIds});
        }
    }

    public class ofIRelatedObjectsProvider extends ApexMoq implements CPDocs.IRelatedObjectsProvider{
        public Map<CPDocs.ObjectType, List<CPDocs.RelatedObject>> getRelatedObjects(DmUser userDm){
            return (Map<CPDocs.ObjectType, List<CPDocs.RelatedObject>>)handleMethodInvocation('getRelatedObjects', new List<object>{userDm});
        }
        public Map<CPDocs.ObjectType, List<CPDocs.RelatedObject>> getRelatedObjectsByAccessObjects(DmUser userDm, List<DmCpDocumentAccess> accessObjects){
            return (Map<CPDocs.ObjectType, List<CPDocs.RelatedObject>>)handleMethodInvocation('getRelatedObjectsByAccessObjects', new List<object>{userDm, accessObjects});
        }
        public Map<CPDocs.ObjectType, List<CPDocs.RelatedObject>> getRelatedObjectsByObjectName(DmUser userDm, String objectName){
            return (Map<CPDocs.ObjectType, List<CPDocs.RelatedObject>>)handleMethodInvocation('getRelatedObjectsByObjectName');
        }
    }
}