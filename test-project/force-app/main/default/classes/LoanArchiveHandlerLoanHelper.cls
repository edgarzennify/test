public class LoanArchiveHandlerLoanHelper implements LoanArchive.IHandlerLoanHelper {

    public static Map<Id, Id> cachedMap;

    public Map<Id, Id> buildCachedMap(List<LLC_BI__Loan__c> llcBiLoans, List<EB_Account__c> ebAccounts){
        Map<String, Id> ebAcctMap = mapify(ebAccounts);

        Map<Id, Id> twinMap = new Map<Id, Id>();    
        for(LLC_BI__Loan__c llcBiLoan : llcBiLoans){
            if(llcBiLoan.LLC_BI__lookupKey__c != '' && llcBiLoan.LLC_BI__lookupKey__c != null){
                twinMap.put(llcBiLoan.Id, ebAcctMap.get(llcBiLoan.LLC_BI__lookupKey__c));
            }
        }
        return twinMap;
    }

    private Map<String, Id> mapify(List<EB_Account__c> ebAccounts){
        Map<String, Id> ebAcctmap = new Map<String, Id>();
        for(EB_Account__c ebAcct : ebAccounts){
            ebAcctmap.put(ebAcct.Key__c, ebAcct.Id);
        }
        return ebAcctmap;
    }
}