public class TMPacketStageCalculatorDataProvider implements TMPacketStageCalculator.ITMPacketStageCalculatorDataProvider {
    
    public List<Tm_Service_Request__c> getAllRequests(List<Id> parentIds){
        return [
                SELECT
                    Id
                    ,Name
                    ,RecordTypeId
                    ,RecordType.Name
                    ,Stage__c
                    ,Stage__r.Id
                    ,Stage__r.Name
                    ,Stage__r.Type__c
                    ,Stage__r.Permission__c
                    ,TM_Service_Request_Packet__c
                    ,TM_Service_Request_Packet__r.Id
                    ,TM_Service_Request_Packet__r.Name
                    ,TM_Service_Request_Packet__r.Opportunity__c
                    ,TM_Service_Request_Packet__r.Stage__c
                FROM
                    Tm_Service_Request__c
                WHERE
                    TM_Service_Request_Packet__c IN: parentIds
        ];
    }
}