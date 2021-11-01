public  class EBEventController {
    private static String externalURL = 'http://enterprisebank.force.com/';
    private static String productionURL = Utility.getServerUrl() + '/apex/';
    private static String sandboxURL = utility.getServerUrl() + '/apex/'; 
    
    private static String baseURL = externalURL;
    private String confirmationURL = baseURL + 'ebeventmessage?Id=';
    
    private Id eventId;
    public EB_Event_Attendees__c att{get;set;}
    public EB_Event__c event{get;set;}
    public String dropdownLocation{get;set;}
    public Id dropdownSessionId{get;set;}
    public String chkSelection{get;set;}
       
    String[] selectedReasons = new String[]{};
    public String[] getSelectedReasons() {
        return selectedReasons;
    }    
    public void setSelectedReasons(String[] reasons) {
        this.selectedReasons = reasons;
    }
    
    public EBEventController(ApexPages.StandardController controller) {
        try{
                eventId = apexpages.currentpage().getparameters().get('e');
            }catch(exception ex){
                        eventId = null;
            }
                initialize();
    }
    
    private void initialize(){        
        event = [SELECT Id, Name, Ask_For_Company__c, Ask_for_Company_Address_Street__c, Ask_for_Company_Address_City__c, Ask_for_Company_Address_State__c, Ask_for_Company_Address_Zip__c, Ask_For_Email__c, Ask_for_Phone_Number__c, Ask_for_Comments__c, Show_Heading__c FROM EB_Event__c WHERE Id =: eventId];
        att = new EB_Event_Attendees__c();
    }
    
        public String getQuotes(){
                return '"';
        }
    
    public List<SelectOption> getLocations(){     
        DateTime dtnow =  System.now();
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('',''));
        List<AggregateResult> results = [SELECT Event_Location__c FROM EB_Event_Session__c WHERE EB_Event__c =: eventId AND Seats_Available__c > 0 AND Date_Time_of_Event__c >: dtnow GROUP BY Event_Location__c ORDER BY Event_Location__c ASC limit 50];
        for(AggregateResult ar: results){
                String location = (String)ar.get('Event_Location__c');
                options.add(new SelectOption(location,location));
        }        
        return options;
    }
    
    public List<SelectOption> getSessions(){
        DateTime dtnow =  System.now();
        List<SelectOption> options = new List<SelectOption>();
        List<EB_Event_Session__c> ebEventLocations = [SELECT Id, Event_Location__c , Capacity__c, Number_of_Attendee_From_Trigger__c,  Date_Time_of_Event__c  FROM EB_Event_Session__c WHERE EB_Event__c =: eventId AND Event_Location__c =:dropdownLocation AND Seats_Available__c > 0 AND Date_Time_of_Event__c >: dtnow ORDER BY Date_Time_of_Event__c ASC limit 50];
        for(EB_Event_Session__c e: ebEventLocations){
            String d = e.Date_Time_of_Event__c.format('MM/dd/yyyy');
            String t = e.Date_Time_of_Event__c.format('hh:mm a');
            String dt = d + ' - ' + t;
            options.add(new SelectOption(e.Id, dt));
        }        
        return options;
    }
   
        public List<SelectOption> getReasons() {
        EB_Event__c ebevent = new EB_Event__c();
        List<SelectOption> options = new List<SelectOption>();
        try{
            ebevent = [SELECT Event_Reason__c FROM EB_Event__c WHERE Id =: eventId];
        }catch(Exception ex){
            ebevent = null;
        }
        if (ebevent <> null){
            try{
                List<String> chkoptions = ebevent.Event_Reason__c.Split(',');
                
                for (String s : chkoptions){
                     options.add(new SelectOption(s,s));
                }
            }catch(exception ex){                
            }        
        }
        return options;
    }   
    
    public boolean getShowHeading(){
        return event.Show_Heading__c;
    }
    
    public boolean getShowCompany(){
        return event.Ask_For_Company__c;
    }
    //added on 07/16/2012
     public boolean getShowCompanyStreet(){
        return event.Ask_for_Company_Address_Street__c;
    }
     public boolean getShowCompanyCity(){
        return event.Ask_for_Company_Address_City__c;
    }
     public boolean getShowCompanyState(){
        return event.Ask_for_Company_Address_State__c;
    }
    public boolean getShowCompanyZip(){
        return event.Ask_for_Company_Address_Zip__c;
    }
    public boolean getShowPhoneNumber(){
        return event.Ask_for_Phone_Number__c;
    }
    public boolean getShowComments(){
        return event.Ask_for_Comments__c;
    }
    public boolean getShowReasons(){
        if(getReasons().size() > 0){
            return true;
        }else{
            return false;
        }
    }
    
    public boolean getShowEmail(){
        return event.Ask_For_Email__c;
    }
    
    public PageReference SaveSession(){        
        att.EB_Event_Course__c = dropdownSessionId;
        att.Attendee_reason__c = '';
        String[] r = getSelectedReasons();        
        for(String s : r){
            if (s <> null){
                att.Attendee_reason__c +=  s + ',';
            }
        }
        
        try{
            insert att;
            PageReference newPage = new PageReference(confirmationURL + att.Id);
            newPage.setRedirect(true);
            return newPage;
        }catch(Exception ex){        
            ApexPages.addMessages(ex);
        }
        
        return null;
    }
   
    public PageReference CancelSession(){
        initialize();
        return null;
    }
    
    public PageReference Bogus(){
        return null;
        }
    
    ///////////////////test methods////////////////////////////////
    private static String pageURL = baseURL + 'apex/EbEvent';
    private static EB_Event__c testEvent;
    private static EB_Event_Session__c testSession;
    private static EB_Event_Attendees__c testAttendee;
    
    public static testmethod void testThisClass(){      
        testSetupTestVariables();
        PageReference pr = testCreatePageReference(testEvent.Id);
        test.setCurrentPage(pr);
        
        test.startTest();       
        testVerifyFunctions();
        testVerifyPageReference();          
        test.stopTest();
    }
    
    private static void testSetupTestVariables(){
        testEvent = new EB_Event__c( Name = 'Salesforce Event Test',
                                     Event_Reason__c = 'Reason 1,Reason 2',
                                     Ask_For_Company__c = true,
                                     Ask_For_Email__c = true);      
        
        insert testEvent;
        DateTime dtnow = System.Now();
        dtnow = dtnow.addDays(10);
        
        testSession = new EB_Event_Session__c( EB_Event__c = testEvent.Id ,
                                               Event_Location__c = 'KC' ,
                                               Capacity__c = 3,
                                               Date_Time_of_Event__c = dtnow);
        insert testSession;
            
        testAttendee = new EB_Event_Attendees__c( EB_Event_Course__c = testSession.Id,
                                                  Attendee__c = 'Rajiv');
        insert testAttendee;
    }
        
    private static void testVerifyFunctions(){
        ApexPages.StandardController sc = new Apexpages.Standardcontroller(testAttendee);
        EBEventController testcontroller = new EBEventController(sc);
        testcontroller.eventId = testEvent.Id;
        testcontroller.initialize();
        List<SelectOption> optionsSession = new List<SelectOption>();
        optionsSession = testcontroller.getSessions();
        List<SelectOption> optionsLocations = new List<SelectOption>();
        optionsLocations = testcontroller.getLocations();
        List<SelectOption> optionsItems = new List<SelectOption>();
        optionsItems = testcontroller.getReasons();
        
        Boolean bBogus = testcontroller.getShowHeading();
        bBogus = testcontroller.getShowCompany();
        bBogus = testcontroller.getShowReasons(); 
        bBogus = testcontroller.getShowEmail();      
        String sBogus = testcontroller.getQuotes();
    }
    
    private static void testVerifyPageReference(){ 
        ApexPages.StandardController sc = new Apexpages.Standardcontroller(testAttendee);
        EBEventController testcontroller = new EBEventController(sc);
        testcontroller.eventId = testEvent.Id;
        testcontroller.initialize();
        testcontroller.att.Attendee__c = 'Test Testerson';
        testcontroller.att.Company__c = 'Acme, Inc.';
        PageReference psave = testcontroller.SaveSession();
    }  
    
    private static PageReference testCreatePageReference(Id e){
        PageReference newPage = new PageReference(pageURL+'?e='+e);
        newPage.setRedirect(true);
        return newPage;
    }
}