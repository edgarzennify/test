public with sharing class PricingWkstDataProv implements PricingWkst.IPricingWkstDataProv{

	public List<EB_Account__c> getEBAccountsForEntities(Set<Id> entityIDs, Set<Integer> applicationCodes){
		return new List<EB_Account__c>([
			SELECT 
				Id,
				Name,
				Account_Number__c,
				Application__c,
				EB_Bank__r.Bank_Name__c,
				EB_Account_Type__c,
				ApplicationDescription__c,
				Core_Current_Balance__c
			FROM
				EB_Account__c
			WHERE
				Primary_Owner_Id__c IN: entityIDs
				AND Application__c IN: applicationCodes
			ORDER BY Account_Number__c ]);
	}

	public void addPricingWorksheet(Pricing_Worksheet__c worksheet){
		insert worksheet;
	}

	public Pricing_Worksheet__c getPricingWorksheet(Id worksheetId){
		return [SELECT Id, Entity__c, Entity__r.Name, Comments__c, Name
				FROM Pricing_Worksheet__c
				WHERE Id =: worksheetId];
	}

	public void updatePricingWorksheet(Pricing_Worksheet__c worksheet){
		update worksheet;
	}

	public List<EB_Loan_Packet__c> getLoanPacketsForEntities(Set<Id> entityIDs){
		RecordType archivedLoanPacketRecordType = Utility.recordTypeObject('EB_Loan_Packet__c', 'Archived');
		return [SELECT Id, Name 
				FROM EB_Loan_Packet__c
				WHERE Lead_Entity__c IN: entityIDs
				  AND RecordTypeId !=: archivedLoanPacketRecordType.Id
				ORDER BY Name];
	}

	public Map<Id, Pricing_Proposed_Loan__c> getPricingProposedLoansForWorksheet(Id worksheetId){
		return new Map<Id, Pricing_Proposed_Loan__c>([SELECT Id, Amount__c, Collateral__c, Expected_Usage__c, Fee__c
															 ,Fully_Amortized__c, Loan_Type__c, Pricing_Worksheet__c, Rate__c
															 ,Rate_Type__c, Renewal__c, Risk__c, Term__c
													  FROM Pricing_Proposed_Loan__c
													  WHERE Pricing_Worksheet__c =: worksheetId
													  ORDER BY Name]);
	}

	public Map<Id, Pricing_Proposed_Deposit__c> getPricingProposedDepositsForWorksheet(Id worksheetId){
		return new Map<Id, Pricing_Proposed_Deposit__c>([SELECT Id, Average_Balance__c, CD_Term__c, Deposit_Type__c 
															 ,Gross_Monthly_Service_Charge__c, Interest_Rate__c, Pricing_Worksheet__c, Waived__c
													  FROM Pricing_Proposed_Deposit__c
													  WHERE Pricing_Worksheet__c =: worksheetId
													  ORDER BY Name]);
	}

	public Map<Id, Pricing_Proposed_Non_Interest_Income__c> getPricingProposedNonIntIncomeForWorksheet(Id worksheetId){
		return new Map<Id, Pricing_Proposed_Non_Interest_Income__c>([SELECT Id, Annual_Gross_Fees__c, Fee_Type__c
																		FROM Pricing_Proposed_Non_Interest_Income__c
																		WHERE Pricing_Worksheet__c =: worksheetId
																		ORDER BY Name]);
	}

	public Map<Id, Pricing_Proposed_Account_Removal__c> getPricingProposedAcctRemovalsForWorksheet(Id worksheetId){
		return new Map<Id, Pricing_Proposed_Account_Removal__c>([SELECT Id, EB_Account__c
																	,EB_Account__r.Account_Number__c, EB_Account__r.EB_Account_Type__c
																	,EB_Account__r.Name, EB_Account__r.Application__c
																	,EB_Account__r.ApplicationDescription__c, EB_Account__r.Core_Current_Balance__c
																	,EB_Account__r.EB_Bank__r.Bank_Name__c
																FROM Pricing_Proposed_Account_Removal__c
																WHERE Pricing_Worksheet__c =: worksheetId
																ORDER BY EB_Account__r.Name]);
	}

	public String getWorksheetIdForEntity(Id entityId){
		List<Pricing_Worksheet__c> wkst = [SELECT Id FROM Pricing_Worksheet__c WHERE Entity__c =: entityId LIMIT 1];
		System.debug('***** getWorksheetIdForEntity: ' + wkst);
		return (wkst.size() == 0) ? '' : wkst[0].Id;
	}

	public void addPricingProposedLoans(List<Pricing_Proposed_Loan__c> propLoans){
		insert propLoans;
	}

	public void addPricingProposedDeposits(List<Pricing_Proposed_Deposit__c> propDeposits){
		insert propDeposits;
	}

	public void addPricingProposedNonIntIncomes(List<Pricing_Proposed_Non_Interest_Income__c> propNonIntIncomes){
		insert propNonIntIncomes;
	}

	public void addPricingProposedAcctRemovals(List<Pricing_Proposed_Account_Removal__c> propAcctRemovals){
		insert propAcctRemovals;
	}

	public Pricing_Proposed_Loan__c getPricingProposedLoan(Id propLoanId){
		return [SELECT Id, Amount__c, Collateral__c, Expected_Usage__c, Fee__c
					 ,Fully_Amortized__c, Loan_Type__c, Pricing_Worksheet__c, Rate__c
					 ,Rate_Type__c, Renewal__c, Risk__c, Term__c
					FROM Pricing_Proposed_Loan__c
					WHERE Id =: propLoanId];
	}

	public Pricing_Proposed_Deposit__c getPricingProposedDeposit(Id propDepositId){
		return [SELECT Id, Average_Balance__c, CD_Term__c, Deposit_Type__c
					 ,Gross_Monthly_Service_Charge__c, Interest_Rate__c, Pricing_Worksheet__c, Waived__c
					FROM Pricing_Proposed_Deposit__c
					WHERE Id =: propDepositId];
	}

	public Pricing_Proposed_Non_Interest_Income__c getPricingProposedNonIntIncome(Id propNonIntIncomeId){
		return [SELECT Id, Annual_Gross_Fees__c, Fee_Type__c
					FROM Pricing_Proposed_Non_Interest_Income__c
					WHERE Id =: propNonIntIncomeId];
	}

	public Pricing_Proposed_Account_Removal__c getPricingProposedAcctRemoval(Id propAcctRemovalId){
		return [SELECT Id, EB_Account__c
						,EB_Account__r.Account_Number__c, EB_Account__r.EB_Account_Type__c
						,EB_Account__r.Name
					FROM Pricing_Proposed_Account_Removal__c
					WHERE Id =: propAcctRemovalId];
	}

	public void updatePricingProposedLoans(List<Pricing_Proposed_Loan__c> propLoans){
		update propLoans;
	}

	public void updatePricingProposedDeposits(List<Pricing_Proposed_Deposit__c> propDeposits){
		update propDeposits;
	}

	public void updatePricingProposedNonIntIncomes(List<Pricing_Proposed_Non_Interest_Income__c> propNonIntIncomes){
		update propNonIntIncomes;
	}

	public void updatePricingProposedAcctRemovals(List<Pricing_Proposed_Account_Removal__c> propAcctRemovals){
		update propAcctRemovals;
	}

	public void deletePricingProposedLoans(List<Pricing_Proposed_Loan__c> propLoans){
		delete propLoans;
	}

	public void deletePricingProposedDeposits(List<Pricing_Proposed_Deposit__c> propDeposits){
		delete propDeposits;
	}

	public void deletePricingProposedNonIntIncomes(List<Pricing_Proposed_Non_Interest_Income__c> propNonIntIncomes){
		delete propNonIntIncomes;
	}

	public void deletePricingProposedAcctRemovals(List<Pricing_Proposed_Account_Removal__c> propAcctRemovals){
		delete propAcctRemovals;
	}


}