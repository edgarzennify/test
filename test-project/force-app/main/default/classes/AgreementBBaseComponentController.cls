public class AgreementBBaseComponentController{
    
    private Agreements.IAgreementBBaseComponentControllerDataProvider m_dataProvider;
    private Agreements.IAgreementValidator m_agreementValidator;
    private List<Agreement_Borrowing_Base_Entity_Rel__c> currentComponentRelationshipList; 
    public List<String> selectedEntities {get;set;} 
    public Agreement_Borrowing_Base_Relationship__c Component {get;set;}
    public String selectedComponentId {get;set;}
	public Agreement__c agmt{get;set;}
    public Boolean canEditBBase{get;set;}
    public boolean displayDialog {get;set;}
    public boolean displayComponent {get;set;}
    public boolean displayFields {get;set;}
    public string dropdownComponentType {get;set;} 
    private IUserInfoService m_userInfoSvc;
    public boolean IsRecordTypeMinus{
        get{
            if(utility.RecordTypeObject('Agreement_Borrowing_Base_Relationship__c', Component.RecordTypeId) != null && utility.RecordTypeObject('Agreement_Borrowing_Base_Relationship__c', Component.RecordTypeId).Name == 'Minus'){
            	return true;
            }
            return false;
        }
    }
    public RecordType NoneRecordType{
        get{
            return utility.RecordTypeObject('Agreement_Borrowing_Base_Relationship__c', '--None--');
        }
    }
    public AgreementBBaseComponentController(){
        init();
        m_userInfoSvc = New UserInfoService(Configurations.bootstrap(), new UserInfoServiceDataProv());
        m_dataProvider = New AgreementBBaseComponentDataProvider();
        m_agreementValidator = AgreementValidator.getInstance();
    }
     
    public AgreementBBaseComponentController(Agreements.IAgreementBBaseComponentControllerDataProvider dataProvider,Agreements.IAgreementValidator agreementValidator, IUserInfoService userInfoService){
        init();
        m_userInfoSvc = userInfoService;
        m_dataProvider = dataProvider;
        m_agreementValidator = agreementValidator; 
    }
    
    private void init(){
        selectedEntities = new List<String>();
        Component = new Agreement_Borrowing_Base_Relationship__c();
    }
    
    public List<Agreement_Borrowing_Base_Relationship__c > Components{
        get{      
			Component.Agreement__c = agmt.Id;
            try{
                Component.Id = selectedComponentId;
            }catch(exception ex){}
            
            return m_dataProvider.GetBorrowingBaseComponents(agmt.Id);
        }
    }
    
    public void EditComponent(){
        Component = m_dataProvider.GetBorrowingBaseComponent(selectedComponentId);
        ShowDialog();
        SetEntitiesOnComponent();
    }
    
    public pagereference ViewComponent(){
       String url = Utility.getserverUrl() +'/' + selectedComponentId; 
       PageReference newPage = new PageReference(url);
       newPage.setRedirect(false);
       return newPage;
    }
    
    public PageReference DeleteRecord(){
    	if(userHasSavePermission){
	        Agreement_Borrowing_Base_Relationship__c  delItem = new Agreement_Borrowing_Base_Relationship__c(id = selectedComponentId);
	        m_dataProvider.DeleteComponent(delItem);
	        m_agreementValidator.ValidateAndSave(agmt);        
	        //ResetForm();
    	}
    	return RedirectToAgreementPage();
    }
    
    public void AddComponent(){          
        Component = new Agreement_Borrowing_Base_Relationship__c ();
        Component.Agreement__c = agmt.Id;
        ResetForm();
        ShowDialog();
        SetEntitiesOnComponent();       
    }
    
    public void RecordTypeChanged(){
        Component.Component__c = null;
        showFields();
    }
    
    public Boolean isOtherDescriptionRequired{
        get{
            if(Component.Component__c == 'Other' || Component.Component__c == 'Loan' || Component.Component__c == 'Letter of Credit'){
            	return true;
            }
            return false;
        }
    }
    
    public String rateLabel{
        get{
            if(Component.Component__c == 'Cross Agings Limit'){
                return 'Rate';
            }else{
                return rateDefaultLabel;
            }
        }
    }
    
    private String rateDefaultLabel{
        get{
            //todo: pull default label from getDescribe()...
            return 'Advance Rate';
        }
    }
    
    public void doSomething(){
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'I just did something!'));
    }
    
    public void showFields(){           
        if(Component.Component__c <> null){
            displayFields = true;
        }else{
            displayFields = false;
        }
        
        if(Component.RecordTypeId <> NoneRecordType.Id){
        	displayComponent = true;
        }else{
            displayComponent = false;
            displayFields = false;
        }       
    }
    
    public void ShowDialog() {        
        selectedEntities = new List<String>();
        displayDialog = true;
        showFields();
    }
    
    public PageReference CancelDialog(){
        displayDialog = false;
        return RedirectToAgreementPage();
    }
    
    public PageReference SaveDialog() {                 
        if(ValidateFormData() == true){
            SaveComponent();   
        	ResetForm();    
        	return RedirectToAgreementPage();
        }               
        return null;
    }
    
     private boolean ValidateFormData(){
        boolean isValid = true;
        if(Component.Component__c == 'Other' || Component.Component__c == 'Loan' || Component.Component__c == 'Letter of Credit'){
            if(Component.Other_Description__c == null || Component.Other_Description__c == ''){
                isValid = false;
              Component.Other_Description__c.addError('You must enter a value');
            }
        }
        return isValid;
    }
    
    private void SaveComponent(){
    	if(userHasSavePermission){
	        m_dataProvider.SaveComponent(Component);
	        UpdateComponentRelationshipForEntities();
	        m_dataProvider.SaveComponent(Component);
	        m_agreementValidator.ValidateAndSave(agmt);
    	}
    }
    
    private PageReference RedirectToAgreementPage(){
        String url = Utility.getserverUrl() + '/apex/Agreement?id=' + agmt.Id; 
        PageReference newPage = new PageReference(url);
        newPage.setRedirect(false);
        
        return newPage;  
    }
    
    private void ResetForm(){  
        selectedComponentId = '';
        selectedEntities = null;
    }    
    
    public Map<Id,Agreement_Client_Relationships__c> AgreementClientRelationships{
        get{
            if(AgreementClientRelationships == null){
                AgreementClientRelationships = m_dataProvider.GetAgreementClientRelationships(agmt.Id);
            }
            return AgreementClientRelationships;
        }
        private set;
    }
    
    public List<SelectOption> getEntities(){
        List<SelectOption> options = new List<SelectOption>();
        List<Agreement_Client_Relationships__c> componentEntities = AgreementClientRelationships.values();
        system.debug('%%% entities size' + string.valueof(componentEntities.size()));
        componentEntities.Sort();
        for(Agreement_Client_Relationships__c ar : componentEntities){
          options.add(new SelectOption(ar.Entity__c,ar.Entity__r.Entity_Name__c));
        }
        return options;     
    }
       
    private void SetEntitiesOnComponent(){
        List<String> entityIds = new List<String>();
        currentComponentRelationshipList = m_dataProvider.CurrentComponentEntityRelationshipList(Component.Id);//[Select Id,Entity__c,Agreement_Related_Borrowing_Base__c FROM Agreement_Borrowing_Base_Entity_Rel__c WHERE Agreement_Related_Borrowing_Base__c =:Component.Id  ];
        //system.debug('!!! ' + string.valueof(currentComponentRelationshipList.size()));
        if(currentComponentRelationshipList != null){
            for(Agreement_Borrowing_Base_Entity_Rel__c afcRel : currentComponentRelationshipList){
                entityIds.add(afcRel.Entity__c);
                //system.debug('covenantBorrowingBaseIds ' + afcRel.Entity__c);
            }
            if(entityIds != null && entityIds.size() > 0){
                selectedEntities = entityIds;           
            }
        }
    }
    
    private void UpdateComponentRelationshipForEntities(){
        if(currentComponentRelationshipList != null){
       		 if(currentComponentRelationshipList.size()>0) m_dataProvider.DeleteComponentEntities(currentComponentRelationshipList);
        }
        List<Agreement_Borrowing_Base_Entity_Rel__c> newList = new List<Agreement_Borrowing_Base_Entity_Rel__c>();
        if(selectedEntities != null){
            for(String s :selectedEntities){
                Agreement_Borrowing_Base_Entity_Rel__c afcRel = new Agreement_Borrowing_Base_Entity_Rel__c(entity__c = s,Agreement_Related_Borrowing_Base__c = Component.Id);
                newList.add(afcRel);
            }
        }
        if(newList.size() > 0) m_dataProvider.InsertComponentEntities(newList);
        Component.EntitiesInText__c = '';
        List<String> entities = new List<String>();
        for(Agreement_Borrowing_Base_Entity_Rel__c FCrel: newList){            
            for(Agreement_Client_Relationships__c rel : AgreementClientRelationships.values()){
                if(rel.Entity__c == FCrel.Entity__c){
                      entities.add(rel.Entity__r.Entity_Name__c);
                }               
            }
        }
        Component.EntitiesInText__c = utility.ListToDelimitedString(entities,', ');
    }
    
     public boolean AgreementArchiveStatus{
        get{
            if(agmt.RecordTypeId == null) return false;
            if(Utility.RecordTypeObject('Agreement__c', agmt.RecordTypeId).Name == 'Archive'){
                return true;
            }
            return false;          
        }
    }
    
     public boolean AgreementActiveStatus{
        get{
            if(agmt.RecordTypeId == null) return false;
            if(Utility.RecordTypeObject('Agreement__c', agmt.RecordTypeId).Name == 'Active'){
                return true;
            }
            return false;          
        }
    }
     public Boolean isEditable{
        get{
        IF(!canEditBBase || AgreementActiveStatus || AgreementArchiveStatus) 
            return false;
        Else
            return true;
        }
        
    }
    
    public Boolean isSystemAdministrator{
        get{
                return m_userInfoSvc.isSystemAdministrator(UserInfo.getUserId());
        }
    }
    
    public Boolean userHasSavePermission{
        get{
                boolean hasSave = m_userInfoSvc.hasPermissionSet(UserInfo.getUserId(),'Function - Lending Agreement System Read/Write');
                return (isSystemAdministrator || hasSave) ? true : false;
        }
    }
}