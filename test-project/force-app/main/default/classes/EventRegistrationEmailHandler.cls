public class EventRegistrationEmailHandler implements EventRegistrationEmail.IEmailHandler {
    
    private final String CLASSES_TAG = '{{classes}}';
    private final String FIRST_NAME_TAG = '{{firstname}}';
    private final String DELIM = '+';

    private final EventRegistrationEmail.IDataProvider m_dataProvider;
    private final ISystem m_sysTime;
    private final Configurations.IConfigurations m_configs;
    
    public EventRegistrationEmailHandler(EventRegistrationEmail.IDataProvider dataProvider, ISystem sysTime, Configurations.IConfigurations configs) {
        m_dataProvider = dataProvider;
        m_sysTime = sysTime;
        m_configs = configs;
    }
    public void handle(Id attendeeId, Id templateId) {
        List<Event_Attendance__c> attendances = m_dataProvider.getAttendancesByAttendee(attendeeId);
        sendEmail(attendances, templateId);
    }

    public List<Id> getAttendeesWithNewRegistration(Id eventCollectionId, Integer timeInMinutesWhenLastRegistered) {
        DateTime now = m_sysTime.now();
        DateTime dtRun = getDateTimeDiff(now, timeInMinutesWhenLastRegistered);
        List<Event_Attendance__c> attendances = m_dataProvider.getAttendancesByCreatedDate(dtRun, eventCollectionId);
        
        return getAttendeeIds(attendances);
    }

    private DateTime getDateTimeDiff(DateTime dt, Integer timeInMinutes) {
        DateTime runDt = dt.addMinutes(-timeInMinutes);
        return runDt;
    }
    
    private void sendEmail(List<Event_Attendance__c> attendances, Id templateId) {      
        string replaceHtml = formatClasses(attendances); 
        EmailTemplate template = m_dataProvider.getTemplate(templateId);

        String emailBody = template.HTMLValue;
        emailBody = emailBody.replace(CLASSES_TAG,replaceHtml);

        String firstName = attendances[0].Event_Attendee__r.Attendee_First_Name__c;
        emailBody = emailBody.replace(FIRST_NAME_TAG, firstName);
        
        String emailAddress = attendances[0].Event_Attendee__r.Email_Address__c;
        List<string> addresses = new List<string>{emailAddress};
        
        Messaging.SingleEmailMessage email = buildEmail(template.subject, addresses, emailBody);

        if(m_configs.get('EU Send Registration Confirmation Email') == 'true'){
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        }
    }
    
    private string formatClasses(List<Event_Attendance__c> attendances) {
        String baseUrl = m_configs.get('EU Add To Calendar Handler');
        String outlookCalenderUrl = baseUrl + '?outlook' + DELIM;
        String gmailCalenderUrl = baseUrl + '?gmail' + DELIM;
        string html = '<p>';
        html += '<table>';
        
        for(Event_Attendance__c a : attendances) {
            html += '<tr>';
            html += '<td>';
            html += formatDate(a.Event_Session__r.Date_Time_of_Event__c);
            html += '</td><td>';
            //html += a.Event_Session__r.EB_Event__r.Name.substring(0,20);
            html += a.Event_Session__r.Event_Name__c;
            html += '</td><td>';
            html += '(' + formatTime(a.Event_Session__r.Date_Time_of_Event__c) + '-' + formatTime(a.Event_Session__r.End_Date_Time_of_Event__c) + ')';
            html += '</td><td>';
            html += a.Event_Session__r.Address__c;
            html += '</td><td>';
            html += '<a href=\"' + outlookCalenderUrl + a.Id +'\" title=\"Add to Outlook Calendar\"><img src=\"http://wvw.enterprisebank.com/l/141901/2017-08-22/4d3jgx/141901/74569/Outlook_Icon.png\" alt=\"Add to Outlook Calendar\" height=\"20\" /></a>';
            html += '</td><td>';
            html += '<a href=\"' + gmailCalenderUrl + a.Id +'\" title=\"Add to Gmail Calendar\" ><img src=\"http://wvw.enterprisebank.com/l/141901/2017-08-22/4d3jgv/141901/74567/gmail_icon.png\" alt=\"Add to Gmail Calendar\" height=\"20\" /></a>';
            html += '</td>';
            html += '</tr>';
        }
        
        html += '</table>';
        html +='</p>';
        
        return html;
    }

    private Messaging.SingleEmailMessage buildEmail(String subject, List<String> addresses, String body) {      
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'no-reply@enterprisebank.com'];
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setSubject( subject );
        email.setToAddresses( addresses );
        email.setHTMLBody( body );
        if ( owea.size() > 0 ) {
            email.setOrgWideEmailAddressId(owea.get(0).Id);
        }

        return email;
    }

    List<Id> getAttendeeIds(List<Event_Attendance__c> attendances) {
        Set<Id> removeDuplicateIds = new Set<Id>();
        for(Event_Attendance__c a : attendances) {
            List<string> checkEmail = a.Event_Attendee__r.Email_Address__c.split('@');
            if(checkEmail.size() == 2) {
                removeDuplicateIds.add(a.Event_Attendee__r.Id);
            }
        }

        List<Id> ids = new List<Id>();
        ids.addAll(removeDuplicateIds);
        return ids;
    }
    
    private string formatDate(DateTime dt) {
        if(dt == null) return '';
        string dtString = '';
        string mo = string.valueof(dt.month());
        string day = string.valueof(dt.day());
        return dt == null ? '' : mo + '/' + day;
    }
    
    private String formatTime(DateTime dt) {
    	if(dt == null) return '';
    	return dt.format('hh:mm a');
    }
}