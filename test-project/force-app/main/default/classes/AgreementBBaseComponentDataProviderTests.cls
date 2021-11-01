@IsTest
private class AgreementBBaseComponentDataProviderTests{
    
    static testMethod void it_should_be_able_to_save_a_component(){
        Agreement__c testAgreement = new Agreement__c(Name = 'Test Agreement');
        insert testAgreement;
        Agreement_Borrowing_Base_Relationship__c bbrel = new Agreement_Borrowing_Base_Relationship__c(Agreement__c = testAgreement.Id);        
 
        AgreementBBaseComponentDataProvider bbDataProvider = new AgreementBBaseComponentDataProvider();                
        bbDataProvider.SaveComponent(bbrel);
        
        //assert insert
        system.assertEquals(true, bbrel.Id != NULL);
        
        bbrel.Amount__c = 1000.00;
        bbDataProvider.SaveComponent(bbrel);
        
        //assert update
        system.assertEquals(true,bbrel.Amount__c == 1000.00);
        
    }
    @IsTest
    private static void it_should_save_componentEntities(){
        Account entity = ObjectFactory.getValidEntity('test entity');
        Agreement__c testAgreement = new Agreement__c(Name = 'Test Agreement');
        insert testAgreement;
        Agreement_Borrowing_Base_Relationship__c bbrel = new Agreement_Borrowing_Base_Relationship__c(Agreement__c = testAgreement.Id);
        insert bbrel;
        Agreement_Borrowing_Base_Entity_Rel__c bbeRel = new Agreement_Borrowing_Base_Entity_Rel__c(Agreement_Related_Borrowing_Base__c =bbrel.Id,  Entity__c = entity.Id);
        List<Agreement_Borrowing_Base_Entity_Rel__c> bbeRelList = new List<Agreement_Borrowing_Base_Entity_Rel__c>{bbeRel};
        
        AgreementBBaseComponentDataProvider bbDataProvider = new AgreementBBaseComponentDataProvider();                
        bbDataProvider.InsertComponentEntities(bbeRelList);
        
        system.assertEquals(true, bbeRelList.get(0).Id != null);            
    }
    @IsTest
    private static void it_should_be_able_to_delete_a_Component(){
        Agreement__c testAgreement = new Agreement__c(Name = 'Test Agreement');
        insert testAgreement;
        Agreement_Borrowing_Base_Relationship__c bbrel = new Agreement_Borrowing_Base_Relationship__c(Agreement__c = testAgreement.Id);        
        insert bbrel;
        
        AgreementBBaseComponentDataProvider bbDataProvider = new AgreementBBaseComponentDataProvider();                
        bbDataProvider.DeleteComponent(bbrel);
        system.assertEquals(true, [SELECT Id FROM Agreement_Borrowing_Base_Relationship__c WHERE id =:bbrel.Id].size() == 0);       
        
    }
    @IsTest
    private static void it_should_be_able_to_delete_ComponentEntities(){
        Account entity = ObjectFactory.getValidEntity('test entity');
        Agreement__c testAgreement = new Agreement__c(Name = 'Test Agreement');
        insert testAgreement;
        Agreement_Borrowing_Base_Relationship__c bbrel = new Agreement_Borrowing_Base_Relationship__c(Agreement__c = testAgreement.Id);
        insert bbrel;
        Agreement_Borrowing_Base_Entity_Rel__c bbeRel = new Agreement_Borrowing_Base_Entity_Rel__c(Agreement_Related_Borrowing_Base__c =bbrel.Id,  Entity__c = entity.Id);
        List<Agreement_Borrowing_Base_Entity_Rel__c> bbeRelList = new List<Agreement_Borrowing_Base_Entity_Rel__c>{bbeRel};
        insert bbeRelList;
        AgreementBBaseComponentDataProvider bbDataProvider = new AgreementBBaseComponentDataProvider();                
        bbDataProvider.DeleteComponentEntities(bbeRelList);
        
        system.assertEquals(true, [SELECT Id FROM Agreement_Borrowing_Base_Entity_Rel__c WHERE id in:bbeRelList].size() == 0); 
    }
    @IsTest
    private static void it_should_get_a_list_of_bbrelationships_for_agreementId(){
        Agreement__c testAgreement = new Agreement__c(Name = 'Test Agreement');
        insert testAgreement;
        Agreement_Borrowing_Base_Relationship__c bbrel = new Agreement_Borrowing_Base_Relationship__c(Agreement__c = testAgreement.Id);
        insert bbrel;
        
        AgreementBBaseComponentDataProvider bbDataProvider = new AgreementBBaseComponentDataProvider();                
        List<Agreement_Borrowing_Base_Relationship__c> bbrelList = bbDataProvider.GetBorrowingBaseComponents(testAgreement.Id);
        
    	system.assertEquals(true, bbrelList.size() == 1);
    
    }
    @IsTest
    private static void it_should_get_a_bbrelationship_for_an_agreementId(){
        Agreement__c testAgreement = new Agreement__c(Name = 'Test Agreement');
        insert testAgreement;
        Agreement_Borrowing_Base_Relationship__c bbrel = new Agreement_Borrowing_Base_Relationship__c(Agreement__c = testAgreement.Id);
        insert bbrel;
        
        AgreementBBaseComponentDataProvider bbDataProvider = new AgreementBBaseComponentDataProvider(); 
        Agreement_Borrowing_Base_Relationship__c bbrelreturn = bbDataProvider.GetBorrowingBaseComponent(bbrel.Id);
        
        system.assertEquals(true,bbrelreturn.Id == bbrel.Id);
    }

    @IsTest
    private static void it_should_get_a_map_of_relationship_for_agreementId(){
        Account entity = ObjectFactory.getValidEntity('test entity');
        Agreement__c testAgreement = new Agreement__c(Name = 'Test Agreement', Borrower_Name__c = entity.Id);
        insert testAgreement;
        Agreement_Client_Relationships__c testClientrel = new Agreement_Client_Relationships__c(Agreement__c = testAgreement.Id,Entity__c = entity.Id);
        insert testClientrel;
        
        AgreementBBaseComponentDataProvider bbDataProvider = new AgreementBBaseComponentDataProvider(); 
        Map<Id,Agreement_Client_Relationships__c> relMap =  bbDataProvider.GetAgreementClientRelationships(testAgreement.Id);
        
        system.assertEquals(true, relMap.values().size() == 1); 
    }
    
    @IsTest
    private static void it_should_get_the_bbentity_relationships_for_a_bbId(){
        Account entity = ObjectFactory.getValidEntity('test entity');
        Agreement__c testAgreement = new Agreement__c(Name = 'Test Agreement', Borrower_Name__c = entity.Id);
        insert testAgreement;
        Agreement_Borrowing_Base_Relationship__c bbrel = new Agreement_Borrowing_Base_Relationship__c(Agreement__c = testAgreement.Id);
        insert bbrel;
        Agreement_Borrowing_Base_Entity_Rel__c bbentity = new Agreement_Borrowing_Base_Entity_Rel__c(Agreement_Related_Borrowing_Base__c = bbrel.Id,entity__c = entity.Id);
        insert bbentity;
        
        AgreementBBaseComponentDataProvider bbDataProvider = new AgreementBBaseComponentDataProvider();
        List<Agreement_Borrowing_Base_Entity_Rel__c> bbentityList = bbDataProvider.CurrentComponentEntityRelationshipList(bbrel.Id);
        
        system.assert(bbentityList.size() == 1);
        
    }

         

}