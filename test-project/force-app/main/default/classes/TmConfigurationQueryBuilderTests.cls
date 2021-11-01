@IsTest
private class TmConfigurationQueryBuilderTests {
	private static final TmConfigurationQueryBuilder sut;
    
    static {
        sut = new TmConfigurationQueryBuilder();
    }
    
    private static testMethod void it_should_add_required_fields_to_requests() {
        List<String> fields = new List<string>{'Name'};
        
        List<string> result = sut.addRequiredRequestFields(fields);
        
        System.assertEquals(13, result.size());
    }
    
    private static testMethod void it_should_add_required_fields_to_contacts() {
        List<String> fields = new List<string>{'Name'};
        
        List<string> result = sut.addRequiredContactFields(fields);
        
        System.assertEquals(5, result.size());
    }
    
    private static testMethod void it_should_add_required_fields_to_accounts() {
        List<String> fields = new List<string>{'Name'};
        
        List<string> result = sut.addRequiredAccountFields(fields);
        
        System.assertEquals(8, result.size());
    }
    
    private static testMethod void it_should_add_required_fields_in_request_contacts() {
        List<String> fields = new List<String>{'Name'};
            
        List<String> result = sut.addRequiredContactRequestFields(fields);
        
        System.assertEquals(6, result.size());
    }
    
    private static testMethod void it_should_add_required_fields_in_request_accounts() {
        List<String> fields = new List<String>{'Name'};
            
        List<String> result = sut.addRequiredAccountRequestFields(fields);
        
        System.assertEquals(12, result.size());
    }
    
    private static testMethod void it_should_add_required_fields_in_request_contact_accounts() {
        List<String> fields = new List<String>{'Name'};
            
        List<String> result = sut.addRequiredContactAccountFields(fields);
        
        System.assertEquals(20, result.size());
    }
}