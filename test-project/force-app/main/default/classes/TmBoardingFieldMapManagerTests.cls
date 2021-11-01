@IsTest
private class TmBoardingFieldMapManagerTests {
	private static final TmBoardingFieldMapManager sut;
    
    static {
        sut = new TmBoardingFieldMapManager();
    }



    private static testMethod void it_should_build_sobject_when_objectName_is_given() {
        string objectName = 'Tm_Service_Request__c';
        string fieldName = 'Name';
        Schema.SObjectField result = sut.getField(objectName, fieldName);

        Schema.DescribeFieldResult fieldDescribe = result.getDescribe();
        System.assertEquals(fieldName ,fieldDescribe.getName());
    }


    private static testMethod void it_should_get_field_helptext() {
        string objectName = 'Tm_Service_Request__c';
        string fieldName = 'Name';
        Schema.SObjectField fld = sut.getField(objectName, fieldName);

        String result = sut.getFieldHelpText(fld);

        System.assertEquals( null,result);
    }

    private static testMethod void it_should_get_type() {
        string objectName = 'Tm_Service_Request__c';
        string fieldName = 'Name';
        Schema.SObjectField fld = sut.getField(objectName, fieldName);

        Schema.DisplayType result = sut.getType(fld);

        System.assertEquals(Schema.DisplayType.String, result);
    }

    private static testMethod void it_should_get_picklist() {
        string objectName = 'Tm_Service_Request__c';
        string fieldName = 'Product__c';
        Schema.SObjectField fld = sut.getField(objectName, fieldName);

        List<Schema.PicklistEntry> result = sut.getPicklist(fld);

        System.assert( result.size() > 0);
    }

    private static testMethod void it_should_validate_field() {
        string objectName = 'Tm_Service_Request__c';
        string fieldName = 'Product__c';

        boolean result = sut.IsFieldValid(objectName, fieldName);

        System.assertEquals(true ,result);
    }

    private static testMethod void it_should_check_if_field_is_updatable_code_coverage() {
        string objectName = 'Tm_Service_Request__c';
        string fieldName = 'Product__c';
        Schema.SObjectField fld = sut.getField(objectName, fieldName);

        boolean result =  sut.IsFieldUpdatable(fld);

        //System.assertEquals(true ,result);
    }
    
    private static testMethod void it_should_convert_a_number_to_date() {
        Decimal dtInt = Decimal.valueOf('1505952000000');
        DateTime dt =  DateTime.newInstance(1970, 1, 1);
        DateTime dt2 = dt.addSeconds((Integer)(dtInt/1000));

        System.assertEquals(2017, dt2.year());
        System.assertEquals(9, dt2.month());
        System.assertEquals(21, dt2.day());
    }

    private static testMethod void it_should_produce_boolean() {

    	String sValue = '';

    	Boolean result = String.IsBlank(sValue)  ?  false : Boolean.valueOf(sValue);
    	System.assertEquals(false, result);
    }

    private static testMethod void it_should_create_a_multiplist() {
        Object obj = (Object) new List<String>{'one', 'two'};
        //String sValue = String.valueOf(obj);

        List<String> result = (List<String>)obj;

        System.assertEquals(2, result.size());
        System.assertEquals('one', result[0]);
        System.assertEquals('two', result[1]);
    }


}