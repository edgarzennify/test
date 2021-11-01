public with sharing class OwnerOverviewComponent {


    public User owner{get;set;}
    public List<SelectOption> availableRMs {get;set;}
    public Id newRMId {get;set;}

    public List<ParentRelationships.RelatedEntity> relationshipTreesForDisplay{
        get{
            if (relationshipsExpanded){
                return m_relationshipTreesFull[m_currentPageNumber];
            }else{
                return m_relationshipTreeCollapsed[m_currentPageNumber];
            }
        }
        set;
    }
    private List<List<ParentRelationships.RelatedEntity>> m_relationshipTreeCollapsed;
    private List<List<ParentRelationships.RelatedEntity>> m_relationshipTreesFull;
    
    private Integer m_currentPageNumber;
    public Integer currentPageNumber{
        get{
            if(m_currentPageNumber == null){
                m_currentPageNumber = 0;
            }else if(m_currentPageNumber > m_relationshipTreesFull.size() - 1){
                m_currentPageNumber = m_relationshipTreesFull.size() - 1;
            }
            return m_currentPageNumber + 1;
        }
        set{
            if(value > m_relationshipTreesFull.size()){
                m_currentPageNumber = m_relationshipTreesFull.size() - 1;
            }else if(value < 1){
                m_currentPageNumber = 0; 
            }else{
                m_currentPageNumber = value - 1; 
            }
        }
    }
    public Boolean displayNextPageLink{
        get{
            return m_relationshipTreesFull.size() > (m_currentPageNumber + 1);
        }
        set;
    }
    public Boolean displayPrevPageLink{
        get{
            return m_currentPageNumber > 0;
        }
        set;
    }
    
    public Boolean relationshipsExpanded{get;set;}

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

    private Boolean m_canEditRM;
    public Boolean canEditRM{
        get{
            if (m_canEditRM == null){
                m_canEditRM = m_userInfoSvc.isSystemAdministrator(m_userInfoSvc.getCurrentUserId());
                if(hasMassModifyRMPermission()){
                    m_canEditRM = true;
                }
            }
            return m_canEditRM;
        }
        set;
    }



    private OwnerOverviewComponentDataProv.IOwnerOverviewComponentDataProv m_dataProvider;
    private ParentRelationships.IParentRelTreeBuilder m_parentRelationshipTreeBuilder;
    private IApexPages m_apexPages;
    private IUserInfoService m_userInfoSvc;
    private Utility.IUtility m_utility;

    public OwnerOverviewComponent() {
        OwnerOverviewComponentDataProv dataProvider = new OwnerOverviewComponentDataProv();
        ParentRelTreeBuilder relationshipBuilder = new ParentRelTreeBuilder();
        ApexPagesWrapper apexPages = new ApexPagesWrapper();
        IUserInfoService userInfoService = UserInfoService.bootstrap();
        Utility util = new Utility();
        initialize(dataProvider, relationshipBuilder, apexPages, userInfoService, util);  
    }
  
    public OwnerOverviewComponent(OwnerOverviewComponentDataProv.IOwnerOverviewComponentDataProv dataProvider, ParentRelationships.IParentRelTreeBuilder relationshipBuilder, IApexPages apexPages, IUserInfoService userInfoService, Utility.IUtility util) {
        initialize(dataProvider, relationshipBuilder, apexPages, userInfoService, util);  
    }

    private void initialize(OwnerOverviewComponentDataProv.IOwnerOverviewComponentDataProv dataProvider, ParentRelationships.IParentRelTreeBuilder relationshipBuilder, IApexPages apexPages, IUserInfoService userInfoService, Utility.IUtility util){
        m_dataProvider = dataProvider;
        m_parentRelationshipTreeBuilder = relationshipBuilder;
        m_apexPages = apexPages;
        m_userInfoSvc = userInfoService;
        m_utility = util;
        owner = m_dataProvider.getUser(m_apexPages.getParameter('Id'));
        setupRelationshipTrees();
        collapseRelationships();
        availableRMs = getAvailableRMs();
    }

    private List<SelectOption> getAvailableRMs(){
         List<SelectOption> availRMs = new List<SelectOption>();
         List<User> relMgrs = m_dataProvider.getRelationshipManagers();
         for(User rm : relMgrs){
            availRMs.add(new SelectOption(rm.Id,rm.Name));
         }
         return availRMs;
    }

    private void setupRelationshipTrees(){
        List<Map<Id, Account>> relTrees = m_parentRelationshipTreeBuilder.getRelationshipTreesForOwners(new Set<Id>{owner.Id});
        List<ParentRelationships.RelatedEntity> relTreesComplete = m_parentRelationshipTreeBuilder.getRelationshipTreeListForDisplay(relTrees, null);
        List<ParentRelationships.RelatedEntity> nextLevelFull = new List<ParentRelationships.RelatedEntity>();
        List<ParentRelationships.RelatedEntity> nextLevelCollapsed = new List<ParentRelationships.RelatedEntity>();
        m_relationshipTreesFull = new List<List<ParentRelationships.RelatedEntity>>();
        m_relationshipTreeCollapsed = new List<List<ParentRelationships.RelatedEntity>>();

        Boolean startNewLevelBeforeNextParent = false;
        for(ParentRelationships.RelatedEntity relatedEntity : relTreesComplete){
            if(nextLevelFull.size() > 950){
                startNewLevelBeforeNextParent = true;
            }
            if(relatedEntity.isTopLevel){
               if(startNewLevelBeforeNextParent){
                    m_relationshipTreesFull.add(nextLevelFull);
                    m_relationshipTreeCollapsed.add(nextLevelCollapsed);
                    nextLevelFull = new List<ParentRelationships.RelatedEntity>();
                    nextLevelCollapsed = new List<ParentRelationships.RelatedEntity>();
                    startNewLevelBeforeNextParent = false;
               }
               nextLevelCollapsed.add(relatedEntity);
            }
            nextLevelFull.add(relatedEntity);
        }
        m_relationshipTreesFull.add(nextLevelFull);
        m_relationshipTreeCollapsed.add(nextLevelCollapsed);
        m_currentPageNumber = 0;
        collapseRelationships();
    }

    public void changesMade(){
        haveChangesBeenMade = true;
    }

    public void expandRelationships(){
        relationshipsExpanded = true;
    }

    public void collapseRelationships(){
        relationshipsExpanded = false;
    }

    public PageReference saveChanges(){
        if(saveChangesToEntities()){
            return getRedirectURL();
        }else{
            return null;
        }
    }

    public PageReference cancel(){
        return getRedirectURL();
    }

    public PageReference updateAllRM(){
        updateEntitiesToNewRM();
        //updateEBAcctsToNewRM();   //** FEEDING FROM BANKWAY, IF SFDC BECOMES SOURCE OF RECORD, USE THIS CODE
        return RedirectToOwnerSelectionPage();
    }

    private void updateEntitiesToNewRM(){
        List<Account> entitiesToBeUpdated = m_dataProvider.getEntitiesForOwner(owner.Id);
        for(Account acct : entitiesToBeUpdated){
            acct.OwnerId = newRMId;
            acct.Relationship_Change_Ignore_Validation__c = True;
        }
        m_dataProvider.updateEntities(entitiesToBeUpdated);        
    }

    //private void updateEBAcctsToNewRM(){
    //    List<EB_Account__c> ebAcctsToBeUpdated = m_dataProvider.getEBAccountsForOwner(owner.Id);
    //    for(EB_Account__c acct : ebAcctsToBeUpdated){
    //        acct.OwnerId = newRMId;
    //    }
    //    m_dataProvider.updateEBAccts(ebAcctsToBeUpdated);        
    //}

    public void nextPage(){
        currentPageNumber++;
    }
    public void prevPage(){
        currentPageNumber--;
    }

    private Boolean saveChangesToEntities(){
        List<Account> entitiesToUpdate = new List<Account>();
        for(ParentRelationships.RelatedEntity relatedEntity : relationshipTreesForDisplay){
            if(relatedEntity.entity.OwnerId != owner.Id){
                entitiesToUpdate.add(relatedEntity.entity);
            }
        }
        if(entitiesToUpdate.size() > 0){
            m_dataProvider.updateEntities(entitiesToUpdate);
            return true;
        }
        return false;
    }

    private PageReference getRedirectURL(){
        String returnURL;
        returnURL = m_apexPages.getParameter('retURL');
        if(returnURL == null || returnURL == ''){
            return redirectToOwnerSelectionPage();
        }
        
        PageReference newPage = new PageReference(returnURL);
        newPage.setRedirect(true);
        return newPage;        
    }

    private PageReference goToMassRMChangePage(){
        String url = Utility.getserverUrl() + '/apex/MassRMChange?FromOwner='+owner.Id; 
        PageReference newPage = new PageReference(url);
        newPage.setRedirect(true);
        return newPage;                
    }

    private PageReference redirectToOwnerSelectionPage(){
        String url = m_utility.getserverUrl() + '/apex/OwnerSelection'; 
        PageReference newPage = new PageReference(url);
        newPage.setRedirect(true);
        return newPage;  
    }

    private Boolean hasMassModifyRMPermission(){
        return m_userInfoSvc.hasPermissionSet(m_userInfoSvc.getCurrentUserId(), 'Function - Mass Modify RM');
    }
  
}