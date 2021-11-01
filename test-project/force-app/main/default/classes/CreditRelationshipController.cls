public class CreditRelationshipController {

    public String selectedRelatedEntityId {get;set;}
    public String selectedRelatedAccountId {get;set;}
    public String selectedExcludedAccountId {get;set;}
    public String selectedPossibleRelatedEntityId {get;set;}
    public String selectedNoteId {get;set;}
    public String analysisDiaryRendered {get;set;}
    public String minuteDiaryRendered {get;set;}
    public CreditRelationship.NoteSm noteSm {get;set;}

    private IStandardController m_controller;
    private CreditRelationship.ICreditRelationshipService m_service;
    
    public CreditRelationshipController(IStandardController controller, CreditRelationship.ICreditRelationshipService service){
        m_controller = controller;
        m_service = service;
        initialize();
    }

    public CreditRelationshipController(ApexPages.StandardController controller) {
        m_controller = new StandardControllerWrapper(controller);
        Configurations.IConfigurations configs = Configurations.bootstrap();
        Utility.IUtility utilities = new Utility();
        m_service = new CreditRelationshipService(
                            new CreditRelationshipVmBuilder(),
                            new CreditRelationshipData(new CreditRelationshipDmBuilder(), utilities),
                            new CreditRelationshipReportManager(configs),
                            new ReportUrlProvider(configs), 
                            UserInfoService.bootstrap());
        initialize();
    }

    private void initialize()
    {        
        noteSm = new CreditRelationship.NoteSm();
        ResetDiaryPanel();
    }

    public CreditRelationship.CreditRelationshipVm vm
    {
        get
        {
            if(vm == null)
            {
                vm = m_service.getCreditRelationshipViewModel(record.Id);
            }
            return vm;
        }
        set;
    }

    private Credit_Relationship__c record
    {
        get{
            return (Credit_Relationship__c) m_controller.getRecord();
        }
    }

    public void saveReport()
    {
        m_service.addArchivedReport(record.Id);
    }

    public String reportUrl
    {    
        get
        {
            return m_service.getReportUrl(record.id);
        }
    }
   
    public PageReference deleteRelatedEntity(){
        m_service.deleteRelatedEntity(selectedRelatedEntityId);        
        return reloadPage();
    }
    
    public PageReference addEntityToRelationship(){
        CreditRelationship.RelatedEntitySm sm = new CreditRelationship.RelatedEntitySm();
        sm.creditRelationshipId = record.Id;
        sm.entityId = selectedPossibleRelatedEntityId;
        m_service.addRelatedEntity(sm);
        return reloadPage();
    }     
     
    public PageReference deleteAccountExclusion(){
        m_service.deleteExcludedEbAccount(selectedExcludedAccountId);
        return reloadPage();
    }

    public PageReference excludeRelatedAccount()
    {
        CreditRelationship.ExcludedAccountSm sm = new CreditRelationship.ExcludedAccountSm();
        sm.creditRelationshipId = record.Id;
        sm.accountId = selectedRelatedAccountId;
        m_service.addExcludedAccount(sm);
        return reloadPage();        
    }
    
    public PageReference NewAnalysis()
    {
        AnalysisDiaryRendered = 'true';
        return null;
    }
    
    public PageReference NewCreditRelationshipRelatedClient()
    {
        String newObjUrl = '/a1J/e?CF00N30000007h4av=CrRel000000&CF00N30000007h4av_lkid='
                            + record.id + '&retURL=/apex/CreditRelationships?id='
                            + record.id + '&sfdc.override=1&core.apexpages.devmode.url=1';
        PageReference newPage = new PageReference(newObjUrl);
        newPage.setRedirect(true);
        return newPage;
    }
    
    public PageReference NewMinute()
    {
        MinuteDiaryRendered = 'true';
        return null;
    }
    
    public void resetDiaryPanel()
    {
        AnalysisDiaryRendered = 'false';
        MinuteDiaryRendered = 'false';
    }
    
    public PageReference saveMinute()
    {
        saveNote(CreditRelationship.NoteType.minute);
        return reloadPage();
    }
    
    public PageReference saveAnalysis()
    {
        saveNote(CreditRelationship.NoteType.situationAnalysis);
        return reloadPage();
    }

    private void saveNote(CreditRelationship.NoteType noteType)
    {
        noteSm.creditRelationshipId = record.id;
        noteSm.type = noteType;
        m_service.addNote(noteSm);
    }
    
    public PageReference cancelRecord()
    {
        ResetDiaryPanel();
        return reloadPage();
    }
    
    public PageReference deleteNote()
    {
        m_service.deleteNote(selectedNoteId);
        return reloadPage();
    }    
    
    public Boolean hasPermissionAdmin
    {
        get
        {
            return m_service.hasPermissionAdmin();
        }
    }
    
    public Boolean hasPermissionToEdit
    {
        get
        {
            return m_service.hasPermissionToEdit();
        }
    }
    
    public Boolean hasPermissionToView
    {
        get
        {
            return m_service.hasPermissionToView();
        }
    }
    
    public Boolean hasPermission
    {
        get
        {
            return hasPermissionAdmin || hasPermissionToEdit || hasPermissionToView;
        }
    }

    private PageReference reloadPage()
    {
        PageReference newPage = new PageReference('/apex/CreditRelationships?id=' + record.id );
        newPage.setRedirect(true);
        return newPage;
    }

}

