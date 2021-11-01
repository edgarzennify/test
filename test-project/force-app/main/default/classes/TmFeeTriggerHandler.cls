public class TmFeeTriggerHandler extends TriggerHandler {
    
	private final TMFeeCalculator.ITmFeeCalculator m_calculator;    
    private final DataProvider.IDataProvider m_dataProvider;
    
    public TmFeeTriggerHandler(TMFeeCalculator.ITmFeeCalculator calc, DataProvider.IDataProvider dataProvider){ 
        m_calculator = calc;
        m_dataProvider = dataProvider;
    }

    public TmFeeTriggerHandler(){ 
       m_calculator = new TmFeeCalculator(new TmFeeCalculatorHelper(new TmFeeCalculatorDataProvider()));
       m_dataProvider = new DataProvider();
    }
    
    public override void bulkBeforeInsert(List<sObject> newSos){
        List<SObject> objects = new List<SObject>();
		objects.addAll(getUpdatedTmServiceRequests(newSos));
        m_dataProvider.saveObjects(objects);        
    }
    
    public override void bulkAfterUpdate(List<SObject> oldSos, Map<Id, SObject> newSosMap){
        List<SObject> objects = new List<SObject>();
        objects.addAll(getUpdatedTmServiceRequests(newSosMap.values()));
        m_dataProvider.saveObjects(objects);
    }
    
    ////
    private List<Tm_Service_Request__c> getUpdatedTmServiceRequests(List<SObject> tmFees){
        List<Tm_Service_Request__c> requests = m_calculator.calculate((List<TM_Fee__c>)tmFees);
        return requests != null ? requests : new List<Tm_Service_Request__c>();        
    }  
}