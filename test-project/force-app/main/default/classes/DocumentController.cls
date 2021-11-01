public class DocumentController {
    private String nullSelectOption = '0000';
    private Documents.IDocumentDataService m_documentDataService;  
    private EbObjectLookup.IEbObjectLookup m_objectLookup;
    private Documents.IRelNavDocument m_relNavDocument;
    public class applicationException extends Exception {}
    
    public String pageKey {get;set;}
    public String pageKeyType {get;set;}
    
    public String objectIdAttribute {
        get;
        set {
            objectIdAttribute = value;
            init();
        }
    }

    private Id objectId {
        get{
            return (Id)objectIdAttribute;
        }
    }
    
    public DocumentController(){
        Configurations.IConfigurations cfg = Configurations.bootstrap();
        WebserviceCache.IWebserviceCache cache = new WebserviceCache();
        m_objectLookup = new EbObjectLookup(new EbObjectLookupDataProvider());
        m_documentDataService = new ImageNowDataService(new RestService(new GatewayApiMetadataProvider(), cfg), cache, m_objectLookup);
        m_relNavDocument = new RelNavDocumentWrapper();
    }  
    
    public DocumentController(Documents.IDocumentDataService docDataSvc, EbObjectLookup.IEbObjectLookup objectLookup, Documents.IRelNavDocument relNavDocument){
        m_documentDataService = docDataSvc;
        m_objectLookup = objectLookup;
        m_relNavDocument = relNavDocument;
    }  
    
    private void init(){
        EbObjectLookup.KeyAndType kt = m_objectLookup.getObjectKeyAndType(objectId);
       	pageKey = kt.objectKey;
        pageKeyType = kt.keyType;
        ResetFilter();
        RefreshPager();
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
    protected Integer pageSize = 4;
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
    public void RefreshPager(){
        pager.pageSize=pageSize;
        pager.ObjectListSize = filteredList.size();
    }
    //filtering
    private RelNavDocument.RelNavDocumentFilter currentFilter = new RelNavDocument.RelNavDocumentFilter();
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
    //public string documentTypeFilterSelectedValue{get;set;} 
    public List<string> documentTypeFilterSelectedValue{get;set;}
    public void LoadFilterLists(){
        // initialize "Document" filter     
        Set<String> documentTypeFilterSet = new Set<String>();
        documentTypeFilterList = new List<SelectOption>();
        documentTypeFilterList.add(new SelectOption(nullSelectOption,'All'));          
        
        // load lists with one loop through the unfiltered list
        if(unfilteredList != null){
            for(RelNavDocument i : unfilteredList){
                if(i.DocTypeName != '' && i.DocTypeName != null){
                    if(!documentTypeFilterSet.Contains(i.DocTypeName) && DrawerPrivilegeMap.ContainsKey(i.DrawerName)){
                        documentTypeFilterSet.add(i.DocTypeName);
                        documentTypeFilterList.add(new SelectOption(i.DocTypeName,i.DocTypeName));
                    }
                }               
            }
            documentTypeFilterList.sort();
        }
        
    }
    public List<SelectOption> documentTypeFilterList{
        get{
            if(documentTypeFilterList==null){
                LoadFilterLists();
            }
            return documentTypeFilterList;
        }
        set;
    }
    @TestVisible
    private void ClearFilter(){
        documentTypeFilterList = null;
        documentTypeFilterSelectedValue = null;
        filterDate.Bogus_Date_1__c = null;
        filterDate.Bogus_Date_2__c = null;      
        ResetFilter();      
    }
    private void ResetFilter(){
        currentFilter.clear();
        currentFilter.add('DocTypeName','<>','');
        currentFilter.add('DrawerName','in', AccessibleDrawers());
    }
    
    private String AccessibleDrawers(){
        String drawers = '';
        if(DrawerPrivileges != null){
            for(DrawerPrivilege d : DrawerPrivileges){
                drawers += (drawers != '') ? ',' : '';
                drawers += d.DrawerName;
            }
        }
        System.debug('####drawers: ' + drawers);
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
        if(FilterInUse(documentTypeFilterSelectedValue) && documentTypeFilterSelectedValue.get(0) != '0000'){
                currentFilter.addCondtionMultiselect('DocTypeName', '=', documentTypeFilterSelectedValue);
        }
        if(FilterInUse(filterDate.Bogus_Date_1__c) || FilterInUse(filterDate.Bogus_Date_2__c)){ 
            currentFilter.add('DocumentDate',filterDate.Bogus_Date_1__c,filterDate.Bogus_Date_2__c);
        }
    }
    public PageReference filterResults(){
        RebuildCurrentFilter();
        SetPage(1);
        SaveToCache();
        RefreshDocumentList();      
        return null;
    }
    //sorting
    private String sortDirection = 'DESC';
    private String sortExp = 'DocumentDate'; 
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
        
    private String listKey{
        get{          
            return m_documentDataService.BuildKey(pageKeyType,pageKey,false);
        }
    }
    private String drawerPrivilegesKey{
        get{
            return DrawerPrivilege.GetKey(UserInfo.getUserEmail());
        }
    }
    public void SaveToCache(){
        m_relNavDocument.SaveList(unfilteredList,listKey);
        m_documentDataService.SaveList(DrawerPrivileges,drawerPrivilegesKey);
    }
    private void RefreshDocumentList(){
        filteredList = m_relNavDocument.LoadList(listKey,sortParameter,getSortDirection(),0,0,currentFilter);
        viewableList = m_relNavDocument.LoadList(listKey,sortParameter,getSortDirection(),pager.pageSize,pager.pagePosition,currentFilter);
        RefreshPager();
    }
    private Map<String,List<RelNavDocument>> unfilteredListMap = new Map<String, List<RelNavDocument>>();
    public List<RelNavDocument> unfilteredList{
       get{
            List<RelNavDocument> theList = unfilteredListMap.get(listKey);
            if(theList == null && listKey != null){
                theList = m_relNavDocument.LoadList(listKey, sortParameter, getSortDirection()); 
                unfilteredListMap.put(listKey,theList);
            }
           return theList;
        }
    }
    public List<RelNavDocument> filteredList{
        get{
            if(filteredList == null){
                filteredList = m_relNavDocument.LoadList(listKey, sortParameter, getSortDirection(),0,0,currentFilter);
            }
            if(filteredList == null){
                filteredList = new List<RelNavDocument>();
            }
            return filteredList;
        }
        set;
    }
    public List<RelNavDocument> viewableList{
        get{
            if(viewableList == null){
                viewableList = m_relNavDocument.LoadList(listKey,sortParameter,getSortDirection(),pager.pageSize,pager.pagePosition,currentFilter);
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
        if(objects != null){
            for(Documents.ICacheable o : objects){
                casted.add((DrawerPrivilege)o);
            }
        }
        return casted;
    }
    private Map<String,DrawerPrivilege> DrawerPrivilegeMap{
        get{
            if(DrawerPrivilegeMap == null){
                DrawerPrivilegeMap = new Map<String,DrawerPrivilege>();
                if(DrawerPrivileges != null){
                    for(DrawerPrivilege d : DrawerPrivileges){
                        DrawerPrivilegeMap.put(d.DrawerName,d);
                    }
                }
            }
            return DrawerPrivilegeMap;
        }
        set;
    }
}