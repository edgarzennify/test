@isTest
public class ProspectToClientDataProviderTests {
	private static testMethod void it_should_merge_related_lists_without_soql(){
		ProspectToClientDataProvider sut = new ProspectToClientDataProvider();
		
		Account testProspect = new Account(Name='Test Prospect');
		insert testProspect;
		Account testClient = new Account(Name='Test Client');
		insert testClient;
		Treasury_Management__c testClientTM = new Treasury_Management__c();
		testClientTM.Account__c = testClient.Id;
		testClientTM.TM_Conv_Master_Account_Number__c = '12345';
		testClientTM.Start_Date__c = Date.today();
		insert testClientTM;
		
		sut.mergeEntities(testProspect, testClient);

        List<Treasury_Management__c> requeryTM = [SELECT Id, TM_Conv_Master_Account_Number__c, Start_Date__c FROM Treasury_Management__c WHERE Account__c =: testProspect.Id];
        System.assertEquals(1, requeryTM.size());
        System.assertEquals('12345', requeryTM[0].TM_Conv_Master_Account_Number__c);
        System.assertEquals(Date.today(), requeryTM[0].Start_Date__c);
    }
}