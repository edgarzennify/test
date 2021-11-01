public class TMServiceRequestPacketTriggerHandler extends TriggerHandler {

    private String TM_SERVICE_REQUEST_OBJ_NAME = 'TM_Service_Request_Packet__c';
    private String STAGE_LOGGING = 'Stage Logging';

    private final TMFeeCalculator.ITmFeeCalculator m_calculator;
    private final TMServiceRequestPacketTriggerHandler.IDataProvider m_dataProvider;
    private final ObjectActionLogService.IObjectActionLogService m_stageLogger;
    private final TmConfiguration.IStageRepository m_stageRepository;
    
    public interface IDataProvider extends DataProvider.IDataProvider{
        List<Tm_Service_Request__c> getTmServiceRequestsByPacket(List<Id> packetIds);
    }
    
    public TMServiceRequestPacketTriggerHandler(){ 
        TmBoarding.IDataProvider dp = new TmBoardingDataProvider();
        m_stageLogger = ObjectActionLogService.bootstrap();
        m_calculator = new TmFeeCalculator(new TmFeeCalculatorHelper(new TmFeeCalculatorDataProvider()));
        m_dataProvider = new TmServiceRequestPacketDataProvider();
        m_stageRepository = new TmConfigurationStageRepository(dp);
    }

    public TMServiceRequestPacketTriggerHandler(TMFeeCalculator.ITmFeeCalculator calc, TMServiceRequestPacketTriggerHandler.IDataProvider dataProv, ObjectActionLogService.IObjectActionLogService stageLogger, TmConfiguration.IStageRepository stageRepository){ 
        m_calculator = calc;
        m_dataProvider = dataProv;
        m_stageLogger = stageLogger;
        m_stageRepository = stageRepository;
    }

    public override void bulkAfterInsert(List<SObject> sos){
        List<SObject> objects = new List<Sobject>();
        objects.addAll(recordIntialStage(sos));       
        m_dataProvider.save(objects);
    }
   
    public override void bulkAfterUpdate(List<SObject> oldSos, Map<Id, SObject> newSosMap){
        List<SObject> objects = new List<SObject>();
        objects.addAll(getUpdatedTmServiceRequests(oldSos, newSosMap));
        objects.addAll(recordStage(oldSos, newSosMap));
        m_dataProvider.save(objects);
    }
    //////
    private List<Tm_Service_Request__c> getUpdatedTmServiceRequests(List<SObject> objectList, Map<Id, SObject> objectMap){
        List<Id> packetIds = new List<Id>();
        for(Tm_Service_Request_Packet__c vOld : (List<Tm_Service_Request_Packet__c>)objectList){
            Tm_Service_Request_Packet__c vNew = (Tm_Service_Request_Packet__c)objectMap.get(vOld.Id);
            if(bundleOrClientTypeIsChanged(vOld, vNew)){
                    packetIds.Add(vOld.Id);
            }
        }
        List<Tm_Service_Request__c> requests = m_dataProvider.getTmServiceRequestsByPacket(packetIds);
        List<Tm_Service_Request__c> requestsToUpdate = m_calculator.calculate(requests);
        return requestsToUpdate != null ? requestsToUpdate : new List<Tm_Service_Request__c>();
    }
    private Boolean bundleOrClientTypeIsChanged(Tm_Service_Request_Packet__c vOld, TM_Service_Request_Packet__c vNew){
        return vOld.Bundle_Type__c != vNew.Bundle_Type__c 
            || vOld.Client_Type__c != vNew.Client_Type__c ;
    }

    private List<Object_Action_Log__c> recordIntialStage(List<SObject> packets){
        for (TM_Service_Request_Packet__c packet : (List<TM_Service_Request_Packet__c>)packets){
            m_stageLogger.log(TM_SERVICE_REQUEST_OBJ_NAME, packet.Id, STAGE_LOGGING, packet.Stage__c);
        }
        return m_stageLogger.getCachedLogs();
    }

    private List<Object_Action_Log__c> recordStage(List<SObject> oldSos, Map<Id, SObject> newSosMap){
        for(TM_Service_Request_Packet__c vOld : (List<TM_Service_Request_Packet__c>)oldSos){
            TM_Service_Request_Packet__c vNew = (TM_Service_Request_Packet__c)newSosMap.get(vOld.Id);
            if(stageHasChanged(vOld, vNew)){
                m_stageLogger.log(TM_SERVICE_REQUEST_OBJ_NAME, vNew.Id, STAGE_LOGGING, vNew.Stage__c);
            }
        }
        return m_stageLogger.getCachedLogs();
    }

    private Boolean stageHasChanged(TM_Service_Request_Packet__c vOld, TM_Service_Request_Packet__c vNew){
        if(String.isNotBlank(vNew.Stage__c)){
            if(vOld.Stage__c != null && vNew != null && vNew.Stage__c != vOld.Stage__c){
                return true;
            }  
        }
        return false;
    }
}