//public class CreditRelationshipController {
//    String url = '';
//    public Credit_Relationship__c credit_relation{get;set;}
//    public Id selectedEntityId{get;set;}
//    public Id selectedEBAccountId{get;set;}
//    public Credit_relationship_Note__c crnote{get;set;}
    
//    public CreditRelationshipController(ApexPages.StandardController controller) {
//        if(url == '') url = getServerUrl();
//        credit_relation = (Credit_Relationship__c)controller.getrecord();
//        crnote = new Credit_relationship_Note__c();
//        ResetDiaryPanel();
//    }
//      public Boolean isOREO(){
//        RecordType oreoRecordType = utility.RecordTypeObject('Credit_Relationship__c','Credit Relationship OREO');
//        if(credit_relation.RecordTypeId == oreoRecordType.Id){
//            return true;
//        }
//        return false;
//    }
    
//    private Map<string,string> AccountStatusSet{
//        get{
//            if(AccountStatusSet == null && isOREO()==false){
//                AccountStatusSet = new map<String,string>();
//                AccountStatusSet.put('C','C');
//                AccountStatusSet.put('R','R');
//                AccountStatusSet.put('P','P');
//             }    
//             else{
//             if(AccountStatusSet == null && isOREO()==true){
//              AccountStatusSet = new map<String,string>();
//                AccountStatusSet.put('R','R');
//                AccountStatusSet.put('P','P');
//             }
//             }             
//            return AccountStatusSet;
//        }
//        set;
//    }
    
   
//    private Boolean isIncludedApplication(Decimal appCode){           
//        if(isOREO()){
//            if(appCode == 91){
//                return true;
//            }
//        }else{
//            if(appCode <> 91){
//                return true;
//            }
//        }
//        return false;
//    }
    
//    private Boolean isLoanAccount(Decimal appCode){
//        if(appCode == 11 || appCode == 13 || appCode == 15 || appCode == 19){
//            return true;
//        }
//        return false;
//    }
    
//    public List<EB_Account__c> getEbAccounts(){
//        Map<Id,Id> creditRelsMap = new Map<Id,Id>();
//        for(Credit_Relationship_Related_Client__c rel : [Select Related_Entity_del__c, Credit_Relationship__c From Credit_Relationship_Related_Client__c WHERE Credit_Relationship__c =: credit_relation.id]){
//                creditRelsMap.put(rel.Related_Entity_del__c,rel.id);
//        }
//        Map<Id, Id> accountsMap = new Map<Id,Id>();
//        for(Account entity : [Select (Select EB_Account_Id__c From EB_Account_Relationships__r) From Account a
//                                    where a.Id in: creditRelsMap.keyset() ]){
//                for(EB_Account_Relationship__c rel : entity.EB_Account_Relationships__r)  {                     
//                        if(!accountsMap.containsKey(rel.EB_Account_Id__c))
//                        accountsMap.put(rel.EB_Account_Id__c,rel.EB_Account_Id__c); 
//                }                       
//        }
       
