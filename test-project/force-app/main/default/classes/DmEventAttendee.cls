public class DmEventAttendee {
    public String Id {get;set;}
    public String FirstName {get;set;}
    public String LastName {get;set;}
    public String JobTitle {get;set;}
    public String Email {get;set;}
    public String Company {get;set;}
    public String Industry {get;set;}
    public String Street {get;set;}
    public String City {get;set;}
    public String State {get;set;}
    public String Zip {get;set;}
    public String Phone {get;set;}
    public String HeardFrom {get;set;}
    public String EbtEmployeeName {get;set;}
    public Boolean IsEbtEmployee {get;set;}
    public Boolean SignupForAnnouncement {get;set;}
    public Boolean PermissionToContact {get;set;}
    public String Location {get;set;}
    public String RelatedTo {get;set;}
    public DmEntity Entity{get;set;}
    public DmLead Lead{get;set;}
    public DmUser PrimaryRM{get;set;}
    public DmRecordType recordType {get;set;}
    public List<DmEventSession> SelectedEventSessions {get;set;}
    public List<DmEventSession> AllEventSessions {get;set;}
}