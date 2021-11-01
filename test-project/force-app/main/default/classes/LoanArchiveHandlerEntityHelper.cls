public class LoanArchiveHandlerEntityHelper implements LoanArchive.IHandlerEntityHelper {

    public List<SObject> reparentEntityInvolvements(List<LLC_BI__Legal_Entities__c> prospectInvolvements, List<LLC_BI__Legal_Entities__c> coreInvolvements) {
        List<SObject> saves = new List<SObject>();
        if(isNull(prospectInvolvements) || isNull(coreInvolvements)) return saves;
        Id prospectId = prospectInvolvements[0].LLC_BI__Account__c;
        Id coreId = coreInvolvements[0].LLC_BI__Account__c;
        Map<Id, List<LLC_BI__Legal_Entities__c>> legalEntities = new Map<Id, List<LLC_BI__Legal_Entities__c>>();

        for(LLC_BI__Legal_Entities__c prospectInv : prospectInvolvements) {
          Id loanId = prospectInv.LLC_BI__Loan__c;
          if(!legalEntities.containsKey(loanId)) {
              legalEntities.put(loanId, new List<LLC_BI__Legal_Entities__c>());
          }
          legalEntities.get(loanId).add(prospectInv);
        }

        for(LLC_BI__Legal_Entities__c coreInv : coreInvolvements) {
            Id loanId = coreInv.LLC_BI__Loan__c;
            if(!legalEntities.containsKey(loanId)) {
                legalEntities.put(loanId, new List<LLC_BI__Legal_Entities__c>());
            }
            legalEntities.get(loanId).add(coreInv);
        }

        for(Id loanId : legalEntities.keySet()) {
            LLC_BI__Legal_Entities__c prospectRef = null;
            LLC_BI__Legal_Entities__c coreRef = null;
            for(LLC_BI__Legal_Entities__c inv : legalEntities.get(loanId)) {
                if(inv.LLC_BI__Account__c == prospectId) {
                    prospectRef = inv;
                }
                if(inv.LLC_BI__Account__c == coreId) {
                    coreRef = inv;
                }               
            }
            if(prospectRef == null && coreRef != null) {
                    coreRef.LLC_BI__Account__c = prospectId;
                    saves.add(coreRef);
            }
        }
        
        return saves;
    }

    public List<SObject> reparentCollateralOwnerships(List<LLC_BI__Account_Collateral__c> prospectOwnerships, List<LLC_BI__Account_Collateral__c> coreOwnerships) {
        List<SObject> saves = new List<SObject>();
        if(isNull(prospectOwnerships) || isNull(coreOwnerships)) return saves;
        Id prospectId = prospectOwnerships[0].LLC_BI__Account__c;
        Id coreId = coreOwnerships[0].LLC_BI__Account__c;
        Map<Id, List<LLC_BI__Account_Collateral__c>> ownerships = new Map<Id, List<LLC_BI__Account_Collateral__c>>();

        for(LLC_BI__Account_Collateral__c own : prospectOwnerships) {
            Id collateralId = own.LLC_BI__Collateral__c;
            if(!ownerships.containsKey(collateralId)) {
                ownerships.put(collateralId, new List<LLC_BI__Account_Collateral__c>());
            }
            ownerships.get(collateralId).add(own);
        }

        for(LLC_BI__Account_Collateral__c own : coreOwnerships) {
            Id collateralId = own.LLC_BI__Collateral__c;
            if(!ownerships.containsKey(collateralId)) {
                ownerships.put(collateralId, new List<LLC_BI__Account_Collateral__c>());
            }
            ownerships.get(collateralId).add(own);
        }

        for(Id collateralId : ownerships.keySet()) {
            LLC_BI__Account_Collateral__c prospectRef = null;
            LLC_BI__Account_Collateral__c coreRef = null;
            for(LLC_BI__Account_Collateral__c own : ownerships.get(collateralId)) {
                if(own.LLC_BI__Account__c == prospectId) {
                    prospectRef = own;
                }
                if(own.LLC_BI__Account__c == coreId) {
                    coreRef = own;
                }   
            }
            if(prospectRef == null && coreRef != null) {
                coreRef.LLC_BI__Account__c = prospectId;
                saves.add(coreRef);
            }
        }

        return saves;
    }

    public List<SObject> reparentEntityDocuments (Id prospectId,List<LLC_BI__AccountDocument__c> coreDocuments){
        List<SObject> saves = new List<SObject>();
        if(prospectId == null || isNull(coreDocuments)) return saves;
        Id coreId = coreDocuments[0].LLC_BI__Account__c;
        for(LLC_BI__AccountDocument__c d :coreDocuments){
            d.LLC_BI__Account__c=prospectId;
            saves.add(d);
        }
        return saves;
    }

    public List<SObject> reparentLoans(Id prospectId, List<LLC_BI__Loan__c> coreLoans) {
        List<SObject> saves = new List<SObject>();
        if(isNull(coreLoans)) return saves;

        for(LLC_BI__Loan__c loan : coreLoans) {
            loan.LLC_BI__Account__c = prospectId;
            saves.add(loan);
        }
       
        return saves;
    }

    public List<SObject> reparentEbAccountRelationships(Id prospectId, List<Eb_Account_Relationship__c> coreRels) {
        List<SObject> saves = new List<SObject>();
        if(isNull(coreRels)) return saves;

        for(Eb_Account_Relationship__c rel : coreRels) {
            rel.Client_Id__c = prospectId;
            saves.add(rel);
        }
        
        return saves;
    }

    public List<SObject> reparentEbCollateralRelationships(Id prospectId, List<EB_Collateral_Client_Relationship__c> coreRels) {
        List<SObject> saves = new List<SObject>();
        if(isNull(coreRels)) return saves;

        for(EB_Collateral_Client_Relationship__c rel : coreRels) {
            rel.Client_Id__c = prospectId;
            saves.add(rel);
        }
        
        return saves;
    }

    public List<SObject> reparentEbAccountOwnerships(Id prospectId, List<Eb_Account__c> coreEbAccounts) {
        List<SObject> saves = new List<SObject>();
        if(isNull(coreEbAccounts)) return saves;

        for(Eb_Account__c acct : coreEbAccounts) {
            acct.Primary_Owner_Id__c = prospectId;
            saves.add(acct);
        }
        
        return saves;
    }

    public List<SObject> reparentEbCollateralOwnerships(Id prospectId, List<Eb_Collateral__c> coreCollaterals) {
        List<SObject> saves = new List<SObject>();
        if(isNull(coreCollaterals)) return saves;

        for(Eb_Collateral__c col : coreCollaterals) {
            col.Collateral_Owner__c = prospectId;
            saves.add(col);
        }

        return saves;
    }

    public List<SObject> createDeletesForEntityInvolvements(List<LLC_BI__Legal_Entities__c> prospectInvolvements, List<LLC_BI__Legal_Entities__c> coreInvolvements){       
        List<SObject> deletes = new List<SObject>();
        Set<Id> prospectLoanIds = new Set<Id>();
        for(LLC_BI__Legal_Entities__c inv : prospectInvolvements){
            prospectLoanIds.add(inv.LLC_BI__Loan__c);
        }

        for(LLC_BI__Legal_Entities__c inv : coreInvolvements){
            if(prospectLoanIds.contains(inv.LLC_BI__Loan__c)){
                deletes.add(inv);
            }
        }

        return deletes;
    }

    public List<SObject> createDeletesForCollateralOwnerships(List<LLC_BI__Account_Collateral__c> prospectOwnerships, List<LLC_BI__Account_Collateral__c> coreOwnerships){
        List<SObject> deletes = new List<SObject>();
        Set<Id> prospectCollateralIds = new Set<Id>();
        for(LLC_BI__Account_Collateral__c own : prospectOwnerships){
            prospectCollateralIds.add(own.LLC_BI__Collateral__c);
        }

        for(LLC_BI__Account_Collateral__c own : coreOwnerships){
            if(prospectCollateralIds.contains(own.LLC_BI__Collateral__c)){
                deletes.add(own);
            }
        }

        return deletes;
    }
    
    private Boolean isNull(List<SObject> objs) {
        return String.valueOf(objs) == '()';
    }
}