public class DmEventAttendance {
	public String id {get;set;}
    public DmEventAttendee attendee {get;set;}
    public List<DmEventClass> classes {get;set;}
    public Boolean Present {get;set;}
}