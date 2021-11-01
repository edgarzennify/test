public class AgreementLoanAppRepositoryHelper implements Agreements.ILoanAppRepositoryHelper {
    
    public List<EB_Loan_Application__c> getExcludedLoanApps(List<EB_Loan_App_Entity_Relationship__c> entityAppRels, Set<Id> includedLoanAppIds) {
        Set<EB_Loan_Application__c> excludedSet = new Set<EB_Loan_Application__c>();
        for (EB_Loan_App_Entity_Relationship__c entityAppRel : entityAppRels) {
            EB_Loan_Application__c app = entityAppRel.Loan_Application_ID__r;
            if (app != null && !includedLoanAppIds.contains(app.Id)) {
                excludedSet.add(app);
            }
        }  
        return new List<EB_Loan_Application__c>(excludedSet);
    }

    public List<LLC_BI__Loan__c> getExcludedLlcBiLoans(List<LLC_BI__Legal_Entities__c> entityInvolvements, Set<Id> includedLoanAppIds) {
        Set<LLC_BI__Loan__c> excludedSet = new Set<LLC_BI__Loan__c>();
        for (LLC_BI__Legal_Entities__c ei : entityInvolvements) {
            LLC_BI__Loan__c loan = ei.LLC_BI__Loan__r;
            if (loan != null && !includedLoanAppIds.contains(loan.Id)) {
                excludedSet.add(loan);
            }
        }  
        return new List<LLC_BI__Loan__c>(excludedSet);  
    }

    public List<LLC_BI__Loan__c> filterExcludedLlcBiLoans(List<LLC_BI__Loan__c> unfilteredExcludedLoans, List<EB_Account__c> IncludedEbAccounts) {
        Map<String, LLC_BI__Loan__c> loanMap = new Map<String, LLC_BI__Loan__c>();
        for (LLC_BI__Loan__c ln : unfilteredExcludedLoans) {
            loanMap.put(ln.Name, ln);
        }

        for (EB_Account__c acc : IncludedEbAccounts) {
            if (loanMap.containsKey(acc.Name)) {
                loanMap.remove(acc.Name);
            }
        }    
        
        return loanMap.values();
    }
}