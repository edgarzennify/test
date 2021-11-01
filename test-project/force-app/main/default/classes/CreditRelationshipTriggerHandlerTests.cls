@isTest
public class CreditRelationshipTriggerHandlerTests {
    
    private static String SIX_RATED_CREDIT = '6 Rated Credit';
    private static String OREO = 'OREO';
    private static String CREDIT_RELATIONSHIP_OBJ = 'Credit_Relationship__c';
    private static String SIX_RATED_RECORD_TYPE = 'Credit Relationship 6 Rated';
    private static String STANDARD_CREDIT_RELATIONSHIP_RECORD_TYPE = 'Credit Relationship';
    private static String OREO_RECORD_TYPE = 'Credit Relationship OREO';
    
    private static CreditRelationshipTriggerHandler sut;
    private static final Mock.ofIUtility mockUtil;
    private static TriggerHandlerTester tester;
    
    static {
        mockUtil = new Mock.ofIUtility();
        sut = new CreditRelationshipTriggerHandler(mockUtil);
        tester = new TriggerHandlerTester();
    }
    
    private static testMethod void it_should_update_the_Credit_Relationship_Record_Type_to_6_Rated_when_Status_IS_UPDATED_TO_6_Rated(){
        //assemble
        Credit_Relationship__c obj = new Credit_Relationship__c();      
        obj.RecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject(STANDARD_CREDIT_RELATIONSHIP_RECORD_TYPE, CREDIT_RELATIONSHIP_OBJ);
        obj.Credit_Relationship_Status__c = SIX_RATED_CREDIT;
        RecordType OREORecType = Utility.recordTypeObject(CREDIT_RELATIONSHIP_OBJ,OREO_RECORD_TYPE);
        RecordType SixRatedRecType = Utility.recordTypeObject(CREDIT_RELATIONSHIP_OBJ,SIX_RATED_RECORD_TYPE);
        RecordType CreditRelationshipRecType = Utility.recordTypeObject(CREDIT_RELATIONSHIP_OBJ,STANDARD_CREDIT_RELATIONSHIP_RECORD_TYPE);
        mockUtil.setup('recordTypeObject', new List<Object>{CREDIT_RELATIONSHIP_OBJ,OREO_RECORD_TYPE}).returns(OREORecType);
        mockUtil.setup('recordTypeObject', new List<Object>{CREDIT_RELATIONSHIP_OBJ,SIX_RATED_RECORD_TYPE}).returns(SixRatedRecType);
        mockUtil.setup('recordTypeObject', new List<Object>{CREDIT_RELATIONSHIP_OBJ,STANDARD_CREDIT_RELATIONSHIP_RECORD_TYPE}).returns(CreditRelationshipRecType);
       
        
        
        //act
        tester.triggerNew.add(obj);
        tester.beforeTriggerUpdateSequence(sut);
        
        //assert       
        System.assertEquals(SixRatedRecType.Id, obj.RecordTypeId);
    }
    
    private static testMethod void it_should_insert_a_new_Credit_Relationship_Record_Type_as_6_Rated_if_Status_IS_INSERTED_AS_6_Rated() {
        //assemble
        Credit_Relationship__c obj = new Credit_Relationship__c();
        RecordType OREORecType = Utility.recordTypeObject(CREDIT_RELATIONSHIP_OBJ,OREO_RECORD_TYPE);
        RecordType SixRatedRecType = Utility.recordTypeObject(CREDIT_RELATIONSHIP_OBJ,SIX_RATED_RECORD_TYPE);
        RecordType CreditRelationshipRecType = Utility.recordTypeObject(CREDIT_RELATIONSHIP_OBJ,STANDARD_CREDIT_RELATIONSHIP_RECORD_TYPE);
        mockUtil.setup('recordTypeObject', new List<Object>{CREDIT_RELATIONSHIP_OBJ,OREO_RECORD_TYPE}).returns(OREORecType);
        mockUtil.setup('recordTypeObject', new List<Object>{CREDIT_RELATIONSHIP_OBJ,SIX_RATED_RECORD_TYPE}).returns(SixRatedRecType);
        mockUtil.setup('recordTypeObject', new List<Object>{CREDIT_RELATIONSHIP_OBJ,STANDARD_CREDIT_RELATIONSHIP_RECORD_TYPE}).returns(CreditRelationshipRecType);        
        obj.Credit_Relationship_Status__c = SIX_RATED_CREDIT;
        obj.RecordTypeId = SixRatedRecType.Id;
        
        //act
        tester.triggerOld.add(obj);
        tester.beforeTriggerInsertSequence(sut);
        
        //assert  
        System.assertEquals(SixRatedRecType.Id, obj.RecordTypeId);
    }
	
