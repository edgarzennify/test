public class EventRegistrationEmailDataProvider implements EventRegistrationEmail.IDataProvider{
    
    public List<Event_Attendance__c> getAttendancesByAttendee(Id attendeeId) {
        return [

            SELECT
                Event_Attendee__r.Attendee__c
                ,Event_Attendee__r.Attendee_First_Name__c
                ,Event_Attendee__r.Attendee_Last_Name__c
                ,Event_Attendee__r.Attendee_Reason__c
                ,Event_Attendee__r.Company__c
                ,Event_Attendee__r.Company_Address_Street__c
                ,Event_Attendee__r.Company_Address_City__c
                ,Event_Attendee__r.Company_Address_State__c
                ,Event_Attendee__r.Company_Address_Zip__c
                ,Event_Attendee__r.Email_Address__c
                ,Event_Attendee__r.Heard_From__c
                ,Event_Attendee__r.Heard_From_EBT_Employee__c
                ,Event_Attendee__r.Industry__c
                ,Event_Attendee__r.Phone__c
                ,Event_Attendee__r.RecordTypeId
                ,Event_Attendee__r.RecordType.Name
                ,Event_Session__r.Name
                ,Event_Session__r.Address__c
                ,Event_Session__r.Capacity__c
                ,Event_Session__r.Description__c
                ,Event_Session__r.Date_Time_of_Event__c
                ,Event_Session__r.End_Date_Time_of_Event__c
                ,Event_Session__r.Region__c
                ,Event_Session__r.Location__c
                ,Event_Session__r.Number_of_Attendee_From_Trigger__c
                ,Event_Session__r.Seats_Available__c
                ,Event_Session__r.Instructor__c
                ,Event_Session__r.Instructor_1__r.Id
                ,Event_Session__r.Instructor_1__r.Name
                ,Event_Session__r.Instructor_1__r.Detail__c
                ,Event_Session__r.Instructor_1__r.Picture_Link__c
                ,Event_Session__r.Instructor_1__r.Resume_Link__c
                ,Event_Session__r.Instructor_1__r.Institution_From__c
                ,Event_Session__r.Instructor_2__r.Id
                ,Event_Session__r.Instructor_2__r.Name
                ,Event_Session__r.Instructor_2__r.Detail__c
                ,Event_Session__r.Instructor_2__r.Picture_Link__c
                ,Event_Session__r.Instructor_2__r.Resume_Link__c
                ,Event_Session__r.Instructor_2__r.Institution_From__c
                ,Event_Session__r.Instructor_3__r.Id
                ,Event_Session__r.Instructor_3__r.Name
                ,Event_Session__r.Instructor_3__r.Detail__c
                ,Event_Session__r.Instructor_3__r.Picture_Link__c
                ,Event_Session__r.Instructor_3__r.Resume_Link__c
                ,Event_Session__r.Instructor_3__r.Institution_From__c
                ,Event_Session__r.Event_Collection__r.Id
                ,Event_Session__r.Event_Collection__r.Name
                ,Event_Session__r.Event_Name__c
                ,Event_Session__r.Category__c
    
            FROM
                Event_Attendance__c
            WHERE       
                Event_Attendee__r.Id =: attendeeId
            ORDER BY
                Event_Session__r.Date_Time_of_Event__c
                ,Event_Session__r.Name
        ];
    }
    
    public EmailTemplate getTemplate(Id templateId) {
        return
        [
            SELECT Id
                   ,Name
                   ,Subject
                   ,Body
                   ,HTMLValue
            FROM 
                EmailTemplate 
            WHERE 
                Id =: templateId
            LIMIT 1
        ];
    }

    public List<Event_Attendance__c> getAttendancesByCreatedDate(DateTime dt, Id eventCollectionId) {
        return [
            SELECT
                Id
                ,Name
                ,Event_Attendee__r.Id
                ,Event_Attendee__r.Email_Address__c
            FROM
                Event_Attendance__c
            WHERE
                CreatedDate >: dt
                AND Event_Session__r.EB_Event__r.Event_Collection__r.Id =: eventCollectionId
        ];
    }

    public Event_Attendance__c getAttendance(Id attendanceId) {
        return [
            SELECT
                Id
                ,Event_Attendee__r.Id
                ,Event_Attendee__r.Name
                ,Event_Session__r.Name
                ,Event_Session__r.Address__c
                ,Event_Session__r.Date_Time_of_Event__c
                ,Event_Session__r.End_Date_Time_of_Event__c
                ,Event_Session__r.Event_Name__c
                ,Event_Session__r.Webinar_Link__c
            	,Event_Session__r.Webinar_Password__c
            FROM
                Event_Attendance__c
            WHERE
                Id =:attendanceId
            LIMIT 1
        ];
    }
}