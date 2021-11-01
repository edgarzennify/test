@isTest
public class TmServiceRequestPacketDataProviderTests {
    private static final TmServiceRequestPacketDataProvider sut; 
    
    static{
        sut = new TmServiceRequestPacketDataProvider(); 
    }    
    
    static testMethod void it_should_call_all_fields_in_getTmServiceRequestsByPacket_to_verify_soql(){
        //assemble
        Tm_Service_Request_Packet__c tmPacket1 = new Tm_Service_Request_Packet__c();
                
        Tm_Service_Request_Packet__c tmPacket2 = new Tm_Service_Request_Packet__c();
        insert new List<SObject>{tmPacket1,tmPacket2};
        
        Tm_Service_Request__c req1 = new Tm_Service_Request__c();
        req1.TM_Service_Request_Packet__c = tmPacket1.Id;        
        
        Tm_Service_Request__c req2 = new Tm_Service_Request__c();
        req2.TM_Service_Request_Packet__c = tmPacket2.Id;
        insert new List<SObject> {req1, req2};
        
        List<Id> packetIds = new List<Id>{tmPacket1.Id};
        
        //act
        List<Tm_Service_Request__c> results = sut.getTmServiceRequestsByPacket(packetIds); 
        //assert
        system.assertEquals(1, results.size());
        Object fieldInResult = results[0].Id;
        fieldInResult = results[0].Tm_Service_Request_Packet__c;
        fieldInResult = results[0].Tm_Service_Request_Packet__r.Client_Type__c;
        fieldInResult = results[0].Tm_Service_Request_Packet__r.Bundle_Type__c;
        fieldInResult = results[0].RecordType.Name;
        
    }
}