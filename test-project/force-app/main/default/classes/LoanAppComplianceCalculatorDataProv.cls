public with sharing class LoanAppComplianceCalculatorDataProv implements LoanAppComplianceCalculatorDataProv.ILoanAppComplianceCalculatorDataProv {

	public interface ILoanAppComplianceCalculatorDataProv {
    	List<EB_Loan_Application__c> getLoanApplicationsByIds(Set<Id> ids);
    	void updateLoanApplications(List<EB_Loan_Application__c> loanapps);
	}

	public List<EB_Loan_Application__c> getLoanApplicationsByIds(Set<Id> ids){
    	List<EB_Loan_Application__c> loanApps = 
    	[SELECT Id, IsHMDAAsDeterminedByTrigger__c, IsHOEPAAsDeterminedByTrigger__c, IsCRAAsDeterminedByTrigger__c
    			, Bank_Owned_Loan_Amount__c, Business_Purpose__c, HOEPA_Finance_Purchase_Or_Construction__c, Loan_Type__c
    			, Refinance_Type__c, Use_of_Funds__c, RecordType.Name
                , Account_Number__r.Current_Loan_Amount__c
    		,(SELECT Id, EB_Collateral_ID__c, EB_Loan_Application_ID__c, Abundance_of_Caution__c
            ,EB_Collateral_ID__r.Collateral_Code__r.CRA_Real_Estate_Details__c
    			,EB_Collateral_ID__r.Collateral_Code__r.Category__c, EB_Collateral_ID__r.Collateral_Code__r.IsHMDADwelling__c
    			,EB_Collateral_ID__r.Collateral_Code__r.Collateral_Code_ID__c
                FROM EB_Loan_App_Collateral_Relationships__r) 
    		,(SELECT Id, RecordType.Name, Participated_Amount__c
    			FROM EB_Loan_Participations__r) 
   	 	 FROM EB_Loan_Application__c WHERE Id in : ids];

   	 	return (loanApps != null) ? loanApps : new List<EB_Loan_Application__c>();
	}

	public void updateLoanApplications(List<EB_Loan_Application__c> loanapps){
		update loanapps;
	}
}