    private static testMethod void it_should_copy_data_from_6Rated_fields_to_Non_6Rated_fields_when_Status_is_changed_from_6rated_to_non_6rated(){     
        // assemble (given)                     
        RecordType OREORecType = Utility.recordTypeObject(CREDIT_RELATIONSHIP_OBJ,OREO_RECORD_TYPE);
        RecordType SixRatedRecType = Utility.recordTypeObject(CREDIT_RELATIONSHIP_OBJ,SIX_RATED_RECORD_TYPE);
        RecordType CreditRelationshipRecType = Utility.recordTypeObject(CREDIT_RELATIONSHIP_OBJ,STANDARD_CREDIT_RELATIONSHIP_RECORD_TYPE);
        mockUtil.setup('recordTypeObject', new List<Object>{CREDIT_RELATIONSHIP_OBJ,OREO_RECORD_TYPE}).returns(OREORecType);
        mockUtil.setup('recordTypeObject', new List<Object>{CREDIT_RELATIONSHIP_OBJ,SIX_RATED_RECORD_TYPE}).returns(SixRatedRecType);
        mockUtil.setup('recordTypeObject', new List<Object>{CREDIT_RELATIONSHIP_OBJ,STANDARD_CREDIT_RELATIONSHIP_RECORD_TYPE}).returns(CreditRelationshipRecType);
         
        Credit_Relationship__c obj = new Credit_Relationship__c();
        obj.RecordTypeId = SixRatedRecType.Id;
        obj.Credit_Relationship_Status__c = 'Watch';
        obj.Why_Loan_Rating_6_Summary__c = 'aaa';
        obj.When_Can_Credit_Be_Upgraded_Details__c = 'bbb';
        
        //act (when)
        tester.triggerNew.add(obj);
        tester.beforeTriggerUpdateSequence(sut);
        
        //assert (then)  
        System.assertEquals(obj.Why_Loan_Rating_6_Summary__c, obj.Problem__c);
        System.assertEquals(obj.When_Can_Credit_Be_Upgraded_Details__c, obj.Current_Action_Plan__c);
    }
    
    private static testMethod void it_should_copy_data_from_Non6Rated_fields_to_6Rated_fields_when_Status_is_changed_from_non6rated_to_6rated(){     
        // assemble (given)            
        RecordType OREORecType = Utility.recordTypeObject(CREDIT_RELATIONSHIP_OBJ,OREO_RECORD_TYPE);
        RecordType SixRatedRecType = Utility.recordTypeObject(CREDIT_RELATIONSHIP_OBJ,SIX_RATED_RECORD_TYPE);
        RecordType CreditRelationshipRecType = Utility.recordTypeObject(CREDIT_RELATIONSHIP_OBJ,STANDARD_CREDIT_RELATIONSHIP_RECORD_TYPE);
        mockUtil.setup('recordTypeObject', new List<Object>{CREDIT_RELATIONSHIP_OBJ,OREO_RECORD_TYPE}).returns(OREORecType);
        mockUtil.setup('recordTypeObject', new List<Object>{CREDIT_RELATIONSHIP_OBJ,SIX_RATED_RECORD_TYPE}).returns(SixRatedRecType);
        mockUtil.setup('recordTypeObject', new List<Object>{CREDIT_RELATIONSHIP_OBJ,STANDARD_CREDIT_RELATIONSHIP_RECORD_TYPE}).returns(CreditRelationshipRecType);
         
        Credit_Relationship__c obj = new Credit_Relationship__c();
        obj.RecordTypeId = CreditRelationshipRecType.Id;
        obj.Credit_Relationship_Status__c = '6 Rated Credit';
        obj.Problem__c = 'aaa';
        obj.Current_Action_Plan__c = 'bbb';
        
        //act (when)
        tester.triggerNew.add(obj);
        tester.beforeTriggerUpdateSequence(sut);
        
        //assert (then)
        System.assertEquals(obj.Problem__c, obj.Why_Loan_Rating_6_Summary__c);
        System.assertEquals(obj.Current_Action_Plan__c, obj.When_Can_Credit_Be_Upgraded_Details__c);
    }
    
