public class BarcodeGeneratorPresenter implements BarcodeGenerator.IPresenter {
    
    private final Integer INITIAL_ROW_COUNT = 5;
    private final Integer ADD_ROWS_COUNT = 5;
    private final String BARCODE_REPORTID_CFGKEY = 'BarcodeGeneratorReportId';
    private final BarcodeGenerator.IVmBuilder m_vmBuilder;
    private final BarcodeGenerator.IRepository m_repository;
    private final ReportUrlProvider.IReportUrlProvider m_reportUrlProvider;
    private final Configurations.IConfigurations m_configs;
    private final String ACCOUNT_KEY_TYPE = 'Account';
    private final String ENTITY_KEY_TYPE = 'Entity';

    public BarcodeGeneratorPresenter(BarcodeGenerator.IVmBuilder vmBuilder, BarcodeGenerator.IRepository repository, ReportUrlProvider.IReportUrlProvider reportUrlProvider, Configurations.IConfigurations configs) {
        m_vmBuilder = vmBuilder;
        m_repository = repository;
        m_reportUrlProvider = reportUrlProvider;
        m_configs = configs;
    }

    public BarcodeGenerator.FormVm getFormVm(Id contextId){
        DmBgContext context = getContext(contextId);
        BarcodeGenerator.FormVm vm = new BarcodeGenerator.FormVm();
        vm.batchTitle = '';
        vm.contextId = contextId;
        vm.categories = m_vmBuilder.buildCategoryVms(context.categories, contextId);
        vm.categoryOptions = m_vmBuilder.buildCategoryOptions(vm.categories);   
        vm.categoryOptionVms = m_vmBuilder.buildSelectOptionVms(vm.categoryOptions);   
        vm.rows = m_vmBuilder.buildRows(INITIAL_ROW_COUNT);
        vm.documentUploadFinalizationUrl = buildUploadFinalizationUrl(contextId);
        vm.addRowsCount = ADD_ROWS_COUNT;
        return vm;
    }
    
    public BarcodeGenerator.FormVm categorySelected(BarcodeGenerator.FormVm vm, Integer selectedRowIndex){
        BarcodeGenerator.RowVm selectedRow = null;
        for(BarcodeGenerator.RowVm row : vm.rows){
            if(row.rowIndex == selectedRowIndex){
                selectedRow = row;
            }
        }
        
        if(selectedRow != null){
            for(BarcodeGenerator.CategoryVm cvm : vm.categories){
                if(cvm.name == selectedRow.selectedCategoryValue){
                    selectedRow.selectedCategory = cvm;
                }
            }
        }
        
        return vm;
    }
    
    public BarcodeGenerator.FormVm addRowsClicked(BarcodeGenerator.FormVm vm){
        vm.rows = m_vmBuilder.addRows(vm.rows, ADD_ROWS_COUNT);
        return vm;
    }

    public String generateClicked(BarcodeGenerator.FormVm vm){
        BarcodeGenerator.FormSm sm = m_vmBuilder.convertToFormSm(vm);
        DmBgBatch batch = m_repository.createBatch(sm);
        String barcodeReportId = m_configs.get(BARCODE_REPORTID_CFGKEY);
        return m_reportUrlProvider.getReportUrl(barcodeReportId, new List<String> { batch.batchId });
    }
    
    private DmBgContext getContext(Id contextId){
        List<DmBgContext> contexts = m_repository.getContexts();
        DmBgContext targetContext = null;
        for(DmBgContext ctx : contexts){
            if(contextId == null){
                if(String.isBlank(ctx.objectName)){
                    return ctx;
                }
            }else{
                Schema.SObjectType objectType = Schema.getGlobalDescribe().get(ctx.objectName);
                if(objectType == contextId.getSObjectType()){
                    return ctx;
                }
            }
        }
        return new DmBgContext();
    }

    private String buildUploadFinalizationUrl(Id objectId) {
        BarcodeGenerator.PageKey pk = getPageKey(objectId);

        return '/apex/TreeView?pageKey=' + pk.PageKey + '&pageKeyType=' + pk.PageKeyType;
    }

    private BarcodeGenerator.PageKey getPageKey(Id objectId) {
        BarcodeGenerator.PageKey pk = new BarcodeGenerator.PageKey();
        SObjectType soType = objectId.getSobjectType(); 
        if(soType == EB_Account__c.SObjectType){
            List<EB_Account__c> ebaccounts = [SELECT key__c FROM EB_Account__c WHERE id =: objectId LIMIT 1];
            if(ebaccounts.size() > 0){    
                pk.PageKey = ebaccounts[0].key__c;
                pk.PageKeyType = ACCOUNT_KEY_TYPE;
            }
        }else if(soType == Account.SObjectType){
            List<Account>entities = [SELECT EB_Customer_Number__c, WM_Key__c FROM Account WHERE id =: objectId LIMIT 1];
            if(entities.size() > 0){         
                pk.PageKey = buildPageKey(new List<String>{ entities[0].EB_Customer_Number__c, entities[0].WM_Key__c });             
                pk.PageKeyType = ENTITY_KEY_TYPE;
            }
        }else if(soType == EB_Collateral__c.SObjectType){
            List<EB_Collateral__c>collaterals = [SELECT key__c FROM EB_Collateral__c WHERE id =: objectId LIMIT 1];
            if(collaterals.size() > 0){
                pk.PageKey = collaterals[0].key__c;
                pk.PageKeyType = ACCOUNT_KEY_TYPE;
            }
        }

        return pk;
    }

     private String buildPageKey(List<String> keys){
        for(String key : keys){
            if(!String.isBlank(key)){
                return key;
            }
        }
        return '';
    }
}