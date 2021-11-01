public class AgreementFinancialDocTriggerHelper{
    public void CallValidator(List<Agreement_Financial_Documents__c> newList){
    	Map<Id,Agreement__c> agreements = new Map<Id,Agreement__c>();
        if(newList != null){
            Set<Id> financialDocumentRelationSet = new Set<Id>();
            for(Agreement_Financial_Documents__c agreementFinancialDoc : newList){          
                financialDocumentRelationSet.add(agreementFinancialDoc.Agreement_Client_Relationship__c);         
            }      
            for(Agreement_Client_Relationships__c r : [SELECT Id, Agreement__c, Agreement__r.Id,Agreement__r.Name,  Agreement__r.RecordTypeId, Agreement__r.Source_Agreement__c, Agreement__r.Loan_Coordinator__c, Agreement__r.Business_Loan_Agreement_Documents__c, Agreement__r.Guarantee_Agreement_Documents__c, Agreement__r.Subordination_Intercreditor_Documents__c, Agreement__r.Loan_Documents_Prepared_By__c, Agreement__r.Agreement_Date__c, Agreement__r.Documentation_Path_Fx__c , Agreement__r.Law_Firm__c FROM Agreement_Client_Relationships__c WHERE id in:financialDocumentRelationSet]){
                agreements.put(r.Agreement__c,r.Agreement__r);
            } 
            if(agreements.size() > 0){
            	AgreementValidator m_agreementValidator = AgreementValidator.getInstance();
	            for(Agreement__c a : agreements.values()){	       
	            	m_agreementValidator.ValidateAndSaveFromTrigger(a);
	            }
            }
        }
    }

}