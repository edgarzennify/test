@IsTest
public class EbDocRepoDataProviderTests {
    public static EbDocRepoDataProvider sut;
    
    static {
    	sut = new EbDocRepoDataProvider();
    }
    
    public static testMethod void it_should_validate_all_fields_are_called_in_soql() {
        EbDocRepo__c repo = new EbDocRepo__c();
        repo.FileName__c = 'hey';
        repo.Name = 'aname';
        
        insert repo;
        
        EbDocRepo__c result = sut.GetRepoFileByName(repo.Name);
        
		Object fields = result.FileName__c;
        fields = result.Name; 
    }
    
    public static testMethod void it_should_validate_all_fields_are_called_in_soql_by_id() {
        EbDocRepo__c repo = new EbDocRepo__c();
        repo.FileName__c = 'hey';
        repo.Name = 'aname';
        
        insert repo;
        
        EbDocRepo__c result = sut.GetRepoFileById(repo.Id);
        
		Object fields = result.FileName__c;
        fields = result.Name; 
    }
}