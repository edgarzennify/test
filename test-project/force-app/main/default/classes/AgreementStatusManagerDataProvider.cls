public class AgreementStatusManagerDataProvider implements Agreements.IAgreementStatusManagerDataProvider{
	public Agreement__c getAgreementById(Id agreementId){
		return [SELECT Id, Name, RecordTypeId, Source_Agreement__c, Stage__c FROM Agreement__c WHERE Id =: agreementId LIMIT 1];
	}

	public List<Agreement_Loan_Application_Relationship__c> getAgreementLoanAppRelationshipsByAgreementId(Id agreementId){
		List<Agreement_Loan_Application_Relationship__c> agmtAppRels = 
			[SELECT 
				Id, Name, Loan_Application__c, Total_Amount__c, EB_Loan_Application__c, Borrower__c, Record_Type__c
	            ,Loan_Packet__c, Loan_Application__r.Id, Loan_Application__r.Name, Loan_Application__r.EB_Loan_Packet__c
	            ,Loan_Application__r.EB_Loan_Packet__r.Id, Loan_Application__r.EB_Loan_Packet__r.Name
	            ,Loan_Application__r.Lead_Entity_With_Link__c, Loan_Application__r.Total_Loan_Amount__c
	            ,Loan_Application__r.Application_Stage__r.Name, Loan_Application__r.Application_Stage__r.Loan_App_Stage_Action_Controller__r.Name
            FROM Agreement_Loan_Application_Relationship__c 
            WHERE Agreement__c =: agreementId];
        
        return (agmtAppRels != null) ? agmtAppRels : new List<Agreement_Loan_Application_Relationship__c>();
	}

	public List<Agreement_Loan_Application_Relationship__c> getAgreementLoanApplicationRelationshipsByAppId(Id applicationId){
		List<Agreement_Loan_Application_Relationship__c> agmtAppRels = 
			[SELECT 
				Agreement__c, Loan_Application__c 
			FROM Agreement_Loan_Application_Relationship__c 
			WHERE Loan_Application__c =: applicationId];

		return (agmtAppRels != null) ? agmtAppRels : new List<Agreement_Loan_Application_Relationship__c>();
	}

	public EB_Loan_App_Stage__c getLoanAppStageByName(String stageName){
		return [SELECT Id, Name FROM EB_Loan_App_Stage__c WHERE Name=: stageName];
	}

	public List<Agreement_EB_Account_Relationship__c> getAgreementAccountRelationshipsByAccountId(Id ebAccountId){
		List<Agreement_EB_Account_Relationship__c> agmtAccountRels = 
			[SELECT 
				Id, Name, Loan_Account__c, Agreement__c
			FROM Agreement_EB_Account_Relationship__c 
			WHERE Loan_Account__c =: ebAccountId];
		
		return (agmtAccountRels != null) ? agmtAccountRels : new List<Agreement_EB_Account_Relationship__c>();
	}

	public void saveAgreement(Agreement__c agreement){
		if(agreement.Id != null){
			update agreement;
		}else{
			insert agreement;		
		}
	}

	public void saveAccountRelationships(List<Agreement_EB_Account_Relationship__c> agreementAccountRelationships){
		upsert agreementAccountRelationships;
	}
}