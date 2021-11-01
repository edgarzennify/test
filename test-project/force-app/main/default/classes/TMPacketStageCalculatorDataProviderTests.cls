@IsTest
Private class TMPacketStageCalculatorDataProviderTests {

    private static final TMPacketStageCalculatorDataProvider sut;

	static{
		sut = new TMPacketStageCalculatorDataProvider();
	}
    
    @isTest
	static void it_should_return_all_requests_related_to_the_given_packets(){
		TM_Service_Request_Stage__c stage = new TM_Service_Request_Stage__c();
		stage.Name = 'test stage name 01';   
		insert stage;
		Tm_Service_Request_Packet__c packet01 = new Tm_Service_Request_Packet__c();
		Tm_Service_Request_Packet__c packet02 = new Tm_Service_Request_Packet__c();
		Tm_Service_Request_Packet__c packet03 = new Tm_Service_Request_Packet__c();
		List<Tm_Service_Request_Packet__c> packets = new List<Tm_Service_Request_Packet__c>{packet01,packet02,packet03};
		insert packets;
		Tm_Service_Request__c req01 = new Tm_Service_Request__c();
		req01.Stage__c = stage.Id;
		req01.TM_Service_Request_Packet__c = packet01.Id;
		Tm_Service_Request__c req02 = new Tm_Service_Request__c();
		req02.Stage__c = stage.Id;
		req02.TM_Service_Request_Packet__c = packet02.Id;
		Tm_Service_Request__c req03 = new Tm_Service_Request__c();
		req03.Stage__c = stage.Id;
		req03.TM_Service_Request_Packet__c = packet03.Id;
		List<Tm_Service_Request__c> reqs = new List<Tm_Service_Request__c>{req01,req02,req03};
		insert reqs;

		List<Id> parentIds = new List<Id>{packet01.Id,packet02.Id};
		//act
		List<Tm_Service_Request__c> results =  sut.getAllRequests(parentIds);
		//assert
		System.assert(!results.contains(req03));
		System.assertEquals(2 , results.size());
		Object soqlField;
		soqlField = results[0].Id;
		soqlField = results[0].Name;
		soqlField = results[0].RecordTypeId;
		soqlField = results[0].RecordType.Name;
		soqlField = results[0].Stage__c;
		soqlField = results[0].Stage__r.Id;
		soqlField = results[0].Stage__r.Name;
		soqlField = results[0].Stage__r.Type__c;
		soqlField = results[0].Stage__r.Permission__c;
		soqlField = results[0].TM_Service_Request_Packet__c;
		soqlField = results[0].TM_Service_Request_Packet__r.Id;
		soqlField = results[0].TM_Service_Request_Packet__r.Name;
		soqlField = results[0].TM_Service_Request_Packet__r.Opportunity__c;
	}
}