public class AgreementControllerDataProvider implements Agreements.IAgreementControllerDataProvider{

    private final String DEFAULT_APP_COMMERCIAL_BOOKED = 'commercial-booked-ui.dashboard-commercial-booked-ui-loan';
    private final String DEFAULT_APP_CONSUMER_BOOKED = 'consumer-booked-ui.dashboard-consumer-booked-ui-loan';
    private final String DEFAULT_APP_CREDIT_BOOKED = 'credit-booked-ui.dashboard-credit-booked-ui-loan';
    private List<String> m_bookedDefaultApps;
    
    public AgreementControllerDataProvider() {
        m_bookedDefaultApps = new List<String>{DEFAULT_APP_COMMERCIAL_BOOKED, DEFAULT_APP_CONSUMER_BOOKED, DEFAULT_APP_CREDIT_BOOKED};
    }

    public Agreement__c getAgreementByID(Id agreementId){
        return [SELECT Id, Name, CreatedDate, CreatedBy.Name, LastModifiedDate, LastModifiedBy.Name
                      ,Borrower_Name__c, Borrower_Name__r.Entity_Name__c, Borrower_Summary__c, Loan_Summary__c, Related_Borrower__c, Included_Loans__c
                      ,Loan_App_Summary__c, RecordTypeId, ErrorMessages__c, WarningMessages__c, Agreement_Date__c
                      ,Included_Loan_Apps__c, Last_Amendment_Date__c, Comments__c, RecordTypeDescription__c
                      ,Loan_Coordinator__c, Credit_Analyst__c, DocumentationRep__c, Booking_Rep__c, Checkback_Rep__c
                      ,File_Review_Rep__c, Image_Prep_Rep__c, Shred_File_Rep__c, Stage__c,Stage__r.Name, Actual_Approval_Process__c
                      ,Approver_One__c, Approver_Two__c, Approver_Three__c, Source_Agreement__c, Replaced_By_Agreement__c
                      ,Business_Loan_Agreement_Documents__c ,Guarantee_Agreement_Documents__c,Subordination_Intercreditor_Documents__c
                      ,Loan_Documents_Prepared_By__c,Documentation_Path_Fx__c, RecordType.Name, Stage__r.Loan_App_Stage_Action_Controller__r.Name
                FROM Agreement__c WHERE id =: agreementId ];
    }

