@isTest
public class ProspectToClientMergerTests {
    
    private static testMethod void it_should_call_merge_on_the_data_provider_with_the_given_prospect_and_client(){
    	MockOfDataProvider mockDataProvider = new MockOfDataProvider();
    	ProspectToClientMerger sut = new ProspectToClientMerger(mockDataProvider);
    	Account testProspect = new Account(Id='001a000000QRNzD', Name='Test Prospect');
    	Account testClient = new Account(Id='001a000000QRNyF', Name='Test Client');
    	
    	sut.mergeProspectAndClient(testProspect, testClient);
    	
    	System.assertEquals(testProspect.Id, mockDataProvider.mergeEntities_Param_masterRecord.Id);
        System.assertEquals(testClient.Id, mockDataProvider.mergeEntities_Param_slaveRecord.Id);
    }
    
    private static testMethod void it_should_retain_selected_client_information_after_merging(){
        MockOfDataProvider mockDataProvider = new MockOfDataProvider();
        ProspectToClientMerger sut = new ProspectToClientMerger(mockDataProvider);
        Account testProspect = new Account(Id='001a000000QRNzD', Name='Test Prospect', RecordTypeId=Utility.recordTypeObject('Account','Prospect').Id);
        Account testClient = new Account(Id='001a000000QRNyF', Name='Test Client', RecordTypeId=Utility.recordTypeObject('Account','Client').Id);
        testClient.TIN_SSN__c = '11111';
        testClient.EB_Customer_Number__c = '22222';
        testClient.EB_Client_Name__c = '33333';
        testClient.BillingStreet = '444444';
        testClient.BillingState = '555555';
        testClient.BillingPostalCode = '66666';
        testClient.BillingCountry = '777777';
        testClient.Phone = '88888';
        testClient.SSNTIN_Encrypted__c = '99999';
        
        sut.mergeProspectAndClient(testProspect, testClient);
        
        Account prospectSentToMerge = mockDataProvider.mergeEntities_Param_masterRecord;        
        System.assertEquals(prospectSentToMerge.Id, testProspect.Id);
        System.assertEquals(prospectSentToMerge.RecordTypeId, Utility.recordTypeObject('Account','Client').Id);
        System.assertEquals(prospectSentToMerge.TIN_SSN__c, testClient.TIN_SSN__c);
        System.assertEquals(prospectSentToMerge.EB_Customer_Number__c, testClient.EB_Customer_Number__c);
        System.assertEquals(prospectSentToMerge.EB_Client_Name__c, testClient.EB_Client_Name__c);
        System.assertEquals(prospectSentToMerge.BillingStreet, testClient.BillingStreet);
        System.assertEquals(prospectSentToMerge.BillingState, testClient.BillingState);
        System.assertEquals(prospectSentToMerge.BillingPostalCode, testClient.BillingPostalCode);
        System.assertEquals(prospectSentToMerge.BillingCountry, testClient.BillingCountry);
        System.assertEquals(prospectSentToMerge.BillingCity, testClient.BillingCity);
        System.assertEquals(prospectSentToMerge.Phone, testClient.Phone);
        System.assertEquals(prospectSentToMerge.SSNTIN_Encrypted__c, testClient.SSNTIN_Encrypted__c);
        System.assertEquals(prospectSentToMerge.Import_Source__c, 'Prospect Promoted To Client');
    }
    
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
}