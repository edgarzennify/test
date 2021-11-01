public class DmTmRequest {
	public String id{get;set;}
	public String name{get;set;}
	public DmRecordType recordType{get;set;}
	public DmTmRequestStage stage{get;set;}
	public DateTime createdDate{get;set;}
	public DmUser createdBy{get;set;}
	public DmUser lastModifiedBy{get;set;}
	public String notes {get;set;}
	public String assignedTo{get;set;}
}