    public List<Agreement_Client_Relationships__c> getAgreementClientRelationshipsByAgreementId(Id agreementId){
        List<Agreement_Client_Relationships__c> returnList =
            [SELECT Id, Name, 
                    Entity__c, Entity__r.Name, Entity__r.Entity_Name__c, Entity__r.Annual_Financial_Statements__c, Entity__r.Annual_Statement_Quality__c, 
                    Entity__r.Annual_Stmt_Days_Due_After_Fiscal_Y_E__c, Entity__r.Other_Type__c, Entity__r.Entities_To_Combine__c, Entity__r.Tax_Returns__c, 
                    Entity__r.Tax_Return_Days_Due_After_Filing__c, Entity__r.Interim_Statements__c, 
                    Entity__r.Interim_Stm_Prepared_By__c, Entity__r.Interim_Stmt_Days_Due_After_Period_End__c, 
                    Entity__r.Personal_Financial_Statement__c, Entity__r.Personal_Financial_Statement_Frequency__c,  
                    Entity__r.Annual_Financial_Statement_Period_Other__c, Entity__r.Interim_Statement_Period_Other__c, Entity__r.Tax_Return_Period_Other__c,                       
                    Entity__r.Pending_PFS__c, Entity__r.Pending_PFS_Frequency__c, Entity__r.Pending_AFS__c, Entity__r.Pending_AFS_Quality__c,
                    Entity__r.Pending_AFS_FYE__c, Entity__r.Pending_AFS_Days_Due_After_FYE__c, Entity__r.Pending_AFS_Period_Other__c, Entity__r.Pending_AFS_Other_Type__c,
                    Entity__r.Pending_AFS_Entities_To_Combine__c, Entity__r.Pending_IntStmts__c, Entity__r.Pending_IntStmts_Quality__c, Entity__r.Pending_IntStmts_Days_Due_After_PE__c,
                    Entity__r.Pending_IntStmts_Period_Other__c, Entity__r.Pending_TaxReturns__c, Entity__r.Pending_TaxReturns_Days_Due_After_Filing__c, Entity__r.Pending_TaxReturns_Period_Other__c,
                    Relationship__c, Agreement__c, Agreement__r.Name, Agreement__r.RecordTypeId, 
                    Borrower_Name__c, Tax_Returns__c, Tax_Return_Days_Due_After_Filing__c, Annual_Financial_Statements__c, 
                    Annual_Statement_Quality__c, Annual_Stmt_Days_Due_After_Fiscal_Y_E__c, Other_Type__c, Entities_To_Combine__c, Personal_Financial_Statement__c, 
                    Personal_Financial_Statement_Frequency__c, Interim_Statements__c, Interim_Stm_Prepared_By__c, 
                    Interim_Stmt_Days_Due_After_Period_End__c, Annual_Financial_Statement_Period_Other__c, Interim_Statement_Period_Other__c, Tax_Return_Period_Other__c
            FROM Agreement_Client_Relationships__c 
            WHERE Agreement__c =: agreementId AND Entity__r.Id != NULL];
        return (returnList != null) ? returnList : new List<Agreement_Client_Relationships__c>();
    }

    public List<Agreement_Financial_Documents__c> getAgreementFinancialDocumentsByAgreementId(Id agreementId){
        List<Agreement_Financial_Documents__c> returnList =
            [SELECT Id, Name, Agreement_Client_Relationship__c, Frequency__c, Include_In_Agreement__c, Other_Type__c, 
                    Period_Due__c, Period_Due_Label__c, Period_Due_Override__c, Start_Date__c, RecordTypeDescription__c, Agreement_Client_Relationship__r.Entity__c, Requirement_Summary__c,
                    Agreement_Client_Relationship__r.Entity__r.Entity_Name__c
            FROM Agreement_Financial_Documents__c 
            WHERE Agreement__c =: agreementId
            ORDER BY RecordTypeDescription__c, Agreement_Client_Relationship__r.Entity__c];
        return (returnList != null) ? returnList : new List<Agreement_Financial_Documents__c>();
    }

    public List<Account> getRelatedEntitiesWithClientRelationshipsByAgreementId(Id agreementId){
        List<Account> returnList =
            [SELECT Id, Name, Entity_Name__c,
                    (SELECT Id, Agreement__c, Agreement__r.Name, Relationship__c, Agreement__r.RecordTypeDescription__c, Primary_Sort_Order__c, CreatedDate 
                    FROM Agreement_To_Loan_Relations__r) 
            FROM Account 
            WHERE Id IN (SELECT Entity__c FROM Agreement_Client_Relationships__c WHERE Agreement__c=:agreementId)];
        return (returnList != null) ? returnList : new List<Account>();
    }

    public List<EB_Account_Relationship__c> getEbAccountRelationships(List<EB_Account__c> ebAccountsIncludedOnAgreement, Set<Id> entitiesIncludedOnAgreement){
        List<EB_Account_Relationship__c> returnList =
            [SELECT Client_Id__c, Name, 
                    EB_Account_Id__r.Id, EB_Account_Id__r.Name, EB_Account_Id__r.Account_Status__c,
                    Client_Id__r.Id, Client_Id__r.Name, Client_Id__r.Entity_Name__c, Client_Id__r.BillingStreet, 
                    Client_Id__r.BillingCity, Client_Id__r.BillingState, Client_Id__r.BillingPostalCode, 
                    Client_Id__r.Record_Type_Description__c
            FROM  EB_Account_Relationship__c 
            WHERE EB_Account_Id__c IN: ebAccountsIncludedOnAgreement 
            AND Client_Id__c NOT IN: entitiesIncludedOnAgreement];
        return (returnList != null) ? returnList : new List<EB_Account_Relationship__c>();
    }

