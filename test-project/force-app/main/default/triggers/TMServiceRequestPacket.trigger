trigger TMServiceRequestPacket on TM_Service_Request_Packet__c (after delete, after insert, after update, before delete, before insert, before update) {
    TriggerFactory.createHandler(TM_Service_Request_Packet__c.sObjectType);
}