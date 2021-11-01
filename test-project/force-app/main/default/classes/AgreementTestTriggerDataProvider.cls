public  class AgreementTestTriggerDataProvider {
	
	/*public List<String> getEmailListForApprovalNotification(List<Agreement_Test__c> agreementTests){
		List<Id> agreementTestIds = new List<Id>();
		for(Agreement_Test__c agreementTest : [SELECT Id FROM Agreement_Test__c WHERE Id in:agreementTests ]){
			agreementTestIds.add(agreementTest.Id);
		}
		List<String> emails = new List<String>();
		for(Id agmtTestId : agreementTestIds){
			List<String> currentEmails = getEmailListForApprovalNotification(agmtTestId);
			if (currentEmails != null) emails.addAll(currentEmails);
		}
		return emails;
	}*/
	public List<String> getEmailListForApprovalNotification(Id agreementTestId){
		Agreement_Test__c agreementTest = [SELECT Id , Agreement__c FROM Agreement_Test__c WHERE Id=:agreementTestId limit 1];
		List<String> emails = new List<String>();
		List<String> emailsFromagmtLoanAppRel = getRMandCooridinatorsFromAgreementLoanRelationship(agreementTest.Agreement__c);
		if (emailsFromAgmtLoanAppRel != null)emails.addAll(getRMandCooridinatorsFromAgreementLoanRelationship(agreementTest.Agreement__c));
		List<String> emailsFromAgmt = getRMandCooridinatorsFromAgreement(agreementTest.Agreement__c);
		if (emailsFromAgmt != null) emails.addAll(emailsFromAgmt);
		Map<String , String> emailMap = new Map<String , String>();
		for(String email : emails){
			if(!String.IsBlank(email)){
				emailMap.put(email,email);
			}
		}
		return emailMap.values();
	}
	
	private List<String> getRMandCooridinatorsFromAgreementLoanRelationship(Id agreementId){
		List<String> emails = new List<String>();
		List<Agreement_Loan_Application_Relationship__c> loanAppAgreements = 
						[SELECT  Loan_Application__r.EB_Loan_Packet__r.Loan_Coordinator__r.User__r.Email
								,Loan_Application__r.EB_Loan_Packet__r.Lead_Entity__r.Team_Relationship_Manager__r.User__r.Email 
						 FROM Agreement_Loan_Application_Relationship__c  Where Agreement__c =: agreementId ];
		for(Agreement_Loan_Application_Relationship__c rel : loanAppAgreements){
			emails.add(rel.Loan_Application__r.EB_Loan_Packet__r.Loan_Coordinator__r.User__r.Email);
			emails.add(rel.Loan_Application__r.EB_Loan_Packet__r.Lead_Entity__r.Team_Relationship_Manager__r.User__r.Email);
		}
		return emails;
	}
	
    private List<String> getRMandCooridinatorsFromAgreement(Id agreementId){
    	List<String> emails = new List<String>();
    	List<Agreement__c> agmts = 
				    	[Select  Loan_Coordinator__r.User__r.Email 
								,Borrower_Name__r.Team_Relationship_Manager__r.User__r.Email 
						From Agreement__c  Where Id =: agreementId ];
		for(Agreement__c a : agmts){
			emails.add(a.Loan_Coordinator__r.User__r.Email );
			emails.add(a.Borrower_Name__r.Team_Relationship_Manager__r.User__r.Email );
		}
		return emails;
    }



}