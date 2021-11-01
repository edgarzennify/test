public class MoreLoanTriggerHandler extends TriggerHandler {
    private final IMoreLoanTriggerHandlerHelper m_helper;
    private final IMoreLoanTriggerHandlerDataProvider m_dataProvider;
    
    public interface IMoreLoanTriggerHandlerHelper {
        Set<Id> getLoanIds(List<SObject> sos);
        Map<Id, More_Loan__c> buildMoreLoanMap(List<More_Loan__c> relatedMoreLoanRecords);
    }
    public interface IMoreLoanTriggerHandlerDataProvider{
        List<More_Loan__c> getRelatedMoreLoanRecords(Set<Id> loanIds);
    }
    
    public MoreLoanTriggerHandler() {
        m_helper = new MoreLoanTriggerHandlerHelper();
        m_dataProvider = new MoreLoanTriggerHandlerDataProvider();
    }
    public MoreLoanTriggerHandler(IMoreLoanTriggerHandlerHelper helper, IMoreLoanTriggerHandlerDataProvider dataProvider){
        m_helper = helper;
        m_dataProvider = dataProvider;
    }
        
    public override void bulkBeforeInsert(List<SObject> sos){
        Set<Id> loanIds = m_helper.getLoanIds(sos);
        List<More_Loan__c> relatedMoreLoanRecords = m_dataProvider.getRelatedMoreLoanRecords(loanIds);
        Map<Id, More_Loan__c> moreLoanMap = m_helper.buildMoreLoanMap(relatedMoreLoanRecords);
        handleMoreLoanValidation(sos, moreLoanMap);
    }
    private void handleMoreLoanValidation(List<SObject> sos, Map<Id, More_Loan__c> moreLoanMap){
        for(More_Loan__c ml : (List<More_Loan__c>)sos){
            More_Loan__c existingMoreLoan;
            if(moreLoanMap != null && moreLoanMap.containsKey(ml.Loan__c)){
                existingMoreLoan = moreLoanMap.get(ml.Loan__c);
            }
            if(existingMoreLoan != null){
                ml.addError('Only one More Loan record may be related to this Loan. More Loan Id: ' + existingMoreLoan.Id);
            }
        }
    }
}