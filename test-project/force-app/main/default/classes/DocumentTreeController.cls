global class DocumentTreeController {
    private final Set<String> ENTITY_TYPES = new Set<String> { 'Entity' };
    private final Set<String> ACCOUNT_TYPES = new Set<String> { 'Loans', 'Deposits', 'Time Deposits', 'Trust', 'Oreo' };
    private final Set<String> COLLATERAL_TYPES = new Set<String> { 'Collateral' };

    private final Documents.IDocumentDataService m_documentDataService;
    private final WebServiceCache.IWebServiceCache m_cache;
    private final EbObjectLookup.IEbObjectLookup m_ebObjectLookup;
    
    protected String nullSelectOption = '0000';    
    public boolean ShowTreevitizer{get;set;}
    public class applicationException extends Exception {}

    public DocumentTreeController(){
        WebServices.IRestService restService = new RestService(new GatewayApiMetadataProvider(), Configurations.bootstrap());
        WebServiceCache.IWebServiceCache cache = new WebServiceCache();
        m_ebObjectLookup = new EbObjectLookup(new EbObjectLookupDataProvider());
        m_documentDataService = new ImageNowDataService(restService, cache, m_ebObjectLookup);        
        init();
    }

    public DocumentTreeController(Documents.IDocumentDataService docDataSvc,  EbObjectLookup.IEbObjectLookup ebObjectLookup){
        m_documentDataService = docDataSvc;       
        m_ebObjectLookup = ebObjectLookup;
        init();       
    }
    
    private void init(){
        pageKey = apexpages.currentpage().getparameters().get('pageKey');
        pageKeyType = apexpages.currentpage().getparameters().get('pageKeyType');
        String historyParam = apexpages.currentpage().getparameters().get('h');
        InitializeNavigation(historyParam);
        pageSize=50;
        ResetFilter();        
        RefreshPager();
    }

    public Id ObjectId{
        get{
            try{
                return m_ebObjectLookup.getObjectId(pageKey);
                }catch(exception ex){
                return null;
            }
        }
    }
    
     //edit security
    public boolean showEditLink {
        get{
            List<PermissionSet> ps = [select id from PermissionSet where Label IN ('Function - ImageNow Document Editor SF', 'Function - ImageNow Document Editor')];
            if(ps.size()>0){
                boolean ret = false;
                for(PermissionSet p :ps){
                    id psid = p.id;
                    List<PermissionSetAssignment> psa  = [SELECT PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId = :UserInfo.getUserId() and PermissionSetId = :psid];
                    if (psa.size()>0){
                        ret = true;                 
                    }
                }
                return ret;
            } else {
                return false;
            }           
        }
        set;
    }
    
    //paging
    private Integer pageSize; 
    private Pagination myPager = new Pagination();
    public Pagination pager {
        get{
            return myPager;
        }
    }
    public void SetPage(Integer pageNum){
        pager.SetPage(pageNum);
        RefreshDocumentList();
    }       
    public PageReference skipToSelectedPage(){
        SaveToCache();
        SetPage(Integer.valueOf(pager.currentSelectedPage));            
        return null;
    }
    public PageReference nextPage(){
        if(pager.hasNextPage){
            SaveToCache();
            SetPage(pager.currentPage+1);
        }        
        return null;
    }
    public PageReference previousPage(){       
        if(pager.hasPreviousPage){
            SaveToCache();
            SetPage(pager.currentPage-1);       
        }
        return null;
    }       
    
    //filtering
    protected RelNavDocument.RelNavDocumentFilter currentFilter = new RelNavDocument.RelNavDocumentFilter();
    public Grenzsoldat__c filterDate{
        get{
            if(filterDate == null ){
                 filterDate = new Grenzsoldat__c();
                 filterDate.Bogus_Date_1__c = null;
                 filterDate.Bogus_Date_2__c = null;
            }
            return filterDate;
        }
        set;
    }
    private Set<String> documentTypeFilterSet = new Set<String>();
    private Set<String> relatedToFilterSet = new Set<String>();
    private Set<String> drawerNameFilterSet = new Set<String>();
    public List<SelectOption> documentTypeFilterList{
        get{
            if(documentTypeFilterList == null){
                documentTypeFilterList = new List<SelectOption>();
                documentTypeFilterList.add(new SelectOption(nullSelectOption,'All'));
            }
            return documentTypeFilterList;
        }
        private set;
    }
    public List<SelectOption> relatedToFilterList{
        get{
            if(relatedToFilterList == null){
                relatedToFilterList = new List<SelectOption>();
                relatedToFilterList.add(new SelectOption(nullSelectOption,'All'));
            }
            return relatedToFilterList;
        }
        private set;
    }
    public List<SelectOption> drawerNameFilterList{
        get{
            if(drawerNameFilterList == null){
                drawerNameFilterList = new List<SelectOption>();
                drawerNameFilterList.add(new SelectOption(nullSelectOption,'All'));
            }
            return drawerNameFilterList;
        }
        private set;
    }
    public List<String> documentTypeFilterSelectedValue{get;set;}
    public List<String> relatedToFilterSelectedValue{get;set;}
    public List<String> drawerNameFilterSelectedValue{get;set;}
    
    private void AddToDocumentTypeFilter(String docType){
        if(String.isNotBlank(docType)){
            if(!documentTypeFilterSet.Contains(docType)){
                documentTypeFilterSet.add(docType);
                documentTypeFilterList.add(new SelectOption(docType,docType));
            }
        }
    }
    private void AddToRelatedToFilter(String relatedTo, Integer documentCount){
        if(String.isNotBlank(relatedTo) && documentCount > 0){
            if(!relatedToFilterSet.Contains(relatedTo)){
                relatedToFilterSet.add(relatedTo);
                relatedToFilterList.add(new SelectOption(relatedTo,relatedTo));
            }
        }
    }
    private void AddToDrawerNameFilter(String drawerName){
        if(String.isNotBlank(drawerName)){
            if(!drawerNameFilterSet.Contains(drawerName)){
                drawerNameFilterSet.add(drawerName);
                drawerNameFilterList.add(new SelectOption(drawerName,drawerName));
            }
        }
    }
    
    private void ResetFilter(){
        currentFilter.clear();
        currentFilter.add('DocTypeName','<>','');
        currentFilter.add('DrawerName','in', AccessibleDrawers());
    }
    
    private String AccessibleDrawers(){
        String drawers;
        for(DrawerPrivilege d : DrawerPrivileges){
            drawers += (drawers != '') ? ',' : '';
            drawers += d.DrawerName;
        }
        System.debug('####AccessibleDrawers: ' + drawers);
        return drawers;
    }
    
    private boolean FilterInUse(List<string> filterSelectedValue){
        if(filterSelectedValue != null && filterSelectedValue.size() > 0) {
            return true;
        }
        return false;
    }
    private boolean FilterInUse(Date filterValue){
        if(filterValue != null){
                return true;
        }
        return false;
    }

    private void RebuildCurrentFilter(){
        ResetFilter();
        if(FilterInUse(relatedToFilterSelectedValue) && relatedToFilterSelectedValue.get(0) != '0000'){
            currentFilter.addCondtionMultiselect('Name','=',relatedToFilterSelectedValue);
        }
        if(FilterInUse(documentTypeFilterSelectedValue) && documentTypeFilterSelectedValue.get(0) != '0000'){
            currentFilter.addCondtionMultiselect('DocTypeName','=',documentTypeFilterSelectedValue);
        }
        if(FilterInUse(filterDate.Bogus_Date_1__c) || FilterInUse(filterDate.Bogus_Date_2__c)){
            currentFilter.addOR('DocumentDate',filterDate.Bogus_Date_1__c,filterDate.Bogus_Date_2__c,'CreatedDate',filterDate.Bogus_Date_1__c,filterDate.Bogus_Date_2__c);
        }
        if(FilterInUse(drawerNameFilterSelectedValue) && drawerNameFilterSelectedValue.get(0) != '0000'){
            currentFilter.addCondtionMultiselect('DrawerName','=',drawerNameFilterSelectedValue);
        }
    }
    public void filterResults(){
        RebuildCurrentFilter();
        SetPage(1);
        SaveToCache();
        RefreshDocumentList();          
    }
    public PageReference clearfilter(){
        String pKey = apexpages.currentpage().getparameters().get('pageKey');
        String pKeyType = apexpages.currentpage().getparameters().get('pageKeyType');
        String hParam = apexpages.currentpage().getparameters().get('h') ;      
        String newPageUrl = Utility.getServerUrl() + '/apex/TreeView?pageKey=' + pKey + '&pageKeyType=' + pKeyType;
        if(hParam != null && hParam != '' ) newPageUrl +=   '&h=' + hParam;
        PageReference newPage = new PageReference(newPageUrl);
        newPage.setRedirect(true);
        return newPage;
    }
        
    //sorting - top list
    public String topSortParameter{
            get{         
                if(topSortParameter == null || topSortParameter=='' || topSortParameter=='Inactive') 
                {
                    topSortParameter = 'Inactive';
                    RelNavDocument.SortParameter = 'Inactive';
                }
                

                return topSortParameter; 
            }
            set{   
                if (value == topSortParameter) 
                    topSortDirection = (topSortDirection == 'ASC')? 'DESC' : 'ASC';
                else
                    topSortDirection = 'ASC';
                        
                topSortParameter = value;
            }
    }    
    public String topSortDirection{
        get{
            if (topSortParameter == null || topSortParameter == '' || topSortDirection == null || topSortDirection == ''){
               topSortDirection = 'ASC';
              // Commented out by JB 12-27-12 topSortDirection = 'DESC';
            }
            return topSortDirection;
        }
        set{
             topSortDirection = value;
        }
    }    
    public PageReference SortTopData(){
        SaveToCache();
        RelNavDocument.SortParameter = topSortParameter;
        RelNavDocument.SortDirection = topSortDirection;
        relatedObjects.sort();
        return null;
    }   
    
    //sorting - bottom list
    protected String sortDirection = 'DESC';
    protected String sortExp = 'DocumentDate'; 
    public String sortParameter{
        get{         
            return sortExp; 
        }
        set{   
            if (value == sortExp) 
                sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
            else
                sortDirection = 'ASC';
                    
            sortExp = value;
        }
    }    
    public String getSortDirection() {
        if (sortParameter == null || sortParameter == '')
            return 'ASC';
        else     
            return sortDirection;
    }    
    public void setSortDirection(String value) {
        sortDirection = value;
    }
    public PageReference SortData(){
        SaveToCache();
        RefreshDocumentList();
        return null;
    }  
    
    //breadcrumb
    private static String crumbFieldDelimiter = ',;,';
    private static String crumbKeyDelimiter = ':;:';
    
    public String history{
        get{
            String historyBuilder = '';
            for(BreadcrumbItem crumb : breadcrumbList){
                if(historyBuilder != ''){
                    historyBuilder += crumbKeyDelimiter;
                }
                historyBuilder = historyBuilder + crumb.Key + crumbFieldDelimiter + crumb.Name + crumbFieldDelimiter + crumb.KeyType;
            }               
            return historyBuilder;
        }
    }
    
    private void InitializeNavigation(String history){
        InitializeBreadcrumb(history);
        InitializeRelatedObjects();
        AddCurrentParentToBreadcrumb();
    }
    
    private void InitializeBreadcrumb(String history){
        if(history==null || history=='')return;
        List<String>bcItems = history.split(crumbKeyDelimiter);
        for(String bcItem : bcItems){                   
            List<String> bcAttributes = bcItem.split(crumbFieldDelimiter);
            if(bcAttributes.size() == 3){
                AddBreadcrumb(bcAttributes[0],bcAttributes[2],bcAttributes[1]);
            }
        }
    }
    private void AddCurrentParentToBreadcrumb(){
        String crumbKey = pageKey;
        String crumbKeyType = pageKeyType;
        String crumbName = pageKey;
        if(parentType == 'Entity'){
            crumbName = Abbreviate(parentName,15);
        } 
        AddBreadcrumb(crumbKey,crumbKeyType,crumbName);
    }
    public class BreadcrumbItem{
        public String Name {get;set;}
        public String Key {get;set;}
        public String KeyType {get;set;}
    }     
    public String parentName{get;set;}
    public String parentType{get;set;}
    private Map<String,Integer> breadcrumbMap{get;set;}
    public List<BreadcrumbItem> breadcrumbList{get;set;} 
    private void AddBreadcrumb(String newKey, String newKeyType, String newName){
        if(breadcrumbMap == null){
            breadcrumbMap = new Map<String,Integer>();
            breadcrumbList = new List<BreadcrumbItem>();
        }
        Integer bcIndex = breadcrumbMap.get(newKey);
        if(bcIndex != null){
            List<BreadcrumbItem> newList = new List<BreadcrumbItem>();
            Map<String,Integer> newMap = new Map<String,Integer>();
            for(Integer i=0;i<=bcIndex;++i){
                BreadcrumbItem crumb = breadcrumbList.get(i);
                newList.add(crumb);
                newMap.put(crumb.Key,newList.size()-1);
            }
            breadcrumbList = newList;
            breadcrumbMap = newMap;
        }else{
            BreadcrumbItem i = new BreadcrumbItem();
                i.Key = newKey;
                i.KeyType = newKeyType;
                i.Name = newName;
            breadcrumbList.add(i);
            breadcrumbMap.put(newKey,breadcrumbList.size()-1);
        }
    }
    private String Abbreviate(String s, Integer maxWidth){
        if(maxWidth < 4){
                throw new applicationException('invalid maxWidth for Abbreviate');
        }else if(s.length() > maxWidth){
                return s.substring(0,maxWidth-3) + '...';
        }else{
                return s;
        }
    }
    public List<BreadcrumbItem> getBreadcrumbLinkList(){
        List<BreadcrumbItem> historyList = new List<breadcrumbItem>();
        for(Integer i=0;i<breadcrumbList.size()-1;++i){
            BreadcrumbItem crumb = breadcrumbList.get(i);
            historyList.add(crumb);
        }
    
        if(historyList.size() > 0) return historyList;   
        return null;
    }
    //related objects list     
    public List<RelNavDocument> relatedObjects{get;set;}   
    public Map<String,RelNavDocument> relatedObjectsMap{get;set;}    
    private void InitializeRelatedObjects(){

        Map<String, List<String>> EntityMap = new Map<String, List<String>>();
        Map<String, List<String>> AccountMap = new Map<String, List<String>>();
        Map<String, List<String>> CollateralMap = new Map<String, List<String>>();
        relatedObjects = new List<RelNavDocument>();

        if(unfilteredList != null){
            relatedObjectsMap = new Map<String,RelNavDocument>();
            for(RelNavDocument ed : unfilteredList){
                relatedObjectsMap.put(ed.key,ed);
                if(ed.key == pageKey){ 
                    parentName = ed.Name;
                    parentType = ed.ObjectType;
                }
                if(ENTITY_TYPES.contains(ed.Objecttype)){
                    if(!EntityMap.containskey(ed.key)){
                        EntityMap.put(ed.key,null);                             
                        relatedObjects.add(ed);
                    }
                }else if(COLLATERAL_TYPES.contains(ed.Objecttype)){
                    if(!CollateralMap.containskey(ed.key)){
                        CollateralMap.put(ed.key,null);
                        relatedObjects.add(ed);
                    }                         
                }else if(ACCOUNT_TYPES.contains(ed.ObjectType)){
                    if(!AccountMap.containskey(ed.key)){                                
                        AccountMap.put(ed.key,null);
                        relatedObjects.add(ed);
                    }
                }
                if(DrawerPrivilegeMap.ContainsKey(ed.DrawerName)){
                    AddToDocumentTypeFilter(ed.DocTypeName);
                    AddToRelatedToFilter(ed.Name,ed.iDocumentCount);
                    AddToDrawerNameFilter(ed.DrawerName);
                }
            }       
        }
        relatedObjects.sort();
        documentTypeFilterList.sort();
        relatedToFilterList.sort();
        drawerNameFilterList.sort();
    }
    
    private String prevPageKey{get;set;}
    public String pageKey{
        get;
        set{
            if(pageKey=='' || pageKey==null){
                prevPageKey = value;
            }else{
                prevPageKey = pageKey;
            }
            pageKey = value;
        }
    }    
    private String prevPageKeyType{get;set;}
    public String pageKeyType{
        get;
        set{
            if(pageKeyType=='' || pageKeyType==null){
                prevPageKeyType = value;
            }else{
                prevPageKeyType = pageKeyType;
            }
            pageKeyType = value;
        }
    }   
    private String listKey{
        get{          
            return m_documentDataService.BuildKey(pageKeyType,pageKey,true);
        }
    }

    private String drawerPrivilegesKey{
        get{
            return DrawerPrivilege.GetKey(UserInfo.getUserEmail());
        }
    }
    public Boolean showEntityIcon{
        get{
            return ENTITY_TYPES.contains(parentType);
        }
    }
    public Boolean showAccountIcon{
        get{
            return ACCOUNT_TYPES.contains(parentType);
        }
    }
    public Boolean showCollateralIcon{
        get{
            return COLLATERAL_TYPES.contains(parentType);
        }
    }    
    public String getSeparator(){
        return ' » ';
    } 

    private void RefreshPager(){
        pager.pageSize=pageSize;
        pager.ObjectListSize = filteredListSize;
    }
    public void SaveToCache(){
        RelNavDocument.SaveList(unfilteredList,listKey);
        m_documentDataService.SaveList(DrawerPrivileges,drawerPrivilegesKey);
    }
    private void RefreshDocumentList(){
        filteredListSize = RelNavDocument.LoadList(listKey,sortParameter,getSortDirection(),0,0,currentFilter).size();
        viewableList = RelNavDocument.LoadList(listKey,sortParameter,getSortDirection(),pager.pageSize,pager.pagePosition,currentFilter);
        RefreshPager();
    }
    public List<RelNavDocument> unfilteredList{
    	get{
        	if(unfilteredList == null){
            	unfilteredList = RelNavDocument.LoadList(listKey, sortParameter, getSortDirection());
            }
            if(unfilteredList == null){
                unfilteredList = new List<RelNavDocument>();
            }
            return unfilteredList;
        }
        set;
    }
    public Integer filteredListSize{
        get{
            if(filteredListSize == null){
                filteredListSize = RelNavDocument.LoadList(listKey, sortParameter, getSortDirection(),0,0,currentFilter).size();
            }
            if(filteredListSize == null){
                filteredListSize = 0;
            }
            return filteredListSize;
        }
        set;
    }
    public List<RelNavDocument> viewableList{
        get{
                if(viewableList == null){
                viewableList = RelNavDocument.LoadList(listKey,sortParameter,getSortDirection(),pager.pageSize,pager.pagePosition,currentFilter);
            }
            if(viewableList == null){
                viewableList = new List<RelNavDocument>();
            }
            return viewableList;
        }
        set;
    }
    private List<DrawerPrivilege> DrawerPrivileges{
        get{
            if(DrawerPrivileges == null){                
                DrawerPrivileges = CastAsDrawerPrivilege(m_documentDataService.LoadList(drawerPrivilegesKey,'','',0,0,'',new DrawerPrivilege()));
            }
            return DrawerPrivileges;
        }
        set;
    }
    private List<DrawerPrivilege> CastAsDrawerPrivilege(List<Documents.ICacheable> objects){
        List<DrawerPrivilege> casted = new List<DrawerPrivilege>();
        for(Documents.ICacheable o : objects){
            casted.add((DrawerPrivilege)o);
        }
        return casted;
    }
    private Map<String,DrawerPrivilege> DrawerPrivilegeMap{
        get{
            if(DrawerPrivilegeMap == null){
                DrawerPrivilegeMap = new Map<String,DrawerPrivilege>();
                for(DrawerPrivilege d : DrawerPrivileges){
                    DrawerPrivilegeMap.put(d.DrawerName,d);
                }
            }
            return DrawerPrivilegeMap;
        }
        set;
    }     
}