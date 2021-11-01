public class ExternalDocumentMetaDataProvider implements IExternalDocumentMetaDataProvider{
    public interface IExternalDocumentMetaDataProvider{
        EB_External_Document__c lookupExternal(String uniqueName);       
    }

    public EB_External_Document__c lookupExternal(String uniqueName){
        return [
            SELECT
                Name,
                External_Document_Id__c,
                Label__c, 
                MIME_Type__c,
                File_Type__c,
                Max_Age_Minutes__c,
            	Required_Permission_Set_Name__c
            FROM 
                EB_External_Document__c 
            WHERE 
                Name =: uniqueName
            LIMIT 1
        ];
    }
}