public class EventAttendeeTriggerHandler extends TriggerHandler {

	private final String EB_COURSE = 'EB Course';

	private final EventRegistration.IDataProvider m_dataProvider;
    private final EventAttendeeCalculator.ICalculator m_calculator;
    
    public EventAttendeeTriggerHandler() {
    	m_dataProvider = new EventRegistrationDataProvider();
    	m_calculator = new EventAttendeeCalculator();
    }

    public EventAttendeeTriggerHandler(EventRegistration.IDataProvider dataProvider, EventAttendeeCalculator.ICalculator calculator) {
        m_dataProvider = dataProvider;
        m_calculator = calculator;
    }

    public override void bulkafterInsert(List<SObject> sos){
    	m_dataProvider.save(getUpdatedSessions(sos));
    }

    public override void bulkAfterUpdate(List<SObject> oldSos, Map<Id, SObject> newSosMap){
    	m_dataProvider.save(getUpdatedSessions(newSosMap.values()));
    	m_dataProvider.save(getUpdatedSessions(oldSos));
    }

    public override void bulkAfterDelete(List<SObject> sos){
    	m_dataProvider.save(getUpdatedSessions(sos));
    }

    private List<Eb_Event_Session__c> getUpdatedSessions(List<Eb_Event_Attendees__c> sos) {
    	List<Eb_Event_Session__c> sessionForUpdates = new List<Eb_Event_Session__c>();
 
    	Map<Id, Eb_Event_Session__c> sessions = m_dataProvider.getSessionsFromEbtEmployeeAttendees(sos);

    	for(Eb_Event_Attendees__c attendee: (List<Eb_Event_Attendees__c>) sos) {
    		if(attendee.EB_Event_Course__c != null) {
    			Eb_Event_Session__c session = sessions.get(attendee.EB_Event_Course__c);
    			if(session != null) {
    				sessionForUpdates.add(m_calculator.updateNumberOfAttendees(session, session.EB_Event_Attendees__r));
    			}
    		}
    	}
    	return sessionForUpdates;
    }

}