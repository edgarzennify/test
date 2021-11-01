public class TmOpportunityConverterBusinessBankMapper implements TmOpportunityConverter.IOpportunityMapper {
    
    private TmOpportunityConverter.IConfiguration m_config;
    
    public TmOpportunityConverterBusinessBankMapper(TmOpportunityConverter.IConfiguration config){
        m_config = config;
    }
    public string handle(){
        return m_config.OPP_RECORDTYPE_BUSINESS_BANKING();
    }
    public TM_Service_Request__c updateTmObject(TM_Service_Request__c request, DmOpportunity oppDm){
        request.Business_Banking__c = true;
        return request;
    }
}