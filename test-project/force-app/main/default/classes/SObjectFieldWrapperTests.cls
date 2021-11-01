@IsTest
private class SObjectFieldWrapperTests {
	
    private static testMethod void it_should_get_field_describe() {
        Map<string, Schema.SObjectField> schemaMap = getSobjectFields('Tm_Service_Request__c');
        Schema.SObjectField sfld = schemaMap.get('name');
        SObjectFieldWrapper sut = new SObjectFieldWrapper(sfld);
        IDescribeFieldResult fldResult = sut.getDescribe();
        
        System.assertEquals('TM Service Request Name', fldResult.getLabel());
    }
    
    private static testMEthod void it_should_do_code_coverage() {
        Map<string, Schema.SObjectField> schemaMap = getSobjectFields('Tm_Service_Request__c');
        Schema.SObjectField sfld = schemaMap.get('name');
        SObjectFieldWrapper sut = new SObjectFieldWrapper(sfld);
        IDescribeFieldResult fldResult = sut.getDescribe();
        Boolean check1 = sut.isUpdateable();
        Boolean check2 = sut.isCreatable();
        Boolean check3 = sut.isCalculated();
        Boolean check4 = sut.isAccessible();
        DescribeFieldResultWrapper.Type getType = sut.getType();
        List<IPicklistEntry> getPicklistValues = sut.getPicklistValues();
        String helpText = sut.getInlineHelpText();
        String name = sut.getName();
        String label = sut.getLabel();
    }
    
    
     private static Map<string, Schema.SObjectField> getSobjectFields(string objectName) {
      	return Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
     }
}