    private static testMethod void it_should_copy_data_from_6Rated_fields_to_Non_6Rated_fields_when_Status_remains_6rated(){     
        // assemble (given)            
        RecordType OREORecType = Utility.recordTypeObject(CREDIT_RELATIONSHIP_OBJ,OREO_RECORD_TYPE);
        RecordType SixRatedRecType = Utility.recordTypeObject(CREDIT_RELATIONSHIP_OBJ,SIX_RATED_RECORD_TYPE);
        RecordType CreditRelationshipRecType = Utility.recordTypeObject(CREDIT_RELATIONSHIP_OBJ,STANDARD_CREDIT_RELATIONSHIP_RECORD_TYPE);
        mockUtil.setup('recordTypeObject', new List<Object>{CREDIT_RELATIONSHIP_OBJ,OREO_RECORD_TYPE}).returns(OREORecType);
        mockUtil.setup('recordTypeObject', new List<Object>{CREDIT_RELATIONSHIP_OBJ,SIX_RATED_RECORD_TYPE}).returns(SixRatedRecType);
        mockUtil.setup('recordTypeObject', new List<Object>{CREDIT_RELATIONSHIP_OBJ,STANDARD_CREDIT_RELATIONSHIP_RECORD_TYPE}).returns(CreditRelationshipRecType);
         
        Credit_Relationship__c obj = new Credit_Relationship__c();
        obj.RecordTypeId = SixRatedRecType.Id;
        obj.Credit_Relationship_Status__c = '6 Rated Credit';
        obj.Why_Loan_Rating_6_Summary__c = 'aaa';
        obj.When_Can_Credit_Be_Upgraded_Details__c = 'bbb';
        
        //act (when)
        tester.triggerNew.add(obj);
        tester.beforeTriggerUpdateSequence(sut);
        
        //assert (then) 
        System.assertEquals(obj.Why_Loan_Rating_6_Summary__c, obj.Problem__c);
        System.assertEquals(obj.When_Can_Credit_Be_Upgraded_Details__c, obj.Current_Action_Plan__c);
    }
        
    private static testMethod void it_should_copy_data_from_Non6Rated_fields_to_6Rated_fields_when_Status_remains_Non6rated(){     
        // assemble (given)             
        RecordType OREORecType = Utility.recordTypeObject(CREDIT_RELATIONSHIP_OBJ,OREO_RECORD_TYPE);
        RecordType SixRatedRecType = Utility.recordTypeObject(CREDIT_RELATIONSHIP_OBJ,SIX_RATED_RECORD_TYPE);
        RecordType CreditRelationshipRecType = Utility.recordTypeObject(CREDIT_RELATIONSHIP_OBJ,STANDARD_CREDIT_RELATIONSHIP_RECORD_TYPE);
        mockUtil.setup('recordTypeObject', new List<Object>{CREDIT_RELATIONSHIP_OBJ,OREO_RECORD_TYPE}).returns(OREORecType);
        mockUtil.setup('recordTypeObject', new List<Object>{CREDIT_RELATIONSHIP_OBJ,SIX_RATED_RECORD_TYPE}).returns(SixRatedRecType);
        mockUtil.setup('recordTypeObject', new List<Object>{CREDIT_RELATIONSHIP_OBJ,STANDARD_CREDIT_RELATIONSHIP_RECORD_TYPE}).returns(CreditRelationshipRecType);
         
        Credit_Relationship__c obj = new Credit_Relationship__c();
        obj.RecordTypeId = CreditRelationshipRecType.Id;
        obj.Credit_Relationship_Status__c = 'Watch';
        obj.Problem__c = 'aaa';
        obj.Current_Action_Plan__c = 'bbb';
        
        //act (when)
        tester.triggerNew.add(obj);
        tester.beforeTriggerUpdateSequence(sut);
        
        //assert (then)
        System.assertEquals(obj.Problem__c, obj.Why_Loan_Rating_6_Summary__c);
        System.assertEquals(obj.Current_Action_Plan__c, obj.When_Can_Credit_Be_Upgraded_Details__c);
    }
    
