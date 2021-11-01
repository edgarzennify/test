@IsTest
private class SObjectFieldFactoryTests {
	
    private static testMEthod void it_should_getWrapped_field_when_sobject_field_is_provided() {
        //ISObjectField getInstance(Schema.SObjectField fld)
        Map<string, Schema.SObjectField> schemaMap = getSobjectFields('Tm_Service_Request__c');
        Schema.SObjectField sfld = schemaMap.get('name');
        SObjectFieldFactory sut = new SObjectFieldFactory();
        ISObjectField ifld = sut.getInstance(sfld);
        System.assertEquals('TM Service Request Name', ifld.getLabel());
    }
    
     private static Map<string, Schema.SObjectField> getSobjectFields(string objectName) {
      	return Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
     }
}