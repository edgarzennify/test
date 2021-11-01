@isTest
public class EbAppraisalOrderTriggerIntegrationTests{
     
    private static testMethod void integration_test_bulk_appraisal_orders(){
        Integer num = 200;
        
        List<EB_Appraisal_Order__c> results = getAppraisalOrders(num);
        insert results;
        update results;
        
        System.assertEquals(200, results.size());
    }
	
    private static List<EB_Appraisal_Order__c> getAppraisalOrders(Integer numberOfIterations){
        List<EB_Appraisal_Order__c> apprOrders = new List<EB_Appraisal_Order__c>();
        String apprCollName='Coll -';
        String baseCollCodeName = 'CollCode - ';
  
        for(Integer apprCounter=0; apprCounter<numberOfIterations; ++apprCounter){
            apprCollName =+ String.valueOf(apprCounter);
            baseCollCodeName =+ String.valueOf(apprCounter);
            apprOrders.add(getAppraisalOrder(apprCollName, baseCollCodeName, String.valueOf(apprCounter)));
        }
		return apprOrders;       
    }
    
    private static EB_Appraisal_Order__c getAppraisalOrder(String collName, String collCodeName, String collCodeNum){
        EB_Appraisal_Order__c apprOrder = new EB_Appraisal_Order__c();
        apprOrder.Appraisal_Company_Used__c = 'Appraisal Co';
        apprOrder.As_Completed_Value__c = 100;
        apprOrder.As_Is_Value__c = 200;
        
        return apprOrder;
    }
}