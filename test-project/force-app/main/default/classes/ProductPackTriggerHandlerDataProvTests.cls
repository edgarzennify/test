@isTest
public class ProductPackTriggerHandlerDataProvTests {
    private static final ProductPackageTriggerHandlerDataProvider sut;
    
    static{
        sut = new ProductPackageTriggerHandlerDataProvider();
    }
    
    static testMethod void it_should_call_all_fields_in_getRelatedLoans_to_verify_soql(){
        //assemble
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        insert pack;
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.LLC_BI__Product_Package__c = pack.Id;
        insert loan;
        Set<Id> idSet = new Set<Id>{pack.Id};
        
        //act
        List<LLC_BI__Loan__c> results = sut.getLoans(idSet); 
        //assert
        System.assertEquals(1, results.size());
        Object fieldInResult = results[0].Id;
        fieldInResult = results[0].LLC_BI__Structure_Hierarchy__c;
        fieldInResult = results[0].LLC_BI__Stage__c;
        fieldInResult = results[0].LLC_BI__Product_Package__c;
        fieldInResult = results[0].First_Approver__c;
        fieldInResult = results[0].Second_Approver__c ;
        fieldInResult = results[0].Third_Approver__c ;
        fieldInResult = results[0].Originating_Officer__c ;
        fieldInResult = results[0].Actual_Approval_Path_fx__c ;
        fieldInResult = results[0].Channel__c ;
        fieldInResult = results[0].LLC_BI__Status__c ;
    }	
    static testMethod void it_should_submit_objects_for_approval_when_submitRequests_is_called(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Channel__c = 'Business Banking';
        pack.Override_Recommended_Approval_Path__c = false;
        pack.PASS_Recommendation__c = 'Approve';
        pack.LLC_BI__Status__c = 'Open';
        insert pack;
        List<Approval.ProcessSubmitRequest> requests = new List<Approval.ProcessSubmitRequest>();
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setObjectId(pack.Id);
        requests.add(req);
        List<Approval.ProcessResult> results = sut.submitRequests(requests);
        system.assertEquals(true, results[0].IsSuccess());
    }
}