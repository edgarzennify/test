public class EventAttendeeCalculator implements ICalculator{
    public interface ICalculator {
        Eb_Event_Session__c updateNumberOfAttendees(Eb_Event_Session__c session, List<Eb_Event_Attendees__c> attendees);
    }
    
    public Eb_Event_Session__c updateNumberOfAttendees(Eb_Event_Session__c session, List<Eb_Event_Attendees__c> attendees) {
    	if(session != null) {
			if(session.Number_of_Attendee_From_Trigger__c == null) {
				session.Number_of_Attendee_From_Trigger__c = 0;
			}
			session.Number_of_Attendee_From_Trigger__c = attendees == null?0: attendees.size();
    	}

    	return session;
    }
}