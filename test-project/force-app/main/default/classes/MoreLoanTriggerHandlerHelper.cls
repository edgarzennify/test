public class MoreLoanTriggerHandlerHelper implements MoreLoanTriggerHandler.IMoreLoanTriggerHandlerHelper {
    
    public Set<Id> getLoanIds(List<SObject> sos){
        Set<Id> returnSet = new Set<Id>();
        for(More_Loan__c moreLoan : (List<More_Loan__c>)sos){
            returnSet.add(moreLoan.Loan__c);
        }
        return returnSet;
    }
    public Map<Id, More_Loan__c> buildMoreLoanMap(List<More_Loan__c> relatedMoreLoanRecords){
        Map<Id, More_Loan__c> returnMap = new Map<Id, More_Loan__c>();
        for(More_Loan__c ml : relatedMoreLoanRecords){
            if(returnMap == null || !returnMap.containsKey(ml.Loan__c)){
                returnMap.put(ml.Loan__c, ml);
            }
        }
        return returnMap;
    }

}