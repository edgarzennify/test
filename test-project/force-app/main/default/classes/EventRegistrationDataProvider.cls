public class EventRegistrationDataProvider extends DataProvider implements EventRegistration.IDataProvider {

    public List<Eb_Event_Attendees__c> getAttendee(String lastName, String email) {

        return [
            SELECT
                Id
                ,Attendee_First_Name__c
                ,Attendee_Last_Name__c
                ,Job_Title__c
                ,Attendee_Reason__c
                ,Company__c
                ,Company_Address_Street__c
                ,Company_Address_City__c
                ,Company_Address_State__c
                ,Company_Address_Zip__c
                ,Email_Address__c
                ,Heard_From__c
                ,Heard_From_EBT_Employee__c
                ,Industry__c
                ,Phone__c
                ,Signup_For_Announcement__c
        		,Permission_To_Contact__c
                ,RecordTypeId
                ,RecordType.Name
            FROM
                Eb_Event_Attendees__c
            WHERE
                Attendee_Last_Name__c =: lastName
                AND Email_Address__c =:email
            LIMIT 1
        ];
    }

    public Eb_Event_Attendees__c getAttendee(String attendeeId) {

        return [
            SELECT
                Id
                ,Attendee_First_Name__c
                ,Attendee_Last_Name__c
                ,Job_Title__c
                ,Attendee_Reason__c
                ,Company__c
                ,Company_Address_Street__c
                ,Company_Address_City__c
                ,Company_Address_State__c
                ,Company_Address_Zip__c
                ,Email_Address__c
                ,Heard_From__c
                ,Heard_From_EBT_Employee__c
                ,Industry__c
                ,Phone__c
                ,Signup_For_Announcement__c
            	,Permission_To_Contact__c
                ,RecordTypeId
                ,RecordType.Name
            FROM
                Eb_Event_Attendees__c
            WHERE
                Id =: attendeeId
            LIMIT 1
        ];
    }

    public List<Event_Attendance__c> getEventAttendee(Id eventCollectionId, String lastName, String attendeeEmail) {
        
        return [

            SELECT
                Event_Attendee__r.Attendee__c
                ,Event_Attendee__r.Attendee_First_Name__c
                ,Event_Attendee__r.Attendee_Last_Name__c
                ,Event_Attendee__r.Job_Title__c
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
                ,Event_Attendee__r.Signup_For_Announcement__c
            	,Event_Attendee__r.Permission_To_Contact__c
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
                ,Event_Session__r.Number_of_Attendees_By_Attendance__c
                ,Event_Session__r.Seats_Available__c
                ,Event_Session__r.Seats_Available_By_Attendance__c
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
            	,Event_Session__r.Survey_Link__c
            	,Event_Session__r.Time_Zone__c
            	,Event_Session__r.Webinar_Link__c
            	,Event_Session__r.Webinar_Password__c
    
            FROM
                Event_Attendance__c
            WHERE       
                Event_Session__r.Event_Collection__r.Id =: eventCollectionId
                AND Event_Attendee__r.Email_Address__c =: attendeeEmail
                AND Event_Attendee__r.Attendee_Last_Name__c =: lastName
            ORDER BY
                Event_Session__r.Date_Time_of_Event__c
                ,Event_Session__r.Name
        ];
    }

    public List<Event_Attendance__c> getEventAttendee(Id eventCollectionId, String attendeeId) {
        
        return [

            SELECT
                Event_Attendee__r.Attendee__c
                ,Event_Attendee__r.Attendee_First_Name__c
                ,Event_Attendee__r.Attendee_Last_Name__c
                ,Event_Attendee__r.Job_Title__c
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
                ,Event_Attendee__r.Signup_For_Announcement__c
            	,Event_Attendee__r.Permission_To_Contact__c
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
                ,Event_Session__r.Number_of_Attendees_By_Attendance__c
                ,Event_Session__r.Seats_Available__c
                ,Event_Session__r.Seats_Available_By_Attendance__c
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
            	,Event_Session__r.Survey_Link__c
            	,Event_Session__r.Time_Zone__c
            	,Event_Session__r.Webinar_Link__c
            	,Event_Session__r.Webinar_Password__c
    
            FROM
                Event_Attendance__c
            WHERE       
            	Event_Session__r.Event_Collection__r.Id =: eventCollectionId
                AND Event_Attendee__r.Id =:attendeeId
            ORDER BY
                Event_Session__r.Date_Time_of_Event__c
                ,Event_Session__r.Name
        ];
    }

    public List<EB_Event_Session__c> getSessionsByEventId(Id eventCollectionId) {

        return [

            SELECT
                Id
                ,Name
                ,Address__c
                ,Capacity__c
                ,Date_Time_of_Event__c
                ,Description__c
                ,Instructor_1__r.Id
                ,Instructor_1__r.Name
                ,Instructor_1__r.Detail__c
                ,Instructor_1__r.Picture_Link__c
                ,Instructor_1__r.Resume_Link__c
                ,Instructor_1__r.Institution_From__c
                ,Instructor_2__r.Id
                ,Instructor_2__r.Name
                ,Instructor_2__r.Detail__c
                ,Instructor_2__r.Picture_Link__c
                ,Instructor_2__r.Resume_Link__c
                ,Instructor_2__r.Institution_From__c
                ,Instructor_3__r.Id
                ,Instructor_3__r.Name
                ,Instructor_3__r.Detail__c
                ,Instructor_3__r.Picture_Link__c
                ,Instructor_3__r.Resume_Link__c
                ,Instructor_3__r.Institution_From__c
                ,End_Date_Time_of_Event__c
                ,Location__c
                ,Number_of_Attendee_From_Trigger__c
                ,Number_of_Attendees_By_Attendance__c
                ,Number_Of_Attendees_Plus_One__c
                ,Meeting_Information_Sent__c
                ,Seats_Available__c
                ,Seats_Available_By_Attendance__c
                ,Instructor__c
                ,Region__c
                ,Event_Name__c
                ,Category__c
            	,Survey_Link__c
            	,Time_Zone__c
            	,Webinar_Link__c
            	,Webinar_Password__c
            FROM
                EB_Event_Session__c
            WHERE
                Event_Collection__r.Id =: eventCollectionId
            ORDER BY
                Date_Time_of_Event__c
                ,Event_Name__c
        ];
    }

    public Event_Instructor__c getInstructor(Id instructorId) {

        return [
            SELECT
                Id
                ,Name
                ,Detail__c
                ,Picture_Link__c
                ,Resume_Link__c
                ,Institution_From__c
            FROM
                Event_Instructor__c
            WHERE
                Id =: instructorId
            LIMIT 1
        ];
    }

    public Map<String, String> getEbtLocations() {
        List<EU_Location__mdt> locations = [
            SELECT 
                Label
                ,Location_Code__c
            FROM
                EU_Location__mdt
        ];

        return buildLocationLookup(locations);
    }

    public Map<Id, Eb_Event_Session__c> getSessionsFromEbtEmployeeAttendees(List<Eb_Event_Attendees__c> attendees) {
        Set<Id> relatedSessionIds = new Set<Id>();
        for(Eb_Event_Attendees__c attendee : attendees) {
            if(String.isNotBlank(attendee.EB_Event_Course__c)) {
                relatedSessionIds.add(attendee.EB_Event_Course__c);
            }
        }

        return 
            new Map<Id, Eb_Event_Session__c> ([
                Select 
                    Id
                    ,Name
                    ,Number_of_Attendee_From_Trigger__c
                    ,(
                        SELECT 
                            Id
                            ,Name 
                        FROM 
                            EB_Event_Attendees__r
                    )  
                    FROM 
                        Eb_Event_Session__c 
                    WHERE 
                        Id in:relatedSessionIds
            
        ]);
    }

    private Map<String, String> buildLocationLookup(List<EU_Location__mdt> locations) {
        if(locations == null || locations.size() == 0) return null;
        
        Map<String, String> locationMapping = new Map<String, String>();

        for(EU_Location__mdt l : locations) {
            String key = l.location_code__c.toLowerCase();
            locationMapping.put(key, l.label);
        }

        return locationMapping;
    }
}