@IsTest
private class DescribeFieldResultWrapperTests {    
    private static testMethod void it_should_get_label_when_field_is_provided() {
        Schema.Describefieldresult fieldResult = Tm_Service_Request__c.International_Wires__c.getDescribe();
        
        DescribeFieldResultWrapper sut = new DescribeFieldResultWrapper(fieldResult);
        
        System.assertEquals('International Wires', sut.getLabel());
    }
    
    private static testMethod void it_should_get_name_when_field_is_provided() {
        Schema.Describefieldresult fieldResult = Tm_Service_Request__c.International_Wires__c.getDescribe();
        
        DescribeFieldResultWrapper sut = new DescribeFieldResultWrapper(fieldResult);
        
        System.assertEquals('International_Wires__c', sut.getName());
    }
    
    private static testMethod void it_should_get_help_text_when_field_is_provided() {
        Schema.Describefieldresult fieldResult = Tm_Service_Request__c.Portal_Display_Name__c.getDescribe();
        
        DescribeFieldResultWrapper sut = new DescribeFieldResultWrapper(fieldResult);
        
        String helpText = sut.getInlineHelpText();
        System.assert(String.isNotBlank(helpText));
    }
    
    private static testMethod void it_should_code_cover_access() {
        Schema.Describefieldresult fieldResult = Tm_Service_Request__c.Portal_Display_Name__c.getDescribe();    
        DescribeFieldResultWrapper sut = new DescribeFieldResultWrapper(fieldResult);
        Boolean check1 = sut.isUpdateable();
        Boolean check2 = sut.isCreateable();
        Boolean check3 = sut.isCalculated();
        Boolean check4 = sut.isAccessible();
        List<IPicklistEntry> picklistItems = sut.getPicklistValues();
        DescribeFieldResultWrapper.Type getType = sut.getType();
    }
    
}