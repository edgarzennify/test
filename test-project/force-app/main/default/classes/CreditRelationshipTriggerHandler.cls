public with sharing class CreditRelationshipTriggerHandler extends TriggerHandler {
    
    private static String SIX_RATED_CREDIT = '6 Rated Credit';
    private static String OREO = 'OREO';
    private static String CREDIT_RELATIONSHIP_OBJ = 'Credit_Relationship__c';
    private static String SIX_RATED_RECORD_TYPE = 'Credit Relationship 6 Rated';
    private static String CREDIT_RELATIONSHIP_RECORD_TYPE = 'Credit Relationship';
    private static String OREO_RECORD_TYPE = 'Credit Relationship OREO';
    private final Utility.IUtility m_util;
    
    public CreditRelationshipTriggerHandler(){
        m_util = new Utility();
    }
    
    public CreditRelationshipTriggerHandler(Utility.IUtility util){
        m_util = util;
    }
        
    public override void bulkBeforeUpdate(List<SObject> oldSos, Map<Id, SObject> newSosMap){
    	updateRecordTypeFor6RatedCredits(newSosMap.values());
    }
    
    public override void bulkBeforeInsert(List<SObject> sos){
        updateRecordTypeFor6RatedCredits(sos);
    }
    
    private void updateRecordTypeFor6RatedCredits(List<SObject> newsos) {
        for(SObject so : newsos){
            Credit_Relationship__c cr = (Credit_Relationship__c)so;
            if (cr.RecordTypeId != SixRatedCreditRecordTypeId) {
				if(cr.Credit_Relationship_Status__c == SIX_RATED_CREDIT) {
                    cr.RecordTypeId = SixRatedCreditRecordTypeId;                 
                    copyDataFromNon6RatedFieldsTo6RatedFields(cr);
            	} else if (cr.Credit_Relationship_Status__c != SIX_RATED_CREDIT && cr.Credit_Relationship_Status__c != OREO) {                    
                    copyDataFromNon6RatedFieldsTo6RatedFields(cr);
            	} else if (cr.Credit_Relationship_Status__c == OREO) {
                	cr.RecordTypeId = OREORecordTypeId;
            	}                
            } else {
                if(cr.Credit_Relationship_Status__c == SIX_RATED_CREDIT) {                    
                    copyDataFrom6RatedFieldsToNon6RatedFields(cr);
                } else if (cr.Credit_Relationship_Status__c != SIX_RATED_CREDIT && cr.Credit_Relationship_Status__c != OREO) {
                    cr.RecordTypeId = StandardRecordTypeId;
                    copyDataFrom6RatedFieldsToNon6RatedFields(cr);
                } else if (cr.Credit_Relationship_Status__c == OREO) {
                    cr.RecordTypeId = OREORecordTypeId;
                }
            }
        }
    }

    private void copyDataFromNon6RatedFieldsTo6RatedFields(Credit_Relationship__c cr) {
        cr.Why_Loan_Rating_6_Summary__c = cr.Problem__c;
        cr.When_Can_Credit_Be_Upgraded_Details__c = cr.Current_Action_Plan__c;
    }
    
    private void copyDataFrom6RatedFieldsToNon6RatedFields(Credit_Relationship__c cr) {
        cr.Problem__c = cr.Why_Loan_Rating_6_Summary__c;
        cr.Current_Action_Plan__c = cr.When_Can_Credit_Be_Upgraded_Details__c;
    }
    
    private Id SixRatedCreditRecordTypeId {
        get{ return m_util.recordTypeObject(CREDIT_RELATIONSHIP_OBJ, SIX_RATED_RECORD_TYPE).Id;}
    }
    
    private Id StandardRecordTypeId {
        get{ return m_util.recordTypeObject(CREDIT_RELATIONSHIP_OBJ, CREDIT_RELATIONSHIP_RECORD_TYPE).Id;}
    }
    
    private Id OREORecordTypeId {
        get{ return m_util.recordTypeObject(CREDIT_RELATIONSHIP_OBJ, OREO_RECORD_TYPE).Id;}
    }
}