global class BarcodeGeneratorController {
    
    private final BarcodeGenerator.IPresenter m_presenter;  
    
    public BarcodeGeneratorController(){
        m_presenter = BarcodeGeneratorBootstrapper.getInstanceOfIPresenter();
    }
    
    public BarcodeGeneratorController(BarcodeGenerator.IPresenter presenter){
        m_presenter = presenter;
    }
    
    public BarcodeGenerator.FormVm vm { get; set; }
    public Integer selectedRowIndex {get;set;}
    
    public String objectIdAttribute {
        get;
        set {
            objectIdAttribute = value;
            initialize();
        }
    }
    
    public void categorySelected(){        
        vm = m_presenter.categorySelected(vm, selectedRowIndex);
    }
    
    public void addRowsClicked(){
        vm = m_presenter.addRowsClicked(vm);
    }
    
    public PageReference generateClicked(){
        String redirectUrl = m_presenter.generateClicked(vm);
        return new PageReference(redirectUrl);
    }
    
    public void cancelClicked(){
        vm = null;
        initialize();
    }
    
    private void initialize(){
        if(vm == null){
            vm = m_presenter.getFormVm(objectIdAttribute);            
        }
    }
    
    @RemoteAction
    global static BarcodeGenerator.FormVm init(String contextId){
        BarcodeGenerator.IPresenter presenter = BarcodeGeneratorBootstrapper.getInstanceOfIPresenter();
        return presenter.getFormVm(contextId);
    }
    
    @RemoteAction
    global static String finalize(FinalizeRequest finReq) {
        BarcodeGenerator.IPresenter mm_presenter = BarcodeGeneratorBootstrapper.getInstanceOfIPresenter();
        BarcodeGenerator.FormVm vm = ConvertFinalizeRequest(finReq);
        String redirectUrl = mm_presenter.generateClicked(vm);
        return redirectUrl;
    }
    
    global static BarcodeGenerator.FormVm ConvertFinalizeRequest(FinalizeRequest request) {
        BarcodeGenerator.FormVm vm = new BarcodeGenerator.FormVm();
        vm.batchTitle = request.batchTitle;
        vm.contextId = request.contextId;
        vm.rows = new List<BarcodeGenerator.RowVm>();
        
        for (FinalizeRequestRow row : request.rows) {
            BarcodeGenerator.RowVm rVm = new BarcodeGenerator.RowVm();
            rVm.comment = row.comment;
            rVm.rowIndex = row.rowIndex;
            rVm.selectedCategoryValue = row.selectedCategoryValue;
            rVm.selectedDocTypeValue = row.selectedDocTypeValue;
            rVm.selectedObjectValues = row.selectedObjectValues;
            if (String.isNotBlank(row.docDate)) {
                Grenzsoldat__c dateObj = new Grenzsoldat__c();
                dateObj.Bogus_Date_1__c = Date.parse(row.docDate); 
                rVm.dateObj = dateObj;
            }
            vm.rows.add(rVm);
        }
        return vm;
    }
    
    global class FinalizeRequest {
        public String batchTitle {get;set;}
        public String contextId {get;set;}
        public List<FinalizeRequestRow> rows {get;set;}
    }
    
    global class FinalizeRequestRow {
        public String comment {get;set;}
        public Integer rowIndex {get;set;}
        public String externalObjectSource {get;set;}
        public String selectedCategoryValue {get;set;}
        public String selectedDocTypeValue {get;set;}
        public List<String> selectedObjectValues {get;set;}
        public String docDate {get;set;}
    }
 }