global class EventRegistrationEmailController {

    @RemoteAction
    global static EventRegistrationEmail.FormVm bootstrap(string recordJson) {
        try{
            IJson j = new JsonWrapper();
            EventRegistrationRequest req = (EventRegistrationRequest)j.deserialize(recordJson, EventRegistrationRequest.class);       

            return getFormVm(req);

        }catch(exception ex){
            throw new EventRegistration.BootstrapException(ex.getMessage());
        }  
        return null;
    }

    global static EventRegistrationEmail.FormVm getFormVm(EventRegistrationRequest req){
        EventRegistrationEmail.IDataProvider dp = new EventRegistrationEmailDataProvider();
        Event_Attendance__c a = dp.getAttendance(req.attendanceId);
        EventRegistrationEmail.FormVm vm = new EventRegistrationEmail.FormVm();
        vm.emailClient = req.EmailClient;
        vm.details = new EventRegistrationEmail.EmailDetails();
        vm.details.name = a.Event_Session__r.Event_Name__c;
        vm.details.location = a.Event_Session__r.Address__c;
        vm.details.startTime = formatForCalendar(a.Event_Session__r.Date_Time_of_Event__c);
        vm.details.endTime = formatForCalendar(a.Event_Session__r.End_Date_Time_of_Event__c);
        vm.details.WebinarLink = a.Event_Session__r.Webinar_Link__c;
        vm.details.WebinarPassword = a.Event_Session__r.Webinar_Password__c;
        
        return vm;
    }

    global static String formatForCalendar(DateTime dt) {
        return dt.formatGmt('yyyyMMdd\'T\'HHmmss\'Z\'');
    }

    global class EventRegistrationRequest {
        public String AttendanceId {get;set;}
        public String EmailClient {get;set;}
    } 
}