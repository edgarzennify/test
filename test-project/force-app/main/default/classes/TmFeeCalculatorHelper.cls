public class TmFeeCalculatorHelper implements TmFeeCalculator.ITmFeeCalculatorHelper{

    private final string BUSINESS_BANKING = 'Business Banking';
    private final string COMMERCIAL_BANKING = 'Commercial Banking';
    private final string CORPORATE_OLB = 'Corporate OLB';
    private List<TM_Fee__c> m_allFees;
    private Map<String, List<TM_Fee__c>> m_feeMap;    
    private List<TM_Service_Request_Packet__c> m_allPackets;  
    private Map<Id, Tm_Service_Request_Packet__c> m_packetMap;    
    private List<TM_Fee_Schedule__c> m_allSchedules;
    private Map<Id, Tm_Fee_Schedule__c> m_scheduleMap;
    private List<TM_Product__c> m_allProducts;
    private Map<Id, Tm_Product__c> m_productMap;
    private List<TM_Service_Request__c> m_allRequests;
    private Map<String, List<Tm_Service_Request__c>> m_requestMap;
    private List<TM_Service_Request_Stage__c> m_allStages;
    private Map<Id, Tm_Service_Request_Stage__c> m_stageMap;
    
    private static TmFeeCalculator.IDataProvider m_dataProvider; 

    public TmFeeCalculatorHelper(TmFeeCalculator.IDataProvider dataProvider){
        m_dataProvider = dataProvider;
    }
    public List<Tm_Fee__c> GetFees(String clientType, String bundleType, String productType){
        String keyName =  GetKeyName(clientType, bundleType, productType); 
        if (m_allFees == null) {
            m_allFees = m_dataProvider.getAllFees();
            m_feeMap = mapify(m_allFees);
        }
        return m_feeMap.get(keyName);
    }
    public Tm_Service_Request_Packet__c GetPacket(Id packetId){
        if (m_allPackets == null) {
            m_allPackets = m_dataProvider.getAllPackets();
            m_packetMap = mapify(m_allPackets);
        }
        return m_packetMap.get(packetId);
    }
    public Tm_Fee_Schedule__c GetSchedule(Id scheduleId){ 
        if (m_allSchedules == null) {
            m_allSchedules = m_dataProvider.getAllSchedules();
            m_scheduleMap  = mapify(m_allSchedules);
        }
        return m_scheduleMap.get(scheduleId);
    }
    public List<Tm_Service_Request__c> GetRequests(String clientType, String bundleType, String productName){
        String keyName = GetKeyName(clientType, bundleType, productName);
        if (m_allRequests == null) {
            m_allRequests = m_dataProvider.getAllRequests();
            m_requestMap  = mapify(m_allRequests);
        }
        return m_requestMap.get(keyName);
    }
    public Tm_Product__c GetProductType(Id productId){
        if(m_allProducts == null){
            m_allProducts = m_dataProvider.getAllProducts();
            m_productMap = mapify(m_allProducts);
        }
        return m_productMap.get(productId); 
    }
    public Tm_Service_Request_Stage__c GetStage(Id stageId){
        if(m_allStages == null){
            m_allStages = m_dataProvider.getAllStages();
            m_stageMap = mapify(m_allStages);
        }
        return m_stageMap.get(stageId); 
    }
    public String GetClientType(TM_Service_Request__c tmRequest){
        Tm_Service_Request_Packet__c packet = GetPacket(tmRequest.TM_Service_Request_Packet__c);
        return packet != null ? packet.Client_Type__c : null;
    }
    public String GetBundleType(TM_Service_Request__c tmRequest){
        Tm_Service_Request_Packet__c packet = GetPacket(tmRequest.TM_Service_Request_Packet__c);
        return packet != null ? packet.Bundle_Type__c : null;
    }
    public String GetProductType(TM_Service_Request__c tmRequest){
        return Utility.recordTypeObject('TM_Service_Request__c', tmRequest.RecordTypeId).Name;
    }
   
    private Map<String, List<TM_Fee__c>> mapify(List<TM_Fee__c> allFees){
        Map<String, List<TM_Fee__c>> feeMap = new Map<String, List<TM_Fee__c>>();
        for(TM_Fee__c f : allFees){
            String keyName =  GetKeyName(f.TM_Fee_Schedule__r.Client_Type__c, f.TM_Fee_Schedule__r.Bundle_Type__c, f.TM_Fee_Schedule__r.TM_Product__r.Name);
            if(!feeMap.containsKey(keyName)){
                feeMap.put(keyName, new List<TM_Fee__c>());
            }
            feeMap.get(keyName).add(f);            
        }
		return feeMap;
    }
    private Map<Id, Tm_Service_Request_Packet__c> mapify(List<Tm_Service_Request_Packet__c> objs){
        Map<Id, Tm_Service_Request_Packet__c> mapped = new Map<Id, Tm_Service_Request_Packet__c>();
        if(objs != null){
            for(Tm_Service_Request_Packet__c o : objs){
                mapped.put(o.Id, o);
            }        
        }
        return mapped;
    }
    private Map<Id, Tm_Fee_Schedule__c> mapify(List<Tm_Fee_Schedule__c> objs){
        Map<Id, Tm_Fee_Schedule__c> mapped = new Map<Id, Tm_Fee_Schedule__c>();
        if(objs != null){
            for(Tm_Fee_Schedule__c o : objs){
                mapped.put(o.Id, o);
            }
        }
        return mapped;
    }
    private Map<Id, Tm_Product__c> mapify(List<Tm_Product__c> objs){
        Map<Id, Tm_Product__c> mapped = new Map<Id, Tm_Product__c>();
        if(objs != null){
            for(Tm_Product__c o : objs){
                mapped.put(o.Id, o);
            }
        }
        return mapped;
    }    
    private Map<Id, Tm_Service_Request_Stage__c> mapify(List<Tm_Service_Request_Stage__c> objs){
        Map<Id, Tm_Service_Request_Stage__c> mapped = new Map<Id, Tm_Service_Request_Stage__c>();
        if(objs != null){
            for(Tm_Service_Request_Stage__c o : objs){
                mapped.put(o.Id, o);
            }
        }
        return mapped;
    }
    private Map<String, List<Tm_Service_Request__c>> mapify(List<Tm_Service_Request__c> requests){
       Map<String, List<TM_Service_Request__c>> requestMap = new Map<String, List<TM_Service_Request__c>>();
        for(TM_Service_Request__c req : requests){
            String keyName =  GetKeyName(req.Tm_Service_Request_Packet__r.Client_Type__c, req.Tm_Service_Request_Packet__r.Bundle_Type__c, req.RecordType.Name);
            if(!requestMap.containsKey(keyName)){
                requestMap.put(keyName, new List<TM_Service_Request__c>());
            }
            requestMap.get(keyName).add(req);            
        }
		return requestMap;
    }
    private string GetKeyName(String clientType, String bundleType, String productType){
        return clientType + bundleType + productType;
    }
}