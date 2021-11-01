public with sharing class WebsiteCMSListsController {


    
    String assoc_previous;
    String assoc_next;
    String assoc_showPrev;
    String assoc_showNext;
    String assoc_clicked;
    Integer assoc_currentPos;
    Integer assoc_page = 15;
    
    String unit_previous;
    String unit_next;
    String unit_showPrev;
    String unit_showNext;
    String unit_clicked;
    Integer unit_currentPos;
    Integer unit_page =15;
    List<EB_Team_Member__c> associates;
    List<EB_Team_Member__c> allAssociates;
    List <EB_Unit__c> units;
    List <EB_Unit__c> allunits;
    
    PageReference thisPage = null;
    String retURL;
    String url = '';
    
    
    
    
     String view;    
     String viewBranch;     
            
     public List<SelectOption> getViewItems() {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('ALL','All Associates')); 
            options.add(new SelectOption('WEB','All Website Content'));
            options.add(new SelectOption('RM','Relationship Managers'));
            options.add(new SelectOption('STAFF','Staff Directory'));
            return options;
        }
        
     public List<SelectOption> getViewBranchItems() {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('ALL','All Branches'));                
            options.add(new SelectOption('WEB','All Website Content'));
            return options;
        }
            
     public String getView() {
            return view;
        }
            
     public void setView(String view) {
            this.view = view;
        }
    
    public void showView(){
        allAssociates = null;
        getAssociates();
    }
     public String getViewBranch() {
            return viewBranch;
        }
            
     public void setViewBranch(String view) {
            this.viewBranch = view;
        }
    
    public void showViewBranch(){
        allUnits = null;
        getUnits();
    }    
    
    
    

    //Pager assoc_Pager = new Pager();
    //Pager unit_Pager = new Pager();
    
    public String getassoc_showNext(){
        return this.assoc_showNext;
    }
    public String getassoc_showPrev(){
        return this.assoc_showPrev;
    }
    public String getunit_showNext(){
        return this.unit_showNext;
    }
    public String getunit_showPrev(){
        return this.unit_showPrev;
    }
    
    
    //added an instance varaible for the standard controller
   // private ApexPages.StandardController controller {get; set;}


    
    
    public String getassoc_previous(){
        return '<Previous Page';
    }
    public String getassoc_next(){
        return 'Next Page>';
    }
    public String getunit_previous(){
        return '<Previous Page';
    }
    public String getunit_next(){
        return 'Next Page>';
    }
    
    public String getunit_currentpos(){
        return String.valueof(unit_currentpos);
    }
    
    public String getassoc_currentpos(){
        return String.valueof(assoc_currentpos);
    }

    
    

    public WebsiteCMSListsController() {    


    
        if(thisPage==null) thisPage = apexpages.currentpage();
        //if(url == '') url = getServerUrl();
        getQueryParameters();
        initialize();
    }
    
    private void initialize() {
        
        if (assoc_currentPos==null){
            assoc_currentPos = 0;
        }
        
        if (unit_currentPos==null){
            unit_currentPos = 0;
        }
        //this.assoc_currentPos = 0;
        //this.unit_currentPos = 0;
        if (view==null){
            setView('ALL');
        }
        if(viewBranch==null){
            setViewBranch('ALL');
        }
        getAssociates();
        getunits();
        
    }
    public  void assoc_getNext(){
        //this.assoc_currentPos = this.assoc_currentPos+this.assoc_page;
        this.assoc_currentPos +=this.assoc_page;
        //assocs = makeassocList();
        //return assocs;
                //for(integer i = assoc_currentPos; i < assocs.size(); i++ ){
    }
    
    public  void assoc_getPrev(){
        //this.assoc_currentPos = this.assoc_currentPos-this.assoc_page;
        this.assoc_currentPos -= this.assoc_page;
        //assocs = makeassocList();
       // return assocs;
    }
    
    public  void unit_getNext(){
        //this.unit_currentPos = this.unit_currentPos+this.unit_page;
        this.unit_currentPos += this.unit_page;
        //assocs = makeassocList();
        //return assocs;
                //for(integer i = assoc_currentPos; i < assocs.size(); i++ ){
    }
    
    public  void unit_getPrev(){
        //this.unit_currentPos = this.unit_currentPos-this.unit_page;
        this.unit_currentPos -= this.unit_page;
        //assocs = makeassocList();
       // return assocs;
    }
    
    
    
    
    //public List<EB_Team_Member__c> getAssociates() {
    //  associates = [SELECT Name, Id from EB_Team_Member__c];
    //  return associates;
    //}
    
    public List<EB_Team_Member__c> getAssociates() {
        associates = makeAssociatesList();
        return associates;                  
    }
    
    public List<EB_Team_Member__c> makeAssociatesList() {
        //if(dir==null) {       dir = [Select id FROM EB_Team_Member__c where id = :director.id];}
        List<EB_Team_Member__c> ret_assoc = new List<EB_Team_Member__c>() ;
        
        string fieldlist;       
        string whereclause;
        string orderby;
        string qryString;

        if (allAssociates == null){ //rebuild the list...the user has selected a new view
            
            whereClause='';
            //get the view selected in the dropdown
            if(view=='ALL') {
                whereClause = '';
            }
            if(view=='WEB') {
                whereClause='WHERE Website_Relationship_Manager__c = true OR Website_Associate_Directory__c = true ';
            }
            if(view=='RM'){
                whereClause='WHERE Website_Relationship_Manager__c = true ';
            }  
            if(view=='STAFF'){
                whereClause='WHERE Website_Associate_Directory__c = true ';
            }
            
            fieldList = 'Name, id, Website_Associate_Directory__c, Website_Relationship_Manager__c, Website_Division_Published__c, ';
            fieldList += 'Website_Email_Published__c, Website_Office_Phone_Published__c, Website_Mobile_Phone_Published__c, ';
            fieldList += 'Website_Directory_Category__c, Website_RM_Type__c, Website_Name_Published__c, Website_Region_Code__C ';
            orderBy = 'ORDER BY Name ';
            qryString = 'SELECT ' + fieldList + ' FROM EB_Team_Member__c ' + whereClause + orderBy;
            
            
            //Query salesforce with your Query string
            System.debug('QRYSTRING====' +qryString);
            allAssociates = Database.query(qryString);
            
            
            /*
            allAssociates = [
                Select b.Name,
                b.Id,
                b.Website_Associate_Directory__c,
                b.Website_Relationship_Manager__c,
                b.Website_Division_Published__c,
                b.Website_Email_Published__c,
                b.Website_Office_Phone_Published__c,
                b.Website_Mobile_Phone_Published__c,
                b.Website_Directory_Category__c,
                b.Website_RM_Type__c                    
                From EB_Team_Member__c b
                //WHERE b.Website_Relationship_Manager__c = true AND b.Website_Associate_Directory__c = true
                ORDER BY b.Name         
         ];
         */
         }
        if (allAssociates.size()<=this.assoc_page){
            ret_assoc = allassociates;
            this.assoc_showNext='false';
            this.assoc_showPrev='false';
        } else {
            for(integer i = this.assoc_currentPos; i < this.assoc_currentPos + this.assoc_page; i++ ){
                if(i>=allassociates.size()-1){
                    this.assoc_showNext='false';
                } else {
                    this.assoc_showNext='true';
                }       
                if(i>=this.assoc_page){
                    this.assoc_showPrev='true';
                }       else {
                    this.assoc_showPrev='false';
                }
                if (i<=allassociates.size()-1){
                    ret_assoc.add(allassociates.get(i))  ;
                }
                

            }
            
        }
        return ret_assoc;

        
    }
    
    
    
    public List<EB_Unit__c> getUnits() {
        Units = makeUnitsList();
        return Units;
                    
    }
    
    public List<EB_Unit__c> makeUnitsList() {
        //if(dir==null) {       dir = [Select id FROM EB_Team_Member__c where id = :director.id];}
        List<EB_Unit__c> ret_unit = new List<EB_Unit__c>() ;
        
        string fieldlist;       
        string whereclause;
        string orderby;
        string qryString;
        
        
         if (allUnits == null){
            whereClause='';
            //get the view selected in the dropdown
            if(viewBranch=='ALL') {
                whereClause = '';
            }
            if(viewBranch=='WEB') {
                whereClause='WHERE website_include__c = true ';
            }
            fieldList = 'Name, id, website_include__c, EB_Region__r.name, Website_Address_Published__c, Website_Phone_Published__c, ';
            fieldList += 'website_lobby_hours__c, website_atm_onsite__c, website_drive_through__c, website_drive_through_hours__c, ';
            fieldList += 'website_image_url__c, website_notes__c, Website_Name_Published__c ';
            orderBy = 'ORDER BY Name ';
            qryString = 'SELECT ' + fieldList + ' FROM EB_Unit__c ' + whereClause + orderBy;
            
            
            //Query salesforce with your Query string
            System.debug('QRYSTRING====' +qryString);
            allUnits = Database.query(qryString);
            
            /*allUnits = [
                Select b.Name,
                b.Id,
                b.website_include__c,
                b.EB_Region__r.name,
                b.Website_Address_Published__c,
                b.Website_Phone_Published__c,
                b.website_lobby_hours__c,
                b.website_atm_onsite__c,
                b.website_drive_through__c,
                b.website_drive_through_hours__c ,
                b.website_image_url__c,
                b.website_notes__c          
                From EB_Unit__c b
                ORDER BY b.Name         
         ];
         */
         }
        if (allUnits.size()<=this.unit_page){
            ret_unit = allUnits;
            this.unit_showNext='false';
            this.unit_showPrev='false';
        } else {
            for(integer i = this.unit_currentPos; i < this.unit_currentPos + this.unit_page; i++ ){
                if(i>=allUnits.size()-1){
                    this.unit_showNext='false';
                } else {
                    this.unit_showNext='true';
                }       
                if(i>=this.unit_page){
                    this.unit_showPrev='true';
                }       else {
                    this.unit_showPrev='false';
                }
                if (i<=allUnits.size()-1){
                    ret_unit.add(allUnits.get(i))  ;
                }
                

            }
            
        }
        return ret_unit;

        
    }
    
    private void getQueryParameters(){
        try{
            this.assoc_currentPos = Integer.valueOf(thisPage.getParameters().get('ap'));
        }catch(exception ex){
            this.assoc_currentPos = null;
        }
        try{
            this.unit_currentPos = Integer.valueOf(thisPage.getParameters().get('up'));
        }catch(exception ex){
            this.unit_currentPos = null;
        }
        try{
            this.view = thisPage.getParameters().get('av');
        }catch(exception ex){
            this.view = null;
        }
        try{
            this.viewBranch = thisPage.getParameters().get('uv');
        }catch(exception ex){
            this.viewBranch = null;
        }
    }

    public static testMethod void verifyMe(){
        
        EB_Team_Member__c assoc1 = objectFactory.getTeamMember('Test One');
        EB_Team_Member__c assoc2 = objectFactory.getTeamMember('Test Two');
        EB_Team_Member__c assoc3 = objectFactory.getTeamMember('Test Three');
        EB_Team_Member__c assoc4 = objectFactory.getTeamMember('Test Four');
        EB_Team_Member__c assoc5 = objectFactory.getTeamMember('Test Five');
        assoc1.RecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('Director', 'EB_Team_Member__c');        
        update assoc1;
        assoc2.RecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('Director', 'EB_Team_Member__c');        
        update assoc2;
        assoc3.RecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('Director', 'EB_Team_Member__c');        
        update assoc3;
        assoc4.RecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('Director', 'EB_Team_Member__c');        
        update assoc4;
        assoc5.RecordTypeId = ObjectFactory.getRecordTypeIdByNameAndObject('Director', 'EB_Team_Member__c');        
        update assoc5;
        
        EB_Unit__c branch1 = new EB_Unit__c(name='Test Branch One',Phone_Number__c='999-999-9999', Unit_Reporting_Label__c='Test Branch One');
        EB_Unit__c branch2 = new EB_Unit__c(name='Test Branch Two',Phone_Number__c='999-999-9999', Unit_Reporting_Label__c='Test Branch Two');
        EB_Unit__c branch3 = new EB_Unit__c(name='Test Branch Three',Phone_Number__c='999-999-9999', Unit_Reporting_Label__c='Test Branch Three');
        EB_Unit__c branch4 = new EB_Unit__c(name='Test Branch Four',Phone_Number__c='999-999-9999', Unit_Reporting_Label__c='Test Branch Four');
        EB_Unit__c branch5 = new EB_Unit__c(name='Test Branch Five',Phone_Number__c='999-999-9999', Unit_Reporting_Label__c='Test Branch Five');
        insert branch1;
        insert branch2;
        insert branch3;
        insert branch4;
        insert branch5;
        
        
        
        
        String serverurl =  Utility.getServerUrl();       
        String url = serverurl + '/';
       // PageReference pr = new PageReference(url + director.Id);
        //pr.setRedirect(true);        
        //test.setCurrentPage(pr);
        WebsiteCMSListsController controller = new WebsiteCMSListsController();
        controller.getViewItems();
        controller.getViewBranchItems();              
        controller.assoc_page = 3;
        controller.unit_page = 3;
        controller.initialize();        
        controller.assoc_page = 5;
        controller.unit_page = 5;
        List<EB_Unit__c> units;
        List<EB_Team_Member__c> assocs;
        assocs = controller.makeassociatesList();
        units = controller.makeunitsLIst();
        controller.getassoc_Next();
        controller.getassoc_Previous();
        controller.getunit_Next();
        controller.getunit_Previous();      
        controller.getassoc_showPrev();
        controller.getassoc_showNext();
        controller.getunit_showPrev();
        controller.getunit_showNext();
        controller.assoc_getNext();
        controller.unit_getNext();
                controller.assoc_page = 1;
        controller.unit_page = 1;
        assocs = controller.makeassociatesList();
        units = controller.makeunitsLIst();
        controller.assoc_getNext();controller.unit_getNext();
        assocs = controller.makeassociatesList();
        units = controller.makeunitsLIst();
        controller.assoc_getNext();controller.unit_getNext();
        assocs = controller.makeassociatesList();
        units = controller.makeunitsLIst();
        controller.assoc_getNext();controller.unit_getNext();
        assocs = controller.makeassociatesList();
        units = controller.makeunitsLIst();
        controller.assoc_getNext();controller.unit_getNext();
        assocs = controller.makeassociatesList();
        units = controller.makeunitsLIst();     
        controller.assoc_getPrev();controller.unit_getPrev();
        assocs = controller.makeassociatesList();
        units = controller.makeunitsLIst();
        controller.assoc_getPrev();controller.unit_getPrev();
        assocs = controller.makeassociatesList();
        units = controller.makeunitsLIst();
        controller.assoc_getPrev();controller.unit_getPrev();
        assocs = controller.makeassociatesList();
        units = controller.makeunitsLIst();
        controller.assoc_getPrev();controller.unit_getPrev();
        assocs = controller.makeassociatesList();
        units = controller.makeunitsLIst();
        controller.assoc_getPrev();controller.unit_getPrev();
        controller.getunit_currentpos();
        controller.getassoc_currentpos();
        controller.getView();
        controller.setView('WEB');
        controller.showView();  
        controller.setView('RM');
        controller.showView();  
        controller.setView('STAFF');
        controller.showView();  
        controller.getViewBranch();
        controller.setViewBranch('WEB');
        controller.showViewBranch();    

    }

    
}