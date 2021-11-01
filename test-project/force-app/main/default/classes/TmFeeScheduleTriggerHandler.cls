public class TmFeeScheduleTriggerHandler extends TriggerHandler{
    private final TMFeeCalculator.ITmFeeCalculator m_calculator;
    private final TmFeeScheduleTriggerHandler.IDataProvider m_dataProvider;    
    
    public interface IDataProvider{
        List<String> saveObjects(List<SObject> objs);
        List<Tm_Fee__c> getTmFeesByFeeSchedule(List<Id> feeScheduleIds);
    }    
    
    public TmFeeScheduleTriggerHandler(TMFeeCalculator.ITmFeeCalculator calc, TmFeeScheduleTriggerHandler.IDataProvider dataProv ){ 
        m_calculator = calc;
        m_dataProvider = dataProv;
    }
    
    public TmFeeScheduleTriggerHandler(){ 
        m_calculator = new TmFeeCalculator(new TmFeeCalculatorHelper(new TmFeeCalculatorDataProvider()));
        m_dataProvider = new TmFeeScheduleDataProvider(); 
    }
    
    public override void bulkAfterUpdate(List<SObject> oldSos, Map<Id, SObject> newSosMap){
		List<SObject> objects = new List<SObject>();     
        objects.AddAll(getUpdatedTmServiceRequests(oldSos, newSosMap));
        m_dataProvider.saveObjects(objects);
    }
    
    ////
    private List<Tm_Service_Request__c> getUpdatedTmServiceRequests(List<SObject> objectList, Map<Id, SObject> objectMap){
        List<Id> changingScheduleIds = new List<Id>();
        
        for(Tm_Fee_Schedule__c vOld : (List<Tm_Fee_Schedule__c>)objectList){
            Tm_Fee_Schedule__c vNew = (Tm_Fee_Schedule__c)objectMap.get(vOld.Id);
            if(isChanged(vOld, vNew)){
                changingScheduleIds.add(vNew.Id);                
            }
        }
        
        List<TM_Fee__c> fees = m_dataProvider.getTmFeesByFeeSchedule(changingScheduleIds);
    
        List<Tm_Service_Request__c> tmRequests = m_calculator.calculate(fees);
        return tmRequests != null ? tmRequests : new List<Tm_Service_Request__c>();
    }
    
    private Boolean isChanged(Tm_Fee_Schedule__c vOld, TM_Fee_Schedule__c vNew){
        return vOld.Bundle_Type__c != vNew.Bundle_Type__c 
            || vOld.Client_Type__c != vNew.Client_Type__c 
            || vOld.TM_Product__c != vNew.TM_Product__c;
    }
}