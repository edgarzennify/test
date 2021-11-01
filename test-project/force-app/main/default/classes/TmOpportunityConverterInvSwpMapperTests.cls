@IsTest
private class TmOpportunityConverterInvSwpMapperTests {
    
	private static TmOpportunityConverterInvSweepMapper sut;
    private static final TmOpportunityConverterMock.ofIConfiguration mockConfig;
    
    static {
       mockConfig = new TmOpportunityConverterMock.ofIConfiguration();
       sut = new TmOpportunityConverterInvSweepMapper(mockConfig);
    }

    @IsTest
    static void it_should_handle_inv_sweep_recordtype() {
    	mockConfig.setup('RECORDTYPE_INVESTMENT_SWEEP').returns('Inv-Sweep');

    	String result = sut.handle();

    	System.assertEquals('Inv-Sweep', result);
    }

    @IsTest
    static void it_should_update_a_tm_object() {
    	TM_Service_Request__c request = new TM_Service_Request__c();
    	String subProduct1 = 'Goldman Sachs';
    	String subProduct2 = 'Money Market';
    	String subProduct3 = 'Optima Plus';
    	String subProduct4 = 'Repo';
    	List<string> opportunityProducts = new List<String>{subProduct1, subProduct2, subProduct3, subProduct4};
    	Set<string> subProductsByProduct = new Set<String>(new List<String>{subProduct1, subProduct2, subProduct3, subProduct4});
    	mockConfig.setup('SUBTYPE_INVESTMENT_SWEEP_GOLDMAN_SACHS').returns(subProduct1);
    	mockConfig.setup('SUBTYPE_INVESTMENT_SWEEP_MONEY_MARKET').returns(subProduct2);
    	mockConfig.setup('SUBTYPE_INVESTMENT_SWEEP_OPTIMA_PLUS').returns(subProduct3);
    	mockConfig.setup('SUBTYPE_INVESTMENT_SWEEP_REPO').returns(subProduct4);

    	Tm_Service_Request__c result = sut.updateTmObject(request, opportunityProducts, subProductsByProduct);
    	
    	mockConfig.verify('SUBTYPE_INVESTMENT_SWEEP_GOLDMAN_SACHS', Times.Once);
    	mockConfig.verify('SUBTYPE_INVESTMENT_SWEEP_MONEY_MARKET', Times.Once);
    	mockConfig.verify('SUBTYPE_INVESTMENT_SWEEP_OPTIMA_PLUS', Times.Once);
    	mockConfig.verify('SUBTYPE_INVESTMENT_SWEEP_REPO', Times.Once);
    }
}