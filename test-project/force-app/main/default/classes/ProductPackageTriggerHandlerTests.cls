@IsTest
private class ProductPackageTriggerHandlerTests {
	private static final ProductPackageTriggerHandler sut;
    private static final MockOfIDataProvider mockDataProv;
    private static final MockOfIProductPackageHelper mockHelper; 
    private static final MockOfIProductPackageObjectFactory mockObjectFactory;
    private static final MockOfProductPackageApprovalPathCalculator mockApprovalCalculator;
    
    static {
        mockDataProv = new MockOfIDataProvider();
        mockHelper = new MockOfIProductPackageHelper();
        mockObjectFactory = new MockOfIProductPackageObjectFactory();
        mockApprovalCalculator = new MockOfProductPackageApprovalPathCalculator();
        sut = new ProductPackageTriggerHandler(mockDataProv, mockHelper, mockObjectFactory, mockApprovalCalculator);
    }
    
    static void it_should_call_updatePackageApprovers_on_the_object_factory_when_bulkBeforeUpdate_is_called(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        Set<Id> packageIds = new Set<Id>{pack.Id};
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.LLC_BI__Product_Package__c = pack.Id;
        List<SObject> oldSos = new List<SObject>{pack};
        Map<Id, SObject> newSosMap = new Map<Id, SObject>{pack.Id=>pack};
            
        sut.BulkBeforeUpdate(oldSos, newSosMap);
        mockObjectFactory.verify('updatePackageApprovers', new List<Object>{oldSos, newSosMap}, Times.Once);
    }
    static void it_should_call_setGuidanceLineTakedownApproval_on_the_object_factory_when_bulkBeforeUpdate_is_called(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        Set<Id> packageIds = new Set<Id>{pack.Id};
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.LLC_BI__Product_Package__c = pack.Id;
        List<SObject> oldSos = new List<SObject>{pack};
        Map<Id, SObject> newSosMap = new Map<Id, SObject>{pack.Id=>pack};
            
        sut.BulkBeforeUpdate(oldSos, newSosMap);
        mockObjectFactory.verify('setGuidanceLineTakedownApproval', new List<Object>{oldSos, newSosMap}, Times.Once);
    }
    static void it_should_call_setAllFacilitiesApproved_on_the_object_factory_when_bulkBeforeUpdate_is_called(){
        LLC_BI__Product_Package__c pack = new LLC_BI__Product_Package__c();
        pack.Id = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        Set<Id> packageIds = new Set<Id>{pack.Id};
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.LLC_BI__Product_Package__c = pack.Id;
        List<SObject> oldSos = new List<SObject>{pack};
        Map<Id, SObject> newSosMap = new Map<Id, SObject>{pack.Id=>pack};
            
        sut.BulkBeforeUpdate(oldSos, newSosMap);
        mockObjectFactory.verify('setAllFacilitiesApproved', new List<Object>{newSosMap}, Times.Once);
    }
    private static testMethod void code_coverage_for_constructor() {
        ProductPackageTriggerHandler hndl = new ProductPackageTriggerHandler();
    }
    private static testMethod void it_should_call_the_object_factory_to_determine_objects_that_need_auto_approval_then_submit_those_objects_for_approval() {
        Id packId = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        LLC_BI__Product_Package__c oldPack = new LLC_BI__Product_Package__c();
        oldPack.Id = packId;
        oldPack.PASS_Recommendation__c = null;
        List<SObject> oldSos = new List<SObject>{oldPack};
        Map<Id, SObject> newSosMap = new Map<Id,SObject>();
        LLC_BI__Product_Package__c newPack = new LLC_BI__Product_Package__c();
        newPack.Id = packId;
        newPack.PASS_Recommendation__c = 'Approve';
        newSosMap.put(newPack.Id, newPack);
        Set<Id> packageIds = newSosMap.keySet();
        LLC_BI__Loan__c loan = new LLC_BI__Loan__c();
        loan.LLC_BI__Product_Package__c = newPack.Id;
        loan.Id = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        List<LLC_BI__Loan__c> loans = new List<LLC_BI__Loan__c>{loan};
        Map<Id, List<LLC_BI__Loan__c>> relatedLoanMap = new Map<Id, List<LLC_BI__Loan__c>>();
        relatedLoanMap.put(newPack.Id, loans);
        Approval.ProcessSubmitRequest packReq = new Approval.ProcessSubmitRequest();
        packReq.setObjectId(newPack.Id);
        Approval.ProcessSubmitRequest loanReq = new Approval.ProcessSubmitRequest();
        loanReq.setObjectId(loan.Id);
        List<Approval.ProcessSubmitRequest> requests = new List<Approval.ProcessSubmitRequest>{packReq, loanReq};
        
        mockObjectFactory.setup('gatherPackagesAndLoansThatNeedAutoApproval', new List<Object>{oldSos, newSosMap}).returns(requests);
        sut.bulkAfterUpdate(oldSos, newSosMap);
        mockDataProv.verify('submitRequests', new List<Object>{requests}, Times.Once);
    }
    private static testMethod void it_should_collect_a_list_of_loans_and_save_them_when_bulkBeforeUpdate_is_called_with_product_packages_that_need_to_update_their_loans() {
        Id packId = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        LLC_BI__Product_Package__c oldPack = new LLC_BI__Product_Package__c();
        oldPack.Id = packId;
        oldPack.LLC_BI__Status__c = 'Open';
        List<SObject> oldSos = new List<SObject>{oldPack};
        LLC_BI__Product_Package__c newPack = new LLC_BI__Product_Package__c();
        newPack.Id = packId;
        newPack.LLC_BI__Status__c = 'Hold';
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(newPack.Id, newPack);
        LLC_BI__Loan__c returnedLoan = new LLC_BI__Loan__c();
        returnedLoan.LLC_BI__Product_Package__c = newPack.Id;
        returnedLoan.LLC_BI__Status__c = 'Hold';
        List<LLC_BI__Loan__c> returnedLoans = new List<LLC_BI__Loan__c>{returnedLoan};
        Map<Id, List<LLC_BI__Loan__c>> relatedLoanMap = new Map<Id, List<LLC_BI__Loan__c>>();
        relatedLoanMap.put(newPack.Id, returnedLoans);
        Set<Id> packageIds = new Set<Id>{newPack.Id};
        List<SObject> savedObjects = new List<SObject>{returnedLoan};        
        mockHelper.setup('getUpdatedLoans', new List<Object>{oldSos, newSosMap}).returns(returnedLoans);
        sut.bulkBeforeUpdate(oldSos, newSosMap);
        mockDataProv.verify('saveObjects', new List<Object>{savedObjects}, Times.Once);     
    }
    private static testMethod void it_should_call_calculate_on_the_approval_calculator_when_bulkBeforeUpdate_is_called_with_a_list_of_packages(){
        Id packId1 = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '1');
        Id packId2 = ObjectFactory.getFakeId(LLC_BI__Product_Package__c.SObjectType, '2');
        LLC_BI__Product_Package__c pack1 = new LLC_BI__Product_Package__c();
        pack1.Channel__c = 'Commercial Banking';
        pack1.LLC_BI__TCE__c = 1000000;
        pack1.Id = packId1;
        LLC_BI__Product_Package__c pack2 = new LLC_BI__Product_Package__c();
        pack2.Channel__c = 'Business Banking';
        pack2.LLC_BI__TCE__c = 150000;
        pack2.Id = packId2;
        List<SObject> oldSos = new List<SObject>{pack1, pack2};
        Map<Id, SObject> newSosMap = new Map<Id, SObject>();
        newSosMap.put(pack1.Id, pack1);
        newSosMap.put(pack2.Id, pack2);
            
