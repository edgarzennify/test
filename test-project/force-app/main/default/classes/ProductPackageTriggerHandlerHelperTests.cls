@isTest
public class ProductPackageTriggerHandlerHelperTests {
    private static final ProductPackageTriggerHandlerHelper sut;
    private static final MockOfIDataProvider mockDataProvider;
    
    static {        
        mockDataProvider = new MockOfIDataProvider();
        sut = new ProductPackageTriggerHandlerHelper(mockDataProvider);
    }  
    
    private static testMethod void code_coverage_for_constructor(){
        ProductPackageTriggerHandlerHelper hlp = new ProductPackageTriggerHandlerHelper();
    }
    private static testMethod void it_should_return_a_loan_with_updated_approvers_if_not_matching_package(){
        User firstApprover = new User();
        firstApprover.Id = ObjectFactory.getFakeId(User.SObjectType, '1');
        User secondApprover = new User();
        secondApprover.Id = ObjectFactory.getFakeId(User.SObjectType, '1');
        User thirdApprover = new User();
        thirdApprover.Id = ObjectFactory.getFakeId(User.SObjectType, '1');
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        pack.First_Approver__c = firstApprover.Id;
        pack.Second_Approver__c = secondApprover.Id; 
        pack.Third_Approver__c = thirdApprover.Id;
        List<LLC_BI__Product_Package__c> oldSos = new List<LLC_BI__Product_Package__c>{pack};
        Map<Id, LLC_BI__Product_Package__c> newSosMap = new Map<Id, LLC_BI__Product_Package__c>();
        newSosMap.put(pack.Id, pack);
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.LLC_BI__Product_Package__c = pack.Id;
        loan.LLC_BI__Stage__c = 'Credit Request';
        List<LLC_BI__Loan__c> relatedLoans = new List<LLC_BI__Loan__c>{loan};
        Set<Id> packageIds = new Set<Id>{pack.Id};
        
        mockDataProvider.setup('getLoans', new List<Object>{packageIds}).returns(relatedLoans);
        List<LLC_BI__Loan__c> results = sut.getUpdatedLoans(oldSos, newSosMap);
        system.assertEquals(pack.First_Approver__c, results[0].First_Approver__c);
        system.assertEquals(pack.Second_Approver__c, results[0].Second_Approver__c);
        system.assertEquals(pack.Third_Approver__c, results[0].Third_Approver__c);
    }
    private static testMethod void it_should_return_a_loan_with_updated_officer_if_not_matching_package(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        pack.Originating_Officer__c = ObjectFactory.getFakeId(User.SObjectType, '1');
        List<LLC_BI__Product_Package__c> oldSos = new List<LLC_BI__Product_Package__c>{pack};
        Map<Id, LLC_BI__Product_Package__c> newSosMap = new Map<Id, LLC_BI__Product_Package__c>();
        newSosMap.put(pack.Id, pack);
        LLC_BI__Loan__c loan1 = new LLC_BI__Loan__c();
        loan1.LLC_BI__Product_Package__c = pack.Id;
        loan1.LLC_BI__Stage__c = 'Credit Request';
        LLC_BI__Loan__c loan2 = new LLC_BI__Loan__c();
        loan2.LLC_BI__Product_Package__c = pack.Id;
        loan2.LLC_BI__Stage__c = 'Post-Approval Review';
        List<LLC_BI__Loan__c> relatedLoans = new List<LLC_BI__Loan__c>{loan1, loan2};
        Set<Id> packageIds = new Set<Id>{pack.Id};
        
        mockDataProvider.setup('getLoans', new List<Object>{packageIds}).returns(relatedLoans);
        List<LLC_BI__Loan__c> results = sut.getUpdatedLoans(oldSos, newSosMap);
        system.assertEquals(pack.Originating_Officer__c, results[0].Originating_Officer__c);
    }
    private static testMethod void it_should_return_a_loan_with_updated_hold_status_if_not_matching_package(){
        Id packId = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        LLC_BI__Product_Package__c oldPack = new LLC_BI__Product_Package__c();
        oldPack.Id = packId;
        oldPack.LLC_BI__Status__c = null;
        LLC_BI__Product_Package__c newPack = new LLC_BI__Product_Package__c();
        newPack.Id = packId;
        newPack.LLC_BI__Status__c = 'Hold';
        List<LLC_BI__Product_Package__c> oldSos = new List<LLC_BI__Product_Package__c>{oldPack};
        Map<Id, LLC_BI__Product_Package__c> newSosMap = new Map<Id, LLC_BI__Product_Package__c>();
        newSosMap.put(newPack.Id, newPack);
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.LLC_BI__Product_Package__c = newPack.Id;
        List<LLC_BI__Loan__c> relatedLoans = new List<LLC_BI__Loan__c>{loan};
        Set<Id> packageIds = new Set<Id>{newPack.Id};
        
        mockDataProvider.setup('getLoans', new List<Object>{packageIds}).returns(relatedLoans);
        List<LLC_BI__Loan__c> results = sut.getUpdatedLoans(oldSos, newSosMap);
        system.assertEquals(newPack.LLC_BI__Status__c, results[0].LLC_BI__Status__c);
    }
    /////////
    public class MockOfIDataProvider extends ApexMoq implements ProductPackageTriggerHandler.IDataProvider{
        public List<LLC_BI__Loan__c> getLoans(Set<Id> packageIds){
            return (List<LLC_BI__Loan__c>)handleMethodInvocation('getLoans', new List<Object>{packageIds});
        }
        public List<String> saveObjects(List<SObject> objs){
            return (List<String>)handleMethodInvocation('saveObjects', new List<Object>{objs});
        }
        public List<Approval.ProcessResult> submitRequests(List<Approval.ProcessRequest> objectsToSubmit){
            return (List<Approval.ProcessResult>)handleMethodInvocation('submitRequests', new List<Object>{objectsToSubmit});
        }
    }
}