    private static testMethod void it_should_copy_data_from_6Rated_fields_to_Non6Rated_fields_when_Status_IS_INSERTED_AS_6_Rated(){
        //assemble (given)
        RecordType OREORecType = Utility.recordTypeObject(CREDIT_RELATIONSHIP_OBJ,OREO_RECORD_TYPE);
        RecordType SixRatedRecType = Utility.recordTypeObject(CREDIT_RELATIONSHIP_OBJ,SIX_RATED_RECORD_TYPE);
        RecordType CreditRelationshipRecType = Utility.recordTypeObject(CREDIT_RELATIONSHIP_OBJ,STANDARD_CREDIT_RELATIONSHIP_RECORD_TYPE);
        mockUtil.setup('recordTypeObject', new List<Object>{CREDIT_RELATIONSHIP_OBJ,OREO_RECORD_TYPE}).returns(OREORecType);
        mockUtil.setup('recordTypeObject', new List<Object>{CREDIT_RELATIONSHIP_OBJ,SIX_RATED_RECORD_TYPE}).returns(SixRatedRecType);
        mockUtil.setup('recordTypeObject', new List<Object>{CREDIT_RELATIONSHIP_OBJ,STANDARD_CREDIT_RELATIONSHIP_RECORD_TYPE}).returns(CreditRelationshipRecType);
        
        Credit_Relationship__c obj = new Credit_Relationship__c();
        obj.RecordTypeId = SixRatedRecType.Id;
        obj.Credit_Relationship_Status__c = '6 Rated Credit';
        obj.Why_Loan_Rating_6_Summary__c = 'This is some text for the Problem field';
        obj.When_Can_Credit_Be_Upgraded_Details__c = 'This is some text for the Current Action Plan field';
               
        //act (when)
        tester.triggerOld.add(obj);
        tester.beforeTriggerInsertSequence(sut);
        
        //assert (then)
        System.assertEquals(obj.Why_Loan_Rating_6_Summary__c, obj.Problem__c);
        System.assertEquals(obj.When_Can_Credit_Be_Upgraded_Details__c, obj.Current_Action_Plan__c);
    }
    
    private static testMethod void it_should_update_Record_Type_to_Credit_Relationship_when_Status_IS_UPDATED_TO_non6Rated(){
        //assemble (given)
        RecordType OREORecType = Utility.recordTypeObject(CREDIT_RELATIONSHIP_OBJ,OREO_RECORD_TYPE);
        RecordType SixRatedRecType = Utility.recordTypeObject(CREDIT_RELATIONSHIP_OBJ,SIX_RATED_RECORD_TYPE);
        RecordType CreditRelationshipRecType = Utility.recordTypeObject(CREDIT_RELATIONSHIP_OBJ,STANDARD_CREDIT_RELATIONSHIP_RECORD_TYPE);
        mockUtil.setup('recordTypeObject', new List<Object>{CREDIT_RELATIONSHIP_OBJ,OREO_RECORD_TYPE}).returns(OREORecType);
        mockUtil.setup('recordTypeObject', new List<Object>{CREDIT_RELATIONSHIP_OBJ,SIX_RATED_RECORD_TYPE}).returns(SixRatedRecType);
        mockUtil.setup('recordTypeObject', new List<Object>{CREDIT_RELATIONSHIP_OBJ,STANDARD_CREDIT_RELATIONSHIP_RECORD_TYPE}).returns(CreditRelationshipRecType);
        
        Credit_Relationship__c obj = new Credit_Relationship__c();
        obj.RecordTypeId = SixRatedRecType.Id;
        obj.Credit_Relationship_Status__c = 'Watch';
                
        //act (when)
        tester.triggerNew.add(obj);
        tester.beforeTriggerUpdateSequence(sut);
        
        //assert (then) 
        System.assertEquals(CreditRelationshipRecType.Id, obj.RecordTypeId);
    }
    