    public List<EB_Loan_App_Entity_Relationship__c> getLoanApplicationRelationships(List<EB_Loan_Application__c> loanAppsIncludedOnAgreement, Set<Id> entitiesIncludedOnAgreement){
        List<EB_Loan_App_Entity_Relationship__c> returnList =
            [SELECT Id, Name, Entity_Name__c,
                    Loan_Application_ID__r.Name,
                    Entity_Name__r.Id, Entity_Name__r.Name, Entity_Name__r.Entity_Name__c, Entity_Name__r.BillingStreet, 
                    Entity_Name__r.BillingCity, Entity_Name__r.BillingState, Entity_Name__r.BillingPostalCode, 
                    Entity_Name__r.Record_Type_Description__c
             FROM EB_Loan_App_Entity_Relationship__c 
             WHERE Loan_Application_ID__c IN: loanAppsIncludedOnAgreement 
             AND Entity_Name__c NOT IN: entitiesIncludedOnAgreement];
        return (returnList != null) ? returnList : new List<EB_Loan_App_Entity_Relationship__c>();
    }

    public List<Agreement_EB_Account_Relationship__c> getIncludedEbAccountRelationshipsByAgreementId(Id agreementId){
        List<Agreement_EB_Account_Relationship__c> returnList =
            [SELECT Loan_Account__r.Id, Loan_Account__r.Name, Loan_Account__r.Account_status__c, Loan_Account__r.Account_Line_1__c, Loan_Account__r.Core_Current_Balance__c
            FROM Agreement_EB_Account_Relationship__c 
            WHERE Agreement__c =: agreementId];
        return (returnList != null) ? returnList : new List<Agreement_EB_Account_Relationship__c>();
    }

    public List<Agreement_LLC_BI_Loan_Relationship__c> getIncludedLlcBiLoanRelationshipsByAgreementId(Id agreementId){
        return [
            SELECT
                LLCBI_Loan__r.Id,
                LLCBI_Loan__r.Name,
                LLCBI_Loan__r.LLC_BI__Account__r.Id,
                LLCBI_Loan__r.LLC_BI__Account__r.Name,
                LLCBI_Loan__r.LLC_BI__Product_Package__r.Name,
                LLCBI_Loan__r.LLC_BI__Amount__c
            FROM
                Agreement_LLC_BI_Loan_Relationship__c
            WHERE
                Agreement__c =: agreementId
                AND LLCBI_Loan__r.LLC_BI__Default_App__c NOT IN: m_bookedDefaultApps
        ];
    }

    public List<EB_Account__c> getExcludedEbAccounts(Set<Id> entitiesIncludedOnAgreement, List<EB_Account__c> ebAccountsIncludedOnAgreement){
        List<EB_Account_Relationship__c> ebAccountEntities = 
            [SELECT EB_Account_Id__c
            FROM EB_Account_Relationship__c
            WHERE Client_Id__c IN: entitiesIncludedOnAgreement
            AND EB_Account_Id__c NOT IN: ebAccountsIncludedOnAgreement];
                
        Set<Id>potentialAccounts = new Set<Id>();
        for(EB_Account_Relationship__c rel : ebAccountEntities){
            potentialAccounts.add(rel.EB_Account_Id__c);
        }
        List<EB_Account__c> returnList =
            [SELECT Id, Name, Account_Line_1__c, Core_Current_Balance__c
            FROM EB_Account__c
            WHERE Id IN: potentialAccounts
            AND Account_Status__c NOT IN ('C','R','P')
            AND Application__c IN (11,13,15)];
        return (returnList != null) ? returnList : new List<EB_Account__c>();
    }

