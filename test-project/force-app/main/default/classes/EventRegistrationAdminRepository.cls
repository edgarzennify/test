public class EventRegistrationAdminRepository implements EventRegistrationAdmin.IRepository {
    private final Configurations.IConfigurations m_config;
    private final EventRegistrationAdmin.IDataProvider m_dataProvider;
    private final EventRegistrationAdmin.IDmBuilder m_dmBuilder;
    private final Utility.IUtility m_util;
    private final String Attendee_Default_Session ='EU Attendee Default Session';

    private final String EVENT_COLLECTION_ID = 'EventRegistrationApp';
    private final String ATTENDEE_OBJ = 'EB_Event_Attendees__c';
    private final String EB_COURSE = 'EB Course';

    public EventRegistrationAdminRepository(Configurations.IConfigurations config, EventRegistrationAdmin.IDataProvider dataProvider, 
        EventRegistrationAdmin.IDmBuilder dmBuilder, Utility.IUtility util) {
        m_config = config;    
        m_dataProvider = dataProvider;
        m_dmBuilder = dmBuilder;
        m_util = util;
    }

    public List<DmEventClass> getAllClasses() {
        String collectionId = m_config.get(EVENT_COLLECTION_ID);
        List<Eb_Event_Session__c> classes = m_dataProvider.allClasses(collectionId, Date.today());
        return m_dmBuilder.build(classes);
    }
    public DmEventClass getClass(String classId) {
        Eb_Event_Session__c r_classes = m_dataProvider.getClass(classId);
        List<Eb_Event_Session__c> classes = new List<Eb_Event_Session__c>();
        classes.Add(r_classes);
        return m_dmBuilder.build(classes)[0];
    }

    public List<DmEventAttendance> getAttendeesForClass(String classId) {
        List<Event_Attendance__c> attendees = m_dataProvider.allAttendeesForClass(classId);
        return m_dmBuilder.buildAttendance(attendees);
    }

    public DmEventAttendee getAttendee(String attendeeId) {
        EB_Event_Attendees__c attendee = m_dataProvider.attendee(attendeeId);
        return m_dmBuilder.buildAttendee(attendee);
    }

    public void setAttendeeAttendance(List<DmEventAttendance> attendances) {
        List<Event_Attendance__c> pms = new List<Event_Attendance__c>();
        for(DmEventAttendance att: attendances) {
            Event_Attendance__c pm = new Event_Attendance__c(Id = att.Id, Record_Attendance__c = att.Present);
            pms.Add(pm);
        }
        m_dataProvider.save((List<SObject>)pms);
    }

    public String saveAttendee(List<DmEventAttendee> attendees) {
        List<EB_Event_Attendees__c> pms = new List<EB_Event_Attendees__c>();
        RecordType rec = m_util.RecordTypeObject(ATTENDEE_OBJ, EB_COURSE);
        for(DmEventAttendee attendee: attendees) {
            EB_Event_Attendees__c pm = new EB_Event_Attendees__c();
            pm.Id = attendee.Id; 
            pm.Attendee_First_Name__c = attendee.FirstName; 
            pm.Attendee_Last_Name__c = attendee.LastName;
            pm.Email_Address__c= attendee.Email;
            pm.Job_Title__c = attendee.JobTitle;
            pm.Company__c = attendee.Company;
            pm.RecordTypeId = rec.Id;
            pms.Add(pm);
        }
        m_dataProvider.save((List<SObject>)pms);
        return pms[0].Id;
    }

    public void createAttendance(String attendeeId, String classId, Boolean present) {
        List<Event_Attendance__c> pms = new List<Event_Attendance__c>();
        Eb_Event_Attendees__c attendee = m_dataProvider.attendee(attendeeId);
        Eb_Event_Session__c classPm = m_dataProvider.getClass(classId);
        Event_Attendance__c pm = new Event_Attendance__c(Event_Attendee__c = attendee.Id, 
			Event_Session__c = classPm.Id, 
			Record_Attendance__c = present);
        pms.Add(pm);
        
        m_dataProvider.save((List<SObject>)pms);
    }

    public List<DmEventClass> search(String param) {
        String collectionId = m_config.get(EVENT_COLLECTION_ID);
        List<Eb_Event_Session__c> classes = m_dataProvider.search(collectionId, param);
        return m_dmBuilder.build(classes);
    }
}