    private static testMethod void it_should_update_the_Record_Type_to_Oreo_when_Status_is_UPDATED_TO_Oreo(){
        //assemble (given)
        RecordType OREORecType = Utility.recordTypeObject(CREDIT_RELATIONSHIP_OBJ,OREO_RECORD_TYPE);
        RecordType SixRatedRecType = Utility.recordTypeObject(CREDIT_RELATIONSHIP_OBJ,SIX_RATED_RECORD_TYPE);
        RecordType CreditRelationshipRecType = Utility.recordTypeObject(CREDIT_RELATIONSHIP_OBJ,STANDARD_CREDIT_RELATIONSHIP_RECORD_TYPE);
        mockUtil.setup('recordTypeObject', new List<Object>{CREDIT_RELATIONSHIP_OBJ,OREO_RECORD_TYPE}).returns(OREORecType);
        mockUtil.setup('recordTypeObject', new List<Object>{CREDIT_RELATIONSHIP_OBJ,SIX_RATED_RECORD_TYPE}).returns(SixRatedRecType);
        mockUtil.setup('recordTypeObject', new List<Object>{CREDIT_RELATIONSHIP_OBJ,STANDARD_CREDIT_RELATIONSHIP_RECORD_TYPE}).returns(CreditRelationshipRecType);
        
        Credit_Relationship__c obj = new Credit_Relationship__c();
        obj.RecordTypeId = SixRatedRecType.Id;
        obj.Credit_Relationship_Status__c = 'OREO';
        
        //act (when)
        tester.triggerNew.add(obj);
        tester.beforeTriggerUpdateSequence(sut);
        
        //assert (then)
        System.assertEquals(OREORecType.Id, obj.RecordTypeId);
    }
    
    private static testMethod void it_should_update_the_6RatedRecord_Type_to_Oreo_when_Status_is_INSERTED_as_Oreo(){
        //assemble (given)
        RecordType OREORecType = Utility.recordTypeObject(CREDIT_RELATIONSHIP_OBJ,OREO_RECORD_TYPE);
        RecordType SixRatedRecType = Utility.recordTypeObject(CREDIT_RELATIONSHIP_OBJ,SIX_RATED_RECORD_TYPE);
        RecordType CreditRelationshipRecType = Utility.recordTypeObject(CREDIT_RELATIONSHIP_OBJ,STANDARD_CREDIT_RELATIONSHIP_RECORD_TYPE);
        mockUtil.setup('recordTypeObject', new List<Object>{CREDIT_RELATIONSHIP_OBJ,OREO_RECORD_TYPE}).returns(OREORecType);
        mockUtil.setup('recordTypeObject', new List<Object>{CREDIT_RELATIONSHIP_OBJ,SIX_RATED_RECORD_TYPE}).returns(SixRatedRecType);
        mockUtil.setup('recordTypeObject', new List<Object>{CREDIT_RELATIONSHIP_OBJ,STANDARD_CREDIT_RELATIONSHIP_RECORD_TYPE}).returns(CreditRelationshipRecType);
               
        Credit_Relationship__c obj = new Credit_Relationship__c();
        obj.RecordTypeId = SixRatedRecType.Id;
        obj.Credit_Relationship_Status__c = OREO;
        
        //act (when)
        tester.triggerOld.add(obj);
        tester.beforeTriggerInsertSequence(sut);
        
        //assert (then)
        System.assertEquals(OREORecType.Id, obj.RecordTypeId);
    }
    
