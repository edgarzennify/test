public class AgreementBorrowingBaseTriggerHelper{
    
    public void CallValidator(List<Agreement_Borrowing_Base_Relationship__c> newList){
    	Map<Id,Agreement__c> agreements = new Map<Id,Agreement__c>();
        if(newList != null){
            for(Agreement_Borrowing_Base_Relationship__c r : newList){
               agreements.put(r.Agreement__c,null);
            }
            if(agreements.size() > 0){
                AgreementValidator m_agreementValidator = AgreementValidator.getInstance();
                for(Id aId : agreements.keySet()){                  
                    m_agreementValidator.ValidateAndSaveFromTrigger(new Agreement__c(id = aId));
                }
            }
        }
    }
}