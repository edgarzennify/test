public class ProductPackageTriggerHandler extends TriggerHandler{
    
    public ProductPackageTriggerHandler(ProductPackageTriggerHandler.IDataProvider dataProv
                                        ,ProductPackageTriggerHandler.IProductPackageHelper helper
                                       ,LLCBI_ProductPackageObjectFactory.IProductPackageFactory factory
                                       ,ProductPackageApprovalPathCalculator.IProductPackageApprovalPathCalculator approvalCalculator){ 
        m_dataProvider = dataProv;
        m_helper = helper;
        m_objectFactory = factory;
        m_approvalCalculator = approvalCalculator;
    }    
    public ProductPackageTriggerHandler(){ 
        m_dataProvider = new ProductPackageTriggerHandlerDataProvider();
        m_helper = new ProductPackageTriggerHandlerHelper(); 
        m_objectFactory = new LLCBI_ProductPackageObjectFactory();
        m_approvalCalculator = new ProductPackageApprovalPathCalculator();
    }
    
    public interface IDataProvider{
        List<String> saveObjects(List<SObject> objs);
        List<LLC_BI__Loan__c> getLoans(Set<Id> packageIds);
        List<Approval.ProcessResult> submitRequests (List<Approval.ProcessSubmitRequest> objectsToSubmit);
    }
    public interface IProductPackageHelper{
        List<LLC_BI__Loan__c> getUpdatedLoans(List<LLC_BI__Product_Package__c> oldSos, Map<Id, SObject> newSosMap);
    }
    
    private final ProductPackageTriggerHandler.IDataProvider m_dataProvider; 
    private final ProductPackageTriggerHandler.IProductPackageHelper m_helper;
    private final LLCBI_ProductPackageObjectFactory.IProductPackageFactory m_objectFactory;
    private final ProductPackageApprovalPathCalculator.IProductPackageApprovalPathCalculator m_approvalCalculator;
    
    public override void bulkBeforeUpdate(List<SObject> oldSos, Map<Id, SObject> newSosMap){
        List<SObject> objects = new List<SObject>();
        m_objectFactory.updatePackageApprovers(oldSos, newSosMap);
        m_objectFactory.setGuidanceLineTakedownApproval(oldSos, newSosMap);
        m_objectFactory.setAllFacilitiesApproved(newSosMap);
        m_approvalCalculator.calculate(newSosMap.values());
        List<LLC_BI__Loan__c> updatedLoans = m_helper.getUpdatedLoans(oldSos, newSosMap);
        if(updatedLoans != null && updatedLoans.size() > 0){
            objects.addAll(updatedLoans);
        }
        m_dataProvider.saveObjects(objects);
    }
    public override void bulkAfterUpdate(List<SObject> oldSos, Map<Id, SObject> newSosMap){
        List<Approval.ProcessSubmitRequest> objectsToSubmit = m_objectFactory.gatherPackagesAndLoansThatNeedAutoApproval(oldSos, newSosMap);
        if(objectsToSubmit != null && objectsToSubmit.size() > 0){
            m_dataProvider.submitRequests(objectsToSubmit);
        }
    }
}