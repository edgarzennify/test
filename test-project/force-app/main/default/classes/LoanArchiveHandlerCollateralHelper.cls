public class LoanArchiveHandlerCollateralHelper implements LoanArchive.IHandlerCollateralHelper {
     public List<SObject> reparentCollateralPledges(List<LLC_BI__Loan_Collateral2__c> prospects, List<LLC_BI__Loan_Collateral2__c> cores) {
         List<SObject> saves = new List<SObject>();
         if(isNull(prospects) || isNull(cores)) return saves;
         
         Id prospectId = prospects[0].LLC_BI__Collateral__c;
         Id coreId = cores[0].LLC_BI__Collateral__c;
         Map<Id, List<LLC_BI__Loan_Collateral2__c>> loanCollateral = new Map<Id, List<LLC_BI__Loan_Collateral2__c>>();
         for(LLC_BI__Loan_Collateral2__c coreCollPl : cores){
             Id lnid = coreCollPl.LLC_BI__Loan__c;
             if(!loanCollateral.containsKey(lnid)){
                 loanCollateral.put(lnid, new List<LLC_BI__Loan_Collateral2__c>());
             }
             loanCollateral.get(lnid).add(coreCollPl);
         }
         for(LLC_BI__Loan_Collateral2__c prospectCollPl : prospects){
             Id lnid = prospectCollPl.LLC_BI__Loan__c;
             if(!loanCollateral.containsKey(lnid)){
                 loanCollateral.put(lnid, new List<LLC_BI__Loan_Collateral2__c>());
             }
             loanCollateral.get(lnid).add(prospectCollPl);
         }
         for(Id loanId : loanCollateral.keySet()){
             LLC_BI__Loan_Collateral2__c refToProspect = null;
             LLC_BI__Loan_Collateral2__c refToCore = null;
             for(LLC_BI__Loan_Collateral2__c e : loanCollateral.get(loanId)){
                 if(e.LLC_BI__Collateral__c == prospectId){
                     refToProspect = e;
                 }
                 if(e.LLC_BI__Collateral__c == coreId){
                     refToCore = e;
                 }
             }
             if(refToProspect == null && refToCore != null){
                 refToCore.LLC_BI__Collateral__c = prospectId;
                 saves.add(refToCore);
             }
         }  
         return saves;
    }
    
    public List<SObject> reparentCollateralOwnerships(List<LLC_BI__Account_Collateral__c> prospects, List<LLC_BI__Account_Collateral__c> cores) {
        List<SObject> saves = new List<SObject>();
        if(isNull(prospects) || isNull(cores)) return saves;
        
        Id prospectId = prospects[0].LLC_BI__Collateral__c;
        Id coreId = cores[0].LLC_BI__Collateral__c;
        Map<Id, List<LLC_BI__Account_Collateral__c>> entityCollateral = new Map<Id, List<LLC_BI__Account_Collateral__c>>();
        for(LLC_BI__Account_Collateral__c coreEntityRef : cores){
            Id eid = coreEntityRef.LLC_BI__Account__c;
            if(!entityCollateral.containsKey(eid)){
                entityCollateral.put(eid, new List<LLC_BI__Account_Collateral__c>());
            }
            entityCollateral.get(eid).add(coreEntityRef);
        }
        for(LLC_BI__Account_Collateral__c prospectEntityRef : prospects){
            Id eid = prospectEntityRef.LLC_BI__Account__c;
            if(!entityCollateral.containsKey(eid)){
                entityCollateral.put(eid, new List<LLC_BI__Account_Collateral__c>());
            }
            entityCollateral.get(eid).add(prospectEntityRef);
        }
        for(Id entityId : entityCollateral.keySet()){
            LLC_BI__Account_Collateral__c refToProspect = null;
            LLC_BI__Account_Collateral__c refToCore = null;
            for(LLC_BI__Account_Collateral__c e : entityCollateral.get(entityId)){
                if(e.LLC_BI__Collateral__c == prospectId){
                    refToProspect = e;
                }
                if(e.LLC_BI__Collateral__c == coreId){
                    refToCore = e;
                }
            }
            if(refToProspect == null && refToCore != null){
                refToCore.LLC_BI__Collateral__c = prospectId;
                saves.add(refToCore);
            }
        }   
        return saves;
    }

    public List<SObject> reparentCollateralDocuments(Id prospectId,List<LLC_BI__Document_PlaceHolder__c> coreDocuments){
        List<SObject> saves = new List<SObject>();
        if(prospectId==null || isNull(coreDocuments)) return saves;

        for(LLC_BI__Document_PlaceHolder__c d : coreDocuments){
            d.LLC_BI__External_Id__c = prospectId;
            saves.add(d);
        }
        return saves;
    }
    
    private Boolean isNull(List<SObject> objs) {
        return String.valueOf(objs) == '()';
    }
}