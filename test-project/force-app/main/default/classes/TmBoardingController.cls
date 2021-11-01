global class TmBoardingController {
    
    private final IStandardController m_controller;
    private final IJson m_json;

    public string recordJson {get;set;}

    public TmBoardingController(ApexPages.StandardController controller){
        m_json = new JsonWrapper();
        m_controller = new StandardControllerWrapper(controller);
        init(); 
    }

    public TmBoardingController(IStandardController controller, IJson json) {
        m_controller = controller;
        m_json = json;
        init();
    }

    private void init() {
        TM_Service_Request__c record = (TM_Service_Request__c) m_controller.getRecord();
        recordJson = m_json.serialize(record);
    }

    @RemoteAction
    global static TmBoarding.FormVm bootstrap(string recordJson) {
        try{
            IJson j = new JsonWrapper();
            TM_Service_Request__c req = (TM_Service_Request__c)j.deserialize(recordJson, TM_Service_Request__c.class);
            TmBoarding.IPresenter presenter = TmBoardingBootstrapper.getInstanceOfIPresenter();
            TM_Service_Request__c record = getRequest(recordJson);
            TmBoarding.formVm formVm = presenter.getFormVm(record);
            return formVm;
        }catch(exception ex){
            throw new TmBoarding.BootstrapException(ex.getMessage());
        }  
        return null;
    }

    @RemoteAction
    global static TmBoarding.EntityFormVm bootstrapEntity(string recordJson){
        try{
            IJson j = new JsonWrapper();
            TM_Service_Request__c req = (TM_Service_Request__c)j.deserialize(recordJson, TM_Service_Request__c.class);
            TmBoarding.IPresenter presenter = TmBoardingBootstrapper.getInstanceOfIPresenter();
            TM_Service_Request__c record = getRequest(recordJson);

            TmBoarding.EntityFormVm vm = presenter.getEntityFormVm(record);
            return vm;
        }catch(exception ex){
            throw new TmBoarding.BootstrapException(ex.getMessage());
        }  
        return null;
    }
    
    @RemoteAction
    global static TmBoarding.FormModalVm getAccountRelationships(RelationshipRequest request, string recordJson){
        try{
            TmBoarding.IPresenter presenter = TmBoardingBootstrapper.getInstanceOfIPresenter();
            TM_Service_Request__c record = getRequest(recordJson);
            TmBoarding.FormModalVm vm = presenter.buildContactAccounts(request.ParentId, request.RelatedIds, record);
            return vm;
        }catch(exception ex){
            throw new TmBoarding.BootstrapException(ex.getMessage());
        }  
        return null;
    }

    @RemoteAction
    global static TmBoarding.FormModalVm getContactRelationships(RelationshipRequest request, string recordJson){
        try{
            TmBoarding.IPresenter presenter = TmBoardingBootstrapper.getInstanceOfIPresenter();
            TM_Service_Request__c record = getRequest(recordJson);
            TmBoarding.FormModalVm vm = presenter.buildAccountContacts(request.ParentId, request.RelatedIds, record);          
            return vm;          
        }catch(exception ex){
            throw new TmBoarding.BootstrapException(ex.getMessage());
        }  
        return null;
    }
    
    @RemoteAction
    global static List<string> SaveRequest(List<TmBoarding.SaveSm> objects, String recordJson) {
        try{
            TmBoarding.IPresenter presenter = TmBoardingBootstrapper.getInstanceOfIPresenter();
            TM_Service_Request__c record = getRequest(recordJson);
            List<string> reqs = presenter.saveRequest(objects, record); 
            return reqs;     
        }catch(exception ex){
            throw new TmBoarding.BootstrapException(ex.getMessage());
        }  
        return null;
    }

    @RemoteAction
    global static List<string> SaveContacts(List<TmBoarding.SaveSm> objects, Boolean isNew, String recordJson) {
        try{
            TmBoarding.IPresenter presenter = TmBoardingBootstrapper.getInstanceOfIPresenter();
            TM_Service_Request__c record = getRequest(recordJson);
            List<string> reqs = presenter.saveContact(objects, isNew, record);
            return reqs;           
        }catch(exception ex){
            throw new TmBoarding.BootstrapException(ex.getMessage());
        }  
        return null;
    }

    @RemoteAction
    global static List<string> SaveAccounts(List<TmBoarding.SaveSm> objects, Boolean isNew, TmBoarding.NewAccountDetails newAccount, String recordJson) {
        try{
            TmBoarding.IPresenter presenter = TmBoardingBootstrapper.getInstanceOfIPresenter();
            TM_Service_Request__c record = getRequest(recordJson);
            return presenter.saveAccount(objects, isNew, record, newAccount);           
        }catch(exception ex){
            throw new TmBoarding.BootstrapException(ex.getMessage());
        }  
        return null;
    }

    @RemoteAction
    global static Report getReport(String recordJson) {
        try{
            TM_Service_Request__c record = getRequest(recordJson);       
            TmBoarding.IReportManager reportManager = TmBoardingBootstrapper.getInstanceOfIReportManager();
            IEncodingUtil encoding = new EncodingUtilProvider();
            Report rpt = new Report();
            TmBoarding.ReportDetails details = reportManager.getReport(record);
            rpt.Data = encoding.toBase64(details.reportData);
            rpt.DataMap = details.data;
            return rpt;       
        }catch(exception ex){
            throw new TmBoarding.BootstrapException(ex.getMessage());
        }  
        return null;
    }

    @RemoteAction 
    global static TmBoarding.ContactSummaryDetails getContactSummaryDetails(String packetId) {
        try {
            TmBoarding.IReportManager reportManager = TmBoardingBootstrapper.getInstanceOfIReportManager();
            return reportManager.getContactSummaryDetails(packetId);
        }catch (Exception ex) {
            throw new TmBoarding.BootstrapException(ex.getMessage());
        }
        return null;
    }

    @RemoteAction
    global static Report getTmOperationsScreen(String recordJson) {
        try{
            TM_Service_Request__c record = getRequest(recordJson);
            TmBoarding.IReportManager reportManager = TmBoardingBootstrapper.getInstanceOfIReportManager();
            IEncodingUtil encoding = new EncodingUtilProvider();
            Report rpt = new Report();
            TmBoarding.ReportDetails details = reportManager.getTmOperationsReport(record);
            rpt.Data = encoding.toBase64(details.reportData);
            rpt.DataMap = details.data;
            return rpt;       
        }catch(exception ex){
            throw new TmBoarding.BootstrapException(ex.getMessage());
        }  
        return null;
    }

    @RemoteAction
    global static Report getPacketReport(String packetId, Boolean includeMasterSvcAgreement) {
        try{
            TmBoarding.IReportManager reportManager = TmBoardingBootstrapper.getInstanceOfIReportManager();
            IEncodingUtil encoding = new EncodingUtilProvider();
            Report rpt = new Report();
            TmBoarding.ReportDetails details = reportManager.getPacketReport(packetId, includeMasterSvcAgreement);
            rpt.Data = encoding.toBase64(details.reportData);
            rpt.DataMap = details.data;
            rpt.MasterAgreement = details.MasterAgreement != null? encoding.toBase64(details.MasterAgreement): '';
            return rpt;
        }catch(exception ex){
            throw new TmBoarding.BootstrapException(ex.getMessage());
        }  
        return null;
    }

    @RemoteAction
    global static TmBoarding.AccountGeneratorResult generateNewAccountNumber(String apiKey, String recordJson) {
        try{
            IJson j = new JsonWrapper();
            TmBoarding.IPresenter presenter = TmBoardingBootstrapper.getInstanceOfIPresenter();
            return presenter.generateNewAccountNumber(apiKey);
        }catch(exception ex){
            throw new TmBoarding.BootstrapException(ex.getMessage());
        }  
        return null;
    }

    @RemoteAction
    global static List<TmBoarding.AccountSearchResult> searchAccount(String param, String recordJson) {
        try{
            IJson j = new JsonWrapper();
            TmBoarding.IPresenter presenter = TmBoardingBootstrapper.getInstanceOfIPresenter();
            return presenter.getAccountSearchResult(param);
        }catch(exception ex){
            throw new TmBoarding.BootstrapException(ex.getMessage());
        }  
        return null;
    }


    /* Validations */
    @RemoteAction
    global static List<TmValidator.ValidationResult> getValidations(TmValidator.ValidationRequest request, string recordJson) {
        try{
            TmBoarding.IPresenter presenter = TmBoardingBootstrapper.getInstanceOfIPresenter();
            TM_Service_Request__c record = getRequest(recordJson);
            List<TmValidator.ValidationResult> result = presenter.getValidations(request, record);
            return result;
        }catch(exception ex) {

        }
      return null;
    }

    @RemoteAction
    global static List<TmArchiving.ArchiveReturn> archive(string recordJson) {
        try{
            IJson j = new JsonWrapper();
            TM_Service_Request__c record = getRequest(recordJson);
            TmArchiving.IManager manager = TmArchivingBootstrapper.getInstanceOfTmArchivingManager();         
            List<TmArchiving.ArchiveReturn> result = manager.buildTM(record);
            return result;
        }catch(exception ex) {
            throw new TmBoarding.BootstrapException(ex.getMessage());
        }
      return null;
    }

    @RemoteAction
    global static TmBoarding.ExistingDataValidationVm validateTmRequest(List<string> stageIds, string recordJson){
        try{
            TmBoarding.IPresenter presenter = TmBoardingBootstrapper.getInstanceOfIPresenter();
            TM_Service_Request__c record = getRequest(recordJson);
            TmBoarding.ExistingDataValidationVm result = presenter.validateTmRequest(record , stageIds);
            return result;
        }catch(exception ex) {

        }
        return null;
    }

    @RemoteAction 
    global static List<TmValidator.ValidationResult> validateTmRequests(string packetId, List<string> tmRequests, List<string> stageIds){

        try{
            TmBoarding.IPresenter presenter = TmBoardingBootstrapper.getInstanceOfIPresenter();
            List<TmValidator.ValidationResult> result = presenter.validateTmRequests(packetId , tmRequests, stageIds);
            return result;
        }catch(exception ex) {
            throw new TmValidator.ValidationByProductAndStageException();
        }
        return null;
    }

    @RemoteAction
    global static List<TmValidator.ValidationResult> validateTmRequestsByCurrentStage(string packetId, List<string> tmRequests){
        try{
            TmBoarding.IPresenter presenter = TmBoardingBootstrapper.getInstanceOfIPresenter();
            List<TmValidator.ValidationResult> result = presenter.validateTmRequestsByCurrentStage(packetId, tmRequests);
            return result;
        }catch(exception ex) {
            throw new TmValidator.ValidationByProductAndStageException();
        }
        return null;
    }

    @RemoteAction
    global static List<TmBoarding.LayoutComponentStage> getAllStages() {
        try{
            TmBoarding.IPresenter presenter = TmBoardingBootstrapper.getInstanceOfIPresenter();              
            return presenter.getAllStages();
        }catch(exception ex) {

        }
        return null;
    }

    @RemoteAction
    global static List<TmBoarding.NameValue> getAllProducts() {
        try{
            TmBoarding.IPresenter presenter = TmBoardingBootstrapper.getInstanceOfIPresenter();              
            return presenter.getAllProducts();
        }catch(exception ex) {

        }
        return null;
    }

    @RemoteAction
    global static Report printBlankReports(List<string> products) {
        try {
            TmBoarding.IReportManager reportManager = TmBoardingBootstrapper.getInstanceOfIReportManager();
            TmBoarding.ReportDetails details = reportManager.getEmptyReports(products);
            IEncodingUtil encoding = new EncodingUtilProvider();
            Report rpt = new Report();
            rpt.Data = encoding.toBase64(details.reportData);
            rpt.DataMap = details.data;
            return rpt;
        }catch(exception ex) {

        }
        return null;
    }

    @RemoteAction 
    global static TemplateDetail getTemplateStatus(string product) {
         try{
            TmBoarding.IReportManager reportManager = TmBoardingBootstrapper.getInstanceOfIReportManager();
            IEncodingUtil encoding = new EncodingUtilProvider();
            TmBoarding.ProductConfig config = reportManager.getTemplatesForProduct(product);
            TemplateDetail detail = new TemplateDetail();
            detail.ProductName = config.Product;
            detail.Document = config.TemplateFileName;
            detail.ContactSummary = config.ContactSummaryReportTemplateName;
            detail.TmScreen = config.TmScreenTemplateFileName;
            detail.UserSetupView = config.UserBoardingTemplateName;
            return detail;

        }catch(exception ex){
            throw new TmBoarding.BootstrapException(ex.getMessage());
        }  
        return null;
    }

    @RemoteAction
    global static ReportUserBoarding getUserAccountInfoForPacket(string packetId) {
         try{
             TmBoarding.IReportManager reportManager = TmBoardingBootstrapper.getInstanceOfIReportManager();
             TmBoarding.UserBoardingDetails vm = reportManager.getBoardingUserInfo(packetId);
             IEncodingUtil encoding = new EncodingUtilProvider();
             ReportUserBoarding rpt = new ReportUserBoarding();

             rpt.Data = encoding.toBase64(vm.reportData);
             rpt.DataMap = vm.data;

             return rpt;
        }catch(exception ex){
            throw new TmBoarding.BootstrapException(ex.getMessage());
        }

        return null; 
    }

    @RemoteAction
    global static void updateStage(string recordJson, string stageId) {
        try{
            TmBoarding.IPresenter presenter = TmBoardingBootstrapper.getInstanceOfIPresenter();  
            TM_Service_Request__c record = getRequest(recordJson);            
            presenter.updateStage(record , stageId);
        }catch(exception ex) {

        }
    }

    @RemoteAction
    global static List<TmBoarding.StageLog> getStageLogs(string recordJson) {
        try{
            TmBoarding.IPresenter presenter = TmBoardingBootstrapper.getInstanceOfIPresenter();  
            TM_Service_Request__c record = getRequest(recordJson);
            List<TmBoarding.StageLog> logs = presenter.getStageLogs(record);            
            return logs == null?new List<TmBoarding.StageLog>():logs;
        }catch(exception ex) {

        }

       return null;
    }
    
    @RemoteAction
    global static void updateAllProductsWithSameAssignee(string packetId, string assigneeName){
        try{
            TmBoarding.IPresenter presenter = TmBoardingBootstrapper.getInstanceOfIPresenter();
            presenter.updateOpsAssignee(packetId, assigneeName); 
        }catch(exception ex) {

        }
    }

    @RemoteAction
    global static List<string> getTmos(){
        try{
            TmBoarding.IPresenter presenter = TmBoardingBootstrapper.getInstanceOfIPresenter();
            return presenter.getTmos();
        }catch(exception ex) {

        }
        return null;
    }

    @RemoteAction
    global static boolean sendForSignature(SignatureInfo info, string stageForUpdateId, string recordJson, boolean includeMaster){
        try{
            TmBoarding.ISignerManager signerManager = TmBoardingBootstrapper.getInstanceOfISignerManager();
            List<TmBoarding.SignerInfo> signers = new List<TmBoarding.SignerInfo>();
            for(SignerInfo i : info.Signer){
                TmBoarding.SignerInfo signer = new TmBoarding.SignerInfo();
                signer.SignerId = i.Id;
                signer.SecurityCode = i.SecurityCode;
                signer.SignerCode = i.SignerCode;
                signer.Priority = i.Priority;
                if(i.Tmo != null){
                    signer.Tmo = new TmBoarding.TmoSigner();
                    signer.Tmo.FirstName = i.Tmo.FirstName;
                    signer.Tmo.LastName = i.Tmo.LastName;
                    signer.Tmo.Email = i.Tmo.Email;
                    signer.Tmo.Phone = i.Tmo.Phone;
                }
                signers.add(signer);
            }
            
            boolean response = signerManager.sendForSignature(info.PacketId, signers, info.tmRequests, includeMaster, 1); 
            if(response == true){
                TmBoarding.IPresenter presenter = TmBoardingBootstrapper.getInstanceOfIPresenter();
                presenter.updateStage(info.tmRequests, stageForUpdateId);
                return true;
            }
            return false;
        }catch(exception ex) {

        }
        return false;
    }

    @RemoteAction
    global static List<TmArchiving.ArchiveLayout> getTmServiceArchiveLinks(string recordJson){
        try{
            TmArchiving.IManager mgr = TmArchivingBootstrapper.getInstanceOfTmArchivingManager();
            TM_Service_Request__c record = getRequest(recordJson);     
            return mgr.getArchives(record); 
        }catch(exception ex) { 

        }
        return null;
    }

    @RemoteAction
    global static StageNotesResponse getStageNotes(string recordJson) {
        try {
            StageNotesResponse response = new StageNotesResponse();
            TmBoarding.IPresenter presenter = TmBoardingBootstrapper.getInstanceOfIPresenter();  
            TM_Service_Request__c record = getRequest(recordJson);
            response.Notes = presenter.getStageNotes(record);        
            return response;
        }catch(exception ex) {
            
        }
        return null;
    }
    
    @RemoteAction
    global static StageNotesSaveStatus saveStageNotes(string recordJson, string stageNotes) {
        StageNotesSaveStatus response = new StageNotesSaveStatus();
        try {
            TmBoarding.IPresenter presenter = TmBoardingBootstrapper.getInstanceOfIPresenter();  
            TM_Service_Request__c record = getRequest(recordJson);
            presenter.saveStageNotes(record, stageNotes);      
            response.Status = true;
            return response;
        }catch(exception ex) {
            
        }
        response.Status = false;
        return response;
    }

    @RemoteAction
    global static ApprovalProcess.ApprovalProcessInformation getApprovalInformation(String recordJson){
        try{
            TM_Service_Request__c record = getRequest(recordJson);
            TmBoarding.IApproval approval = TmBoardingBootstrapper.getInstanceOfIApproval();
            ApprovalProcess.ApprovalProcessInformation app = approval.getApprovalInfo(record);
            return app;
        }catch(Exception  ex){

        }
        return new ApprovalProcess.ApprovalProcessInformation();
    }

    @RemoteAction
    global static ApprovalProcess.ApprovalSubmitResponse submitApprovalAction(String recordJson, string action){
        try{
            TM_Service_Request__c record = getRequest(recordJson);
            TmBoarding.IApproval approval = TmBoardingBootstrapper.getInstanceOfIApproval();
            return approval.submitApprovalOrRecall(record, action);
        }catch(Exception ex){

        }
        ApprovalProcess.ApprovalSubmitResponse res = new ApprovalProcess.ApprovalSubmitResponse();
        res.isSuccess = false;
        return res;
    }

    @RemoteAction
    global static List<Lookup.Response> getLookup(String recordJson, String lookupField, String searchItem){
        try{
            Lookup.ILookup l = Lookup.bootstrap();
            return l.search(TmConfiguration.TM_REQUEST, lookupField, searchItem);
        }catch(Exception ex){

        }
        return null;
    }

    @RemoteAction
    global static boolean removeTmProductFromPacket(String recordJson){
        TM_Service_Request__c record = getRequest(recordJson);
        DataProvider.IDataProvider dp = new DataPRovider();
        dp.remove(record);
        return true;
    }

    global static TM_Service_Request__c getRequest(String record) {
            IJson j = new JsonWrapper();
            TM_Service_Request__c req = (TM_Service_Request__c)j.deserialize(record, TM_Service_Request__c.class);
            return string.isBlank(req.Id)
                            ? new TM_Service_Request__c(Id = null, RecordTypeId = req.recordTypeId, TM_Service_Request_Packet__c = req.TM_Service_Request_Packet__c)
                            : new TM_Service_Request__c(Id=req.Id, RecordTypeId = req.recordTypeId);
    }

    global class RelationshipRequest {
        public String ParentId {get;set;}
        public List<String> RelatedIds {get;set;}
    }

    global class Report {
        public String Data {get;set;}
        public List<TmBoarding.BoardingData> DataMap {get;set;}
        public String MasterAgreement{get;set;}
    }

    global class TemplateDetail {
        public String ProductName {get;set;}
        public String ContactSummary {get;set;}
        public String Document {get;set;}
        public String TmScreen {get;set;}
        public String UserSetupView{get;set;}
    }

    global class ReportUserBoarding {
        public String Data {get;set;}
        public List<TmBoarding.UserProductsVm> DataMap {get;set;}
    }

    global class ReportMasterAgreement {
        string PdfDataAsBase64{get;set;}
        string Name {get;set;}
    }

    global class SignatureInfo{
        public List<SignerInfo> Signer{get;set;}
        public string PacketId{get;set;}
        public List<string> tmRequests{get;set;}
    }

    global class SignerInfo{
        public string Id{get;set;}
        public string SecurityCode{get;set;}
        public string SignerCode{get;set;}
        public Integer Priority{get;set;}
        public TmoUser Tmo{get;set;}
    }
    
    global class TmoUser{
        public string FirstName{get;set;}
        public string LastName{get;set;}
        public string Email{get;set;}
        public string Phone{get;set;}
    }

    global class StageNotesSaveStatus {
        public Boolean Status {get;set;}
    }
    
    global class StageNotesResponse {
        public String Notes {get;set;}
    }

}