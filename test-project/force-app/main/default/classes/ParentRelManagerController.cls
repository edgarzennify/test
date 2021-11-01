public with sharing class ParentRelManagerController {

    private ParentRelationships.IParentRelManagerControllerDataProvider m_parentRelManagerControllerDataProvider;        
    private String m_returnURL;

    public EntityWrapper viewEntity{get;set;}

    public Boolean hasParent {         
      get{
          if(viewEntity.noParent){
              return false;
          }else{
              return true;
          }
        }
        set;
    }

    private Boolean m_displayNoChangesNecessary;
    public Boolean displayNoChangesNecessary{
        get{
            if(m_displayNoChangesNecessary == null){
                m_displayNoChangesNecessary = viewEntity.Entity.Relationship_Review_Required_Date__c != null;
            }
            return m_displayNoChangesNecessary;
        }
        set{
            m_displayNoChangesNecessary = value;
        }
    }

    public Boolean saveDisabled{
        get{
            if(viewEntity.haveChangesBeenMade || viewEntity.noChangesNecessary){
                return false;
            }else{
                return true;
            }
        }
        set;
    }

    public ParentRelManagerController(){
        ParentRelManagerControllerDataProvider prmDataService = new ParentRelManagerControllerDataProvider();
        Id entityId = apexpages.currentpage().getparameters().get('id');
        String returnURL = apexpages.currentpage().getparameters().get('retURL');
        Boolean checkForMessage = true;
        initialize(prmDataService, entityId, returnURL, checkForMessage);
    }
    
    public ParentRelManagerController(ParentRelationships.IParentRelManagerControllerDataProvider prmDataService, Id entityId, String returnURL, Boolean checkForMessage){  
        initialize(prmDataService, entityId, returnURL, checkForMessage);
    }

    private void initialize(ParentRelationships.IParentRelManagerControllerDataProvider prmDataService, Id entityId, String retURL, Boolean checkForMessage){
        m_parentRelManagerControllerDataProvider = prmDataService;           
        Account currEntity = m_parentRelManagerControllerDataProvider.getEntity(entityId);
        viewEntity = new EntityWrapper(currEntity,m_parentRelManagerControllerDataProvider);
        m_returnURL = retURL;
        if (checkForMessage){
            checkForPageParamMessage();
        }
    }

    private void checkForPageParamMessage(){
        String msgType = apexpages.currentpage().getparameters().get('msg');
        if(msgType == 'reqOpp'){
            ApexPages.Message reqOppMsg = new ApexPages.Message(ApexPages.Severity.Info,'You are required to review the relationship for this entity prior to moving the opportunity through the stages.');
            ApexPages.addMessage(reqOppMsg);
        }
    }
     
    public void changesMade(){
        viewEntity.haveChangesBeenMade = true;
        displayNoChangesNecessary = false;
    }

    public void noParentToggled(){
        viewEntity.setParentAndRelationshipToParentNull();
        changesMade();
    }

    public PageReference save(){
        if(viewEntity.entity.ParentId != null && viewEntity.entity.Relationship_To_Parent__c == null)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You must fill out the relationship to parent if the entity is not a level 1 entity.'));
            return null; 
        }

        if(saveChangesToEntity()){
            return getRedirectURL();
        }else{
            return null;
        }
    }

    public PageReference noChangesNecessary(){
        if(saveChangesToEntity()){
            return getRedirectURL();
        }else{
            return null;
        }
    }
        
    public PageReference cancel(){
        return getRedirectURL();
    }

    private Boolean saveChangesToEntity(){
        try{
            viewEntity.entity.Relationship_Review_Last_Modified_Date__c = System.now();
            viewEntity.entity.Relationship_Review_Required_Date__c = null;
            viewEntity.entity.Relationship_Change_Ignore_Validation__c = true;
            Account entityParent = new Account();
            if(viewEntity.entity.ParentId != null){
                entityParent = m_parentRelManagerControllerDataProvider.getEntity(viewEntity.entity.ParentId);
                if(viewEntity.entity.OwnerId != entityParent.OwnerId){
                    viewEntity.entity.OwnerId = entityParent.OwnerId;
                }
            }
            m_parentRelManagerControllerDataProvider.saveEntity(viewEntity.entity);
            return true;
        }catch(DmlException dmlEx){
            ApexPages.Message dmlMsg;
            for(Integer index = 0; index < dmlEx.getNumDml(); index++){
                dmlMsg = new ApexPages.Message(ApexPages.Severity.ERROR,dmlEx.getDmlMessage(index));
                ApexPages.addMessage(dmlMsg);
            }
            ApexPages.addMessages(dmlEx);
        }catch(Exception ex){
            ApexPages.Message exMsg = new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage());
            ApexPages.addMessage(exMsg);
        }
        return false;
    }

    private PageReference getRedirectURL(){
        if(m_returnURL == null || m_returnURL == ''){
            m_returnURL = utility.getServerUrl() + '/' + viewEntity.entity.Id;
        }
        
        PageReference newPage = new PageReference(m_returnURL);
        newPage.setRedirect(true);
        return newPage;        
    }
    

    public class EntityWrapper{

        public Account entity {get;set;}

        private ParentRelationships.IParentRelManagerControllerDataProvider m_parentRelationshipManagerServiceDataProvider;        

        private Boolean m_haveChangesBeenMade;
        public Boolean haveChangesBeenMade{
            get{
                if (m_haveChangesBeenMade == null){
                    m_haveChangesBeenMade = false;
                }
                return m_haveChangesBeenMade;
            }
            set{
                m_haveChangesBeenMade = value;
            }
        }

        private Boolean m_noChangesNecessary;
        public Boolean noChangesNecessary{
            get{
                if (m_noChangesNecessary == null){
                    m_noChangesNecessary = false;
                }
                return m_noChangesNecessary;
            }
            set{
                m_noChangesNecessary = value;
            }
        }

        private Boolean m_noParent;
        public Boolean noParent{
            get{
                if(m_noParent == null){
                    if(entity.parentId == null){
                        m_noParent = true;
                    }else{
                        m_noParent = false;
                    }
                }
                return m_noParent;
            }
            set{
                if(value == true){                              
                    setParentAndRelationshipToParentNull();
                }
                m_noParent = value;
            }
        }
        
        public String entityParentName{
            get{
                return m_parentRelationshipManagerServiceDataProvider.getEntity(entity.parentId).Name;
            }
        }
        
        public EntityWrapper(Account currentEntity, ParentRelationships.IParentRelManagerControllerDataProvider prmDataService){
            entity = currentEntity;
            m_parentRelationshipManagerServiceDataProvider = prmDataService;
        }

        private void setParentAndRelationshipToParentNull(){
            entity.parentId = null;
            entity.Relationship_To_Parent__c = null;
        }

    }
}