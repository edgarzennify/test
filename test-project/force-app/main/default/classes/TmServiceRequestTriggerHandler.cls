public class TmServiceRequestTriggerHandler extends TriggerHandler {

    private String TM_SERVICE_REQUEST_OBJ_NAME = 'TM_Service_Request__c';
    private String STAGE_LOGGING = 'Stage Logging';

    private final TmConfiguration.IStageRepository m_stageRepository;
    private final ObjectActionLogService.IObjectActionLogService m_logger; 
    private final TMFeeCalculator.ITmFeeCalculator m_feeCalculator;
    private final Utility.IUtility m_util;
    private final TMPacketStageCalculator.ITMPacketStageCalculator m_packetStageCalculator; 
    private final DataProvider.IDataProvider m_dataProvider; 
    private final ISystem m_sys;
    private Map<String,DmTmRequestStage> m_stageMap;


    public TmServiceRequestTriggerHandler(){
        m_logger = ObjectActionLogService.bootstrap();
        TmBoarding.IDataProvider dp = new TmBoardingDataProvider();
        TmFeeCalculator.IDataProvider calculatorDp = new TmFeeCalculatorDataProvider();
        TMPacketStageCalculator.ITMPacketStageCalculatorDataProvider packetStageDp = new TMPacketStageCalculatorDataProvider(); 
        m_sys = new SystemWrapper();
        TMPacketStageCalculator.ITMPacketStageCalculatorHelper packetStageCalcHelper = new TMPacketStageCalculatorHelper(m_sys);
        TmFeeCalculator.ITmFeeCalculatorHelper feeCalculatorHelper = new TmFeeCalculatorHelper(calculatorDp);
        m_stageRepository = new TmConfigurationStageRepository(dp);
        m_util = new Utility(); 
        m_feeCalculator = new TmFeeCalculator(feeCalculatorHelper);
        m_packetStageCalculator = new TMPacketStageCalculator(packetStageCalcHelper, packetStageDp);
        m_dataProvider = new DataProvider();
    }

    public TmServiceRequestTriggerHandler(TmConfiguration.IStageRepository stageRepository 
        ,ObjectActionLogService.IObjectActionLogService logger,  Utility.IUtility util,
        TMFeeCalculator.ITmFeeCalculator feeCalculator, TMPacketStageCalculator.ITMPacketStageCalculator packetStageCalculator, DataProvider.IDataProvider dataProvider, ISystem sys
        ){
        m_logger = logger;
        m_stageRepository = stageRepository;
        m_util = util;
        m_feeCalculator = feeCalculator;
        m_packetStageCalculator = packetStageCalculator;
        m_dataProvider = dataProvider;
        m_sys = sys;
    }

    public override void bulkBeforeInsert(List<SObject> sos){
        calculateFees(sos);        
    }

    public override void bulkAfterInsert(List<SObject> sos){
        List<SObject> objects = new List<Sobject>();
        objects.addAll(calculatePacketStage(sos));
        objects.addAll(recordIntialStage(sos));
        m_dataProvider.save(objects);
    }

    public override void bulkBeforeUpdate(List<SObject> oldSos, Map<Id, SObject> newSosMap){        
        calculateFees(newSosMap.values());        
        handleStageChanges(oldSos,newSosMap);        
    }

    public override void bulkAfterUpdate(List<SObject> oldSos, Map<Id, SObject> newSosMap){
        List<SObject> objects = new List<Sobject>();
        objects.addAll(calculatePacketStage(newSosMap.values()));        
        m_dataProvider.save(objects);
    }

    private List<Object_Action_Log__c> recordIntialStage(List<SObject> sos){
        for(TM_Service_Request__c r : (List<Tm_Service_Request__c>)sos){
            DmTmRequestStage stage = getStageById(r.Stage__c);
            m_logger.log(TM_SERVICE_REQUEST_OBJ_NAME, r.Id, STAGE_LOGGING, stage.Name);
        }
        return m_logger.getCachedLogs();
    }

    private void handleStageChanges(List<SObject> oldSos, Map<Id, SObject> newSosMap){
        for(TM_Service_Request__c vOld : (List<TM_Service_Request__c>)oldSos){
            TM_Service_Request__c vNew = (TM_Service_Request__c)newSosMap.get(vOld.Id);
            if(stageHasChanged(vOld, vNew)){
                DmTmRequestStage stage = getStageById(vNew.Stage__c);
                m_logger.log(TM_SERVICE_REQUEST_OBJ_NAME, vNew.Id, STAGE_LOGGING, stage.Name);
                handleStageAutoForwarding(stage, vNew);
            }
        }
        m_logger.recordCachedLogs();
    }
    
    private void handleStageAutoForwarding(DmTmRequestStage stage, TM_Service_Request__c r){
        if(stage.autoForwardStage != null){
            r.Stage__c = stage.autoForwardStage.Id;
            m_logger.log(TM_SERVICE_REQUEST_OBJ_NAME, r.Id, STAGE_LOGGING, stage.autoForwardStage.Name);      
            handleStageAutoForwarding(stage.autoForwardStage, r);
        }
    }

    private Boolean stageHasChanged(TM_Service_Request__c vOld, TM_Service_Request__c vNew){
        if(String.isNotBlank(vNew.Stage__c)){
            if(vOld.Stage__c != null && vNew != null && vNew.Stage__c != vOld.Stage__c){
                return true;
            }  
        }
        return false;
    }

    private DmTmRequestStage getStageById(Id stageId){
        if(getStageMap().containsKey(stageId)){
            return getStageMap().get(stageId);
        }
        DmTmRequestStage unknown = new DmTmRequestStage();        
        unknown.Name = 'Unknown';
        return unknown;
    }

    private Map<String,DmTmRequestStage> getStageMap(){
        if (m_stageMap == null || m_stageMap.size() == 0){
            List<DmTmRequestStage> stages = m_stageRepository.getAllStages();
            m_stageMap = new Map<String ,DmTmRequestStage>();
            if(stages != null){
                for(DmTmRequestStage stg: stages){
                    m_stageMap.put(stg.id, stg);
                }
            }
        }
        return m_stageMap;
    }

    private void calculateFees(List<SObject> newSos){  
        m_feeCalculator.calculate((List<TM_Service_Request__c>)newSos);
    }

    private List<TM_Service_Request_Packet__c> calculatePacketStage(List<SObject> sos){
        List<TM_Service_Request_Packet__c> packets = m_packetStageCalculator.calculate(sos);
        return packets != null && !packets.isEmpty() ? packets : new List<SObject>();
    }
}