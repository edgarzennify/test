public class LoanArchiveMergeProcessor implements LoanArchive.IMergeProcessor {
    
    private final List<LoanArchive.IHandler> m_handlers;
    private final LoanArchive.IMergeProcessorHelper m_helper;
    
    public LoanArchiveMergeProcessor(List<LoanArchive.IHandler> handlers, LoanArchive.IMergeProcessorHelper helper){
        m_handlers = handlers;
        m_helper = helper;
    }
    
    public List<LoanArchive.MergeResult> process(List<LoanArchive.SObjectMergeRequest> requests){
        Map<SObjectType, List<LoanArchive.SObjectMergeRequest>> mappedRequests = m_helper.buildRequestMap(requests);
        List<LoanArchive.MergeResult> mergeResults = new List<LoanArchive.MergeResult>();
        for(SObjectType sobjectType : mappedRequests.keySet()){
            for(LoanArchive.IHandler handler : findHandlers(sobjectType)){
                List<LoanArchive.MergeResult> results = mergeObjects(handler, mappedRequests.get(sobjectType));
                mergeResults.addAll(results);
            }           
        }
        
        return mergeResults;
    }
    
    private List<LoanArchive.IHandler> findHandlers(SObjectType sobjectType) {
        List<LoanArchive.IHandler> handlers = new List<LoanArchive.IHandler>();
        for(LoanArchive.IHandler handler : m_handlers) {
            if(sobjectType == handler.getSObjectTypeHandled()){
                handlers.add(handler);
            }
        }
        if(handlers.size() > 0){
            return handlers;
        }
        throw new LoanArchive.HandlerNotFoundException();
    }
    
    private List<LoanArchive.MergeResult> mergeObjects(LoanArchive.IHandler handler, List<LoanArchive.SObjectMergeRequest> requests){
        List<Id> objectIds = m_helper.buildIdList(requests);
        List<SObject> sobjects = handler.getSObjectsForMerging(objectIds);      
        Map<Id, SObject> sobjectMap = m_helper.buildSObjectMap(sobjects);
        return m_helper.mergeObjects(handler, requests, sobjectMap);
    }
    
}