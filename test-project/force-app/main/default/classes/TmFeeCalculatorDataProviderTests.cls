@isTest
private class TmFeeCalculatorDataProviderTests {
    private static final TmFeeCalculatorDataProvider sut; 
    
    static{
        sut = new TmFeeCalculatorDataProvider();
    }    

    static testMethod void it_should_call_all_fields_in_getAllFees_to_verify_soql(){
        //assemble
        Tm_Fee__c fee = new Tm_Fee__c();
        insert fee;
        
        //act
        List<Tm_Fee__c> results = sut.getAllFees(); 
        //assert
        Object fieldInResult = results[0].Id;
        fieldInResult = results[0].Fee_Amount__c;
        fieldInResult = results[0].Fee_API_Name__c;
        fieldInResult = results[0].TM_Fee_Schedule__c;
        fieldInResult = results[0].Feature_Fee_Dependency__c;
        fieldInResult = results[0].TM_Fee_Schedule__r.TM_Product__r.Name;
        fieldInResult = results[0].TM_Fee_Schedule__r.bundle_type__c;
        fieldInResult = results[0].TM_Fee_Schedule__r.Client_type__c;
    }	
    static testMethod void it_should_call_all_fields_in_get_packets_to_verify_soql(){
        //assemble
        Tm_Service_Request_Packet__c packet = new Tm_Service_Request_Packet__c();
        insert packet;
        
        //act
        List<Tm_Service_Request_Packet__c> results = sut.getAllPackets(); 
        //assert
        Object fieldInResult = results[0].Id;
        fieldInResult = results[0].Client_Type__c;
        fieldInResult = results[0].Bundle_Type__c;
    }
    static testMethod void it_should_call_all_fields_in_getAllSchedules_to_verify_soql(){
        //assemble
        Tm_Fee_Schedule__c sched = new Tm_Fee_Schedule__c();
        insert sched;
        
        //act
        List<Tm_Fee_Schedule__c> results = sut.getAllSchedules(); 
        //assert
        Object fieldInResult = results[0].Id;
        fieldInResult = results[0].Client_Type__c;
        fieldInResult = results[0].Bundle_Type__c;
        fieldInResult = results[0].Tm_Product__c;
        fieldInResult = results[0].Tm_Product__r.Name;
       
    }
    static testMethod void it_should_call_all_fields_in_getAllProducts_to_verify_soql(){
        //assemble
        Tm_Product__c product = new Tm_Product__c();
        insert product;
        
        //act
        List<Tm_Product__c> results = sut.getAllProducts(); 
        //assert
        Object fieldInResult = results[0].Id;
        fieldInResult = results[0].Name;
       
    }
    static testMethod void it_should_call_all_fields_in_getAllRequests_to_verify_soql(){
        //assemble
        Tm_Service_Request_Packet__c tmPacket = new Tm_Service_Request_Packet__c();
        insert tmPacket;
        
        Tm_Service_Request__c req = new Tm_Service_Request__c();
        req.TM_Service_Request_Packet__c = tmPacket.Id;
        insert req;
        
        //act
        List<Tm_Service_Request__c> results = sut.getAllRequests(); 
        //assert
        Object fieldInResult = results[0].Id;
        fieldInResult = results[0].Tm_Service_Request_Packet__c;
        fieldInResult = results[0].Tm_Service_Request_Packet__r.Client_Type__c;
        fieldInResult = results[0].Tm_Service_Request_Packet__r.Bundle_Type__c;
       
    }
    static testMethod void it_should_call_all_fields_in_getAllStages_to_verify_soql(){
        //assemble
        TM_Service_Request_Stage__c stage = new TM_Service_Request_Stage__c();
        insert stage;
        
        //act
        List<TM_Service_Request_Stage__c> results = sut.getAllStages(); 
        //assert
        Object fieldInResult = results[0].Id;
        fieldInResult = results[0].Name;
       
    }
}