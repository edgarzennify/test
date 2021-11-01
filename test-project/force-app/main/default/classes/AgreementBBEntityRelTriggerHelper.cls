public class AgreementBBEntityRelTriggerHelper{
    
    public void CallValidator(List<Agreement_Borrowing_Base_Entity_Rel__c> newList){
       if(newList != null){
            Set<Id> bbRelationSet = new Set<Id>();
            for(Agreement_Borrowing_Base_Entity_Rel__c bbRelationentity : newList){         
                bbRelationSet.add(bbRelationentity.Agreement_Related_Borrowing_Base__c);          
            }      
            for(Agreement_Borrowing_Base_Relationship__c bbRelation : [SELECT ID, Agreement__c FROM Agreement_Borrowing_Base_Relationship__c WHERE id in:bbRelationSet]){
                AgreementValidator m_agreementValidator = AgreementValidator.getInstance();
                m_agreementValidator.ValidateAndSaveFromTrigger(new Agreement__c(id = bbRelation.Agreement__c));
            }
        }
    } 

}