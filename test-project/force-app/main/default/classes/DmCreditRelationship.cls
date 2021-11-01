public class DmCreditRelationship 
{
	public String id {get;set;}
	public DmRecordType recordType {get;set;}
	public List<DmArchivedReport> archivedReports {get;set;}
	public List<DmCreditRelationshipRelatedEntity> relatedEntities {get;set;}
	public List<DmCreditRelationshipExcludedAccount> excludedAccounts {get;set;}
	public List<DmCreditRelationshipNote> notes {get;set;}
}