//        List<EB_Account__c> returnAccountList = new List<EB_Account__c>();
       
//        for(EB_Account__c a : [SELECT Current_Balance__c, Current_Commitment__c, Unadvanced_Loan_Amount__c,Core_Current_Balance__c,id, Name,Account_Line_1__c, Application__c,Account_Number__c,Account_Status__c, Primary_Owner_Id__r.Name, Contribution_Margin__c, User_Code_1__c FROM EB_Account__c
//                               WHERE id in: accountsMap.keyset() and Account_Status__c not in:AccountStatusSet.keyset()                                                                                  
//                               ORDER BY Application__c desc, User_Code_1__c desc ,Account_Number__c]){
//            if(isIncludedApplication(a.Application__c)){
//                returnAccountList.add(a);                               
//            }
//        }
        
//        return returnAccountList;
//    }
    
//   //added 8/8/2012 km
//   private set<id> excludedrelatedSet{
//        get{
//            if(excludedrelatedSet == null){
//                excludedrelatedSet = new set<id>();
//            }
//            return excludedrelatedSet;
//        }
//        set;
//    }
    
//    public List<EB_Account__c> getExcludedEbAccounts(){
//        Map<Id,Id> excludedRelsMap = new Map<Id,Id>();
//        for(Credit_Relationship_Excluded_Account__c rel : [Select EB_Account_Id__c, EB_Account_Id__r.name, Credit_Relationship_Id__c From Credit_Relationship_Excluded_Account__c WHERE Credit_Relationship_Id__c =: credit_relation.id]){
//            excludedRelsMap.put(rel.Credit_Relationship_Id__c, rel.id);
//        }
                
//       List<EB_Account__c> excludedEBAccountList = new List<EB_Account__c>();
       
//        for(EB_Account__c a : [SELECT Current_Balance__c, Current_Commitment__c, Unadvanced_Loan_Amount__c,Core_Current_Balance__c,id, Name,Account_Line_1__c, Application__c,Account_Number__c,Account_Status__c, Primary_Owner_Id__r.Name, Contribution_Margin__c, User_Code_1__c FROM EB_Account__c
//                               WHERE id in: excludedRelsMap.keyset() and Account_Status__c not in:AccountStatusSet.keyset()                                                                                  
//                               ORDER BY Application__c desc, User_Code_1__c desc ,Account_Number__c]){
//            if(isIncludedApplication(a.Application__c)){
//                if(isLoanAccount(a.Application__c)){
//                    if((a.Current_Commitment__c + a.Unadvanced_Loan_Amount__c  + a.Current_Balance__c ) > 0){
//                        excludedEBAccountList.add(a);
//                    }
//                }else{
//                    excludedEBAccountList.add(a);     
//                }
//            }                                 
//        }
        
//        return excludedEBAccountList;
//    }
//   //end
   
//    public List<Account> getClients(){
//        Map<Id,Id> ebAccountsMap = new Map<Id, Id> ();
//        for(EB_Account__c ebaccount : getEbAccounts() ){
//                ebAccountsMap.put(ebaccount.Id, ebaccount.Id);
//        }
        
//        Map<Id,Id> clientsMap = new Map<Id,Id>();
//        for(EB_Account_Relationship__c rel : [Select  Client_Id__c,Client_Id__r.Name From EB_Account_Relationship__c where EB_Account_Id__c in: ebAccountsMap.keyset()]){
//                clientsMap.put(rel.Client_Id__c,rel.Client_Id__c );
//        }
//        //[Select  Client_Id__c,Client_Id__r.Name From EB_Account_Relationship__c where EB_Account_Id__c in: ebAccountsMap.keyset())];
//        Map<Id,Id> creditRelsMap = new Map<Id,Id>();
//        for(Credit_Relationship_Related_Client__c rel : [Select Related_Entity_del__c, Credit_Relationship__c From Credit_Relationship_Related_Client__c WHERE Credit_Relationship__c =: credit_relation.id]){
//                if(!creditRelsMap.containsKey(rel.Related_Entity_del__c))
//                creditRelsMap.put(rel.Related_Entity_del__c,rel.id);
//        }
//        return [SELECT Id, name, BillingStreet,BillingCity, BillingState,BillingPostalCode , Record_Type_Description__c  FROM Account WHERE id in: clientsMap.keyset() and id not in: creditRelsMap.keyset() order by name];
//    }
    
