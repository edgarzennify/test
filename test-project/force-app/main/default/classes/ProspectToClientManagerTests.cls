@isTest
public class ProspectToClientManagerTests {
	
	private static testMethod void it_should_query_the_data_provider_for_the_entities_from_the_provided_mappings_list(){
        MockOfDataProvider mockDataProvider = new MockOfDataProvider();
        MockOfMerger mockMerger = new MockOfMerger();
        ProspectToClientManager sut = new ProspectToClientManager(mockDataProvider,mockMerger);
        
        ProspectToClient.ProspectToClientMapping mapping1 = new ProspectToClient.ProspectToClientMapping();
        mapping1.prospectId = '001a000000QRNzD';
        mapping1.clientId = '001a000000QRNyF';
        ProspectToClient.ProspectToClientMapping mapping2 = new ProspectToClient.ProspectToClientMapping();
        mapping2.prospectId = '001a000000QRNzB';
        mapping2.clientId = '001a000000QRNzC';
        
        sut.promoteProspectsToClients(new List<ProspectToClient.ProspectToClientMapping> {mapping1, mapping2});
        
        System.assertEquals(mapping1.prospectId, mockDataProvider.getEntities_Param_entityIds[0]);
        System.assertEquals(mapping1.clientId, mockDataProvider.getEntities_Param_entityIds[1]);
        System.assertEquals(mapping2.prospectId, mockDataProvider.getEntities_Param_entityIds[2]);
        System.assertEquals(mapping2.clientId, mockDataProvider.getEntities_Param_entityIds[3]);
	}
	
	private static testMethod void it_should_send_the_mapped_entities_to_the_merger(){
        MockOfDataProvider mockDataProvider = new MockOfDataProvider();
        MockOfMerger mockMerger = new MockOfMerger();
        ProspectToClientManager sut = new ProspectToClientManager(mockDataProvider,mockMerger);
        
        ProspectToClient.ProspectToClientMapping mapping1 = new ProspectToClient.ProspectToClientMapping();
        mapping1.prospectId = '001a000000QRNzD';
        mapping1.clientId = '001a000000QRNyF';
        
        Map<Id, Account> returnedMap = new Map<Id, Account>();
        returnedMap.put(mapping1.prospectId, new Account(Id='001a000000QRNzD', Name='Test Prospect'));
        returnedMap.put(mapping1.clientId, new Account(Id='001a000000QRNyF', Name='Test Entity'));
        mockDataProvider.getEntities_Return = returnedMap;
        
        sut.promoteProspectsToClients(new List<ProspectToClient.ProspectToClientMapping> {mapping1});
        
        System.assertEquals(mapping1.prospectId, mockMerger.mergeProspectAndClient_Param_prospect.Id);
        System.assertEquals(mapping1.clientId, mockMerger.mergeProspectAndClient_Param_client.Id);
	}
	
	/////////////////////////////////////////////////////////////////////////////////////////////////////////
	// integration tests
	/*private static testMethod void it_should_merge_related_lists_without_soql(){
		ProspectToClientDataProvider dataProvider = new ProspectToClientDataProvider();
        ProspectToClientManager sut = new ProspectToClientManager(dataProvider);
        
        Account testProspect = new Account(Name='Test Prospect');
        insert testProspect;
        Account testClient = new Account(Name='Test Client');
        insert testClient;
        Treasury_Management__c testClientTM = new Treasury_Management__c();
        testClientTM.Account__c = testClient.Id;
        testClientTM.TM_Conv_Master_Account_Number__c = '12345';
        testClientTM.Start_Date__c = Date.today();
        insert testClientTM;
        ProspectToClient.ProspectToClientMapping mapping1 = new ProspectToClient.ProspectToClientMapping();
        mapping1.prospectId = testProspect.Id;
        mapping1.clientId = testClient.Id;
        
        test.startTest();
        sut.promoteProspectsToClients(new List<ProspectToClient.ProspectToClientMapping> {mapping1});
        test.stopTest();

        List<Treasury_Management__c> requeryTM = [SELECT Id, TM_Conv_Master_Account_Number__c, Start_Date__c FROM Treasury_Management__c WHERE Account__c =: testProspect.Id];
        System.assertEquals(1, requeryTM.size());
        System.assertEquals('12345', requeryTM[0].TM_Conv_Master_Account_Number__c);
        System.assertEquals(Date.today(), requeryTM[0].Start_Date__c);
    }*/
	
	////////////////////////////////////////////////////////////////////////////////////////////
    
    private class MockOfDataProvider implements ProspectToClient.IProspectToClientDataProvider {
    	public Boolean getEntities_Called {get; private set;}
        public List<Id> getEntities_Param_entityIds {get; private set;}
        public Map<Id, Account> getEntities_Return {get; private set;}
        
        public Boolean mergeEntities_Called {get; private set;}
        public Account mergeEntities_Param_masterRecord {get; private set;}
        public Account mergeEntities_Param_slaveRecord {get; private set;}
    	
    	public Map<Id, Account> getEntities(List<Id> entityIds){
    		getEntities_Called = true;
    		getEntities_param_entityIds = entityIds;
            return getEntities_Return;
    	}
    	
    	public void mergeEntities(Account masterRecord, Account slaveRecord){
            mergeEntities_Called = true;
            mergeEntities_param_masterRecord = masterRecord;
            mergeEntities_param_slaveRecord = slaveRecord;
        }
    }
    private class MockOfMerger implements ProspectToClient.IProspectToClientMerger {
        public Boolean mergeProspectAndClient_Called {get; private set;}
        public Account mergeProspectAndClient_Param_prospect {get; private set;}
        public Account mergeProspectAndClient_Param_client {get; private set;}
        public Account mergeProspectAndClient_Return {get; private set;}
        
        public Account mergeProspectAndClient(Account prospect, Account client){
            mergeProspectAndClient_Called = true;
            mergeProspectAndClient_Param_prospect = prospect;
            mergeProspectAndClient_Param_client = client;
            return mergeProspectAndClient_Return;
        }
    }
}