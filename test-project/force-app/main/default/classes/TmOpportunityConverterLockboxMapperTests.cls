@IsTest
private class TmOpportunityConverterLockboxMapperTests {
	
    private static TmOpportunityConverterLockboxMapper sut;
    private static final TmOpportunityConverterMock.ofIConfiguration mockConfig;
    
    static {
    	mockConfig = new TmOpportunityConverterMock.ofIConfiguration();
        sut = new TmOpportunityConverterLockboxMapper(mockConfig);
    }

    @IsTest
    static void it_should_call_the_handle_method_and_get_handled_record_type() {
    	mockConfig.setup('RECORDTYPE_LOCKBOX').returns('Lockbox');

    	String result = sut.handle();

    	System.assertEquals('Lockbox', result);
    }

    @IsTest
    static void it_should_update_the_tm_service_request_to_mapped_field() {
    	String subProduct1 = 'Lockbox1';
    	String subProduct2 = 'Lockbox2';
    	String subProduct3 = 'Lockbox3';
    	TM_Service_Request__c request = new TM_Service_Request__c();
    	List<string> opportunityProducts = new List<String>{subProduct1, subProduct2, subProduct3};
    	Set<string> subProductsByProduct = new Set<String>(new List<String>{subProduct1, subProduct2, subProduct3});
    	mockConfig.setup('SUBTYPE_LOCKBOX_DATA_ENTRY_MODULE').returns(subProduct1);
    	mockConfig.setup('SUBTYPE_LOCKBOX_DATA_EXTRACT_MODULE').returns(subProduct2);
    	mockConfig.setup('SUBTYPE_LOCKBOX_DATA_REMITTANCE_MODULE').returns(subProduct3);

    	Tm_Service_Request__c result =  sut.updateTmObject(request, opportunityProducts, subProductsByProduct);
    
    	mockConfig.verify('SUBTYPE_LOCKBOX_DATA_ENTRY_MODULE', Times.Once);
    	mockConfig.verify('SUBTYPE_LOCKBOX_DATA_EXTRACT_MODULE', Times.Once);
    	mockConfig.verify('SUBTYPE_LOCKBOX_DATA_REMITTANCE_MODULE', Times.Once);

    	System.assertEquals(true, result.Data_Entry__c);
    	System.assertEquals(true, result.Data_Extract__c);
    	System.assertEquals(true, result.Remittance_Imaging__c);
    }
}