public class AgreementEntityManager implements Agreements.IAgreementEntityManager{

    Agreements.IAgreementEntityManagerDataProvider m_dataProvider;

    public AgreementEntityManager(Agreements.IAgreementEntityManagerDataProvider dataProvider){
        m_dataProvider = dataProvider;
    }

    public void copyPendingFinancialReportingRequirementsToActive(Id agreementId){
        List<Account> relatedEntities = m_dataProvider.getRelatedEntitiesByAgreementId(agreementId);
        for(Account entity : relatedEntities){
            entity.Personal_Financial_Statement__c = entity.Pending_PFS__c;
            entity.Personal_Financial_Statement_Frequency__c = entity.Pending_PFS_Frequency__c;
            entity.Annual_Financial_Statements__c = entity.Pending_AFS__c;
            entity.Annual_Statement_Quality__c = entity.Pending_AFS_Quality__c;
            entity.Annual_Stmt_Days_Due_After_Fiscal_Y_E__c = entity.Pending_AFS_Days_Due_After_FYE__c;
            entity.Annual_Financial_Statement_Period_Other__c = entity.Pending_AFS_Period_Other__c;
            entity.Fiscal_Year_End_Date__c = entity.Pending_AFS_FYE__c;
            entity.Entities_To_Combine__c = entity.Pending_AFS_Entities_To_Combine__c;
            entity.Other_Type__c = entity.Pending_AFS_Other_Type__c;
            entity.Interim_Statements__c = entity.Pending_IntStmts__c;
            entity.Interim_Stm_Prepared_By__c = entity.Pending_IntStmts_Quality__c;
            entity.Interim_Stmt_Days_Due_After_Period_End__c = entity.Pending_IntStmts_Days_Due_After_PE__c;
            entity.Interim_Statement_Period_Other__c = entity.Pending_IntStmts_Period_Other__c;
            entity.Tax_Returns__c = entity.Pending_TaxReturns__c;
            entity.Tax_Return_Days_Due_After_Filing__c = entity.Pending_TaxReturns_Days_Due_After_Filing__c;
            entity.Tax_Return_Period_Other__c = entity.Pending_TaxReturns_Period_Other__c;
        }
        m_dataProvider.updateEntities(relatedEntities);
    }

    public void copyActiveFinancialReportingRequirementsToArchive(Id agreementId){
        List<Agreement_Client_Relationships__c> agreementEntities = m_dataProvider.getAgreementClientRelationshipsByAgreementId(agreementId);
        for(Agreement_Client_Relationships__c rel : agreementEntities){
            rel.Personal_Financial_Statement__c = rel.Entity__r.Personal_Financial_Statement__c;
            rel.Personal_Financial_Statement_Frequency__c = rel.Entity__r.Personal_Financial_Statement_Frequency__c;
            rel.Annual_Financial_Statements__c = rel.Entity__r.Annual_Financial_Statements__c;
            rel.Annual_Statement_Quality__c = rel.Entity__r.Annual_Statement_Quality__c;
            rel.Annual_Stmt_Days_Due_After_Fiscal_Y_E__c = rel.Entity__r.Annual_Stmt_Days_Due_After_Fiscal_Y_E__c;
            rel.Annual_Financial_Statement_Period_Other__c = rel.Entity__r.Annual_Financial_Statement_Period_Other__c;
            rel.Fiscal_Year_End_Date__c = rel.Entity__r.Fiscal_Year_End_Date__c;
            rel.Entities_To_Combine__c = rel.Entity__r.Entities_To_Combine__c;
            rel.Other_Type__c = rel.Entity__r.Other_Type__c;
            rel.Interim_Statements__c = rel.Entity__r.Interim_Statements__c;
            rel.Interim_Stm_Prepared_By__c = rel.Entity__r.Interim_Stm_Prepared_By__c;
            rel.Interim_Stmt_Days_Due_After_Period_End__c = rel.Entity__r.Interim_Stmt_Days_Due_After_Period_End__c;
            rel.Interim_Statement_Period_Other__c = rel.Entity__r.Interim_Statement_Period_Other__c;
            rel.Tax_Returns__c = rel.Entity__r.Tax_Returns__c;
            rel.Tax_Return_Days_Due_After_Filing__c = rel.Entity__r.Tax_Return_Days_Due_After_Filing__c;
            rel.Tax_Return_Period_Other__c = rel.Entity__r.Tax_Return_Period_Other__c;
        }
        m_dataProvider.updateAgreementClientRelationships(agreementEntities);
    }
}