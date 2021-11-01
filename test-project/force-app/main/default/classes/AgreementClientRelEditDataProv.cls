public class AgreementClientRelEditDataProv Implements Agreements.IAgreementClientRelationshipEditDataProvider{

	public Agreement_Client_Relationships__c getAgreementClientRelationshipById(Id agreementClientRelationshipId){
		return [SELECT Id, Name, Entity__c, Entity__r.Id, Entity__r.Name, Entity__r.Entity_Name__c, Entity__r.Annual_Financial_Statements__c, Entity__r.Annual_Statement_Quality__c, 
							Entity__r.Annual_Stmt_Days_Due_After_Fiscal_Y_E__c, Entity__r.Other_Type__c, Entity__r.Tax_Returns__c, 
							Entity__r.Tax_Return_Days_Due_After_Filing__c, Entity__r.Interim_Statements__c, 
							Entity__r.Interim_Stm_Prepared_By__c, Entity__r.Interim_Stmt_Days_Due_After_Period_End__c, Entity__r.Fiscal_Year_End_Date__c,
							Entity__r.Personal_Financial_Statement__c, Entity__r.Personal_Financial_Statement_Frequency__c,Entity__r.Entities_To_Combine__c,
							Entity__r.Annual_Financial_Statement_Period_Other__c, Entity__r.Interim_Statement_Period_Other__c, Entity__r.Tax_Return_Period_Other__c,                       
							Entity__r.Pending_PFS__c, Entity__r.Pending_PFS_Frequency__c, Entity__r.Pending_AFS__c, Entity__r.Pending_AFS_Quality__c,
							Entity__r.Pending_AFS_FYE__c, Entity__r.Pending_AFS_Days_Due_After_FYE__c, Entity__r.Pending_AFS_Period_Other__c, Entity__r.Pending_AFS_Other_Type__c,
							Entity__r.Pending_AFS_Entities_To_Combine__c, Entity__r.Pending_IntStmts__c, Entity__r.Pending_IntStmts_Quality__c, Entity__r.Pending_IntStmts_Days_Due_After_PE__c,
							Entity__r.Pending_IntStmts_Period_Other__c, Entity__r.Pending_TaxReturns__c, Entity__r.Pending_TaxReturns_Days_Due_After_Filing__c, Entity__r.Pending_TaxReturns_Period_Other__c,
							Relationship__c, Agreement__c, Agreement__r.Name, Agreement__r.RecordTypeId, Agreement__r.Stage__r.Name,Agreement__r.Stage__c,
							Borrower_Name__c, Tax_Returns__c, Tax_Return_Days_Due_After_Filing__c, Annual_Financial_Statements__c, 
							Annual_Statement_Quality__c, Annual_Stmt_Days_Due_After_Fiscal_Y_E__c, Other_Type__c, Personal_Financial_Statement__c, 
							Personal_Financial_Statement_Frequency__c, Interim_Statements__c, Interim_Stm_Prepared_By__c, Entities_To_Combine__c,
							Interim_Stmt_Days_Due_After_Period_End__c, Annual_Financial_Statement_Period_Other__c, Interim_Statement_Period_Other__c, Tax_Return_Period_Other__c, Fiscal_Year_End_Date__c
						FROM Agreement_Client_Relationships__c 
						WHERE id =: agreementClientRelationshipId];
	}

	public Agreement__c getAgreementById(Id agreementId){
		return [SELECT id, Name, RecordType.Name, Stage__r.Name, RecordTypeId, Stage__r.Loan_App_Stage_Action_Controller__r.Name
						FROM Agreement__c 
						WHERE id =: agreementId];
	}

	public List<Agreement_Financial_Documents__c> getAgreementFinancialDocumentsFilteredByRecordType(ID agreementClientRelationshipID, Set<ID> recordTypeIDSet){
		List<Agreement_Financial_Documents__c> FinDocs = 
				[SELECT Id, Name, Agreement_Client_Relationship__c, Frequency__c, Include_In_Agreement__c, Other_Type__c, Period_Due__c, Period_Due_Label__c, 
								Period_Due_Override__c, RecordTypeId, Start_Date__c 
				 FROM Agreement_Financial_Documents__c 
				 WHERE Agreement_Client_Relationship__c =: agreementClientRelationshipID AND RecordTypeId IN: recordTypeIDSet];
		return (FinDocs != null) ? FinDocs : new List<Agreement_Financial_Documents__c>();
	}

	public List<Agreement_Financial_Documents__c> getAgreementFinancialDocuments(ID agreementClientRelationshipID){
		List<Agreement_Financial_Documents__c> FinDocs = 
				[SELECT Id, Name, Agreement_Client_Relationship__c, Frequency__c, Include_In_Agreement__c, Other_Type__c, Period_Due__c, Period_Due_Label__c, 
						Period_Due_Override__c, Start_Date__c, RecordTypeId 
				 FROM Agreement_Financial_Documents__c 
				 WHERE Agreement_Client_Relationship__c =: agreementClientRelationshipID];
		return (FinDocs != null) ? FinDocs : new List<Agreement_Financial_Documents__c>();
	}

    public Account updateAccount(Account account){
    	update account;
    	return account;
    }

    public Agreement_Client_Relationships__c updateAgreementClientRelationships(Agreement_Client_Relationships__c agmtClientRel){
    	update agmtClientRel;
    	return agmtClientRel;
    }

    public List<Agreement_Financial_Documents__c> saveAgreementFinancialDocuments(List<Agreement_Financial_Documents__c> agmtFinancialDocs){
    	if (agmtFinancialDocs.size() > 0){
    		List<Agreement_Financial_Documents__c> agmtFinancialDocsToInsert = new List<Agreement_Financial_Documents__c>();
    		List<Agreement_Financial_Documents__c> agmtFinancialDocsToUpdate = new List<Agreement_Financial_Documents__c>();
    		for (Agreement_Financial_Documents__c agmtDoc: agmtFinancialDocs){
    			if (agmtDoc.ID == null){
    				agmtFinancialDocsToInsert.add(agmtDoc);
    			}
    			else{
    				agmtFinancialDocsToUpdate.add(agmtDoc);
    			}
    		}
    		if (agmtFinancialDocsToUpdate.size() > 0){
	    		update agmtFinancialDocsToUpdate;
    		}
    		if (agmtFinancialDocsToInsert.size() > 0){
	    		insert agmtFinancialDocsToInsert;
    		}
    	}
    	return agmtFinancialDocs;
    }

    public void deleteAgreementFinancialDocuments(List<Agreement_Financial_Documents__c> agmtFinancialDocs){
    	if (agmtFinancialDocs.size() > 0){
    		delete agmtFinancialDocs;
    	}
    }

}