        sut.BulkBeforeUpdate(oldSos, newSosMap);
        mockApprovalCalculator.verify('calculate', new List<Object>{newSosMap.values()}, Times.Once);
        mockApprovalCalculator.verify('calculate', ApexMoq.ARGUMENTS_HAVE_ANY_VALUE, Times.Once);
    }

    private class MockOfIDataProvider extends ApexMoq implements ProductPackageTriggerHandler.IDataProvider{  
        public List<LLC_BI__Loan__c> getLoans(Set<Id> packageIds){
            return (List<LLC_BI__Loan__c>)handleMethodInvocation('getLoans', new List<Object>{packageIds});
        }
        public List<String> saveObjects(List<SObject> objs){
            return (List<String>)handleMethodInvocation('saveObjects', new List<Object>{objs});
        }
        public List<Approval.ProcessResult> submitRequests(List<Approval.ProcessRequest> objectsToSubmit){
            return (List<Approval.ProcessResult>)handleMethodInvocation('submitRequests', new List<Object>{objectsToSubmit});
        }
        public List<ProcessInstance> getProcessIntances(List<LLC_BI__Product_Package__c> packageList){
            return (List<ProcessInstance>)handleMethodInvocation('getProcessIntances', new List<Object>{packageList});
        }
    }

    private class MockOfIProductPackageHelper extends ApexMoq implements ProductPackageTriggerHandler.IProductPackageHelper {
        public List<LLC_BI__Loan__c> getUpdatedLoans(List<LLC_BI__Product_Package__c> oldSos, Map<Id, SObject> newSosMap){
            return (List<LLC_BI__Loan__c>)handleMethodInvocation('getUpdatedLoans', new List<Object>{oldSos, newSosMap});
        }
    }
    private class MockOfIProductPackageObjectFactory extends ApexMoq implements LLCBI_ProductPackageObjectFactory.IProductPackageFactory {
        public List<LLC_BI__Product_Package__c> updatePackages(List<SObject> oldSos, Map<Id, SObject> newSosMap){
            return (List<LLC_BI__Product_Package__c>)handleMethodInvocation('updatePackages', new List<Object>{oldSos, newSosMap});
        }
        public void updatePackageApprovers(List<SObject> oldSos, Map<Id, SObject> newSosMap){
            handleMethodInvocation('updatePackageApprovers', new List<Object>{oldSos, newSosMap});
        }
        public void setGuidanceLineTakedownApproval(List<SObject> oldSos, Map<Id, SObject> newSosMap){
            handleMethodInvocation('setGuidanceLineTakedownApproval', new List<Object>{oldSos, newSosMap});
        }
        public void setAllFacilitiesApproved(Map<Id, SObject> newSosMap){
            handleMethodInvocation('setAllFacilitiesApproved', new List<Object>{newSosMap});
        }
        public List<Approval.ProcessSubmitRequest> gatherPackagesAndLoansThatNeedAutoApproval(List<SObject> oldSos, Map<Id, SObject> newSosMap){
            return(List<Approval.ProcessSubmitRequest>)handleMethodInvocation('gatherPackagesAndLoansThatNeedAutoApproval', new List<Object>{oldSos, newSosMap});
        }
        
    }
    private class MockOfProductPackageApprovalPathCalculator extends ApexMoq implements ProductPackageApprovalPathCalculator.IProductPackageApprovalPathCalculator{
        public void calculate(List<SObject> objects){
            handleMethodInvocation('calculate', new List<Object>{objects});
        }
    }
}