    private static testMethod void it_should_update_the_Non6RatedRecord_Type_to_Oreo_when_Status_is_INSERTED_as_Oreo(){
        //assemble (given)
        RecordType OREORecType = Utility.recordTypeObject(CREDIT_RELATIONSHIP_OBJ,OREO_RECORD_TYPE);
        RecordType SixRatedRecType = Utility.recordTypeObject(CREDIT_RELATIONSHIP_OBJ,SIX_RATED_RECORD_TYPE);
        RecordType CreditRelationshipRecType = Utility.recordTypeObject(CREDIT_RELATIONSHIP_OBJ,STANDARD_CREDIT_RELATIONSHIP_RECORD_TYPE);
        mockUtil.setup('recordTypeObject', new List<Object>{CREDIT_RELATIONSHIP_OBJ,OREO_RECORD_TYPE}).returns(OREORecType);
        mockUtil.setup('recordTypeObject', new List<Object>{CREDIT_RELATIONSHIP_OBJ,SIX_RATED_RECORD_TYPE}).returns(SixRatedRecType);
        mockUtil.setup('recordTypeObject', new List<Object>{CREDIT_RELATIONSHIP_OBJ,STANDARD_CREDIT_RELATIONSHIP_RECORD_TYPE}).returns(CreditRelationshipRecType);
        
        Credit_Relationship__c obj = new Credit_Relationship__c();
        obj.RecordTypeId = CreditRelationshipRecType.Id;
        obj.Credit_Relationship_Status__c = OREO;
        
        //act (when)
        tester.triggerOld.add(obj);
        tester.beforeTriggerInsertSequence(sut);
        
        //assert (then)
        System.assertEquals(OREORecType.Id, obj.RecordTypeId);
    }
    
    
    private static testMethod void it_should_copy_the_data_from_the_Non6Rated_fields_to_the_6Rated_fields_if_the_Status_is_6Rated_ON_INSERT() {
        //assemble (given)
        RecordType OREORecType = Utility.recordTypeObject(CREDIT_RELATIONSHIP_OBJ,OREO_RECORD_TYPE);
        RecordType SixRatedRecType = Utility.recordTypeObject(CREDIT_RELATIONSHIP_OBJ,SIX_RATED_RECORD_TYPE);
        RecordType CreditRelationshipRecType = Utility.recordTypeObject(CREDIT_RELATIONSHIP_OBJ,STANDARD_CREDIT_RELATIONSHIP_RECORD_TYPE);
        mockUtil.setup('recordTypeObject', new List<Object>{CREDIT_RELATIONSHIP_OBJ,OREO_RECORD_TYPE}).returns(OREORecType);
        mockUtil.setup('recordTypeObject', new List<Object>{CREDIT_RELATIONSHIP_OBJ,SIX_RATED_RECORD_TYPE}).returns(SixRatedRecType);
        mockUtil.setup('recordTypeObject', new List<Object>{CREDIT_RELATIONSHIP_OBJ,STANDARD_CREDIT_RELATIONSHIP_RECORD_TYPE}).returns(CreditRelationshipRecType);
        
        Id objId = ObjectFactory.getFakeId(Credit_Relationship__c.SObjectType, '1');
        Credit_Relationship__c obj = new Credit_Relationship__c(Id=objId);
        obj.Credit_Relationship_Status__c = '6 Rated Credit';
        obj.RecordTypeId = CreditRelationshipRecType.Id;
        obj.Problem__c = 'aaa';
        obj.Current_Action_Plan__c = 'bbb';    
		        
        //act (when)
        tester.triggerOld.add(obj);
        tester.beforeTriggerInsertSequence(sut);
        
        //assert (then)
        System.assertEquals(SixRatedRecType.Id, obj.RecordTypeId);
        System.assertEquals(obj.Problem__c, obj.Why_Loan_Rating_6_Summary__c);
        System.assertEquals(obj.Current_Action_Plan__c, obj.When_Can_Credit_Be_Upgraded_Details__c);
    }
    
