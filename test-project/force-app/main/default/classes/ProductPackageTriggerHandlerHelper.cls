public class ProductPackageTriggerHandlerHelper implements ProductPackageTriggerHandler.IProductPackageHelper{
    private static ProductPackageTriggerHandler.IDataProvider m_dataProvider;
    private static Map<Id, List<LLC_BI__Loan__c>> m_relatedLoanMap;
    private static Integer m_processRuns = 0;
    
    public ProductPackageTriggerHandlerHelper(ProductPackageTriggerHandler.IDataProvider dataProvider){ 
        m_dataProvider = dataProvider;
    }
    public ProductPackageTriggerHandlerHelper(){
        m_dataProvider = new ProductPackageTriggerHandlerDataProvider();
    }
    
    public List<LLC_BI__Loan__c> getUpdatedLoans(List<LLC_BI__Product_Package__c> oldSos, Map<Id, SObject> newSosMap){
        if(m_relatedLoanMap == null){
            m_relatedLoanMap = getRelatedLoans(newSosMap.keySet());
        }
        List<LLC_BI__Loan__c> updatedLoans = new List<LLC_BI__Loan__c>();
        for(LLC_BI__Product_Package__c oldPack : (List<LLC_BI__Product_Package__c>)oldSos){
            LLC_BI__Product_Package__c newPack = (LLC_BI__Product_Package__c)newSosMap.get(oldPack.Id);
            if(m_relatedLoanMap !=null && m_relatedLoanMap.containsKey(oldPack.Id)){
                List<LLC_BI__Loan__c> relatedLoans = m_relatedLoanMap.get(oldPack.Id);
                updatedLoans.addAll(handleLoans(oldPack,newPack,relatedLoans));
            }
        }
        return updatedLoans;
    }
    private Map<Id, List<LLC_BI__Loan__c>> getRelatedLoans(Set<Id> packageIds){
        List<LLC_BI__Loan__c> allRelatedLoans = m_dataProvider.getLoans(packageIds);
        return mapLoans(allRelatedLoans);
    }
   
    
    //////////
    private Map<Id, List<LLC_BI__Loan__c>> mapLoans(List<LLC_BI__Loan__c> allLoans){
        Map<Id, List<LLC_BI__Loan__c>> mapped = new Map<Id, List<LLC_BI__Loan__c>>();
        if(allLoans != null){
            for(LLC_BI__Loan__c loan : allLoans){
                if(!mapped.containsKey(loan.LLC_BI__Product_Package__c)){
                mapped.put(loan.LLC_BI__Product_Package__c, new List<LLC_BI__Loan__c>{loan});
                }else{
                    mapped.get(loan.LLC_BI__Product_Package__c).add(loan);
                }
            }        
        }
        return mapped;
    }
   
    private List<LLC_BI__Loan__c> handleLoans(LLC_BI__Product_Package__c oldPack, LLC_BI__Product_Package__c newPack, List<LLC_BI__Loan__c> relatedLoans){
        List<LLC_BI__Loan__c> loansToUpdate = new List<LLC_BI__Loan__c>();
        Boolean addToList;
        if(relatedLoans != null && m_processRuns < 1){
            for(LLC_BI__Loan__c l : relatedLoans){
                addToList = false;
                if(approversDontMatch(newPack,l) && loanNotApproved(l)){
                    l.First_Approver__c = newPack.First_Approver__c;
                    l.Second_Approver__c = newPack.Second_Approver__c;
                    l.Third_Approver__c = newPack.Third_Approver__c;
                    if(addToList==false){
                        addToList = true;
                    }
                }
                if(officersDontMatch(newPack, l) && loanNotApproved(l)){
                    l.Originating_Officer__c = newPack.Originating_Officer__c;
                    if(addToList==false){
                        addToList = true;
                    }
                }
                if(holdStatusChanged(oldPack, newPack) && newPack.LLC_BI__Status__c != l.LLC_BI__Status__c){
                    l.LLC_BI__Status__c = newPack.LLC_BI__Status__c;
                    if(addToList==false){
                        addToList = true;
                    }
                }
                if(addToList == true){
                    loansToUpdate.add(l);
                }
            }
        }
        return loansToUpdate;
    }
    private Boolean approversDontMatch(LLC_BI__Product_Package__c pack, LLC_BI__Loan__c loan){
        return pack.First_Approver__c != loan.First_Approver__c 
            || pack.Second_Approver__c != loan.Second_Approver__c 
            || pack.Third_Approver__c != loan.Third_Approver__c;
    }
    private Boolean officersDontMatch(LLC_BI__Product_Package__c vNew, LLC_BI__Loan__c loan){
        return vNew.Originating_Officer__c != loan.Originating_Officer__c;
    }
    
    private Boolean holdStatusChanged(LLC_BI__Product_Package__c oldPack, LLC_BI__Product_Package__c newPack){
        return oldPack.LLC_BI__Status__c != 'Hold' && newPack.LLC_BI__Status__c == 'Hold' 
            || oldPack.LLC_BI__Status__c == 'Hold' && newPack.LLC_BI__Status__c != 'Hold';
    }
    
    private Boolean loanNotApproved(LLC_BI__Loan__c l){
        return l.LLC_BI__Stage__c == 'Credit Request' || l.LLC_BI__Stage__c == 'Credit Underwriting';
    }
}