//    //Archived Reports
//    public Id selectedArchivedReportForDelete{get;set;}
//    public PageReference DeleteArchivedReport(){
//        List<Archived_Report__c> aReport = [SELECT Id, Name FROM Archived_Report__c WHERE id =:selectedArchivedReportForDelete];
//        if(aReport.size() > 0) delete aReport;
//        PageReference newPage = new PageReference(url + 'apex/CreditRelationships?id=' + credit_relation.id );
        
//        newPage.setRedirect(true);
//        return newPage;
//    }
//    public List<Archived_Report__c> getArchivedReports(){
//        return [SELECT Id,Name, IDLong__c,  url__c, Credit_Relationship__c,createddate,CreatedById FROM Archived_Report__c WHERE Credit_Relationship__c =: credit_relation.Id];
        
//    }
  
//    //Related Entities
//    public Id selectedRelatedEntityForDelete{get;set;}
//    public PageReference DeleteRelatedEntity(){
//        List<Credit_Relationship_Related_Client__c> rels = [SELECT Id FROM Credit_Relationship_Related_Client__c WHERE  id =: selectedRelatedEntityForDelete];
//        if(rels.size()> 0) delete rels;
//        PageReference newPage = new PageReference(url + 'apex/CreditRelationships?id=' + credit_relation.id );          
//        newPage.setRedirect(true);
//        return newPage;
//    }
//    public List<Credit_Relationship_Related_Client__c> getRelatedEntities(){
//        return [SELECT id, Name, Credit_Relationship__c,Related_Entity_del__c , Related_Entity_del__r.Name,Related_Entity_del__r.BillingStreet,Related_Entity_del__r.BillingCity,Related_Entity_del__r.BillingState, Related_Entity_del__r.BillingPostalCode  FROM Credit_Relationship_Related_Client__c WHERE Credit_Relationship__c =: credit_relation.Id];
//    }
    
//    public PageReference addEntityToRelationship(){
//        Account addEntity = [SELECT Id, Name FROM Account WHERE Id =: selectedEntityId];
//        Credit_Relationship_Related_Client__c newRelationship = new Credit_Relationship_Related_Client__c();
//        newRelationship.Credit_Relationship__c = credit_relation.Id;
//        newRelationship.Related_Entity_del__c = addEntity.Id;
//        insert newRelationship;
//        return null;
//    }
    
//     //Exclude Related EB Accounts added 8/7/2012 KM
     
//     public Id selectedRelatedEBAccountForInclude{get;set;}
     
//     public PageReference IncludeRelatedEBAccount(){
//        List<Credit_Relationship_Excluded_Account__c> exclAccts = [SELECT Id FROM Credit_Relationship_Excluded_Account__c WHERE  id =: selectedRelatedEBAccountForInclude];
//        if(exclAccts.size()> 0) delete exclAccts;
//        PageReference newPage = new PageReference(url + 'apex/CreditRelationships?id=' + credit_relation.id );          
//        newPage.setRedirect(true);
//        return newPage;
//    }
     
