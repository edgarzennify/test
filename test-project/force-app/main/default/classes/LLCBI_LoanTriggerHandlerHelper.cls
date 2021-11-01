public class LLCBI_LoanTriggerHandlerHelper implements LLCBI_LoanTriggerHandler.ILLCBI_LoanTriggerHandlerHelper{
    
    public Set<Id> gatherPackageIds(List<SObject> sos){
        Set<Id> returnSet = new Set<Id>();
        for(LLC_BI__Loan__c loan : (List<LLC_BI__Loan__c>)sos){
            if(loan.LLC_BI__Product_Package__c != null){
                returnSet.add(loan.LLC_BI__Product_Package__c);
            }
        }
        return returnSet;
    }
    public Map<Id, List<Conditions__c>> mapConditions(List<Conditions__c> allRelatedConditions){
        Map<Id, List<Conditions__c>> returnMap = new Map<Id, List<Conditions__c>>();
        if(allRelatedConditions != null){
            for(Conditions__c condition : allRelatedConditions){
                if(returnMap == null || !returnMap.keySet().contains(condition.Product_Package__c)){
                    returnMap.put(condition.Product_Package__c, new List<Conditions__c>());
                    returnMap.get(condition.Product_Package__c).add(condition);
                }else {
                    returnMap.get(condition.Product_Package__c).add(condition);
                }
            }
        }
        return returnMap;
    }
    public Set<Id> gatherEntityIds(List<SObject> sos){
        Set<Id> returnSet = new Set<Id>();
        for(LLC_BI__Loan__c loan : (List<LLC_BI__Loan__c>)sos){
            if(loan.LLC_BI__Account__c != null){
                returnSet.add(loan.LLC_BI__Account__c);
            }
        }
        return returnSet;
    }
    public Map<Id, Account> mapEntities(List<Account> relatedEntities){
        Map<Id, Account> returnMap = new Map<Id, Account>();
        if(relatedEntities != null){
            for(Account entity : relatedEntities){
                if(returnMap == null || !returnMap.keySet().contains(entity.Id)){
                    returnMap.put(entity.Id, entity);
                }
            }
        }
        return returnMap;
    }
    public List<Account> gatherEntitiesToUpdate(List<SObject> oldSos, Map<Id, SObject> newSosMap, List<Account> relatedEntities){
        List<Account> returnList = new List<Account>();
        Map<Id, Account> mappedEntities = mapEntities(relatedEntities);
        for(LLC_BI__Loan__c oldLoan : (List<LLC_BI__Loan__c>)oldSos){
            LLC_BI__Loan__c loanFromMap = (LLC_BI__Loan__c)newSosMap.get(oldLoan.Id);
            if(grossAnnualRevenueChanged(oldLoan, loanFromMap)  && loanFromMap.LLC_BI__Account__c != null){
                Account entityToUpdate = mappedEntities.get(loanFromMap.LLC_BI__Account__c);
                if(annualRevenueMismatch(loanFromMap, entityToUpdate)){
                    entityToUpdate.AnnualRevenue = loanFromMap.Gross_Annual_Revenue_Income__c;
                    returnList.add(entityToUpdate);
                }
            }
        }
        return returnList;
    }
    private Boolean grossAnnualRevenueChanged(LLC_BI__Loan__c oldLoan, LLC_BI__Loan__c loanFromMap){
        return oldLoan.Gross_Annual_Revenue_Income__c != loanFromMap.Gross_Annual_Revenue_Income__c;
    }
    private Boolean annualRevenueMismatch(LLC_BI__Loan__c loanFromMap, Account entityToUpdate){
        return loanFromMap.Gross_Annual_Revenue_Income__c != entityToUpdate.AnnualRevenue;
    }
}