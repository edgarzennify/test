public class DmTmPacket {
    public String id {get;set;}
    public String name {get;set;}
    public DmEntity entity {get;set;}
    public String status {get;set;}
    public DateTime LastStatusDate {get;set;}
    public Boolean IsRushed{get;set;}
    public DateTime createdDate{get;set;}
    public DmUser createdBy{get;set;}
    public DmUser lastModifiedBy{get;set;}
    public List<DmTmRequest> tmRequests{get;set;}
}