//     public List<Credit_Relationship_Excluded_Account__c> getAllExcludedEBAccounts(){
//        List<Credit_Relationship_Excluded_Account__c> exacctList = new List<Credit_Relationship_Excluded_Account__c>();
//        for(Credit_Relationship_Excluded_Account__c cr : [SELECT id, Name, Credit_Relationship_Id__c,EB_Account_Id__c , Credit_Relationship_Id__r.Name, EB_Account_Id__r.Name, EB_Account_Id__r.Account_Line_1__c  FROM Credit_Relationship_Excluded_Account__c WHERE Credit_Relationship_Id__c =: credit_relation.Id]){
//            if(!excludedrelatedSet.contains(cr.EB_Account_Id__c)) excludedrelatedSet.add(cr.EB_Account_Id__c);
//            exacctList.add(cr);
//        }
//        return exacctList;
//    }

//     public PageReference addEBAccountToExcludedRelationship(){
//        EB_Account__c addEBAccount = [SELECT Id, Name FROM EB_Account__c WHERE Id =: selectedEBAccountId];
//        Credit_Relationship_Excluded_Account__c newExcludedRelationship = new Credit_Relationship_Excluded_Account__c();
//        newExcludedRelationship.Credit_Relationship_Id__c = credit_relation.Id;
//        newExcludedRelationship.EB_Account_Id__c = addEBAccount.Id;
//        if(!excludedrelatedSet.contains(newExcludedRelationship.EB_Account_Id__c)){
//            insert newExcludedRelationship;
//            excludedrelatedSet.add(newExcludedRelationship.EB_Account_Id__c);
//        }        
//        return null;
//    }
    
//    // end
//    public Boolean getIsSandBox(){
//        GlobalVar__c gv = GlobalVar__c.getOrgDefaults();
//        if(String.ValueOf(gv.IsSandbox__c)=='true'){
//            return true;
//        }
//        return false;
//    }
    
//    public String getReportView(){
//        GlobalVar__c gv = GlobalVar__c.getOrgDefaults();
        
//        Integer reportId = Integer.valueOf(gv.Credit_Relationship_Report_Id__c);
        
//        if(isOREO()){
//            reportId = Integer.valueOf(gv.Credit_Relationship_OREO_Report_Id__c);
//        }
        
//        return 'http://ebatwork/reportal/showreportfromtrustedip.aspx?id=' + String.valueOf(reportId) + '&P1=' + String.valueOf(credit_relation.Id);
//    }
    
//    public PageReference getRefresh(){
//        return null;
//    }
    
//    public void getReport(){
//        IF(isOREO()){
//            SaveWatchCreditReportOREO();
//        }
//        else {
            
//        SaveWatchCreditReport();
//             }
//    }
    
//    private void SaveWatchCreditReport(){
//        Archived_Report__c areport = new Archived_Report__c(Name = 'Watch Credit Report', Credit_Relationship__c = this.credit_relation.Id);
//        List<Credit_Relationship_Note__c> UpdatesituationAnalysisList = new List<Credit_Relationship_Note__c>();
//        for(Credit_Relationship_Note__c note : [SELECT id, Credit_Relationship__c,RecordtypeId, Situation_Flag__c FROM Credit_Relationship_Note__c WHERE Credit_Relationship__c =: credit_relation.Id and recordtypeid =:getanalysisRecTypeId]){
//            note.Situation_Flag__c = true;
//            UpdatesituationAnalysisList.add(note);
//        }
//        insert areport;
//        if(UpdatesituationAnalysisList.size() > 0) update UpdatesituationAnalysisList;
//        CallSDFCServiceURL(areport.Id);
//    }
    
//    private void SaveWatchCreditReportOREO(){
//         Archived_Report__c areport = new Archived_Report__c(Name = 'Watch Credit OREO Report', Credit_Relationship__c = this.credit_relation.Id);
//        List<Credit_Relationship_Note__c> UpdatesituationAnalysisList = new List<Credit_Relationship_Note__c>();
//        for(Credit_Relationship_Note__c note : [SELECT id, Credit_Relationship__c,RecordtypeId, Situation_Flag__c FROM Credit_Relationship_Note__c WHERE Credit_Relationship__c =: credit_relation.Id and recordtypeid =:getanalysisRecTypeId]){
//            note.Situation_Flag__c = true;
//            UpdatesituationAnalysisList.add(note);
//        }
//        insert areport;
//        if(UpdatesituationAnalysisList.size() > 0) update UpdatesituationAnalysisList;
//        CallSDFCServiceURLOREO(areport.Id);
//    }
    
