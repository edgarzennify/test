public class EventRegistrationSmBuilder implements EventRegistration.ISmBuilder {
	
    private final String Attendee_Default_Session ='EU Attendee Default Session';
    private final Configurations.IConfigurations m_configs;

    public EventRegistrationSmBuilder(Configurations.IConfigurations configs) {
        m_configs = configs;
    }
    
    public EventRegistration.AttendeeSm buildAttendee(EventRegistration.FormVm vm) {
        EventRegistration.AttendeeSm sm = new EventRegistration.AttendeeSm();
        sm.attendee = buildAttendeeObj(vm.attendee);

        return sm;
    }

    public EventRegistration.AttendeeSm buildAttendee(EventRegistration.EventAttendeeSm attendeeSm) {
        EventRegistration.AttendeeSm sm = new EventRegistration.AttendeeSm();
        if(attendeeSm != null && String.isNotBlank(attendeeSm.Id)){
            if(String.isBlank(attendeeSm.Email)){
                sm.attendee = new Eb_Event_Attendees__c();
                sm.attendee.id = attendeeSm.Id;
            } else{
                 sm.attendee = buildAttendeeObj(attendeeSm);
            }
        }
        return sm;
    }

    public EventRegistration.AttendeeSm buildAttendee(String lastName, String email, String recordTypeId) {
        EventRegistration.AttendeeSm sm = new EventRegistration.AttendeeSm();
        sm.attendee = new Eb_Event_Attendees__c();
        sm.attendee.Attendee_Last_Name__c = lastName;
        sm.attendee.Email_Address__c = email;
        sm.attendee.Attendee__c = lastName;
        sm.attendee.RecordTypeId = recordTypeId;
        
        return sm;
    } 

    public EventRegistration.AttendanceSm buildAttendances(Eb_Event_Attendees__c savedAttendee, EventRegistration.FormVm vm, List<Event_Attendance__c> attendanceLookup) {
        Map<String, String> lookup = buildAttendanceLookup(attendanceLookup);
        Id attendeeId = savedAttendee.Id;
        List<EventRegistration.EventClassVm> newSelection = vm.classes;
        List<EventRegistration.EventClassVm> oldSelection = getClasses(vm);

        EventRegistration.AttendanceSm sm = new EventRegistration.AttendanceSm();
        sm.saves = new List<Event_Attendance__c>();
        sm.removes = new List<Event_Attendance__c>();
        Set<String> items = new Set<String>();
        for(EventRegistration.EventClassVm evm : newSelection) {
            if(evm.selected){
                items.add(evm.SelectedClass.id);
            }
        }

        for(EventRegistration.EventClassVm evm : oldSelection) {
            if(items.contains(evm.SelectedClass.id) && !evm.selected){
                String key = attendeeId + ',' + evm.SelectedClass.id;
                if(!lookup.containskey(key)) {
                    sm.saves.add(buildAttendance(attendeeId, evm, null));
                }
            }
            if(!items.contains(evm.SelectedClass.id) && evm.selected) {
                if(lookup != null) {
                    
                    String key = attendeeId + ',' + evm.SelectedClass.id;
                    Id attendanceId = (Id)lookup.get(key);
                    sm.removes.add(buildAttendance(attendeeId, evm, attendanceId));
                }
            }
        }

        return sm;
    }

    private Eb_Event_Attendees__c buildAttendeeObj(EventRegistration.EventAttendee attendee) {
    	if(String.isBlank(attendee.Id)) {
            throw new EventRegistration.saveException('Attendee Id missing while saving ');
        }
        Eb_Event_Attendees__c a = new Eb_Event_Attendees__c();
        a.Id = attendee.id;
        a.Attendee__c = a.Attendee_Last_Name__c;
     
    	return a;
    }

    private Eb_Event_Attendees__c buildAttendeeObj(EventRegistration.EventAttendeeSm attendee) {
        if(String.isBlank(attendee.Id)) {
            throw new EventRegistration.saveException('Attendee Id missing while saving ');
        }
        Eb_Event_Attendees__c a = new Eb_Event_Attendees__c();
        a.Id = attendee.id;
        a.Attendee__c = a.Attendee_Last_Name__c;
        a.Attendee_First_Name__c = attendee.FirstName;
        a.Job_Title__c = attendee.JobTitle;
        a.Company__c = attendee.Company;
        a.Company_Address_Street__c = attendee.Street;
        a.Company_Address_City__c = attendee.City;
        a.Company_Address_State__c = attendee.State;
        a.Company_Address_Zip__c = attendee.Zip;
        a.Industry__c = attendee.Industry;
        a.Heard_From__c = attendee.HowDidYouHear;
        a.Phone__c = attendee.Phone;
        a.Heard_From_EBT_Employee__c = attendee.EbtEmployeeName;
        a.Signup_For_Announcement__c = attendee.SignupForAnnouncement == null ? false : attendee.SignupForAnnouncement;
        a.Permission_To_Contact__c = attendee.PermissionToContact == null ? false : attendee.PermissionToContact;
        a.Year_in_School__c = attendee.Year;
        a.Area_of_Study__c = attendee.Degree;
        a.College_Attended__c = attendee.College;
        
        return a;
    }

    private Event_Attendance__c buildAttendance(String attendeeId, EventRegistration.EventClassVm vm, Id attendanceId) {
        Event_Attendance__c obj = new Event_Attendance__c();
        obj.Id = attendanceId;
        obj.Event_Attendee__c = attendeeId;
        obj.Event_Session__c = vm.SelectedClass.Id;

        return obj;
    }

    private List<EventRegistration.EventClassVm> getClasses(EventRegistration.FormVm vm) {
        Map<Id, EventRegistration.EventClassVm> classes = new Map<Id, EventRegistration.EventClassVm>();

        for(EventRegistration.EventClassByCategoryVm cg : vm.ClassesGroupedByCategory) {
            for(EventRegistration.EventClassVm cls : cg.classes) {
                classes.put(cls.SelectedClass.id, cls);
            }
        }

        return classes.values();
    }

    private Map<String, String> buildAttendanceLookup(List<Event_Attendance__c> attendances) {
        Map<String, String> lookup = new Map<String, String>();
        for(Event_Attendance__c atn : attendances) {
            if(String.isNotBlank(atn.Event_Attendee__c) && String.isNotBlank(atn.Event_Session__c)){
                String key = atn.Event_Attendee__c + ',' +  atn.Event_Session__c;
                lookup.put(key, atn.Id);
            }
        }
        return lookup;
    }
}