    public List<Agreement_Loan_Application_Relationship__c> getIncludedLoanAppRelationshipsByAgreementId(Id agreementId){
        List<Agreement_Loan_Application_Relationship__c> returnList = [
            SELECT
                Loan_Application__c,
                Loan_Application__r.Name,
                Loan_Application__r.EB_Loan_Packet__r.Name,
                Loan_Application__r.EB_Loan_Packet__r.Lead_Entity__r.Name,
                Loan_Application__r.Total_Loan_Amount__c,
                Loan_Application__r.Application_Stage__r.Name                
            FROM 
                Agreement_Loan_Application_Relationship__c 
            WHERE 
                Agreement__c =: agreementId
        ];

        return (returnList != null) ? returnList : new List<Agreement_Loan_Application_Relationship__c>();
    }

    public List<EB_Loan_Application__c> getExcludedLoanApps(Set<Id> entitiesIncludedOnAgreement, List<EB_Loan_Application__c> loanAppsIncludedOnAgreement){
        List<EB_Loan_App_Entity_Relationship__c> loanAppEntities = 
            [SELECT Loan_Application_ID__c 
            FROM EB_Loan_App_Entity_Relationship__c 
            WHERE Entity_Name__c IN:entitiesIncludedOnAgreement 
            AND Loan_Application_ID__c NOT IN:loanAppsIncludedOnAgreement];
        Set<Id> potentialApps = new Set<Id>();
        for(EB_Loan_App_Entity_Relationship__c rel : loanAppEntities){
            potentialApps.add(rel.Loan_Application_ID__c);
        }
        List<EB_Loan_Application__c> returnList =
            [SELECT Id, Name, EB_Loan_Packet__c, EB_Loan_Packet__r.Name, EB_Loan_Packet__r.Lead_Entity__c, Lead_Entity__c, Lead_Entity_With_Link__c, Total_Loan_Amount__c, Application_Stage__r.Name 
            FROM EB_Loan_Application__c 
            WHERE Id IN:potentialApps AND Application_Stage__r.Name <> 'Archived'];
        return (returnList != null) ? returnList : new List<EB_Loan_Application__c>();
    }

    public void save(SObject so){
        if(String.isBlank(so.Id)){
            insert so;
        }else{
            update so;
        }
    }

    public Agreement_Loan_Application_Relationship__c findAgreementLoanApplicationRelationship(Id agreementId, Id loanAppId){
        return [SELECT
                    Id
                FROM
                    Agreement_Loan_Application_Relationship__c
                WHERE
                    Agreement__c =: agreementId
                    AND Loan_Application__c =: loanAppId
                    AND Agreement__c != null
                    AND Loan_Application__c != null
                    AND Agreement__c != ''
                    AND Loan_Application__c != ''
                LIMIT 1
                ];
    }

    public Agreement_LLC_BI_Loan_Relationship__c findAgreementLlcBiLoanRelationship(Id agreementId, Id loanAppId){
        return [SELECT
                    Id
                FROM
                    Agreement_LLC_BI_Loan_Relationship__c
                WHERE
                    Agreement__c =: agreementId
                    AND LLCBI_Loan__c =: loanAppId
                    AND Agreement__c != null
                    AND LLCBI_Loan__c != null
                    AND Agreement__c != ''
                    AND LLCBI_Loan__c != ''                       
                LIMIT 1
                ];
    }

    public void remove(SObject so){
        delete so;
    }

