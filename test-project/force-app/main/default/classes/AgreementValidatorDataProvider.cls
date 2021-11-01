public class AgreementValidatorDataProvider implements Agreements.IAgreementValidatorDataProvider {
    public void SaveAgreement(Agreement__c agreement) {
        update agreement;
    }
    
    public Agreement__c loadAgreementById(Id agreementId) {
    	return [
            SELECT
                Id,
                Name,
                RecordType.Name,
                RecordType.Id,
                RecordTypeId,
                Source_Agreement__c,
                Loan_Coordinator__c,
                Business_Loan_Agreement_Documents__c,
                Guarantee_Agreement_Documents__c,
                Subordination_Intercreditor_Documents__c,
                Loan_Documents_Prepared_By__c,
                Agreement_Date__c
            FROM Agreement__c
            WHERE Id =: agreementId
            ];
    }
    
    public List<Account> getEntitiesTiedToARBorrowingBaseComponent(Id agreementId) {
        List<Account> tiedEntities = new List<Account>();
        List<String> arComponents = new List<String>{'A/R < 120 Days','A/R < 90 Days','A/R < 60 Days','A/R < 30 Days'};
        Map<Id,Agreement_Borrowing_Base_Relationship__c> bbComponents  = New Map<Id,Agreement_Borrowing_Base_Relationship__c>(
            [
                SELECT
                    Id
                FROM
                    Agreement_Borrowing_Base_Relationship__c
                WHERE Agreement__c =: agreementId
                    AND Component__c in: arComponents
            ]);
        List<Agreement_Borrowing_Base_Entity_Rel__c> bbEntities = [
            SELECT
                Id,
                Entity__c
            FROM Agreement_Borrowing_Base_Entity_Rel__c
            WHERE Agreement_Related_Borrowing_Base__c in: bbComponents.keyset()
            ];

        for (Agreement_Borrowing_Base_Entity_Rel__c bbEntity : bbEntities) {
            tiedEntities.add(new Account(Id=bbEntity.Entity__c));
        }
        return tiedEntities;
    }
    
    public List<Agreement_Client_Relationships__c> getReportingRequirementsForEntityList(List<Account> entities, Id agreementId) {
        return [SELECT 
                    (SELECT
                        Id,
                        Name,
                        RecordTypeID,
                        Agreement_Client_Relationship__r.Entity__c,
                        Agreement_Client_Relationship__r.Name,
                        Agreement_Client_Relationship__c,
                        Frequency__c,
                        Include_In_Agreement__c,
                        Other_Type__c,
                        Period_Due__c,
                        Period_Due_Override__c 
                     FROM Agreement_Financial_Documents__r),
                Entity__c,
                Entity__r.Name,
                Entity__r.Entity_Name__c,
                Borrowing_Base_Certificate__c,
                Borrowing_Base_Certificate_Period_Due__c,
                Borrowing_Base_Frequency__c,
                A_P_Detailed_Agings__c,
                A_P_Detailed_Agings_Frequency__c,
                A_P_Detailed_Agings_Period_Due__c,
                Inventory_Report__c,
                Inventory_Report_Frequency__c,
                Inventory_Report_Period_Due__c,
                Brokerage_Statement__c,
                Brokerage_Statement_Frequency__c,
                Brokerage_Statement_Period_Due__c,
                Rent_Roll__c,
                Rent_Roll_Frequency__c,
                Rent_Roll_Period_Due__c,
                Compliance_Certificate__c,
                Compliance_Certificate_Frequency__c,
                Compliance_Certificate_Period_Due__c,
                Work_in_Process__c,
                Work_in_Process_Frequency__c,
                Work_In_Process_Period_Due__c,
                A_R_Detailed_Agings__c,
                Annual_Stmt_Days_Due_After_Fiscal_Y_E__c 
            FROM Agreement_Client_Relationships__c
            WHERE Entity__c in: entities
                AND Agreement__c =: agreementId
        ];
    }
    
    public List<Agreement_Client_Relationships__c> getAgreementEntityRels(Id agreementId) {
        return [SELECT 
		            (SELECT
                        Id,
                        Name,
                        RecordTypeID,
                        Agreement_Client_Relationship__r.Entity__c,
                        Agreement_Client_Relationship__r.Annual_Stmt_Days_Due_After_Fiscal_Y_E__c,
                        Agreement_Client_Relationship__r.Name,
                        Agreement_Client_Relationship__c,
                        Frequency__c,
                        Include_In_Agreement__c,
                        Other_Type__c,
                        Period_Due__c,
                        Period_Due_Override__c,
                        RecordTypeDescription__c,
                        Period_Due_Maximum__c 
                    FROM Agreement_Financial_Documents__r),
                    Agreement__r.Source_Agreement__c,
                    Entity__c,
                    Entity__r.Name,
                    Entity__r.Entity_Name__c,
                    Entity__r.Annual_Stmt_Days_Due_After_Fiscal_Y_E__c,
                    Entity__r.Annual_Financial_Statement_Period_Other__c,
                    Entity__r.Interim_Statements__c,
                    Entity__r.Interim_Stmt_Days_Due_After_Period_End__c,
                    Entity__r.Interim_Statement_Period_Other__c,
                    Entity__r.Tax_Return_Days_Due_After_Filing__c,
                    Entity__r.Tax_Return_Period_Other__c,
                    Entity__r.Pending_AFS_Days_Due_After_FYE__c,
                    Entity__r.Pending_AFS_Period_Other__c,
                    Entity__r.Pending_IntStmts_Days_Due_After_PE__c,
                    Entity__r.Pending_IntStmts_Period_Other__c,
                    Entity__r.Pending_TaxReturns_Days_Due_After_Filing__c,
                    Entity__r.Pending_TaxReturns_Period_Other__c,
                    Relationship__c,
                    Borrowing_Base_Certificate__c,
                    Borrowing_Base_Certificate_Period_Due__c,
                    Borrowing_Base_Frequency__c,
                    A_P_Detailed_Agings__c,
                    A_P_Detailed_Agings_Frequency__c,
                    A_P_Detailed_Agings_Period_Due__c,
                    Inventory_Report__c,
                    Inventory_Report_Frequency__c,
                    Inventory_Report_Period_Due__c,
                    Brokerage_Statement__c,
                    Brokerage_Statement_Frequency__c,
                    Brokerage_Statement_Period_Due__c,
                    Rent_Roll__c,
                    Rent_Roll_Frequency__c,
                    Rent_Roll_Period_Due__c,
                    Compliance_Certificate__c,
                    Compliance_Certificate_Frequency__c,
                    Compliance_Certificate_Period_Due__c,
                    Work_in_Process__c,
                    Work_in_Process_Frequency__c,
                    Work_In_Process_Period_Due__c,
                    Annual_Stmt_Days_Due_After_Fiscal_Y_E__c,
                    Interim_Statements__c,
                    Interim_Stmt_Days_Due_After_Period_End__c,
                    Tax_Return_Days_Due_After_Filing__c,
                    Annual_Financial_Statement_Period_Other__c,
                    Interim_Statement_Period_Other__c,
                    Tax_Return_Period_Other__c 
                FROM Agreement_Client_Relationships__c 
                WHERE Agreement__c =: agreementId
            ];
    }
    
    public List<Account> getEntitiesTiedToBorrowingBaseComponent(Id agreementId) {
        List<Account> tiedEntities = new List<Account>();
        Map<Id,Agreement_Borrowing_Base_Relationship__c> bbComponents = New Map<Id,Agreement_Borrowing_Base_Relationship__c>(
            [SELECT
                Id
             FROM Agreement_Borrowing_Base_Relationship__c
             WHERE Agreement__c =: agreementId]);
        List<Agreement_Borrowing_Base_Entity_Rel__c> bbEntities =
            [SELECT
                Id,
                Entity__c,
                Entity__r.Name,
                Entity__r.Entity_Name__c
             FROM Agreement_Borrowing_Base_Entity_Rel__c
             WHERE Agreement_Related_Borrowing_Base__c in: bbComponents.keyset()
            ];
        
        for (Agreement_Borrowing_Base_Entity_Rel__c bbEntity : bbEntities) {
            tiedEntities.add(bbEntity.Entity__r);
        }
        return tiedEntities;
    }
    
    public List<Agreement_Client_Relationships__c> getOtherAgreementEntitiesRels(List<Account> entities, Id agreementId, Id sourceAgmtId) {
        return [
            SELECT
                Entity__r.Id,
                Entity__r.Name,
                Entity__r.Entity_Name__c,
                Relationship__c
            FROM Agreement_Client_Relationships__c 
            WHERE Entity__c in: entities
                AND Agreement__c !=: agreementId
                AND Agreement__c !=: sourceAgmtId
                AND Agreement__r.RecordTypeDescription__c NOT IN('Archive','Pending')
        ];
    }
    
    public List<EB_Loan_Application__c> getEbLoanApplicationsNotRelatedToCurrentAgreement(Id agreementId, Id sourceAgmtId) {
        List<EB_Loan_Application__c> includedLoanApps =
            [SELECT
                Id,
                Name
             FROM EB_Loan_Application__c
             WHERE Id IN (
                SELECT
                    Loan_Application__c
                FROM Agreement_Loan_Application_Relationship__c
                WHERE Agreement__c =: agreementId)
            ];
        
        return [SELECT
                    Id,
                	Name
                FROM EB_Loan_Application__c 
                WHERE Id IN (
                    SELECT Loan_Application__c
                    FROM Agreement_Loan_Application_Relationship__c
                    WHERE Loan_Application__c IN: includedLoanApps
                    	AND Agreement__c !=: agreementId
                    	AND Agreement__c !=: sourceAgmtId
                        AND Agreement__r.RecordTypeDescription__c != 'Archive'
            )
        ];
    }
    
    public List<Agreements.EBAccountWrapper> getEbAccountsNotRelatedToCurrentAgreement(Id agreementId, Id sourceAgmtId) {
    	List<Agreements.EBAccountWrapper> returnValues = new List<Agreements.EBAccountWrapper>();
    	
        List<EB_Account__c> includedAccounts =
            [
                SELECT
                    Id,
                    Name
                FROM EB_Account__c
                WHERE Id IN (
                    SELECT Loan_Account__c From Agreement_EB_Account_Relationship__c
                    WHERE Agreement__c =: agreementId
                    AND Loan_Account__c != Null
                    AND Agreement__c != Null
                )
        ];
        
        if (includedAccounts != null) {
            List<Agreement_EB_Account_Relationship__c> otherRelationships = [
                         SELECT 
                            Id,
                            Name,
                            Loan_Account__c,
                            Loan_Account__r.Id,
                            Loan_Account__r.Name,
                            Agreement__r.Id, Agreement__r.Name
                         FROM Agreement_EB_Account_Relationship__c
                         WHERE Loan_Account__c IN: includedAccounts
                            AND Agreement__c !=: agreementId
                            AND Agreement__c !=: sourceAgmtId
                            AND Agreement__r.RecordType.Name IN ('Pending','Active')
                        ];
            Map<Id,EB_Account__c> accounts = new Map<Id,EB_Account__c>();
            for (Agreement_EB_Account_Relationship__c rel : otherRelationships) {
            	accounts.put(rel.Loan_Account__c,rel.Loan_Account__r);
            }
            for (EB_Account__c a : accounts.values()) {
            	Agreements.EBAccountWrapper ebW = new Agreements.EBAccountWrapper(a);
            	for (Agreement_EB_Account_Relationship__c aRel : otherRelationships) {
            		if(aRel.Loan_Account__c == a.Id) {
            			ebW.relatedAgreements.add(aRel.Agreement__r);
            		}
            	}
            	returnValues.add(ebW);
            }
        }
        return returnValues;
    }
    
    public List<Agreement_Loan_Application_Relationship__c> getLoanApplicationRelationshipsByAgreementId(Id agreementId) {
    	return [
            SELECT
                    Id,
                    Name,
                    Agreement__r.Loan_Coordinator__c,
                    Loan_Application__c,
                    Agreement__c
                FROM Agreement_Loan_Application_Relationship__c
                WHERE Agreement__c =: agreementId
            ];
    }
}