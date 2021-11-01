public with sharing class AgreementClientRelationshipTriggerHelper {
    
    public void CallValidator(List<Agreement_Client_Relationships__c> newList){
        if(newList != null){
            for(Agreement_Client_Relationships__c clientRelation : newList){
                AgreementValidator m_agreementValidator = AgreementValidator.getInstance();
                m_agreementValidator.ValidateAndSaveFromTrigger(new Agreement__c(id = clientRelation.Agreement__c));                                     
            }
        }
    }
    
    public void doBeforeInsert(List <Agreement_Client_Relationships__c> newAgreementClientList){
    }
    
    public void doAfterInsert(List <Agreement_Client_Relationships__c> newAgreementClientList ){  
        updateAgreementSummaries(newAgreementClientList);
    }
    
    public void doAfterUpdate(list <Agreement_Client_Relationships__c> oldAgreementClientList,list <Agreement_Client_Relationships__c> newAgreementClientList){   
	    updateAgreementSummaries(newAgreementClientList);	 
	}
	
	public void doAfterDelete(List<Agreement_Client_Relationships__c> oldAgreementClientList){
		updateAgreementSummaries(oldAgreementClientList);
	}
	
	private void updateAgreementSummaries(List<Agreement_Client_Relationships__c> agreementClientList){
		Map<Id, Id> agreements = new Map<Id, Id>();
		for(Agreement_Client_Relationships__c clientRel : agreementClientList){
			if(agreements.get(clientRel.Agreement__c) == null){
				agreements.put(clientRel.Agreement__c, clientRel.Agreement__c);
			}
		}
		AgreementSummaryUpdater.updateSummaries(agreements.values());
	}
}