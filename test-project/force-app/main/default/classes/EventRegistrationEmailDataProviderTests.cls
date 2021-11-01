@IsTest
private class EventRegistrationEmailDataProviderTests {
    
    private static final EventRegistrationEmailDataProvider sut;

    static {
        sut = new EventRegistrationEmailDataProvider();
    }

    private static testMethod void it_should_call_the_getAttendancesByAttendee() {
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
        Event_Attendance__c attn = new Event_Attendance__c();
        attn.Event_Attendee__c = attendee.Id;
        attn.Event_Session__c = session.Id;
        insert attn;

        List<Event_Attendance__c> result = sut.getAttendancesByAttendee(attendee.Id);

        Object fieldObject;
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

    private static testMethod void it_should_call_the_get_template_method() {

        EmailTemplate validEmailTemplate = new EmailTemplate();
        validEmailTemplate.isActive = true;
        validEmailTemplate.Name = 'name';
        validEmailTemplate.DeveloperName = 'unique_name_addSomethingSpecialHereebt';
        validEmailTemplate.TemplateType = 'text';
        validEmailTemplate.FolderId = UserInfo.getUserId();

        insert validEmailTemplate;

        EmailTemplate result = sut.getTemplate(validEmailTemplate.Id);

        Object fieldObject;
        fieldObject = result.Id;
        fieldObject = result.Name;
        fieldObject = result.Subject;
        fieldObject = result.Body;
        fieldObject = result.HTMLValue;
    }

    private static testMethod void it_should_get_attendance() {
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
        Event_Attendance__c attn = new Event_Attendance__c();
        attn.Event_Attendee__c = attendee.Id;
        attn.Event_Session__c = session.Id;
        insert attn;

        Event_Attendance__c result =  sut.getAttendance(attn.Id);

        Object fieldObject;
        fieldObject = result.Id;
        fieldObject = result.Event_Attendee__r.Id;
        fieldObject = result.Event_Attendee__r.Name;
        fieldObject = result.Event_Session__r.Name;
        fieldObject = result.Event_Session__r.Address__c;
        fieldObject = result.Event_Session__r.Date_Time_of_Event__c;
        fieldObject = result.Event_Session__r.End_Date_Time_of_Event__c;
        fieldObject = result.Event_Session__r.Event_Name__c;
        fieldObject = result.Event_Session__r.Webinar_Link__c;
    }
}