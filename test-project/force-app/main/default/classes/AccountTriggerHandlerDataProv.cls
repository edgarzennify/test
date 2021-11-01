public with sharing class AccountTriggerHandlerDataProv implements AccountTriggerHandler.IAccountTriggerHandlerDataProv{
	public List<Account> getChildrenOfAccounts(Set<Id> accts){
		List<Account> children = [SELECT Id,ParentId,OwnerId,EB_UnitID__c,Relationship_Change_Ignore_Validation__c,Primary_Relationship__c FROM Account WHERE ParentId In: accts LIMIT 5000];
		return (children != null) ? children : new List<Account>();
	}

	public void updateAccounts(List<Account> accts){
		update accts;
	}

	public List<Eb_Team_Member__c> getTeamMembersByOwnerID(Set<Id> ownerIds){
		List<Eb_Team_Member__c> teamMembers = [SELECT Id,User__c FROM Eb_Team_Member__c WHERE User__c In: ownerIds LIMIT 5000];
		return (teamMembers != null) ? teamMembers : new List<Eb_Team_Member__c>();
	}

	public List<EB_Loan_App_Entity_Relationship__c> getLoanAppRelatedEntities(Set<Id> acctIds, Set<String> fieldsToRetrieve){
		if(fieldsToRetrieve.size() == 0){
			return new List<EB_Loan_App_Entity_Relationship__c>();
		}
		String fields = '';
		for(String field : fieldsToRetrieve){
			fields += field + ',';
		}
		try{
			fields = fields.substring(0,fields.length() - 1);
			String queryString = 'SELECT ' + fields + ' FROM EB_Loan_App_Entity_Relationship__c WHERE Entity_Name__c In:acctIds LIMIT 5000';
			List<EB_Loan_App_Entity_Relationship__c> relatedEntities = (List<EB_Loan_App_Entity_Relationship__c>)Database.query(queryString);
			return (relatedEntities != null) ? relatedEntities : new List<EB_Loan_App_Entity_Relationship__c>();	
		}catch(Exception e){
			//TODO: LOG ERROR
			return new List<EB_Loan_App_Entity_Relationship__c>();
		}
	}

	public void updateLoanAppRelatedEntities(List<EB_Loan_App_Entity_Relationship__c> relEntities){
		update relEntities;
	}

	public Set<EB_Loan_App_Stage_Validation_Rule__c> getLoanAppStageValidationRulesForObject(String objectName){
		return new Set<EB_Loan_App_Stage_Validation_Rule__c>([SELECT id,Name,Object_Name__c,Field_Name__c,Error_Text__c,Operation__c,Operand__c FROM EB_Loan_App_Stage_Validation_Rule__c WHERE Object_Name__c =: objectName LIMIT 5000]);
	}

	public List<EB_Team_Member__c> getTeamMembersById(List<Id> userIds){
		return [SELECT Id, Name, User__c FROM EB_Team_Member__c WHERE User__c in: userIds];
	}
}