public class LoanArchiveDataProvider implements LoanArchive.IDataProvider {

    public void save(List<SObject> objects){       
        save(groupBySObjectType(objects));        
    }
    
    public void remove(List<SObject> objects){
        delete objects;
    }

    public void merges(List<LoanArchive.MergeRequest> objects){

        for(LoanArchive.MergeRequest obj : objects){

            if(obj.prospect.Id.getSObjectType() == Account.SObjectType){
                Account prospect = (Account)obj.prospect;
                Account core = (Account)obj.core;

                merge prospect core;
            }
        }
    }

    public Savepoint setSavepoint(){
        return Database.setSavepoint();
    }

    public void rollback(Savepoint sp){
        Database.rollback(sp);
    }
    
    public LLC_BI__Loan__c getLoanForVm(Id loanId){
        return [
            SELECT 
                Id, 
                Name, 
                (
                    SELECT 
                        Description__c,
                        LLC_BI__Collateral__r.Id,
                        LLC_BI__Collateral__r.Name,                     
                        LLC_BI__Collateral__r.LLC_BI__Collateral_Name__c,
                        LLC_BI__Collateral__r.LLC_BI__Collateral_Type__r.Name,
                        LLC_BI__Collateral__r.Sync_Key__c,
                        LLC_BI__Collateral__r.LLC_BI__Description__c,
                        LLC_BI__Collateral__r.CreatedDate,
                        LLC_BI__Collateral__r.Primary_Owner__r.Name,
                        LLC_BI__Collateral__r.Primary_Owner__r.EB_Client_Name__c
                    FROM 
                        LLC_BI__Loan_Collateral__r
                    ORDER BY
                        LLC_BI__Collateral__r.LLC_BI__Collateral_Name__c
                ),
                (
                    SELECT
                        LLC_BI__Account__r.Id,
                        LLC_BI__Account__r.Name,
                        LLC_BI__Account__r.Entity_Name__c,
                        LLC_BI__Account__r.EB_Client_Name__c,
                        LLC_BI__Account__r.RecordType.Name,
                        LLC_BI__Account__r.CreatedDate
                    FROM
                        LLC_BI__Legal_Entities__r
                    ORDER BY
                        LLC_BI__Account__r.Entity_Name__c
                )
            FROM 
                LLC_BI__Loan__c 
            WHERE 
                Id=:loanId
        ];
    }
    
    public List<LLC_BI__Collateral__c> getSObjectsForCollateralMerge(List<Id> collateralIds){
        return [
            SELECT
                Id,
                Name,
                Sync_Key__c,
                LLC_BI__Collateral_Name__c,
                (
                    SELECT
                        Id,
                        Description__c,
                        LLC_BI__Loan__c,
                        LLC_BI__Collateral__c,
                        LLC_BI__Collateral__r.Name,
                        LLC_BI__Collateral__r.LLC_BI__Description__c,
                        LLC_BI__Collateral__r.LLC_BI__Collateral_Name__c,
                        LLC_BI__Collateral__r.LLC_BI__Collateral_Type__r.Name
                    FROM 
                        LLC_BI__Loan_Collateral2__r
                ),
                (
                    SELECT
                        Id,
                        LLC_BI__Account__c,
                        LLC_BI__Collateral__c
                    FROM
                        LLC_BI__Account_Collateral__r
                )
            FROM
                LLC_BI__Collateral__c
            WHERE
                Id IN: collateralIds
        ];
    }
    public List<LLC_BI__Document_Placeholder__c> getCollateralDocumentsForMerge(List<Id> collateralIds){
        return [SELECT 
                    Id,
                    LLC_BI__DocManager__c,
                    LLC_BI__DocType__c,
                    LLC_BI__DocTab__c,
                    LLC_BI__Document_Store_Index__c,
                    LLC_BI__External_Id__c
                FROM 
                    LLC_BI__Document_Placeholder__c
                WHERE
                    LLC_BI__External_Id__c IN: collateralIds
                ];
    }   
    
