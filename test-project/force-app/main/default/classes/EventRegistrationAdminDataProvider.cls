public class EventRegistrationAdminDataProvider extends DataProvider implements EventRegistrationAdmin.IDataProvider {
	
	public List<Eb_Event_Session__c> allClasses(String collectionId, Date now) {
		List<Eb_Event_Session__c> classes = [
					SELECT
						Id
						,Capacity__c
						,Date_Time_of_Event__c
						,Instructor_1__r.Name
						,Instructor_2__r.Name
						,Instructor_3__r.Name
						,End_Date_Time_of_Event__c
						,Number_of_Attendees_By_Attendance__c
						,Region__c
						,Event_Name__c
					FROM
						Eb_Event_Session__c
					WHERE
						Event_Collection__r.Id =: collectionId
						AND Date_Time_of_Event__c >=: now
					ORDER BY
						Date_Time_of_Event__c
				];
		return classes;
	}
	
	public Eb_Event_Session__c getClass(String sessionId) {
		List<Eb_Event_Session__c> classes = [
					SELECT
						Id
						,Capacity__c
						,Date_Time_of_Event__c
						,Instructor_1__r.Name
						,Instructor_2__r.Name
						,Instructor_3__r.Name
						,End_Date_Time_of_Event__c
						,Number_of_Attendees_By_Attendance__c
						,Region__c
						,Event_Name__c
					FROM
						Eb_Event_Session__c
					WHERE
						Id =: sessionId
				];
		return classes[0];
	}
	
	public List<Event_Attendance__c> allAttendeesForClass(String sessionId) {
		return [

			SELECT
				Id
				,Event_Attendee__r.Attendee_First_Name__c
				,Event_Attendee__r.Attendee_Last_Name__c
				,Event_Attendee__r.Email_Address__c
				,Event_Attendee__r.EntityId__c
                ,Event_Attendee__r.Job_Title__c
            	,Event_Attendee__r.Company__c
				,Event_Attendee__r.LeadId__c
				,Event_Attendee__r.EntityId__r.Name
				,Event_Attendee__r.LeadId__r.Name
				,Event_Attendee__r.Related_To__c
				,Event_Attendee__r.Primary_RM__c
				,Event_Attendee__r.EntityId__r.Owner.Id
				,Event_Attendee__r.EntityId__r.Owner.Name
				,Event_Attendee__r.LeadId__r.Owner.Id
				,Event_Attendee__r.LeadId__r.Owner.Name
				,Record_Attendance__c
			FROM
				Event_Attendance__c
			WHERE		
				Event_Session__r.Id =: sessionId
		];
	}
	
	public Eb_Event_Attendees__c attendee(String attendeeId) {
		return [
			SELECT
				Id
				,Attendee_Last_Name__c
				,Attendee_First_Name__c
				,Email_Address__c
				,Related_To__c
            	,Job_Title__c
            	,Company__c
				,EntityId__c
				,EntityId__r.Name
				,LeadId__r.Name
				,LeadId__c
				,Primary_RM__c
				,EntityId__r.Owner.Id
				,EntityId__r.Owner.Name
				,LeadId__r.Owner.Id
				,LeadId__r.Owner.Name
			FROM
				Eb_Event_Attendees__c
			WHERE
				Id =: attendeeId
		];
	}

	public List<Eb_Event_Session__c> search(String collectionId, String param) {
		String paramSearch = '%'+param+'%';
		List<Eb_Event_Session__c> classes = [
					SELECT
					    Id
						,Capacity__c
						,Date_Time_of_Event__c
						,Instructor_1__r.Name
						,Instructor_2__r.Name
						,Instructor_3__r.Name
						,End_Date_Time_of_Event__c
						,Number_of_Attendees_By_Attendance__c
						,Region__c
						,Event_Name__c
					FROM
						Eb_Event_Session__c
					WHERE
						Event_Collection__r.Id =: collectionId
						AND Event_Name__c LIKE :paramSearch
					LIMIT 100
				];
		return classes;
	}
	
	
}