    public List<EB_Loan_App_Entity_Relationship__c> getEntityLoanAppRelationshipsByEntityIds(Set<Id> entityIds){
        return [
            SELECT
                Loan_Application_ID__c,
                Loan_Application_ID__r.Name,
                Loan_Application_ID__r.EB_Loan_Packet__r.Name,
                Loan_Application_ID__r.EB_Loan_Packet__r.Lead_Entity__r.Name,
                Loan_Application_ID__r.Total_Loan_Amount__c,
                Loan_Application_ID__r.Application_Stage__r.Name,
                Entity_Name__r.Id
            FROM 
                EB_Loan_App_Entity_Relationship__c 
            WHERE 
                Entity_Name__c IN: entityIds
        ];
    }

    public List<EB_Loan_App_Entity_Relationship__c> getEntityLoanAppRelationshipsByAppIds(Set<Id> appIds){
        return [
            SELECT 
                Loan_Application_ID__c,
                Loan_Application_ID__r.Name,
                Loan_Application_ID__r.EB_Loan_Packet__r.Name,
                Loan_Application_ID__r.EB_Loan_Packet__r.Lead_Entity__r.Name,
                Loan_Application_ID__r.Total_Loan_Amount__c,
                Loan_Application_ID__r.Application_Stage__r.Name,
                Entity_Name__r.Id,
                Entity_Name__r.Entity_Name__c,
                Entity_Name__r.Record_Type_Description__c,
                Entity_Name__r.BillingStreet, 
                Entity_Name__r.BillingCity, 
                Entity_Name__r.BillingState, 
                Entity_Name__r.BillingPostalCode
            FROM 
                EB_Loan_App_Entity_Relationship__c 
            WHERE 
                Loan_Application_ID__c IN: appIds
        ];
    }

    public List<LLC_BI__Legal_Entities__c> getLlcBiEntityInvolvementsByEntityIds(Set<Id> entityIds){
        return [
            SELECT
                LLC_BI__Loan__c,
                LLC_BI__Loan__r.Name,
                LLC_BI__Loan__r.LLC_BI__Account__r.Id,
                LLC_BI__Loan__r.LLC_BI__Account__r.Name,
                LLC_BI__Loan__r.LLC_BI__Product_Package__r.Name,
                LLC_BI__Loan__r.LLC_BI__Amount__c,
                LLC_BI__Account__r.Id
            FROM
                LLC_BI__Legal_Entities__c
            WHERE
                LLC_BI__Account__c IN: entityIds
                AND LLC_BI__Loan__r.LLC_BI__Default_App__c NOT IN: m_bookedDefaultApps
        ];
    }

    public List<LLC_BI__Legal_Entities__c> getLlcBiEntityInvolvementsByAppIds(Set<Id> appIds){
        return [
            SELECT 
                LLC_BI__Loan__c,
                LLC_BI__Loan__r.Name,
                LLC_BI__Loan__r.LLC_BI__Account__r.Id,
                LLC_BI__Loan__r.LLC_BI__Account__r.Name,
                LLC_BI__Loan__r.LLC_BI__Product_Package__r.Name,
                LLC_BI__Loan__r.LLC_BI__Amount__c,
                LLC_BI__Account__r.Id,
                LLC_BI__Account__r.Entity_Name__c,
                LLC_BI__Account__r.Record_Type_Description__c,
                LLC_BI__Account__r.BillingStreet, 
                LLC_BI__Account__r.BillingCity, 
                LLC_BI__Account__r.BillingState, 
                LLC_BI__Account__r.BillingPostalCode
            FROM 
                LLC_BI__Legal_Entities__c 
            WHERE 
                LLC_BI__Loan__c IN: appIds
                AND LLC_BI__Loan__r.LLC_BI__Default_App__c NOT IN: m_bookedDefaultApps
        ];
    }

    public List<LLC_BI__LoanRenewal__c> getRenewalModParentLoanRelationships(Set<Id> loanIds){
         return [
            SELECT
                  Id
                , LLC_BI__ParentLoanId__c
                , LLC_BI__RenewalLoanId__c
            FROM
                LLC_BI__LoanRenewal__c
            WHERE
                LLC_BI__RenewalLoanId__c IN: loanIds
        ];
    }
}