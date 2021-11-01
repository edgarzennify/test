global  class SynchronizationResultsController {
    
    private Account m_entity = null;

    public string error {get;set;}

    
    private Account entity {
        get {
            Error = '';
            if(m_entity == null){
                try
                {
                     String idParam = ApexPages.currentPage().getParameters().get('id');
                     m_entity = [SELECT Id, Name, Synchronization_Batch_Id__c, SynchronizationDate__c FROM Account WHERE Id =:idParam LIMIT 1];
                }catch(Exception ex)
                {
                    Error = 'Unable to retrieve entity data';
                }

            }
            return m_entity;
        }
    }

    public String title{
        get{
            return (entity == null)? '' : entity.Name;
        }
    }

    public String synchronizationDate{
        get{
            return (entity == null)? '' : String.valueOf(entity.SynchronizationDate__c);
        }
    }


    
    public String entityJson {
        get {
            return EncodingUtil.urlEncode(JSON.serialize(entity), 'UTF-8');
        }
    }

    @RemoteAction
    global static String ResultsByBatch(String entityString) {
        try
        {
            Account entity = (Account)JSON.deserialize(EncodingUtil.urlDecode(entityString, 'UTF-8'), Account.class);     
            EndpointParams params = BuildParams(entity);
            Webservices.IRestService restService = new RestService(new GatewayApiMetadataProvider(), Configurations.bootstrap());
            String baseUri = restService.GetApiResource('SynchronizeResultsUrl');
            String endpoint = AssembleEndpoint(baseUri, params);
            RESTUtility.result res = restService.GET(endpoint);
            //Utility.debug_DisplayInfo(res);
            if(res.status.contains('OK')){
                return res.response;
            }
            return '';
        }catch(exception ex)
        {

        }
        
        return '';
    }

    private static String AssembleEndpoint(string baseUri, EndpointParams p){
        return String.format('{0}?batchid={1}&objectkey={2}&fields={3}', new String[]{baseUri,p.BatchId,p.ObjectKey,p.fields});
    }

    private static EndpointParams BuildParams(Account entity)
    {
        EndpointParams params = new EndpointParams();
        params.Batchid = entity.Synchronization_Batch_Id__c;
        params.ObjectKey = entity.Id;
        params.Fields = 'BillingCity,BillingPostalCode,BillingState,BillingStreet,Do_Not_Call__c,Do_Not_Email__c,Do_Not_Mail__c,Do_Not_Solicit__c,Do_Not_Text__c,EB_Client_Name__c,EB_Customer_Number__c,EB_UnitID__c,Fax,Name,OwnerId,Phone,Reason_Do_Not_Solicit__c,Team_Relationship_Manager__c';
        return params;
    }

    private class EndpointParams{
        public string Batchid;
        public string ObjectKey;
        public string Fields;
    }
}