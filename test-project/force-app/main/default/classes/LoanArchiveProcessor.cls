public class LoanArchiveProcessor implements LoanArchive.IProcessor {
    
    private final LoanArchive.IDataProvider m_dataProvider;
    private final LoanArchive.IMergeProcessor m_mergeProcessor;
    private final ImagingServiceProxy.IImagingServiceProxy m_imagingService;

    public LoanArchiveProcessor(LoanArchive.IDataProvider dataProvider, 
                                LoanArchive.IMergeProcessor mergeProcessor, 
                                ImagingServiceProxy.IImagingServiceProxy imagingService){
        m_dataProvider = dataProvider;
        m_mergeProcessor = mergeProcessor;
        m_imagingService = imagingService;
    }

    public void process(Id loanId, List<LoanArchive.SObjectMergeRequest> requests){
        List<SObject> saves = new List<SObject>();
        List<SObject> deletes = new List<SObject>();
        List<LoanArchive.MergeRequest> merges = new List<LoanArchive.MergeRequest>();
        List<LoanArchive.DocumentKeyUpdate> keyUpdates = new List<LoanArchive.DocumentKeyUpdate>();
        
        List<LoanArchive.MergeResult> mergeResults = m_mergeProcessor.process(requests);
        
        for(LoanArchive.MergeResult result : mergeResults){
 
            saves.addAll(result.saveRecords);
            deletes.addAll(result.deleteRecords);
            merges.addAll(result.mergeRecords);
            keyUpdates.addAll(result.keyUpdates);
        }

        saveChanges(saves, deletes);
        mergeChanges(merges);
        updateDocumentKeys(keyUpdates);
    }

    private void saveChanges(List<SObject> saves, List<SObject> deletes){
        Savepoint sp = m_dataProvider.setSavepoint();
        try{      
            m_dataProvider.save(saves);
            m_dataProvider.remove(deletes);
        }catch(Exception ex){
            m_dataProvider.rollback(sp);
            throw ex;
        }
    } 

    private void mergeChanges(List<LoanArchive.MergeRequest> mergeObjs){
        Savepoint sp = m_dataProvider.setSavepoint();
        try{
            m_dataProvider.merges(mergeObjs);
        }catch(Exception ex){
            m_dataProvider.rollback(sp);
            throw ex;
        }
    }  

    private void updateDocumentKeys(List<LoanArchive.DocumentKeyUpdate> keyUpdates){
        List<ImagingServiceProxy.UpdateDocumentKeysRequest> requests = new List<ImagingServiceProxy.UpdateDocumentKeysRequest>();
        for(LoanArchive.DocumentKeyUpdate u : keyUpdates){
            ImagingServiceProxy.UpdateDocumentKeysRequest req = new ImagingServiceProxy.UpdateDocumentKeysRequest();
            req.oldExternalKey = u.oldExternalKey;
            req.newExternalKey = u.newExternalKey;
            requests.add(req);
        }
        m_imagingService.updateDocumentKeys_Async(requests);
    }

}