    public List<Account> getSObjectsForEntityMerge(List<Id> entityIds){
        return [
            SELECT
                Id,
                Name,
                RecordTypeId,
                EB_Client_Name__c,
                EB_Customer_Number__c,
                WM_Key__c,
                BillingStreet,
                BillingCity,
                BillingState,
                BillingPostalCode,
                Phone,
                SSNTIN_Encrypted__c,
                SSN_TIN_Has_Value__c,
                (
                    SELECT
                        Id,
                        LLC_BI__Account__c,
                        LLC_BI__Collateral__c
                    FROM
                        LLC_BI__Account_Collateral__r
                ),
                (
                    SELECT
                        Id,
                        LLC_BI__Loan__c,
                        LLC_BI__Account__c,
                        LLC_BI__Account__r.RecordType.Name
                    FROM
                        LLC_BI__Legal_Entities__r
                ),                
                (
                    SELECT
                        Id,
                        LLC_BI__Account__c
                    FROM
                        LLC_BI__Loans__r
                ),
                (
                    SELECT
                        Id,
                        Client_Id__c
                    FROM
                        EB_Account_Relationships__r
                ),
                (
                    SELECT
                        Id,
                        Client_ID__c
                    FROM
                        EB_Collateral_Client_Relationships__r
                ),
                (
                    SELECT
                        Id,
                        Primary_Owner_Id__c
                    FROM
                        EB_Accounts__r
                ),
                (
                    SELECT
                        Id,
                        Collateral_Owner__c
                    FROM
                        Collateral__r
                )

            FROM
                Account
            WHERE
                Id IN: entityIds
        ];
    }

    public List<SObject> getSObjectsForEbCollateralMerge(List<Id> collateralIds){
        List<LLC_BI__Collateral__c> collateral = [
            SELECT
                Id,
                Name,
                Sync_Key__c,
                LLC_BI__Collateral_Name__c
            FROM
                LLC_BI__Collateral__c
            WHERE
                Id IN: collateralIds
        ];

        Set<String> collateralNames = new Set<String>();
        Set<String> collateralSyncKeys = new Set<String>();
        for(LLC_BI__Collateral__c c : collateral){
            collateralNames.add(c.Name);
            collateralSyncKeys.add(c.Sync_Key__c);
        }

        List<EB_Collateral__c> ebCollateral = [
            SELECT
                Id,
                Name,
                Key__c,
                Status__c
            FROM
                EB_Collateral__c
            WHERE
                Name IN: collateralNames
                OR Key__c IN: collateralSyncKeys 
        ];

        List<SObject> sobjects = new List<SObject>();
        sobjects.addAll((List<SObject>)collateral);
        sobjects.addAll((List<SObject>)ebCollateral);
        return sobjects;
    }

    public List<LLC_BI__Loan__c> getSObjectsForLoanMerge(List<Id> loanIds){
        return [
            SELECT
                Id,
                Name,
                LLC_BI__lookupKey__c,
                (
                    SELECT
                        Id,
                        Agreement__c,
                        LLCBI_Loan__c
                    FROM
                        Agreement_LLC_BI_Loan_Relationships__r
                ),
                (
                    SELECT
                        LLC_BI__Account__r.Id,
                        LLC_BI__Account__r.Name,
                        LLC_BI__Account__r.Entity_Name__c,
                        LLC_BI__Account__r.EB_Client_Name__c,
                        LLC_BI__Account__r.RecordType.Name,
                        LLC_BI__Account__r.CreatedDate
                    FROM
                        LLC_BI__Legal_Entities__r
                    ORDER BY
                        LLC_BI__Account__r.Entity_Name__c
                )
            FROM
                LLC_BI__Loan__c
            WHERE
                Id IN: loanIds
        ];
    }

    public EB_Account__c findEbAcctTwin(LLC_BI__Loan__c llcBiLoan){
        return [
            SELECT
                Id,
                Key__c
            FROM
                EB_Account__c
            WHERE
                Key__c =: llcBiLoan.LLC_BI__lookupKey__c
            LIMIT 1
        ];
    }

    public List<EB_Account__c> findEbAcctTwins(List<String> llcBiLoanLookupKeys){
        return [
            SELECT
                Id,
                Key__c
            FROM
                EB_Account__c
            WHERE
                Key__c IN: llcBiLoanLookupKeys
        ];
    }

    private void save(Map<Schema.SObjectType, List<Sobject>> grouped){
        for(Schema.SObjectType key : grouped.keySet()){
            List<Sobject> groupedList = grouped.get(key);
            saveGroupedSObjects(groupedList);
        }
    }

    private Map<Schema.SObjectType, List<Sobject>> groupBySObjectType(List<SObject> objects){
        Map<Schema.SObjectType, List<SObject>> grouped = new Map<Schema.SObjectType, List<SObject>>();

        for (SObject obj : objects) {
            Schema.SObjectType objType = obj.getSObjectType();

            if (!grouped.containsKey(objType)) {
                grouped.put(objType, new List<SObject>());
            }

            grouped.get(objType).add(obj);
        }

        return grouped;
    }

    private void saveGroupedSObjects(List<SObject> objects){
        if(objects != null && objects.size() > 0){
            List<SObject> inserts = new List<SObject>();
            Map<Id,SObject> updates = new Map<Id,SObject>();
            for(SObject o : objects){
                if(String.isBlank(o.Id)) 
                    inserts.add(o);
                else
                    updates.put(o.Id, o);
            }
            if(inserts.size() > 0) insert inserts;
            if(updates.size() > 0) update updates.values();
        } 
    }
}