public class OpportunityTriggerHandler extends TriggerHandler { 
    public Interface IOpportunityTriggerHandlerDataProv{
        List<Account> getAccounts(Set<Id> acctIds);
        void updateAccounts(List<Account> accts);
        List<LLC_BI__Loan__c> getRelatedLoans(Set<Id> loanIds);
    }

    private final IOpportunityTriggerHandlerDataProv m_dataProvider;
    private final Configurations.IConfigurations m_config;
    private Set<Id> m_relatedAccountIDs = new Set<Id>();
  
    public OpportunityTriggerHandler(){
        m_dataProvider = new OpportunityTriggerHandlerDataProv();
        m_config = Configurations.bootstrap();
    }

    public OpportunityTriggerHandler(IOpportunityTriggerHandlerDataProv dataProvider, Configurations.IConfigurations config) {
        m_dataProvider = dataProvider;
        m_config = config;
    }

    public override void bulkAfterInsert(List<SObject> sos){
        for(SObject so : sos){
            addRelatedAccountToSet((Id)so.get('AccountId'));
        }
    }
    public override void bulkBeforeInsert(List<SObject> sos){
        Set<Id> relatedPPPLoanIds = buildPPPLoanIdSet(sos);
        List<LLC_BI__Loan__c> relatedPPPLoans = m_dataProvider.getRelatedLoans(relatedPPPLoanIds);
        Map<Id, LLC_BI__Loan__c> relatedPPPLoanMap = buildPPPLoanMap(relatedPPPLoans);
        handlePPPLoanNumber(sos, new Map<Id, SObject>(), relatedPPPLoanMap);
    }
    public override void bulkBeforeUpdate(List<SObject> sos, Map<Id, SObject> newSosMap){
        Set<Id> relatedPPPLoanIds = buildPPPLoanIdSet(newSosMap.values());
        List<LLC_BI__Loan__c> relatedPPPLoans = m_dataProvider.getRelatedLoans(relatedPPPLoanIds);
        Map<Id, LLC_BI__Loan__c> relatedPPPLoanMap = buildPPPLoanMap(relatedPPPLoans);
        handlePPPLoanNumber(sos, newSosMap, relatedPPPLoanMap);
    }

    public override void finalize(){
        updateRelatedAccountsRelationshipReviewRequiredDate();
    }

    private void addRelatedAccountToSet(Id accountId){
        m_relatedAccountIDs.add(accountId);
    }

    private void updateRelatedAccountsRelationshipReviewRequiredDate(){
        Datetime earliestAcceptableLastReviewedDate = System.now().addDays(-1 * m_config.getRelationshipReviewRequiredGracePeriod());
        Datetime newRelReviewReqDate = Datetime.newInstance(System.Today(), Time.newInstance(8, 0, 0, 0));
        List<Account> acctsToUpdate = new List<Account>();
        List<Account> relatedAccts = m_dataProvider.getAccounts(m_relatedAccountIDs);
        for(Account acct : relatedAccts){
            if(acct.Relationship_Review_Required_Date__c == null && 
                (acct.Relationship_Review_Last_Modified_Date__c == null || acct.Relationship_Review_Last_Modified_Date__c < earliestAcceptableLastReviewedDate)){
                acct.Relationship_Review_Required_Date__c = newRelReviewReqDate;
                acctsToUpdate.add(acct);
            }
        }
        if(acctsToUpdate.size() > 0){
            m_dataProvider.updateAccounts(acctsToUpdate);
        }
    }
    private void handlePPPLoanNumber(List<SObject> sos, Map<Id, SObject> newSosMap, Map<Id, LLC_BI__Loan__c> relatedPPPLoanMap){
        for(Opportunity opp : (List<Opportunity>)sos){
            LLC_BI__Loan__c relatedLoan = new LLC_BI__Loan__c();
            Opportunity newOpp;
                if(newSosMap.keySet().size() > 0){
                    newOpp = (Opportunity)newSosMap.get(opp.Id);
                    relatedLoan = relatedPPPLoanMap.get(newOpp.Original_PPP_Loan_Number2__c);
                }else{
                    relatedLoan = relatedPPPLoanMap.get(opp.Original_PPP_Loan_Number2__c);
                }
            if(PPPLoanNumberNeedsUpdate(opp, newOpp)){
                if(newOpp != null){
                    newOpp.Original_PPP_Loan_Amount__c = relatedLoan.LLC_BI__Amount__c;
                }else {
                    opp.Original_PPP_Loan_Amount__c = relatedLoan.LLC_BI__Amount__c;
                }
            }
        }
    }
    private Boolean PPPLoanNumberNeedsUpdate(Opportunity opp, Opportunity newOpp){
        if(newOpp != null){
            return opp.Original_PPP_Loan_Number2__c != newOpp.Original_PPP_Loan_Number2__c;
        }
        return opp.Original_PPP_Loan_Number2__c != null;
    }
    private Set<Id> buildPPPLoanIdSet(List<SObject> objs){
        Set<Id> returnSet = new Set<Id>();
        for(Opportunity opp : (List<Opportunity>)objs){
            if(opp.Original_PPP_Loan_Number2__c != null){
                returnSet.add(opp.Original_PPP_Loan_Number2__c);
            }
        }
        return returnSet;
    }
    private Map<Id, LLC_BI__Loan__c> buildPPPLoanMap(List<LLC_BI__Loan__c> relatedPPPLoans){
        Map<Id, LLC_BI__Loan__c> returnMap = new Map<Id, LLC_BI__Loan__c>();
        for(LLC_BI__Loan__c loan : relatedPPPLoans){
            returnMap.put(loan.Id, loan);
        }
        return returnMap;
    }

}