@isTest
private class AgreementClientRelationshipTrigHelpTests {

    public static testMethod void testAgreementTriggerHelper(){
	    //create an Agreement
	    Agreement__c agmt = objectfactory.getAgreement('Prospective', 'Borrower Name_1', 'TEST TEST');   
	    //create an Entity
	    EB_Unit__c branch = objectFactory.getUnit('testBranch', 4001);
	    EB_Team_Member__c team = objectFactory.getTeamMember('Team1');
	    Id ClientRecordTypeId = objectFactory.getRecordTypeIdByNameAndObject('Client', 'Account');
	    Account entity = objectFactory.getEntity('Borrower Name_1',ClientRecordTypeId, team);
	         
	    Agreement_Client_Relationships__c newAgreementClientRelationship =  objectFactory.getAgreementClientRelationships('Co-Borrower',agmt, entity);
	    newAgreementClientRelationship.A_P_Detailed_Agings__c = 'Yes';
	    newAgreementClientRelationship.A_P_Detailed_Agings_Frequency__c = 'Monthly';
	    newAgreementClientRelationship.A_P_Detailed_Agings_Period_Due__c = '30';
	    system.debug('#### ' + newAgreementClientRelationship.name);
	    update newAgreementClientRelationship;
    }

    public static testMethod void it_should_update_the_includedBorrowers_field_with_only_the_borrowers_when_a_bulk_update_is_done(){
    	Account entity1 = ObjectFactory.getValidEntity('testEntity1');
    	Account entity2 = ObjectFactory.getValidEntity('testEntity2');
    	Account entity3 = ObjectFactory.getValidEntity('testEntity3');
    	Account entity4 = ObjectFactory.getValidEntity('testEntity4');
    	Account entity5 = ObjectFactory.getValidEntity('testEntity5');
    	Account entity6 = ObjectFactory.getValidEntity('testEntity6');    	
    	
    	Agreement__c testAgreement1 = new Agreement__c(Name = 'testAgreement1' ,Borrower_Name__c = entity1.Id);
    	insert testAgreement1;
    	Agreement__c testAgreement2 = new Agreement__c(Name = 'testAgreement2' ,Borrower_Name__c = entity2.Id);
    	insert testAgreement2;
    	Agreement__c testAgreement3 = new Agreement__c(Name = 'testAgreement3' ,Borrower_Name__c = entity3.Id);
    	insert testAgreement3;
    	Agreement__c testAgreement4 = new Agreement__c(Name = 'testAgreement4' ,Borrower_Name__c = entity4.Id);
    	insert testAgreement4;
    	Agreement__c testAgreement5 = new Agreement__c(Name = 'testAgreement5' ,Borrower_Name__c = entity5.Id);
    	insert testAgreement5;
    	Agreement__c testAgreement6 = new Agreement__c(Name = 'testAgreement6' ,Borrower_Name__c = entity6.Id);
    	insert testAgreement6;  
    	
    	Agreement_Client_Relationships__c testClientRel1 = new Agreement_Client_Relationships__c(entity__c = entity1.Id, Agreement__c = testAgreement1.Id, Relationship__c = 'Primary Borrower');
    	insert testClientRel1;
    	Agreement_Client_Relationships__c testClientRel2 = new Agreement_Client_Relationships__c(entity__c = entity2.Id, Agreement__c = testAgreement2.Id , Relationship__c = 'Guarantor');
    	insert testClientRel2;
    	Agreement_Client_Relationships__c testClientRel3 = new Agreement_Client_Relationships__c(entity__c = entity3.Id, Agreement__c = testAgreement3.Id , Relationship__c = 'Guarantor');
    	insert testClientRel3;
    	Agreement_Client_Relationships__c testClientRel4 = new Agreement_Client_Relationships__c(entity__c = entity4.Id, Agreement__c = testAgreement4.Id, Relationship__c = 'Guarantor');
    	insert testClientRel4;
		Agreement_Client_Relationships__c testClientRel5 = new Agreement_Client_Relationships__c(entity__c = entity5.Id, Agreement__c = testAgreement5.Id, Relationship__c = 'Guarantor');
    	insert testClientRel5;
    	Agreement_Client_Relationships__c testClientRel6 = new Agreement_Client_Relationships__c(entity__c = entity6.Id, Agreement__c = testAgreement6.Id, Relationship__c = 'Guarantor');
    	insert testClientRel6;
    	
    	List<Agreement_Client_Relationships__c> updateAgmtClients = new List<Agreement_Client_Relationships__c>();
    	updateAgmtClients.add(testClientRel1);
    	updateAgmtClients.add(testClientRel2);
    	updateAgmtClients.add(testClientRel3);
    	updateAgmtClients.add(testClientRel4);
    	updateAgmtClients.add(testClientRel5);
    	updateAgmtClients.add(testClientRel6);
    	
    	test.startTest();
    	update updateAgmtClients;
    	test.stopTest();
    	
    	Agreement__c reQuerytestAgmt6 = [SELECT Id, Related_Borrower__c, Name FROM Agreement__c WHERE id=: testAgreement6.Id];
    	system.assertEquals('testEntity6 (Guarantor)' , reQuerytestAgmt6.Related_Borrower__c); 
    } 
}