//    @future(callout=true)
//    public static void CallSDFCServiceURL(String archiveReportId){
//        try{ 
//           Restutility.CreditRelationship(archiveReportId); 
//        }catch(exception ex){
//        }        
//    }
//     @future(callout=true)
//      public static void CallSDFCServiceURLOREO(String archiveReportId){
//        try{ 
//           Restutility.CreditRelationshipOREO(archiveReportId); 
//        }catch(exception ex){
//        }        
//    }
    
//    public static String convertid15ToId18(String id15) {
//        if (id15.length() != 15) return id15;
//        Id currentId = id15;
//        String id18 = currentId;
//        return id18;
//    }
    
//    //minute properties
//    public Map<String,Id> CRrecordtypes{
//        get{
//            if (CRrecordtypes == null){
//                CRrecordtypes = new Map<String,Id>();
//                for(Recordtype rec : [SELECT Id, Name FROM RecordType WHERE SObjectType =: 'Credit_Relationship_Note__c' ]){
//                    CRrecordtypes.put(rec.name, rec.id);
//                }
//            }
//            return CRrecordtypes;
//        }
//        set;
//    }
    
//    private Id getMinuteRecTypeId{
//        get{
//            return CRrecordtypes.get('Minute');
//        }
//    }
    
//    private Id getAnalysisRecTypeId{
//        get{
//            return CRrecordtypes.get('Analysis');
//        }
//    }
    
//    public List<Credit_relationship_Note__c> getMinutes{
//        get{
//            return [SELECT Id, name,Diary__c, CreatedDate FROM Credit_relationship_Note__c WHERE Credit_Relationship__c =:credit_relation.id and recordtypeid =: getMinuteRecTypeId ORDER BY CreatedDate desc];
//        }
//        set;
//    }
    
//    public List<Credit_relationship_Note__c> getAnalysis{
//        get{
//            return [SELECT Id, name,Diary__c,Situation_Flag__c, CreatedDate FROM Credit_relationship_Note__c WHERE Credit_Relationship__c =:credit_relation.id and recordtypeid =: getanalysisRecTypeId ORDER BY CreatedDate desc];
//        }       
//        set;
//    }
    
//    public String AnalysisDiaryRendered{get;set; }
//    public String MinuteDiaryRendered{get;set; }
//    public PageReference NewAnalysis(){
//        AnalysisDiaryRendered = 'true';
//        return null;
//    }
    
//    public PageReference NewCreditRelationshipRelatedClient(){
//        String newObjUrl = url + 'a1J/e?CF00N30000007h4av=CrRel000000&CF00N30000007h4av_lkid='
//        //                   + credit_relation.id + '&retURL=%2Fapex%2FCreditRelationships%3Fid%3D'
//        //                   + credit_relation.id + '%26sfdc.override%3D1%26core.apexpages.devmode.url%3D1';
//                             + credit_relation.id + '&retURL=/apex/CreditRelationships?id='
//                             + credit_relation.id + '&sfdc.override=1&core.apexpages.devmode.url=1';
//        PageReference newPage = new PageReference(newObjUrl );
//        newPage.setRedirect(true);
//        return newPage;
//    }
    
//    public PageReference NewMinute(){
//        MinuteDiaryRendered = 'true';
//        return null;
//    }
    
//    public void ResetDiaryPanel(){
//        AnalysisDiaryRendered = 'false';
//        MinuteDiaryRendered = 'false';
//    }
    
//    public PageReference SaveMinute(){
//        crnote.recordtypeid = getMinuteRecTypeId;
//        crnote.Credit_Relationship__c = credit_relation.id;
//        insert crnote;
//                ResetDiaryPanel();
//        PageReference newPage = new PageReference(url + 'apex/CreditRelationships?id=' + credit_relation.id );
//        newPage.setRedirect(true);
//        return newPage;
//    }
    