    private static testMethod void it_should_copy_the_data_from_the_6Rated_fields_to_the_Non6Rated_fields_if_the_Status_is_Non6Rated_ON_INSERT() {
        //assemble (given)
        RecordType OREORecType = Utility.recordTypeObject(CREDIT_RELATIONSHIP_OBJ,OREO_RECORD_TYPE);
        RecordType SixRatedRecType = Utility.recordTypeObject(CREDIT_RELATIONSHIP_OBJ,SIX_RATED_RECORD_TYPE);
        RecordType CreditRelationshipRecType = Utility.recordTypeObject(CREDIT_RELATIONSHIP_OBJ,STANDARD_CREDIT_RELATIONSHIP_RECORD_TYPE);
        mockUtil.setup('recordTypeObject', new List<Object>{CREDIT_RELATIONSHIP_OBJ,OREO_RECORD_TYPE}).returns(OREORecType);
        mockUtil.setup('recordTypeObject', new List<Object>{CREDIT_RELATIONSHIP_OBJ,SIX_RATED_RECORD_TYPE}).returns(SixRatedRecType);
        mockUtil.setup('recordTypeObject', new List<Object>{CREDIT_RELATIONSHIP_OBJ,STANDARD_CREDIT_RELATIONSHIP_RECORD_TYPE}).returns(CreditRelationshipRecType);
        
        Id objId = ObjectFactory.getFakeId(Credit_Relationship__c.SObjectType, '1');
        Credit_Relationship__c obj = new Credit_Relationship__c(Id=objId);
        obj.RecordTypeId = SixRatedRecType.Id;
        obj.Credit_Relationship_Status__c = 'Watch';
        obj.Why_Loan_Rating_6_Summary__c = 'aaa';
        obj.When_Can_Credit_Be_Upgraded_Details__c = 'bbb';

            
        //act (when)
        tester.triggerOld.add(obj);
        tester.beforeTriggerInsertSequence(sut);
        
        //assert (then)
        System.assertEquals(CreditRelationshipRecType.Id, obj.RecordTypeId);
        System.assertEquals(obj.Why_Loan_Rating_6_Summary__c, obj.Problem__c);
        System.assertEquals(obj.When_Can_Credit_Be_Upgraded_Details__c, obj.Current_Action_Plan__c);
    }
    
    private static testMethod void it_should_set_the_record_type_based_on_the_Status_if_there_is_no_RecordType_to_begin_with(){
        //assemble (given)
        RecordType OREORecType = Utility.recordTypeObject(CREDIT_RELATIONSHIP_OBJ,OREO_RECORD_TYPE);
        RecordType SixRatedRecType = Utility.recordTypeObject(CREDIT_RELATIONSHIP_OBJ,SIX_RATED_RECORD_TYPE);
        RecordType CreditRelationshipRecType = Utility.recordTypeObject(CREDIT_RELATIONSHIP_OBJ,STANDARD_CREDIT_RELATIONSHIP_RECORD_TYPE);
        mockUtil.setup('recordTypeObject', new List<Object>{CREDIT_RELATIONSHIP_OBJ,OREO_RECORD_TYPE}).returns(OREORecType);
        mockUtil.setup('recordTypeObject', new List<Object>{CREDIT_RELATIONSHIP_OBJ,SIX_RATED_RECORD_TYPE}).returns(SixRatedRecType);
        mockUtil.setup('recordTypeObject', new List<Object>{CREDIT_RELATIONSHIP_OBJ,STANDARD_CREDIT_RELATIONSHIP_RECORD_TYPE}).returns(CreditRelationshipRecType);
        
        Credit_Relationship__c obj = new Credit_Relationship__c();
        obj.RecordTypeId = null;
        obj.Credit_Relationship_Status__c = '6 Rated Credit';
        
        //act (when)
        tester.triggerNew.add(obj);
        tester.beforeTriggerUpdateSequence(sut);
        
        System.assertEquals(SixRatedRecType.Id, obj.RecordTypeId);
    }
    
    private static testMethod void CODE_COVERAGE_execute_default_constructor(){
        CreditRelationshipTriggerHandler cc = new CreditRelationshipTriggerHandler();
    }

    private static testMethod void CODE_COVERAGE_integration_test(){
        Credit_Relationship__c cr = new Credit_Relationship__c();
        insert cr;
    }
}