public class LoanArchiveMergeProcessorHelper implements LoanArchive.IMergeProcessorHelper {
    
    public Map<SObjectType, List<LoanArchive.SObjectMergeRequest>> buildRequestMap(List<LoanArchive.SObjectMergeRequest> requests){
        Map<SObjectType, List<LoanArchive.SObjectMergeRequest>> mappedRequests = new Map<SObjectType, List<LoanArchive.SObjectMergeRequest>>();
        for(LoanArchive.SObjectMergeRequest r : requests){
            SObjectType key = r.prospectObjectId.getSObjectType();
            if(!mappedRequests.containsKey(key)){
                mappedRequests.put(key, new List<LoanArchive.SObjectMergeRequest>());
            }
            mappedRequests.get(key).add(r);
        }

        return mappedRequests;
    }
    
    public List<Id> buildIdList(List<LoanArchive.SObjectMergeRequest> requests){
        List<Id> objectIds = new List<Id>();
        for(LoanArchive.SObjectMergeRequest req : requests) {
            objectIds.add(req.prospectObjectId);
            objectIds.add(req.coreObjectId);
        }

        return objectIds;
    }
    
    public Map<Id, SObject> buildSObjectMap(List<SObject> sobjects){
        Map<Id, SObject> sobjectMap = new Map<Id, SObject>();
        if(sobjects != null){
            for(SObject so : sobjects){
                sobjectMap.put(so.Id, so);
            }
        }

        return sobjectMap;
    }
    
    public List<LoanArchive.MergeResult> mergeObjects(LoanArchive.IHandler handler, List<LoanArchive.SObjectMergeRequest> requests, Map<Id, SObject> mergeData){
        List<LoanArchive.MergeResult> results = new List<LoanArchive.MergeResult>();
        for(LoanArchive.SObjectMergeRequest req : requests) {
            LoanArchive.MergeResult result = handler.mergeObjects(req.prospectObjectId, req.coreObjectId, mergeData);
            if(result != null){
                results.add(result);
            }
        }

        return results;
    }
}