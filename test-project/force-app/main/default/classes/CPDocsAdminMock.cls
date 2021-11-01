public class CPDocsAdminMock {
    

    public class ofIDataProvider extends Mock.ofIDataProvider implements CPDocsAdmin.IDataProvider{
        public List<CP_Document_Access__c> getAccessByUser(List<String> objectIds){
            return (List<CP_Document_Access__c>)handlemethodinvocation('getAccessByUser', new List<Object>{objectIDs});
        }
        public PM_User getUserFromContact(String contactId){
            return (PM_User)handlemethodinvocation('getUserFromContact', new List<object>{contactId});
        }
        public List<CP_Document_Access__c> getAccessByObjectIds(List<String> objectIds){
            return (List<CP_Document_Access__c>)handleMethodInvocation('getAccessByObjectIds', new List<Object>{objectIds});
        }
        public List<CP_Document_Access__c> getAccessByObjectIdsAndUser(List<String> objectIds, String userId){
            return (List<CP_Document_Access__c>)handleMethodInvocation('getAccessByObjectIdsAndUser', new List<Object>{objectIds, userId});
        }
    }

    public class ofIRepository extends ApexMoq implements CPDocsAdmin.IRepository {
        public DmUser getUserFromContact(String contactId){
            return (DmUser)handleMethodInvocation('getUserFromContact', new List<Object>{contactId});
        }
        public List<DmCpDocumentAccess> getObjectsForUser(String userId){
            return (List<DmCpDocumentAccess>)handleMethodInvocation('getObjectsForUser', new List<Object>{userId});
        }
        public List<DmCpDocumentAccess> getObjectsForObjectIds(List<String> objectIds){
            return (List<DmCpDocumentAccess>)handleMethodInvocation('getObjectsForObjectIds', new List<Object>{objectIds});
        }
        public List<DmCpDocumentAccess> getObjectsForObjectIdsAndUser(List<String> objectIds, String userId){
            return (List<DmCpDocumentAccess>)handleMethodInvocation('getObjectsForObjectIdsAndUser', new List<Object>{objectIds, userId});
        }
    }

    public class ofIVmBuilder extends ApexMoq implements CPDocsAdmin.IVmBuilder {
        public List<CPDocsAdmin.DocumentAdminRequest> buildVms(Map<DmLoan,List<DmLoan>> relatedMap, List<DmCpDocumentAccess> accessDms, DmUser userDm){
            return (List<CPDocsAdmin.DocumentAdminRequest>)handleMethodInvocation('buildVms', new List<Object>{relatedMap, accessDms, userDm});
        }
    }

    public class ofIRelatedNcinoLoans extends ApexMoq implements  CPDocsAdmin.IRelatedNcinoLoans{
        public Map<DmLoan,List<DmLoan>> getRelatedLoanRenewals(List<DmLoanRenewal> dms){
            return (Map<DmLoan,List<DmLoan>>)handleMethodInvocation('getRelatedLoanRenewals', new List<Object>{dms});
        }
    }
}