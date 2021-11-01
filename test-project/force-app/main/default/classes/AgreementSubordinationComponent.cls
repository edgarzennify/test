public class AgreementSubordinationComponent{
  public Agreement__c agmt{get;set;}
  public Boolean canEditSubordination{get;set;}
  public Agreement_Subordination__c subordination{get;set;}
  public String selectedSubordinationId{get;set;}
  
  public AgreementSubordinationComponent(){
    subordination = new Agreement_Subordination__c();       
  }
  
  public List<Agreement_Subordination__c> SubordinationAgreements{
    get{
      return [SELECT Id,Name, Agreement__c, Creditor__c, Secondary_Creditor__c, Obligation_Type__c, Obligation_Amount__c, Limitation__c, Payment_Type__c, 
                Payment_Frequency__c, Payment_Allowed__c, Comments__c, EntitiesInText__c, Payment_Amount__c, Obligation_Summary__c, Payment_Summary__c  
              FROM Agreement_Subordination__c 
              WHERE Agreement__c=:agmt.Id ];
    }
  }
  
  public void AddSubordination(){          
    Subordination = new Agreement_Subordination__c();
    Subordination.Agreement__c = agmt.Id;
    ResetForm();
    ShowDialog();
    SetEntities();       
  }
  
  public void EditSubordination(){
    subordination = [SELECT Id, Name, Agreement__c, Creditor__c, Secondary_Creditor__c, Obligation_Type__c, Obligation_Amount__c, Limitation__c, Payment_Type__c, Payment_Frequency__c, Payment_Allowed__c, Payment_Amount__c, Comments__c
                     FROM Agreement_Subordination__c 
                     WHERE Id=:selectedSubordinationId ];
    showDialog();
    SetEntities();
  }
  
  public PageReference DeleteSubordination(){
    Agreement_Subordination__c subordination = new Agreement_Subordination__c(Id=selectedSubordinationId);
    delete subordination;
    return agreementPage(); 
  }
  
  public pagereference ViewSubordination(){
    String url = Utility.getserverUrl() +'/' + selectedSubordinationId; 
    PageReference newPage = new PageReference(url);
    newPage.setRedirect(true);
    return newPage;
  }
  
  public List<String> selectedEntities{
    get{
      if(selectedEntities == null){
        selectedEntities = new List<String>();
      }
      return selectedEntities;
    }
    set;
  }
  
  private List<Agreement_Client_Relationships__c> agreementEntities{
    get{
      if(agreementEntities == null){
        agreementEntities = [SELECT Id, Entity__c, Entity__r.Name, Entity__r.Entity_Name__c 
                             FROM Agreement_Client_Relationships__c 
                             WHERE Agreement__c =: agmt.Id
                             ORDER BY Entity__r.Name];
      }
      return agreementEntities;
    }
    set;
  }
  @TestVisible
  private Map<id,String> entityMap{
    get{
      if(entityMap == null){
        entityMap = new Map<id,String>();
        for(Agreement_Client_Relationships__c rel : agreementEntities){
          entityMap.put(rel.Entity__c, rel.Entity__r.Entity_Name__c);
        }
      }
      return entityMap;
    }
    set;
  }
  
  public List<SelectOption> getEntities() {
    List<SelectOption> options = new List<SelectOption>();
    for(Agreement_Client_Relationships__c rel : agreementEntities){
      options.add(new SelectOption(rel.Entity__c,rel.Entity__r.Entity_Name__c));
    }
    return options;     
  }
  
  private List<Agreement_Subordination_Entity_Rel__c> currentSubordinationRelationshipList;
  private void SetEntities(){
    List<String> entityIds = new List<String>();
    currentSubordinationRelationshipList = [SELECT Id, Entity__c, Agreement_Subordination__c 
                                            FROM Agreement_Subordination_Entity_Rel__c 
                                            WHERE Agreement_Subordination__c =: Subordination.Id];
    
    for(Agreement_Subordination_Entity_Rel__c rel : currentSubordinationRelationshipList){
      entityIds.add(rel.Entity__c);
    }
  
    if(entityIds.size() > 0){
      selectedEntities = entityIds;           
    }        
  }
  
  private void UpdateRelationshipForEntities(){
    if(currentSubordinationRelationshipList != null && currentSubordinationRelationshipList.size()>0){
      delete currentSubordinationRelationshipList;
    }
    List<Agreement_Subordination_Entity_Rel__c> newList = new List<Agreement_Subordination_Entity_Rel__c>();
    for(String s : selectedEntities){
      Agreement_Subordination_Entity_Rel__c r = new Agreement_Subordination_Entity_Rel__c(Entity__c = s, Agreement_Subordination__c = Subordination.Id);
      newList.add(r);
    }
    if(newList.size() > 0) insert newList;
  
    List<String> entities = new List<String>();        
    for(Agreement_Subordination_Entity_Rel__c rel : newList){            
      if(entityMap.containsKey(rel.Entity__c)){                   
        entities.add(entityMap.get(rel.Entity__c));
      }
    }
  
    subordination.EntitiesInText__c = utility.ListToDelimitedString(entities, ', ');
  }
  
  private void resetForm(){  
    selectedSubordinationId = '';
    selectedEntities = null;
  }
  
  private void showDialog() {        
    displayDialog = true;    
  }
  @TestVisible
  private void resetClickedParameters(){   
    selectedSubordinationId = '';
  }
  
    
  public boolean displayDialog {get;set;}
  
  public PageReference CancelDialog(){
    displayDialog = false;
    selectedEntities = null;
    return agreementPage(); 
  }
  
  public pagereference SaveDialog(){
    if(validateFormData()){
        saveSubordination();
        UpdateRelationshipForEntities();
        saveSubordination();
        return agreementPage();
    }
    return null; 
  }
  
  private void saveSubordination(){
    if(Subordination.Id == null){
      insert Subordination;
    }else{
      update Subordination;
    }
  }
  
  private boolean validateFormData(){
        boolean isValid = true;
        if(isCommentsRequired && (subordination.Comments__c == null || subordination.Comments__c == '')){
            isValid = false;
            subordination.Comments__c.addError('input required');
        }
        if(isPaymentAllowedRequired && subordination.Payment_Allowed__c == null){
            isValid = false;
            subordination.Payment_Allowed__c.addError('input required');
        }
        if(isLimitationRequired && subordination.Limitation__c == null){
            isValid = false;
            subordination.Limitation__c.addError('input required');
        }        
        return isValid;
    }
  
  private PageReference agreementPage(){
    String url = Utility.getServerUrl() + '/apex/Agreement?id=' + agmt.Id; 
    PageReference newPage = new PageReference(url);
    newPage.setRedirect(false);              
    return newPage;
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
      if(!canEditSubordination || AgreementActiveStatus || AgreementArchiveStatus) 
        return false;
      else
        return true;
    }        
  }
  
  public Boolean isCommentsRequired{
    get{
        if(subordination.Obligation_Type__c == 'Other'){
            return true;
        }
        return false;
    }
  }
  
  public Boolean isPaymentAllowedRequired{
    get{
        if(subordination.Obligation_Type__c == 'Loan'){
            return true;
        }
        return false;
    }
  }
  
  public Boolean isLimitationRequired{
    get{
        if(subordination.Obligation_Type__c == 'Loan'){
            return true;
        }
        return false;
    }
  }
}