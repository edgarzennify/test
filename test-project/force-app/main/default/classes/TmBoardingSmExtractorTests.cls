@IsTest
private class TmBoardingSmExtractorTests {
    private final static TmBoardingSmExtractor sut;
    static {
        sut = new TmBoardingSmExtractor();
    }
    
    private static testMethod void it_should_build_a_map_of_valid_fields() {
        
        String objectName = 'Tm_Service_Request__c';
        Id objectId = ObjectFactory.getFakeId(Tm_Service_Request__c.SObjectType, '1');
        List<TmBoarding.SaveSm> sms = new List<TmBoarding.SaveSm>();
        TmBoarding.SaveSm sm1 = new TmBoarding.SaveSm();
        sm1.FieldName = 'Tm_Service_Request__c.Domastic_Daily_Limit__c';
        sm1.FieldValue = '235235';
        sm1.ObjectId = objectId;
        
        TmBoarding.SaveSm sm2 = new TmBoarding.SaveSm();
        sm2.FieldName = 'Tm_Service_Request__c.Domastic_Monthly_Limit__c';
        sm2.FieldValue = null;
        sm2.ObjectId = objectId;
        
        TmBoarding.SaveSm sm3 = new TmBoarding.SaveSm();
        sm3.FieldName = 'Tm_Service_Request__c.Tm_Some__r.Some_Field__c';
        sm3.FieldValue = null;
        sm3.ObjectId = objectId;
        
        TmBoarding.SaveSm sm4 = new TmBoarding.SaveSm();
        sm4.FieldName = 'Some_Field__c';
        sm4.FieldValue = null;
        sm4.ObjectId = objectId;
        
        sms.add(sm1);
        sms.add(sm2);
        sms.add(sm3);
        sms.add(sm4);
           
        Map<String, Object> result = sut.getObjectFields(objectName, sms);

        List<string> items = sm1.FieldName.split('\\.');
        System.assertEquals('Domastic_Daily_Limit__c' , items[1]);
        System.assertEquals(2, result.keyset().size());
    }

    private static testMethod void it_should_get_selected_items_when_sms_are_provided() {
        
        String objectName = 'Tm_Service_Request__c';
        Id objectId = ObjectFactory.getFakeId(Tm_Service_Request__c.SObjectType, '1');
        Id objectId1 = ObjectFactory.getFakeId(Tm_Service_Request__c.SObjectType, '2');
        List<TmBoarding.SaveSm> sms = new List<TmBoarding.SaveSm>();
        TmBoarding.SaveSm sm1 = new TmBoarding.SaveSm();
        sm1.FieldName = 'Tm_Service_Request__c.Domastic_Daily_Limit__c';
        sm1.FieldValue = '235235';
        sm1.ObjectId = objectId;

        TmBoarding.SaveSm sm2 = new TmBoarding.SaveSm();
        sm2.FieldName = 'Selected';
        sm2.FieldValue = '';
        sm2.ObjectId = objectId;

        TmBoarding.SaveSm sm3 = new TmBoarding.SaveSm();
        sm3.FieldName = 'Selected';
        sm3.FieldValue = '';
        sm3.ObjectId = objectId1;

        sms.add(sm1);
        sms.add(sm2);
        sms.add(sm3);

        Map<String, Object> result = sut.getSelectedFields(objectId ,sms);

        System.assertEquals(1, result.keyset().Size());
    }

    private static testMethod void it_should_build_sms_by_parent_id_when_objectId_is_empty() {
        String objectName = 'TM_Service_Request_Contact__c';
        Id c_objectId = ObjectFactory.getFakeId(Contact.SObjectType, '1');
        Id cr_objectId = ObjectFactory.getFakeId(Tm_Service_Request__c.SObjectType, '1');
        
        TmBoarding.SaveSm sm1 = new TmBoarding.SaveSm();
        sm1.FieldName = 'TM_Service_Request_Contact__c.Access_Level__c';
        sm1.FieldValue = 'Supervisor / Manage Users';
        sm1.ParentId = c_objectId;

        TmBoarding.SaveSm sm2 = new TmBoarding.SaveSm();
        sm2.FieldName = 'TM_Service_Request_Contact__c.User_Special_Instructions__c';
        sm2.FieldValue = 'test-instruction';
        sm2.ObjectId = cr_objectId;
        sm2.ParentId = c_objectId;
        List<TmBoarding.SaveSm> sms = new List<TmBoarding.SaveSm>{sm1, sm2};

        Map<String, List<TmBoarding.SaveSm>> result = sut.getNewObjectsByParentId(objectName, sms);

        System.assertEquals(1, result.keySet().size());
        System.assertEquals(1, result.values().size());
        System.assertEquals('TM_Service_Request_Contact__c.Access_Level__c', result.get(c_objectId)[0].FieldName);
    }

