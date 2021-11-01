public class TMPacketStageCalculatorHelper implements TMPacketStageCalculator.ITMPacketStageCalculatorHelper {
    private final ISystem m_sys;

    public TMPacketStageCalculatorHelper(ISystem sys){
        m_sys = sys;
    }

    public List<Id> buildParentIdsList(List<TM_Service_Request__c> requests){
        List<Id> parentIds = new List<Id>();
        for (TM_Service_Request__c r : requests){
            parentIds.add(r.TM_Service_Request_Packet__c);
        }
        return parentIds;
    }
    
    public Map<Id, List<TM_Service_Request__c>> buildPacketRequestMap(List<TM_Service_Request__c> requests){
        Map<Id, List<TM_Service_Request__c>> thisMap = new Map<Id, List<TM_Service_Request__c>>();
        for (TM_Service_Request__c r : requests){
            if(!thisMap.containsKey(r.TM_Service_Request_Packet__r.Id)){
                thisMap.put(r.TM_Service_Request_Packet__r.Id, new List<TM_Service_Request__c>());
            } thisMap.get(r.TM_Service_Request_Packet__r.Id).add(r);
        }
        return thisMap;
    }

    public Set<String> getPacketState(List<TM_Service_Request__c> requests){
        List<String> thisList = new List<String>();
        for (TM_Service_Request__c r : requests){
            thisList.add(r.Stage__r.Name);
        }
        return new Set<String>(thisList);
    }

    public List<Tm_Service_Request_Packet__c> buildPacketList(List<TM_Service_Request__c> requests){
        List<Tm_Service_Request_Packet__c> thisList = new List<Tm_Service_Request_Packet__c>();
        for(TM_Service_Request__c r : requests){
            if(!thisList.contains(r.TM_Service_Request_Packet__r)){
                thisList.add(r.TM_Service_Request_Packet__r);
            }
        }
        return thisList;
    }

    public List<TM_Service_Request_Packet__c> buildUpdatedPacketList(Map<Id, String> packetStageMap, List<TM_Service_Request_Packet__c> packetList){
        List<TM_Service_Request_Packet__c> thisList = new List<TM_Service_Request_Packet__c>();
        for (TM_Service_Request_Packet__c packet : packetList){
            if(packet.Stage__c != packetStageMap.get(packet.Id)){
                packet.Stage__c = packetStageMap.get(packet.Id);
                packet.Last_Stage_Change_Date__c = m_sys.now();
                thisList.add(packet);
            }
        }
        return thisList;
    }

    public String getStatus(Set<String> packetSet){
        List<String> DOCUMENTATION_STAGES = new List<String>{'New', 'Documentation Cycle', 'Out For Signature', 'Signature Complete'};
        String PENDING_STAGE = 'Pending';
        String DOCUMENTATION_STAGE = 'Documentation';
        String WITHDRAWN_STAGE = 'Withdrawn';
        String ARCHIVED_STAGE = 'Archived';
        String COMPLETE_STAGE = 'Complete';

        if(toList(packetSet) == toList(WITHDRAWN_STAGE)){
           return WITHDRAWN_STAGE;
        }

        packetSet.remove(WITHDRAWN_STAGE);

        if(hasAnyInList(packetSet, DOCUMENTATION_STAGES)) return DOCUMENTATION_STAGE; 

        if (packetSet.size() == 1){
            if(packetSet.contains(COMPLETE_STAGE)) return ARCHIVED_STAGE;
            return toList(packetSet)[0];
        }
        
        return PENDING_STAGE;      
    }

    private Boolean hasAnyInList(Set<String> strs, List<String> theList){
        for(String s : theList){
            if(strs.contains(s)) return true;
        }
        return false;
    }

    private List<String> toList(String str){
        return new List<String>{str};
    }

    private List<String> toList(Set<String> stringSet){
        return new List<String>(stringSet);
    }    
}