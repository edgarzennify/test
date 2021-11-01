public  class CPDocsDocumentSynchronizer implements CPDOCS.IDocumentSynchronizer{

    private string ACCOUNT_DOCUMENT = 'llc_bi__accountdocument__c';
    private string LOAN_DOCUMENT = 'llc_bi__llc_loandocument__c';
    private string COLLATERAL_DOCUMENT = 'llc_bi__document_placeholder__c';
    private static string IN_FILE_STATUS = 'In-File';
    private static string SOURCE_DOCMAN = 'docman';

    private final Utility.IUtility m_util;
    public CPDocsDocumentSynchronizer(Utility.IUtility util){
        m_util = util;
    }

    public void sync(DmCPDocumentRequest dm){
        if(dm == null || String.isBlank(dm.SourceId) || dm.Source.toLowerCase() != SOURCE_DOCMAN) return;

        if(m_util.getObjectNameFromId(dm.SourceId).toLowerCase() == ACCOUNT_DOCUMENT){
            syncNcinoAccountDocumentExecute(dm.id, dm.SourceId);
        }
        if(m_util.getObjectNameFromId(dm.SourceId).toLowerCase() == LOAN_DOCUMENT){
            syncNcinoLoanDocumentExecute(dm.id, dm.SourceId);
        }
        if(m_util.getObjectNameFromId(dm.SourceId).toLowerCase() == COLLATERAL_DOCUMENT){
            syncNcinoCollateralDocumentExecute(dm.id, dm.SourceId);
        }
    }

    @future
    private static void syncNcinoAccountDocumentExecute(String documentRequestId, String documentRequestObjectId){
        CPDocs.ICPDocsRepository cpdocsRepo = CPDocsBootstrapper.getCPDocsRepositoryInstance();
        if(String.isBlank(documentRequestObjectId)) return;
        String docIndexId = cpdocsRepo.getDocIndexIdAfterAddingComponentDocumentLinks(documentRequestId,documentRequestObjectId);
        LLC_BI__AccountDocument__c aDoc = new LLC_BI__AccountDocument__c();
        aDoc.Id = documentRequestObjectId;
        aDoc.LLC_BI__Document_Store_Index__c = docIndexId;
        aDoc.LLC_BI__reviewStatus__c = IN_FILE_STATUS;
        aDoc.LLC_BI__Portal_Enabled__c = false;
        List<Sobject> sobjs = new List<SObject>{aDoc};
        if(String.isNotBlank(docIndexId)) cpdocsRepo.save(sobjs);
    }

    @future
    public static void syncNcinoLoanDocumentExecute(String documentRequestId, String documentRequestObjectId){
        CPDocs.ICPDocsRepository cpdocsRepo = CPDocsBootstrapper.getCPDocsRepositoryInstance();
        if(String.isBlank(documentRequestObjectId)) return;
        String docIndexId = cpdocsRepo.getDocIndexIdAfterAddingComponentDocumentLinks(documentRequestId,documentRequestObjectId);
        LLC_BI__LLC_LoanDocument__c aDoc = new LLC_BI__LLC_LoanDocument__c();
        aDoc.Id = documentRequestObjectId;
        aDoc.LLC_BI__Document_Store_Index__c = docIndexId;
        aDoc.LLC_BI__reviewStatus__c = IN_FILE_STATUS;
        aDoc.LLC_BI__Portal_Enabled__c = false;
        List<Sobject> sobjs = new List<SObject>{aDoc};
        if(String.isNotBlank(docIndexId)) cpdocsRepo.save(sobjs);
    }

    @future
    public static void syncNcinoCollateralDocumentExecute(String documentRequestId, String documentRequestObjectId){
        CPDocs.ICPDocsRepository cpdocsRepo = CPDocsBootstrapper.getCPDocsRepositoryInstance();
        if(String.isBlank(documentRequestObjectId)) return;
        String docIndexId = cpdocsRepo.getDocIndexIdAfterAddingComponentDocumentLinks(documentRequestId,documentRequestObjectId);
        LLC_BI__Document_Placeholder__c aDoc = new LLC_BI__Document_Placeholder__c();
        aDoc.Id = documentRequestObjectId;
        aDoc.LLC_BI__Document_Store_Index__c = docIndexId;
        aDoc.LLC_BI__Review_Status__c = IN_FILE_STATUS;
        aDoc.LLC_BI__Portal_Enabled__c = false;
        List<Sobject> sobjs = new List<SObject>{aDoc};
        if(String.isNotBlank(docIndexId)) cpdocsRepo.save(sobjs);
    }
}