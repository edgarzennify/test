public class TMPacketStageCalculator implements ITMPacketStageCalculator {
    private static ITMPacketStageCalculatorDataProvider m_dataProvider;
    private static ITMPacketStageCalculatorHelper m_helper;
    private List<TM_Service_Request__c> m_allRequests;

    public interface ITMPacketStageCalculator{
        List<TM_Service_Request_Packet__c> calculate(List<TM_Service_Request__c> iRequests);
    }

    public interface ITMPacketStageCalculatorDataProvider{
        List<Tm_Service_Request__c> getAllRequests(List<Id> requests);
    }

    public interface ITMPacketStageCalculatorHelper{
        List<Id> buildParentIdsList(List<TM_Service_Request__c> requests);
        Map<Id, List<TM_Service_Request__c>> buildPacketRequestMap(List<TM_Service_Request__c> requests);
        List<Tm_Service_Request_Packet__c> buildPacketList(List<TM_Service_Request__c> requests);
        Set<String> getPacketState(List<TM_Service_Request__c> requests);
        String getStatus(Set<String> packetSet);
        List<TM_Service_Request_Packet__c> buildUpdatedPacketList(Map<Id, String> packetStageMap, List<TM_Service_Request_Packet__c> packetList);
    }

    public TMPacketStageCalculator(ITMPacketStageCalculatorHelper helper, ITMPacketStageCalculatorDataProvider dataProvider){
        m_helper = helper;
        m_dataProvider = dataProvider;
    }
/////////////
    public List<TM_Service_Request_Packet__c> calculate(List<TM_Service_Request__c> iRequests){
        List<Id> parentIds = m_helper.buildParentIdsList(iRequests);
        List<TM_Service_Request__c> requests = m_dataProvider.getAllRequests(parentIds);
        List<TM_Service_Request_Packet__c> packetList = m_helper.buildPacketList(requests);
        Map<Id, List<TM_Service_Request__c>> packetRequestMap = m_helper.buildPacketRequestMap(requests);
        Map<Id, String> packetStageMap = buildPacketStageMap(packetRequestMap);
        return m_helper.buildUpdatedPacketList(packetStageMap, packetList);
    }
    
    private Map<Id, String> buildPacketStageMap(Map<Id, List<TM_Service_Request__c>> packetRequestMap){
        Map<Id, String> thisMap = new Map<Id, String>();

        for (Id i : packetRequestMap.keySet()){
           Set<String> stateSet = m_helper.getPacketState(packetRequestMap.get(i));
           thisMap.put(i, m_helper.getStatus(stateSet));
        }
        return thisMap;
    }  
}