public class EbDocRepoDataProvider implements EbDocRepoProvider.IDataProvider {

    public EBDocRepo__c GetRepoFileByName(string fileName) {
        EBDocRepo__c repoFile = [Select Name, FileName__c From EBDocRepo__c Where Name =: fileName LIMIT 1];
        return repoFile;
    }
    
    public EBDocRepo__c GetRepoFileById(Id fileId) {
        EBDocRepo__c repoFile = [Select Name, FileName__c From EBDocRepo__c Where Id =: fileId];
        return repoFile;
    }

    public List<EBDocRepo__c> GetRepoFilesByNames(List<string> fileNames){
    	return [
    		Select 
    			Name
    		   ,FileName__c 
    	    From 
    	    	EBDocRepo__c 
    	    Where 
    	    	Name in: fileNames
    	];
    }
    
    public List<EBDocRepo__c> GetRepoFilesByIds(List<Id> fileIds){
    	return [
    		Select 
    			Name
    		   ,FileName__c 
    		From 
    			EBDocRepo__c 
    		Where 
    			Id in: fileIds
    	];
    }
}