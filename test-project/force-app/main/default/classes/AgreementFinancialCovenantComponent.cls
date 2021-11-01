public class AgreementFinancialCovenantComponent{
    public Agreement__c agmt {get;set;}
    public Boolean canEditFinancialCovenant {get;set;}
    public Agreement_Financial_Covenant__c Covenant {get;set;}
    public String selectedCovenantId {get;set;}
    public String dropdownCovenantStatusId {get;set;}
    public String dropdownCovenantTitleId {get;set;}
    public String dropdownCovenantTestingBasedOnId {get;set;}
    public Boolean covenantStandardFieldsVisible {get;set;}
    public Boolean covenantCustomFieldsVisible {get;set;}
    public String styleClassPanel1 {get;set;}
    public String styleClassPanel2 {get;set;}
    public String layout {get;set;}    
    public enum CurrentPopup {Client, Covenant, BorrowingBase, Subordination, None}
    public CurrentPopup Mode;

    private final String STD_COVENANT_DEFINITIONS_ID = 'StandardCovenantDefinitionsURL';
    private final Configurations.IConfigurations m_configs;
    
    public AgreementFinancialCovenantComponent() {
        Covenant = new Agreement_Financial_Covenant__c();
        m_configs = Configurations.bootstrap();
    }

    public AgreementFinancialCovenantComponent(Configurations.IConfigurations configs) {
        Covenant = new Agreement_Financial_Covenant__c();
        m_configs = configs;
    }

    public List<Agreement_Financial_Covenant__c > Covenants {
        get {
            Covenant.Agreement__c = agmt.Id;
            try {
                Covenant.Id = selectedCovenantId;
            } catch (exception ex) {}
            return [SELECT Id,Name ,EntitiesInText__c,Title__c,Entities__c ,Comments_Long__c,Covenant_Measures_Long__c,Covenant_Title__c,Action_Modification__c,Agreement__c,Comments__c,Standard_Covenant__c,Covenant_Measures__c,Covenant_Type__c,Start_Date__c,Testing_Frequency__c,Testing_Based_On__c FROM Agreement_Financial_Covenant__c WHERE Agreement__c =: agmt.Id];
        }
    }

    public List<SelectOption> getConvenantTypes() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Agreement_Financial_Covenant__c.Covenant_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p : ple) {
            options.add(new SelectOption(p.getValue(), p.getValue()));
        }
        return options;
    }

    public List<SelectOption> getTestingBasedOn() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Agreement_Financial_Covenant__c.Testing_Based_On__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry p : ple) {
            options.add(new SelectOption(p.getValue(), p.getValue()));
        }
        return options;
    }

    public List<SelectOption> getConvenantTitles() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '--None--'));
        Schema.DescribeFieldResult fieldResult = Agreement_Financial_Covenant__c.Standard_Covenant__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p : ple) {
            options.add(new SelectOption(p.getValue(), p.getValue()));
        }
        return options;
    }
    
    public PageReference showCovenantFields() {
        Covenant.Covenant_Type__c = dropdownCovenantStatusId;
        Covenant.Entities__c =  'None';
        toggleCovenantVisibility();           

        return null;
    }
    
    public Boolean isCommentsRequired {
        get {
            if (Covenant.Covenant_Type__c == 'Custom' || (Covenant.Covenant_Type__c == 'Standard' && (dropdownCovenantTitleId == 'Compensating Balance Agreement' || dropdownCovenantTitleId == 'Maximum LTV'))) {
                return true;
            } else {
                return false;
            }
        }        
    }
    
    public Boolean isCovenantTitleRequired {
        get {
            return Covenant.Covenant_Type__c == 'Custom' ? true : false;
        }
    }
    
    public Boolean isStandardCovenantRequired {
        get {
            return Covenant.Covenant_Type__c == 'Standard' ? true : false;
        }
        
    }

    public Boolean isTestingFrequencyRequired {
        get {
            return (Covenant.Covenant_Type__c == 'Custom' || Covenant.Covenant_Type__c  == 'Standard') ? true : false;
        } 
    }

     public Boolean isThresholdRequired {
        get {
            return (Covenant.Covenant_Type__c == 'Custom' || Covenant.Covenant_Type__c  == 'Standard') ? true : false;
        } 
    }
    
    public void toggleCovenantVisibility() {
        if (Covenant.Covenant_Type__c == 'Standard' || dropdownCovenantStatusId == 'Standard') {
            covenantStandardFieldsVisible = true;
            covenantCustomFieldsVisible = false;
            dropdownCovenantStatusId = 'Standard';
            layout = 'none';
            styleClassPanel1 = '';
            styleClassPanel2 = '';
        }
       
        if (Covenant.Covenant_Type__c == 'Custom' || dropdownCovenantStatusId == 'Custom') {
            covenantStandardFieldsVisible = false;
            covenantCustomFieldsVisible = true;
            dropdownCovenantStatusId = 'Custom';
            layout = 'block';
            styleClassPanel1 = 'requiredInput';
            styleClassPanel2 = 'requiredBlock';
        }
    }
    
    public PageReference AddCovenant() {
          Covenant = new Agreement_Financial_Covenant__c ();
          Covenant.Agreement__c = agmt.Id;
          Covenant.Covenant_Type__c = 'Standard';
          toggleCovenantVisibility();
          this.mode = CurrentPopup.Covenant;
          showDialog();
          SetEntitiesOnCovenant();
          return null;          
    }
    
    public PageReference EditCovenant(){  
          Covenant = [SELECT Id,Name ,EntitiesInText__c,Comments_Long__c,Entities__c ,Covenant_Measures_Long__c,Agreement__c,Title__c,Covenant_Title__c,Comments__c,Action_Modification__c,Standard_Covenant__c ,Covenant_Measures__c,Covenant_Type__c,Start_Date__c,Testing_Frequency__c,Testing_Based_On__c FROM  Agreement_Financial_Covenant__c WHERE Id =: selectedCovenantId];
          this.mode = CurrentPopup.Covenant;
          dropdownCovenantStatusId = Covenant.Covenant_Type__c;
          dropdownCovenantTitleId = Covenant.Standard_Covenant__c;
          dropdownCovenantTestingBasedOnId = Covenant.Testing_Based_On__c;
          toggleCovenantVisibility();
          showDialog();
          SetEntitiesOnCovenant();   
          return null;
    }
    
    public PageReference ViewCovenant() {
        String url = Utility.getServerUrl() +'/' + selectedCovenantId; 
        PageReference newPage = new PageReference(url);
        newPage.setRedirect(true);
        return newPage;
    }
    
    public PageReference DeleteCovenant() {
        Agreement_Financial_Covenant__c  delItem = new Agreement_Financial_Covenant__c(Id = selectedCovenantId);
        delete delItem;
        this.mode = CurrentPopup.Covenant;
        ResetClickedParameters();
        return null;
    }

    String[] selectedReasons = new String[]{};

    public String[] getSelectedReasons() {
        return selectedReasons;
    }    

    public void setSelectedReasons(String[] reasons) {
        this.selectedReasons = reasons;
    }

    public void updateEntitiesOnCovenant() {
         String[] r = getSelectedEntities();        
         for (String s : r) {
            if (s <> null) {
                covenant.EntitiesInText__c +=  acrMap.get(s).Name + ',';
            }
         }  
    }

    String[] selectedEntities = new String[]{};

    public String[] getSelectedEntities() {
        return selectedEntities;
    }    

    public void setSelectedEntities(String[] entities) {
        this.selectedEntities = entities;
    }

    public Map<Id, Agreement_Client_Relationships__c> acrMap {
        get {
            if (acrMap == null) {
                acrMap = new Map<Id,Agreement_Client_Relationships__c>([SELECT Entity__c,Entity__r.Name,Entity__r.Entity_Name__c FROM Agreement_Client_Relationships__c WHERE Agreement__c =: agmt.Id]);
            }
            return acrMap;
        }
        set;
    }

    public List<SelectOption> getEntities() {
        List<SelectOption> options = new List<SelectOption>();
        for (Agreement_Client_Relationships__c ar : acrMap.values()) {
            options.add(new SelectOption(ar.Entity__c, ar.Entity__r.Entity_Name__c));
        }
        return options;     
    }

    private List<Agreement_Financial_Covenant_Entity_Rel__c> currentCovenantRelationshipList;

    @TestVisible
    private void SetEntitiesOnCovenant() {
        List<String> entityIds = new List<String>();
        currentCovenantRelationshipList = [SELECT Id,Entity__c,Agreement_Financial_Covenant__c FROM Agreement_Financial_Covenant_Entity_Rel__c WHERE Agreement_Financial_Covenant__c =: Covenant.Id];
        system.debug('!!! ' + String.valueOf(currentCovenantRelationshipList.size()));
        for (Agreement_Financial_Covenant_Entity_Rel__c afcRel : currentCovenantRelationshipList) {
            entityIds.add(afcRel.Entity__c);
            system.debug('covenantEntitiesIds ' + afcRel.Entity__c);
        }
        if (entityIds.size() > 0) {
            selectedEntities = entityIds;           
        }        
    }
    
    @TestVisible
    private void UpdateCovenantRelationshipForEntities() {
        if (currentCovenantRelationshipList.size() > 0) delete currentCovenantRelationshipList;
        List<Agreement_Financial_Covenant_Entity_Rel__c> newList = new List<Agreement_Financial_Covenant_Entity_Rel__c>();
        for (String s :selectedEntities) {
            Agreement_Financial_Covenant_Entity_Rel__c afcRel = new Agreement_Financial_Covenant_Entity_Rel__c(Entity__c = s, Agreement_Financial_Covenant__c = Covenant.Id);
            newList.add(afcRel);
        }
        if (newList.size() > 0) insert newList;
        Covenant.EntitiesInText__c = '';
        List<String> entities = new List<String>();
        for (Agreement_Financial_Covenant_Entity_Rel__c FCrel: newList) {
            for (Agreement_Client_Relationships__c rel : acrMap.values()) {
                if (rel.Entity__c == FCrel.Entity__c) {
                    entities.add(rel.Entity__r.Entity_Name__c);
                }               
            }
        }       
        
        Covenant.EntitiesInText__c = Utility.ListToDelimitedString(entities, ', ');
    }

    public void showDialog() {        
        displayDialog = true;    
    }

    @TestVisible
    private void ResetClickedParameters() {
        selectedCovenantId = '';
        this.mode = CurrentPopup.none;   
    }

    public Boolean displayDialog {get; set;}

    public PageReference cancelDialog() {
        displayDialog = false;
        selectedEntities = null;
        return RefreshPage();
    }

    private PageReference RefreshPage() {
        String url = Utility.getServerUrl() + '/apex/Agreement?Id=' + agmt.Id; 
        PageReference newPage = new PageReference(url);
        newPage.setRedirect(false);              
        return newPage; 
    }
    
    public PageReference saveDialog() {
    	updateUnboundFields();             
        if (validateFormData()) {
            saveCovenant();   
            resetForm();    
            return redirectToAgreementPage();
        }               
        return null;
    }
    
    private void updateUnboundFields() {
    	Covenant.Covenant_Type__c = dropdownCovenantStatusId;
        Covenant.Testing_Based_On__c = dropdownCovenantTestingBasedOnId;
    }
    
    private Boolean validateFormData() {
        Boolean isValid = true;
        
        if (Covenant.Testing_Frequency__c == null) {
        	Covenant.Testing_Frequency__c.addError('You must enter a value');
        	isValid = false;
        }
        if (Covenant.Testing_Based_On__c == null) {
        	Covenant.Testing_Based_On__c.addError('You must enter a value');
        	isValid = false;
        }
        if (Covenant.Covenant_Measures_Long__c == null) {
        	Covenant.Covenant_Measures_Long__c.addError('You must enter a value');
        	isValid = false;
        }        
        if (Covenant.Covenant_Type__c != 'Standard') {
        	if (Covenant.Covenant_Title__c == null) {
	        	Covenant.Covenant_Title__c.addError('You must enter a value');	        	
	            isValid = false;    
        	}   	
            if (Covenant.Comments_Long__c == null) {
            	Covenant.Comments_Long__c.addError('You must enter a value');
            	isValid = false;
            }	
        }
        
        return isValid;
    }
    
    private void saveCovenant() {
        if (Covenant.Id != null && selectedCovenantId != '') {
            if (Covenant.Covenant_Type__c != 'Standard') {
                Covenant.Standard_Covenant__c = null;   
            }
            update Covenant;
        }
        
        if (Covenant.Id == null && Covenant.Agreement__c != null) {
            if (Covenant.Covenant_Type__c != 'Standard') {
                Covenant.Standard_Covenant__c = null;   
            }
            insert Covenant;
        }
        
        updateCovenantRelationshipForEntities();
        covenant.standard_covenant__c = dropdownCovenantTitleId;
        update Covenant;
    }
    
    private PageReference redirectToAgreementPage() {
        String url = Utility.getServerUrl() + '/apex/Agreement?Id=' + agmt.Id; 
        PageReference newPage = new PageReference(url);
        newPage.setRedirect(false);
        
        return newPage;  
    }
    
    private void resetForm() {
        selectedEntities = null;
        ResetClickedParameters();
    }
    
    public Boolean AgreementArchiveStatus {
        get {
            if (agmt.RecordTypeId == null) {return false;}
            if (Utility.RecordTypeObject('Agreement__c', agmt.RecordTypeId).Name == 'Archive') {
                return true;
            }
            return false;          
        }
    }
    
    public Boolean AgreementActiveStatus {
        get {
            if (agmt.RecordTypeId == null) {return false;}
            if (Utility.RecordTypeObject('Agreement__c', agmt.RecordTypeId).Name == 'Active') {
                return true;
            }
            return false;          
        }
    }

    public Boolean isEditable {
        get {
            if (!canEditFinancialCovenant || AgreementActiveStatus || AgreementArchiveStatus) {
                return false;
            } else {
                return true;
            }
        }
    }

    public String StandardCovenantDefinitionsUrl {
        get {
            return m_configs.get(STD_COVENANT_DEFINITIONS_ID);
        }
    }
}