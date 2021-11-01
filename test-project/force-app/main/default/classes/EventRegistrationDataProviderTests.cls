@IsTest
private class EventRegistrationDataProviderTests {
    
    private static final EventRegistrationDataProvider sut;
    
    static {
        sut = new EventRegistrationDataProvider();
    }

    private static testMethod void it_should_validate_soql_call_for_fields_when_get_attendee_is_called() {
        string lastName = 'last-name';
        string email = 'email';
        EB_Event_Session__c session = new EB_Event_Session__c();
        insert session;
        Eb_Event_Attendees__c attendee = new Eb_Event_Attendees__c();
        attendee.Attendee__c = 'first-name' + lastName;
        attendee.Attendee_Last_Name__c = lastName;
        attendee.Email_Address__c = email;
        attendee.EB_Event_Course__c = session.id;
        insert attendee;

        List<Eb_Event_Attendees__c> result = sut.getAttendee(lastName, email);
        
        Object fieldObject;
        fieldObject = result[0].Id;
        fieldObject = result[0].Attendee_First_Name__c;
        fieldObject = result[0].Attendee_Last_Name__c;
        fieldObject = result[0].Attendee_Reason__c;
        fieldObject = result[0].Company__c;
        fieldObject = result[0].Company_Address_Street__c;
        fieldObject = result[0].Company_Address_City__c;
        fieldObject = result[0].Company_Address_State__c;
        fieldObject = result[0].Company_Address_Zip__c;
        fieldObject = result[0].Email_Address__c;
        fieldObject = result[0].Heard_From__c;
        fieldObject = result[0].Industry__c;
        fieldObject = result[0].Phone__c;
        fieldObject = result[0].RecordTypeId;
        fieldObject = result[0].RecordType.Name;
    }

    private static testMethod void it_should_test_if_the_fields_are_in_soql_when_get_attendance_is_called() {
        
        string lastName = 'last-name';
        string email = 'email';
        Event_Collection__c col = new Event_Collection__c();
        insert col;
        EB_Event_Session__c session = new EB_Event_Session__c();
        session.Event_Collection__c = col.id;
        insert session;
        EB_Event_Attendees__c ate = new EB_Event_Attendees__c();
        ate.Attendee_Last_Name__c = lastName;
        ate.Email_Address__c = email;
        ate.Attendee__c = 'first-name' + lastName;
        ate.RecordTypeId = Utility.RecordTypeObject('EB_Event_Attendees__c', 'EB Course').Id;
        insert ate;
        Event_Attendance__c attendance = new Event_Attendance__c();
        attendance.Event_Attendee__c = ate.Id;
        attendance.Event_Session__c = session.Id;
        insert attendance;
        
        List<Event_Attendance__c> result = sut.getEventAttendee(col.id, lastName, email);
        
        Object fieldObject;
        System.assertEquals(1, result.size());
        fieldObject = result[0].Event_Attendee__r.Attendee__c;
        fieldObject = result[0].Event_Attendee__r.Attendee_First_Name__c;
        fieldObject = result[0].Event_Attendee__r.Attendee_Last_Name__c;
        fieldObject = result[0].Event_Attendee__r.Attendee_Reason__c;
        fieldObject = result[0].Event_Attendee__r.Company__c;
        fieldObject = result[0].Event_Attendee__r.Company_Address_Street__c;
        fieldObject = result[0].Event_Attendee__r.Company_Address_City__c;
        fieldObject = result[0].Event_Attendee__r.Company_Address_State__c;
        fieldObject = result[0].Event_Attendee__r.Company_Address_Zip__c;
        fieldObject = result[0].Event_Attendee__r.Email_Address__c;
        fieldObject = result[0].Event_Attendee__r.Heard_From__c;
        fieldObject = result[0].Event_Attendee__r.Industry__c;
        fieldObject = result[0].Event_Attendee__r.Phone__c;
        fieldObject = result[0].Event_Attendee__r.RecordTypeId;
        fieldObject = result[0].Event_Attendee__r.RecordType.Name;
        fieldObject = result[0].Event_Session__r.Name;
        fieldObject = result[0].Event_Session__r.Address__c;
        fieldObject = result[0].Event_Session__r.Capacity__c;
        fieldObject = result[0].Event_Session__r.Description__c;
        fieldObject = result[0].Event_Session__r.Date_Time_of_Event__c;
        fieldObject = result[0].Event_Session__r.End_Date_Time_of_Event__c;
        fieldObject = result[0].Event_Session__r.Region__c;
        fieldObject = result[0].Event_Session__r.Location__c;
        fieldObject = result[0].Event_Session__r.Number_of_Attendee_From_Trigger__c;
        fieldObject = result[0].Event_Session__r.Seats_Available__c;
        fieldObject = result[0].Event_Session__r.Instructor__c;
        fieldObject = result[0].Event_Session__r.Instructor_1__r.Id;
        fieldObject = result[0].Event_Session__r.Instructor_1__r.Name;
        fieldObject = result[0].Event_Session__r.Instructor_1__r.Detail__c;
        fieldObject = result[0].Event_Session__r.Instructor_1__r.Picture_Link__c;
        fieldObject = result[0].Event_Session__r.Instructor_1__r.Resume_Link__c;
        fieldObject = result[0].Event_Session__r.Instructor_1__r.Institution_From__c;
        fieldObject = result[0].Event_Session__r.Instructor_2__r.Id;
        fieldObject = result[0].Event_Session__r.Instructor_2__r.Name;
        fieldObject = result[0].Event_Session__r.Instructor_2__r.Detail__c;
        fieldObject = result[0].Event_Session__r.Instructor_2__r.Picture_Link__c;
        fieldObject = result[0].Event_Session__r.Instructor_2__r.Resume_Link__c;
        fieldObject = result[0].Event_Session__r.Instructor_2__r.Institution_From__c;
        fieldObject = result[0].Event_Session__r.Instructor_3__r.Id;
        fieldObject = result[0].Event_Session__r.Instructor_3__r.Name;
        fieldObject = result[0].Event_Session__r.Instructor_3__r.Detail__c;
        fieldObject = result[0].Event_Session__r.Instructor_3__r.Picture_Link__c;
        fieldObject = result[0].Event_Session__r.Instructor_3__r.Resume_Link__c;
        fieldObject = result[0].Event_Session__r.Instructor_3__r.Institution_From__c;
        fieldObject = result[0].Event_Session__r.Event_Collection__r.Id;
        fieldObject = result[0].Event_Session__r.Event_Collection__r.Name;
        fieldObject = result[0].Event_Session__r.Event_Name__c;
        fieldObject = result[0].Event_Session__r.Category__c;
    }

