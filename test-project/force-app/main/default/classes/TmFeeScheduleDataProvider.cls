public class TmFeeScheduleDataProvider extends DataProvider implements TmFeeScheduleTriggerHandler.IDataProvider{     
    public List<Tm_Fee__c> getTmFeesByFeeSchedule(List<Id> feeScheduleIds){ 
        return [
            SELECT
            	Id
                ,Fee_Amount__c
                ,Fee_API_Name__c
            	,Feature_Fee_Dependency__c
                ,TM_Fee_Schedule__c
            	,TM_Fee_Schedule__r.TM_Product__r.Name
            	,TM_Fee_Schedule__r.bundle_type__c
            	,TM_Fee_Schedule__r.Client_type__c
            FROM
            	TM_Fee__c
            WHERE
            	TM_Fee_Schedule__c IN: feeScheduleIds
        ];
    }
}