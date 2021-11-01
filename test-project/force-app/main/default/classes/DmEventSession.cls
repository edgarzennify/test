public class DmEventSession {
	public String Id {get;set;}
    public String Name {get;set;}
    public String Description {get;set;}
    public String Region {get;set;} 
    public String Location {get;set;}
    public String Address {get;set;}
    public String Instructor {get;set;}
    public List<DmEventInstructor> Instructors {get;set;}
    public Integer Capacity {get;set;}
    public Integer NumberOfAttendees {get;set;}
    public Integer SeatsAvailable {get;set;}
    public DateTime StartDateTime {get;set;}
    public DateTime EndDateTime {get;set;}
    public String SurveyLink{get;set;}
    public String TimeZone{get;set;}
    public String WebinarLink{get;set;}
    public String WebinarPassword{get;set;}
}