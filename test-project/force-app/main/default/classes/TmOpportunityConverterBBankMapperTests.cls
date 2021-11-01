@IsTest
private class TmOpportunityConverterBBankMapperTests{

	private static TmOpportunityConverterBusinessBankMapper sut;
	private static  TmOpportunityConverterMock.ofIConfiguration mockConfigs;

	static{
		mockConfigs = new TmOpportunityConverterMock.ofIConfiguration();
		sut = new TmOpportunityConverterBusinessBankMapper(mockConfigs);
	}

	private static testMethod void it_should_call_the_config_to_handle_handler_type(){
		mockConfigs.setup('OPP_RECORDTYPE_BUSINESS_BANKING').returns('test');

		String result = sut.handle();

		System.assertEquals('test' ,result);
	}

	private static testMethod void it_should_call_the_update_tm_method_to_update_business_banking_field(){
		DmOpportunity oppDm = new DmOpportunity();
		TM_Service_Request__c request = new TM_Service_Request__c();

		TM_Service_Request__c result =  sut.updateTmObject( request,  oppDm);

		System.assertEquals(true, result.Business_Banking__c);
	}
}