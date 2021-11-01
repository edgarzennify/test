@IsTest
private class OpportunityRecordTypeChangeTests {
	
	private static final MockOfIOpportunityRecordTypeChangeDataProv mockDataProv;
	private static final Opportunity testOpportunity;
	private static final List<RecordType> testRecordTypes;
	private static final OpportunityRecordTypeChange sut;

	static {
		mockDataProv = new MockOfIOpportunityRecordTypeChangeDataProv();
		testRecordTypes = new List<RecordType>();
		testRecordTypes.add(new RecordType(Id='012300000000000AAA', Name='FirstRecordType'));
		testRecordTypes.add(new RecordType(Id='012300000000001AAA', Name='SecondRecordType'));
		mockDataProv.setup('getRecordTypesForOpportunityObject').returns(testRecordTypes);
		testOpportunity = new Opportunity(Id=ObjectFactory.getFakeId(Opportunity.SObjectType, '1'), Name='myTestOpp');
		sut = new OpportunityRecordTypeChange(testOpportunity, mockDataProv);
	}

	@IsTest
    static void it_should_call_the_default_constructor_without_error() {
		ApexPages.currentPage().getParameters().put('Id', testOpportunity.Id);
       	ApexPages.StandardController sc = new ApexPages.StandardController(testOpportunity);
		OpportunityRecordTypeChange sutDef = new OpportunityRecordTypeChange(sc);
	}

	@IsTest
    static void it_should_initialize_opportunity_record_type_selection_list_from_call_to_data_prov() {
		mockDataProv.verify('getRecordTypesForOpportunityObject', Times.Once);
		System.assertEquals(2, sut.opportunityRecordTypes.size());
		System.assertEquals('012300000000000AAA', sut.opportunityRecordTypes[0].getValue());
		System.assertEquals('FirstRecordType', sut.opportunityRecordTypes[0].getLabel());
		System.assertEquals('012300000000001AAA', sut.opportunityRecordTypes[1].getValue());
		System.assertEquals('SecondRecordType', sut.opportunityRecordTypes[1].getLabel());
	}

	@IsTest
    static void it_should_make_call_to_data_provider_to_update_opportunity_and_return_url_back_to_opp() {
		PageReference returnURL = sut.save();

		mockDataProv.verify('updateOpportunity', new List<Object>{testOpportunity}, Times.Once);
		System.assert(true, returnURL.getUrl().contains(testOpportunity.Id));
	}

	@IsTest
    static void it_should_not_make_a_call_to_update_and_return_url_back_to_opportunity() {
		PageReference returnURL = sut.cancel();

		mockDataProv.verify('updateOpportunity', new List<Object>{testOpportunity}, Times.Never);
		System.assert(true, returnURL.getUrl().contains(testOpportunity.Id));
	}

	private class MockOfIOpportunityRecordTypeChangeDataProv extends ApexMoq implements OpportunityRecordTypeChange.IOpportunityRecordTypeChangeDataProv {
		public List<RecordType> getRecordTypesForOpportunityObject(){
			return (List<RecordType>)handleMethodInvocation('getRecordTypesForOpportunityObject');
		}
		public void updateOpportunity(Opportunity opp){
			handleMethodInvocation('updateOpportunity', new List<Object>{opp});
		}
	}
}