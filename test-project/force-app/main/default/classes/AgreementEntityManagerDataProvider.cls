public class AgreementEntityManagerDataProvider implements Agreements.IAgreementEntityManagerDataProvider{
	public List<Account> getRelatedEntitiesByAgreementId(Id agreementId){
		List<Account> relatedEntities =
			[SELECT
				Annual_Financial_Statement_Period_Other__c, Annual_Financial_Statements__c, Annual_Statement_Quality__c, 
				Annual_Stmt_Days_Due_After_Fiscal_Y_E__c, Entities_To_Combine__c, Fiscal_Year_End_Date__c, 
				Interim_Statement_Period_Other__c, Interim_Statements__c, Interim_Stm_Prepared_By__c, Interim_Stmt_Days_Due_After_Period_End__c, 
				Other_Type__c, Pending_AFS__c, Pending_AFS_Days_Due_After_FYE__c, Pending_AFS_Entities_To_Combine__c, Pending_AFS_FYE__c, 
				Pending_AFS_Other_Type__c, Pending_AFS_Period_Other__c, Pending_AFS_Quality__c, Pending_IntStmts__c, Pending_IntStmts_Days_Due_After_PE__c, 
				Pending_IntStmts_Period_Other__c, Pending_IntStmts_Quality__c, Pending_PFS__c, Pending_PFS_Frequency__c, 
				Pending_TaxReturns__c, Pending_TaxReturns_Days_Due_After_Filing__c, Pending_TaxReturns_Period_Other__c, 
				Personal_Financial_Statement__c, Personal_Financial_Statement_Frequency__c, 
				Tax_Return_Days_Due_After_Filing__c, Tax_Return_Period_Other__c, Tax_Returns__c
			FROM Account
			WHERE Id IN (SELECT Entity__c FROM Agreement_Client_Relationships__c WHERE Agreement__c =: agreementId)];
		return (relatedEntities != null) ? relatedEntities : new List<Account>();
	}

	public List<Agreement_Client_Relationships__c> getAgreementClientRelationshipsByAgreementId(Id agreementId){
		List<Agreement_Client_Relationships__c> agreementClientRels =
			[SELECT 
				Annual_Financial_Statement_Period_Other__c, Annual_Financial_Statements__c, Annual_Statement_Quality__c, 
				Annual_Stmt_Days_Due_After_Fiscal_Y_E__c, Entities_To_Combine__c, Entity__r.Annual_Financial_Statement_Period_Other__c, 
				Entity__r.Annual_Financial_Statements__c, Entity__r.Annual_Statement_Quality__c, Entity__r.Annual_Stmt_Days_Due_After_Fiscal_Y_E__c, 
				Entity__r.Entities_To_Combine__c, Entity__r.Fiscal_Year_End_Date__c, Entity__r.Interim_Statement_Period_Other__c, 
				Entity__r.Interim_Statements__c, Entity__r.Interim_Stm_Prepared_By__c, Entity__r.Interim_Stmt_Days_Due_After_Period_End__c, 
				Entity__r.Other_Type__c, Entity__r.Personal_Financial_Statement__c, Entity__r.Personal_Financial_Statement_Frequency__c, 
				Entity__r.Tax_Return_Days_Due_After_Filing__c, Entity__r.Tax_Return_Period_Other__c, Entity__r.Tax_Returns__c, Fiscal_Year_End_Date__c, Interim_Statement_Period_Other__c, 
				Interim_Statements__c, Interim_Stm_Prepared_By__c, Interim_Stmt_Days_Due_After_Period_End__c, Other_Type__c, Personal_Financial_Statement__c, 
				Personal_Financial_Statement_Frequency__c, Tax_Return_Days_Due_After_Filing__c, Tax_Return_Period_Other__c, Tax_Returns__c
			FROM Agreement_Client_Relationships__c 
			WHERE Agreement__c =: agreementId];
		return (agreementClientRels != null) ? agreementClientRels : new List<Agreement_Client_Relationships__c>();
	}

	public void updateEntities(List<Account> entities){
		update entities;
	}

	public void updateAgreementClientRelationships(List<Agreement_Client_Relationships__c> agreementClients){
		update agreementClients;
	}
}