//    public PageReference SaveAnalysis(){
//        crnote.recordtypeid = getAnalysisRecTypeId;
//        crnote.Credit_Relationship__c = credit_relation.id;
//        insert crnote;
//        ResetDiaryPanel();
//        PageReference newPage = new PageReference(url + 'apex/CreditRelationships?id=' + credit_relation.id );
//        newPage.setRedirect(true);
//        return newPage;
//    }
    
//    public PageReference CancelRecord(){
//        PageReference newPage = new PageReference(url + 'apex/CreditRelationships?id=' + credit_relation.id );
//        this.ResetDiaryPanel();
//        newPage.setRedirect(true);
//        return newPage;
//    }
    
//    public Id selectedNoteForDelete{get;set;}
    
//    public PageReference DeleteNote(){
//        List<Credit_relationship_Note__c> delList = [SELECT Id, Name FROM Credit_relationship_Note__c WHERE id =:selectedNoteForDelete];
//        if(delList.size() > 0) delete delList;
//        PageReference newPage = new PageReference(url + 'apex/CreditRelationships?id=' + credit_relation.id );
//        this.ResetDiaryPanel();
//        newPage.setRedirect(true);
//        return newPage;
//    }
    
     
//    private static String  getServerUrl(){
//        return utility.getServerUrl() + '/';
//    }
    
//    //Permissions
//    private Map<String,PermissionSet> PermissionSetMap{
//        get{
//            if(PermissionSetMap == null){
//                PermissionSetMap = new Map<String,PermissionSet>();

//                for(PermissionSet p : [select id, Label from PermissionSet where Label=:'Function - Credit Relationship Admin' or Label=:'Function - Credit Relationship View' or Label=:'Function - Credit Relationship Editor']){
//                    PermissionSetMap.put(p.Label , p);
//                }               
//            }
//            return PermissionSetMap;
//        }
//        set;
//    }
    
//    public String HasPermissionAdmin{
//        get{
//            Profile pr = [select name from Profile where id =: UserInfo.getProfileId()];
//            if(pr.Name == 'System Administrator' || HasPermissionAdmin == 'true') return 'true';
//            List<PermissionSetAssignment> permissionsetassignList  = [SELECT PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId = :UserInfo.getUserId() and PermissionSetId = :PermissionSetMap.get('Function - Credit Relationship Admin').id];                   
//            if(permissionsetassignList.size() > 0) return 'true';
//            return 'false';
//        }
//    }
    
//    public String HasPermissionToEdit{
//        get{
//            Profile pr = [select name from Profile where id =: UserInfo.getProfileId()];
//            if(pr.Name == 'System Administrator' || HasPermissionAdmin == 'true') return 'true';
//            if(PermissionSetMap.containsKey('Function - Credit Relationship Editor')){
//                List<PermissionSetAssignment> permissionsetassignList  = [SELECT PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId = :UserInfo.getUserId() and PermissionSetId = :PermissionSetMap.get('Function - Credit Relationship Editor').id];                  
//                if(permissionsetassignList.size() > 0) return 'true';
//            }
//            return 'false';
//        }
//    }
    
//    public String HasPermissionToView{
//        get{
//            Profile pr = [select name from Profile where id =: UserInfo.getProfileId()];
//            if(pr.Name == 'System Administrator' || HasPermissionAdmin == 'true') return 'true';
//            if(PermissionSetMap.containsKey('Function - Credit Relationship View')){
//                List<PermissionSetAssignment> permissionsetassignList  = [SELECT PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId = :UserInfo.getUserId() and PermissionSetId = :PermissionSetMap.get('Function - Credit Relationship View').id];            
//                if(permissionsetassignList.size() > 0) return 'true';
//            }
//            return 'false';
//        }
//    }
    
//    public String HasPermission{
//        get{
//            Profile pr = [select name from Profile where id =: UserInfo.getProfileId()];
//            if(pr.Name == 'System Administrator' || HasPermissionAdmin == 'true') return 'true';
//            if(HasPermissionToEdit == 'true') return 'true';
//            if(HasPermissionToView == 'true') return 'true';
//            return 'false';   
//        }
//    }
//}