    private static testMethod void it_should_build_sms_for_object_with_empty_object_id_and_empty_parent_id() {
        String objectName = 'TM_Service_Request_Contact__c';
        Id c_objectId = ObjectFactory.getFakeId(Contact.SObjectType, '1');
        Id cr_objectId = ObjectFactory.getFakeId(Tm_Service_Request__c.SObjectType, '1');
        
        TmBoarding.SaveSm sm1 = new TmBoarding.SaveSm();
        sm1.FieldName = 'TM_Service_Request_Contact__c.Access_Level__c';
        sm1.FieldValue = 'Supervisor / Manage Users';
        List<TmBoarding.SaveSm> sms = new List<TmBoarding.SaveSm>{sm1};

        List<TmBoarding.SaveSm> result = sut.getNewObjectWithoutId(objectName, sms); 

        System.assertEquals(1, result.size());
        System.assertEquals('Supervisor / Manage Users', result[0].fieldValue);
    }

    private static testMethod void it_should_get_fields_for_an_object_when_objectId_is_empty_and_parent_and_related_Id_are_present() {
        String objectName = 'TM_Service_Request_Contact_Account__c';
        Id c_objectId = ObjectFactory.getFakeId(Contact.SObjectType, '1');
        Id a_objectId = ObjectFactory.getFakeId(Eb_Account__c.SObjectType, '1');
        
        TmBoarding.SaveSm sm1 = new TmBoarding.SaveSm();
        sm1.FieldName = 'TM_Service_Request_Contact_Account__c.Deposit__c';
        sm1.FieldValue = (Object) true;
        sm1.ParentId = c_objectId;
        sm1.RelatedId = a_objectId;
        List<TmBoarding.SaveSm> sms = new List<TmBoarding.SaveSm>{sm1};

        Map<String, List<TmBoarding.SaveSm>> result = sut.getObjectsByParentAndRelated(objectName, sms);

        System.assertEquals(1, result.keyset().size());
        System.assertEquals(true , result.containskey(c_objectId + '|' + a_objectId));
    }

    private static testMethod void it_should_get_fields_for_objects_when_object_id_is_empty_and_parent_id_is_empty_and_related_id_is_present() {
        String objectName = 'TM_Service_Request_Contact_Account__c';
        Id c_objectId = ObjectFactory.getFakeId(Contact.SObjectType, '1');
        Id a_objectId = ObjectFactory.getFakeId(Eb_Account__c.SObjectType, '1');
        
        TmBoarding.SaveSm sm1 = new TmBoarding.SaveSm();
        sm1.FieldName = 'TM_Service_Request_Contact_Account__c.Deposit__c';
        sm1.FieldValue = (Object) true;
        sm1.ParentId = c_objectId;
        sm1.RelatedId = a_objectId;

        TmBoarding.SaveSm sm2 = new TmBoarding.SaveSm();
        sm2.FieldName = 'TM_Service_Request_Contact_Account__c.Deposit__c';
        sm2.FieldValue = (Object) true;
        sm2.RelatedId = a_objectId;
        List<TmBoarding.SaveSm> sms = new List<TmBoarding.SaveSm>{sm1, sm2};

        Map<String, List<TmBoarding.SaveSm>> result = sut.getObjectsWithoutIdAndParentId(objectName, sms);

        System.assertEquals(1, result.keyset().size());
        System.assertEquals(true, result.containsKey(a_objectId));
    }

    private static testMethod void it_should_get_object_by_id() {
        String objectName = 'Tm_Service_Request__c';
        String fieldName = objectName + '.' + 'Name';
        String objectId = 'a123';
        TmBoarding.SaveSm sm1 = new TmBoarding.SaveSm();
        sm1.FieldName = fieldName;
        sm1.FieldValue = '-name-';
        sm1.objectId = objectId;
        List<TmBoarding.SaveSm> sms = new List<TmBoarding.SaveSm>{sm1};

        Map<String, List<TmBoarding.SaveSm>> result =  sut.getObjectsById(objectName, sms);

        Set<string> resultIds = result.keyset();
        List<String> resultIdList = new List<String>();
        resultIdList.addAll(resultIds);
        System.assertEquals(1, result.size());
        System.assertEquals(objectId, resultIdList[0]);
    }

    private static testMethod void it_should_get_objects_without_id() {

        String objectName = 'Tm_Service_Request__c';
        String fieldName = objectName + '.' + 'Name';
        TmBoarding.SaveSm sm = new TmBoarding.SaveSm();
        sm.FieldName = fieldName;
        sm.FieldValue = '-name-';
        List<TmBoarding.SaveSm> sms = new List<TmBoarding.SaveSm>{sm};

        List<TmBoarding.SaveSm> result = sut.getObjectsWithoutId(objectName, sms);

        System.assertEquals(1 ,result.size());
        System.assertEquals(fieldName ,result[0].FieldName);
    }
}