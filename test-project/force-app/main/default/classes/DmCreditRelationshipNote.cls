public class DmCreditRelationshipNote 
{
	public String id { get; set; }
	public String name { get; set; }
	public DmRecordType recordType { get; set; }
	public DmCreditRelationship creditRelationship { get; set; }
	public String diary { get; set; }
	public Boolean situationFlag { get; set; }
	public DmUser createdBy { get; set; }
	public Datetime createdDate { get; set; }
}