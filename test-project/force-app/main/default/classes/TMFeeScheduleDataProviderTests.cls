@isTest
public class TMFeeScheduleDataProviderTests { 
	private static final TmFeeScheduleDataProvider sut;
    
    static{
        sut = new TmFeeScheduleDataProvider();
    }
    
    static testMethod void it_should_call_all_fields_in_get_fees_to_verify_soql(){
        //assemble
        TM_Fee_Schedule__c sched = new TM_Fee_Schedule__c();
        insert sched;
        TM_Fee__c fee = new TM_Fee__c();
        fee.TM_Fee_Schedule__c = sched.Id; 
        insert fee;
        
        //act
        List<Tm_Fee__c> results = sut.getTmFeesByFeeSchedule(new List<Id>{sched.Id}); 
        
        //assert
        System.assertEquals(1, results.size());
        Object fieldInResult = results[0].Id;
        fieldInResult = results[0].Fee_Amount__c;
        fieldInResult = results[0].Fee_API_Name__c;
        fieldInResult = results[0].TM_Fee_Schedule__c;
        fieldInResult = results[0].TM_Fee_Schedule__r.TM_Product__r.Name;
        fieldInResult = results[0].TM_Fee_Schedule__r.bundle_type__c;
        fieldInResult = results[0].TM_Fee_Schedule__r.Client_type__c;
	}	
}