    private static testMethod void it_should_validate_all_the_fields_insoql_when_session_by_id_is_called() {

        Event_Collection__c collection = new Event_Collection__c();
        insert collection;

        EB_Event_Session__c session = new EB_Event_Session__c();
        session.Event_Collection__c = collection.id;
        insert session;

        List<EB_Event_Session__c> result = sut.getSessionsByEventId(collection.Id);
        
        Object fieldObject;
        fieldObject = result[0].Id;
        fieldObject = result[0].Name;
        fieldObject = result[0].Address__c;
        fieldObject = result[0].Capacity__c;
        fieldObject = result[0].Date_Time_of_Event__c;
        fieldObject = result[0].Description__c;
        fieldObject = result[0].Instructor_1__r.Id;
        fieldObject = result[0].Instructor_1__r.Name;
        fieldObject = result[0].Instructor_1__r.Detail__c;
        fieldObject = result[0].Instructor_1__r.Picture_Link__c;
        fieldObject = result[0].Instructor_1__r.Resume_Link__c;
        fieldObject = result[0].Instructor_1__r.Institution_From__c;
        fieldObject = result[0].Instructor_2__r.Id;
        fieldObject = result[0].Instructor_2__r.Name;
        fieldObject = result[0].Instructor_2__r.Detail__c;
        fieldObject = result[0].Instructor_2__r.Picture_Link__c;
        fieldObject = result[0].Instructor_2__r.Resume_Link__c;
        fieldObject = result[0].Instructor_2__r.Institution_From__c;
        fieldObject = result[0].Instructor_3__r.Id;
        fieldObject = result[0].Instructor_3__r.Name;
        fieldObject = result[0].Instructor_3__r.Detail__c;
        fieldObject = result[0].Instructor_3__r.Picture_Link__c;
        fieldObject = result[0].Instructor_3__r.Resume_Link__c;
        fieldObject = result[0].Instructor_3__r.Institution_From__c;
        fieldObject = result[0].End_Date_Time_of_Event__c;
        fieldObject = result[0].Location__c;
        fieldObject = result[0].Number_of_Attendee_From_Trigger__c;
        fieldObject = result[0].Number_Of_Attendees_Plus_One__c;
        fieldObject = result[0].Meeting_Information_Sent__c;
        fieldObject = result[0].Seats_Available__c;
        fieldObject = result[0].Instructor__c;
        fieldObject = result[0].Region__c;
        fieldObject = result[0].Event_Name__c;
        fieldObject = result[0].Category__c;
    }

    private static testMethod void it_should_validate_all_the_fields_when_get_instructor_is_called() {
        Event_Instructor__c ins = new Event_Instructor__c();
        insert ins;

        Event_Instructor__c result = sut.getInstructor(ins.Id);
        
        Object fieldObject;
        fieldObject = result.Id;
        fieldObject = result.Name;
        fieldObject = result.Detail__c;
        fieldObject = result.Picture_Link__c;
        fieldObject = result.Resume_Link__c;
        fieldObject = result.Institution_From__c;
    }

    private static testMethod void it_should_call_the_location_configs_code_coverage() {

        Map<String, String> result = sut.getEbtLocations();
    }
}