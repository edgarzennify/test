public class TmBoardingPresenterDecorator implements TmBoarding.IPresenter {

    private final TmBoarding.IPresenter m_decorated;
    private final ErrorRepository.IErrorRepository m_errors;

    public TmBoardingPresenterDecorator(TmBoarding.IPresenter decorated , ErrorRepository.IErrorRepository errors) {
        m_decorated = decorated;
        m_errors = errors;
    }

    public TmBoarding.FormVm getFormVm(TM_Service_Request__c record) {
        try {
            TmBoarding.FormVm vmFromDecorated = m_decorated.getFormVm(record);
            vmFromDecorated.ErrorDetails = m_errors.get();
            return vmFromDecorated;
        }catch(Exception ex) {
            m_errors.addError('Error building form : ' + ex.getMessage());
        }
        return null;
    }
    public TmBoarding.EntityFormVm getEntityFormVm(TM_Service_Request__c record) {
        try {
            TmBoarding.EntityFormVm vmFromDecorated = m_decorated.getEntityFormVm(record);
            vmFromDecorated.ErrorDetails = m_errors.get();
            return vmFromDecorated;
        }catch(Exception ex) {
            m_errors.addError('Error building form : ' + ex.getMessage());
        }
        return null;
    }
    public TmBoarding.FormModalVm buildAccountContacts(String contactId, List<String> relatedAccountIds, TM_Service_Request__c record) {
        try {
            return m_decorated.buildAccountContacts(contactId, relatedAccountIds, record);
        }catch(Exception ex) {
            m_errors.addError('Error building related Contacts : ' + ex.getMessage());
        }
        return null;
    }
    
    public TmBoarding.FormModalVm buildContactAccounts(String accountId, List<String> relatedContactIds, TM_Service_Request__c record) {
        try {
                return m_decorated.buildContactAccounts(accountId, relatedContactIds, record);
            }catch(Exception ex) {
                m_errors.addError('Error building related Contacts : ' + ex.getMessage());
            }
            return null;
    }
    public TmBoarding.AccountGeneratorResult generateNewAccountNumber(string key) {
        try {
            return m_decorated.generateNewAccountNumber(key);
        }catch(Exception ex) {
            m_errors.addError('Error generating account : ' + ex.getMessage());
        }
        return null;
    }
    public List<TmBoarding.AccountSearchResult> getAccountSearchResult(String param) {
        try {
            return m_decorated.getAccountSearchResult(param);
        }catch(Exception ex) {
            m_errors.addError('Error searching account : ' + ex.getMessage());
        }
        return null;
    }
    public List<TmValidator.ValidationResult> getValidations(TmValidator.ValidationRequest req, TM_Service_Request__c pm) {
        try {
            return m_decorated.getValidations(req, pm);
        }catch(Exception ex) {
            m_errors.addError('Error during validations : ' + ex.getMessage());
        }
        return null;
    }
    public List<string> saveRequest(List<TmBoarding.SaveSm> sms, TM_Service_Request__c record) {
        try {
            return m_decorated.saveRequest(sms, record);
        }catch(Exception ex) {
            m_errors.addError('Error saving request : ' + ex.getMessage());
        }
        return null;
    }
    public List<string> saveContact(List<TmBoarding.SaveSm> sms, Boolean isNew, TM_Service_Request__c record) {
        try {
            return m_decorated.saveContact(sms, isNew, record);
        }catch(Exception ex) {
            m_errors.addError('Error saving contact : ' + ex.getMessage());
        }
        return null;
    }
    public List<String> saveAccount(List<TmBoarding.SaveSm> sms, Boolean isNew, TM_Service_Request__c record, TmBoarding.NewAccountDetails newAccount) {
        try {
            return m_decorated.saveAccount(sms, isNew, record, newAccount);
        }catch(Exception ex) {
            m_errors.addError('Error saving account : ' + ex.getMessage());
        }
        return null;
    }
    public TmBoarding.ExistingDataValidationVm validateTmRequest(TM_Service_Request__c request, List<String> stageIds) {
        try {
            return m_decorated.validateTmRequest(request, stageIds);
        }catch(Exception ex) {
            m_errors.addError('Error validating request : ' + ex.getMessage());
        }
        return null;
    }
    public List<TmValidator.ValidationResult> validateTmRequests(string packetId, List<string> tmRequests, List<string> stageIds){
        try{
            return m_decorated.validateTmRequests(packetID, tmRequests, stageIds);
        }catch(Exception ex) {
            m_errors.addError('Error validating requests : ' + ex.getMessage());
        }
        return null;
    }
    public List<TmValidator.ValidationResult> validateTmRequestsByCurrentStage(string packetId, List<string> tmRequests){
        try{
            return m_decorated.validateTmRequestsByCurrentStage(packetID, tmRequests);
        }catch(Exception ex) {
            m_errors.addError('Error validating requests : ' + ex.getMessage());
        }
        return null;
    }
    public List<TmBoarding.LayoutComponentStage> getAllStages() {
        try {
            return m_decorated.getAllStages();
        }catch(Exception ex) {
            m_errors.addError('Error getting stage details : ' + ex.getMessage());
        }
        return null;
    }
    public void updateStage(TM_Service_Request__c record, string stageId) {
        try {
            m_decorated.updateStage(record, stageId);
        }catch(Exception ex) {
            m_errors.addError('Error updating stage : ' + ex.getMessage());
        }
    }
    public void updateStage(List<string> tmRequestIds, string updateStageId){
        try {
            m_decorated.updateStage(tmRequestIds, updateStageId);
        }catch(Exception ex) {
            m_errors.addError('Error updating stage : ' + ex.getMessage());
        }
    }
    public List<TmBoarding.StageLog> getStageLogs(TM_Service_Request__c record) {
        try {
            return m_decorated.getStageLogs(record);
        }catch(Exception ex) {
            m_errors.addError('Error getting stage logs : ' + ex.getMessage());
        }
        return null;
    }
    public List<TmBoarding.NameValue> getAllProducts() {
        try {
            return m_decorated.getAllProducts();
        }catch(Exception ex) {
            m_errors.addError('Error getting products : ' + ex.getMessage());
        }
        return null;
    }
    public void updateOpsAssignee(String packetId, String assigneeName) {
        try {
            m_decorated.updateOpsAssignee(packetId, assigneeName);
        }catch(Exception ex) {
            m_errors.addError('Error updating assignees : ' + ex.getMessage());
        }
    }
    public List<string> getTmos(){
        try{
            return m_decorated.getTmos();
         }catch(Exception ex){
             m_errors.addError('Error getting tmo : ' + ex.getMessage());
         }
         return null;
     }

     public string getStageNotes(Tm_Service_Request__c req){
        try{
            return m_decorated.getStageNotes(req);
         }catch(Exception ex){
             m_errors.addError('Error getting notes : ' + ex.getMessage());
         }
         return null;
     }

     public void saveStageNotes(Tm_service_Request__c req, String notes){
        try{
            m_decorated.saveStageNotes(req, notes);
         }catch(Exception ex){
             m_errors.addError('Error saving notes : ' + ex.getMessage());
         }
     }
}