@IsTest
private class TmBoardingInputTypeVmBuilderTests {
	
    private static TmBoardingInputTypeVmBuilder sut;
    
    static {
        sut = new TmBoardingInputTypeVmBuilder();
    }
    
    private static testMethod void it_should_get_a_phone_when_field_type_is_phone() {
        String overrideType = '';
        DescribeFieldResultWrapper.Type fieldType = DescribeFieldResultWrapper.Type.TypePhone;
            
        String result = sut.build(fieldType, overrideType);
        
        System.assertEquals('Phone', result);
    }
    
    private static testMethod void it_should_get_a_phone_when_field_type_is_text_area() {
        String overrideType = '';
        DescribeFieldResultWrapper.Type fieldType = DescribeFieldResultWrapper.Type.TypeTextArea;
            
        String result = sut.build(fieldType, overrideType);
        
        System.assertEquals('TextArea', result);
    }
    
    private static testMethod void it_should_get_a_phone_when_field_type_is_currency() {
        String overrideType = '';
        DescribeFieldResultWrapper.Type fieldType = DescribeFieldResultWrapper.Type.TypeCurrency;
            
        String result = sut.build(fieldType, overrideType);
        
        System.assertEquals('Currency', result);
    }
    
    private static testMethod void it_should_get_a_phone_when_field_type_is_date() {
        String overrideType = '';
        DescribeFieldResultWrapper.Type fieldType = DescribeFieldResultWrapper.Type.TypeDate;
            
        String result = sut.build(fieldType, overrideType);
        
        System.assertEquals('Date', result);
    }
    
    private static testMethod void it_should_get_a_phone_when_field_type_is_integer() {
        String overrideType = '';
        DescribeFieldResultWrapper.Type fieldType = DescribeFieldResultWrapper.Type.TypeInteger;
            
        String result = sut.build(fieldType, overrideType);
        
        System.assertEquals('Numeric', result);
    }
    
    private static testMethod void it_should_get_a_phone_when_field_type_is_dropdown() {
        String overrideType = '';
        DescribeFieldResultWrapper.Type fieldType = DescribeFieldResultWrapper.Type.TypePicklist;
            
        String result = sut.build(fieldType, overrideType);
        
        System.assertEquals('Dropdown', result);
    }
    
    private static testMethod void it_should_get_a_phone_when_field_type_is_checkbox() {
        String overrideType = '';
        DescribeFieldResultWrapper.Type fieldType = DescribeFieldResultWrapper.Type.TypeBoolean;
            
        String result = sut.build(fieldType, overrideType);
        
        System.assertEquals('Checkbox', result);
    }
    
    private static testMethod void it_should_get_a_phone_when_field_type_is_multipicklist() {
        String overrideType = '';
        DescribeFieldResultWrapper.Type fieldType = DescribeFieldResultWrapper.Type.TypeMultipicklist;
            
        String result = sut.build(fieldType, overrideType);
        
        System.assertEquals('MultiPicklist', result);
    }
    
    private static testMethod void it_should_get_a_phone_when_field_type_is_blank() {
        String overrideType = '';
        DescribeFieldResultWrapper.Type fieldType = null;
            
        String result = sut.build(fieldType, overrideType);
        
        System.assertEquals('Blank', result);
    }
}