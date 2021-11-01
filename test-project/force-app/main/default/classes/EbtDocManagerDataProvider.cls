public class EbtDocManagerDataProvider implements EbtDocManager.IDataProvider {
    
    public List<LLC_BI__Document_Store_Index__c> getDocumentManagerLoanDocuments(Id loanId) {
        return [
            SELECT 
                Id, 
                LLC_BI__Document_Store__c, 
                LLC_BI__Document_Store__r.LLC_BI__External_Identifier__c 
            FROM 
                LLC_BI__Document_Store_Index__c
            WHERE 
                Id IN (
                    SELECT 
                        LLC_BI__Document_Store_Index__c
                    FROM 
                        LLC_BI__LLC_LoanDocument__c 
                    WHERE 
                        LLC_BI__Loan__c =: loanId
                )
        ];
    }

    public List<LLC_BI__Document_Store_Index__c> getDocumentManagerEntityDocuments(Id entityId) {
        return [
            SELECT 
                Id, 
                LLC_BI__Document_Store__c, 
                LLC_BI__Document_Store__r.LLC_BI__External_Identifier__c 
            FROM 
                LLC_BI__Document_Store_Index__c
            WHERE 
                Id IN (
                    SELECT 
                        LLC_BI__Document_Store_Index__c
                    FROM 
                        LLC_BI__AccountDocument__c 
                    WHERE 
                        LLC_BI__Account__c =: entityId
                )
        ];
    }

    public List<LLC_BI__Document_Store_Index__c> getDocumentManagerCollateralDocuments(Id collateralId) {
        return [
            SELECT 
                Id, 
                LLC_BI__Document_Store__c, 
                LLC_BI__Document_Store__r.LLC_BI__External_Identifier__c 
            FROM 
                LLC_BI__Document_Store_Index__c
            WHERE 
                Id IN (
                    SELECT 
                        LLC_BI__Document_Store_Index__c
                    FROM 
                        LLC_BI__Document_Placeholder__c 
                    WHERE 
                        LLC_BI__External_Id__c =: collateralId
                )
        ];
    }

    public List<LLC_BI__LLC_LoanDocument__c> getUnmatchedLoanDocuments(Id loanId){
        return [
            SELECT 
                LLC_BI__docType__c,
                LLC_BI__docTab__c,
                LLC_BI__docClass__r.LLC_BI__DocType__c,
                LLC_BI__docClass__r.LLC_BI__DocType__r.LLC_BI__docTab__c
            FROM 
                LLC_BI__LLC_LoanDocument__c 
            WHERE 
                LLC_BI__Loan__c =: loanId
                AND LLC_BI__docClass__c !=: null
                AND (
                    LLC_BI__docType__c =: null
                    OR LLC_BI__docTab__c =: null
                )
        ];
    }

    public void save(List<SObject> items) {
        if(items != null && items.size() > 0){
            List<SObject> inserts = new List<SObject>();
            List<SObject> updates = new List<SObject>();
            for(SObject o : items){
                if(String.isBlank(o.Id)) 
                    inserts.add(o);
                else
                    updates.add(o);
            }
            if(inserts.size() > 0) insert inserts;
            if(updates.size() > 0) update updates;
        }                    
    }

    public LLC_BI__Loan__c getLoan(Id loanId) {
        return [
            SELECT 
                Id, 
                LLC_BI__lookupKey__c 
            FROM 
                LLC_BI__Loan__c 
            WHERE 
                Id =: loanId 
            LIMIT 1
        ];
    }

    public Account getEntity(Id entityId) {
        return [
            SELECT 
                Id, 
                EB_Customer_Number__c,
                RecordType.Name
            FROM 
                Account 
            WHERE 
                Id =: entityId 
            LIMIT 1
        ];
    }

    public LLC_BI__Collateral__c getCollateral(Id collateralId) {
        return [
            SELECT 
                Id,
                Sync_Key__c
            FROM 
                LLC_BI__Collateral__c 
            WHERE 
                Id =: collateralId 
            LIMIT 1
        ];
    }

    public List<LLC_BI__DocManager__c> getDocumentManagers(){
        return [
            SELECT 
                Id,
                Name
            FROM 
                LLC_BI__DocManager__c 
        ];
    }

    public List<LLC_BI__DocClass__c> getDocumentManagerClasses(){
        return [
            SELECT 
                Id, 
                Name,
                LLC_BI__docManager__c, 
                LLC_BI__DocType__c, 
                LLC_BI__DocType__r.LLC_BI__docTab__c 
            FROM
                LLC_BI__DocClass__c
        ];
    }
}