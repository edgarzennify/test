public with sharing class CreditRelationshipReportManager implements CreditRelationship.ICreditRelationshipReportManager {
    private static String REPORT_NAME = 'Watch Credit Report';
    private static String OREO_REPORT_NAME = 'Watch Credit OREO Report';
    private final Configurations.IConfigurations m_configs;

    public CreditRelationshipReportManager(Configurations.IConfigurations configs)
    {
        m_configs = configs;
    }
    
    public void generateReportOutput(String archivedReportId, Boolean isOreo){
        String reportBaseUrl = (isOreo) ? 
            m_configs.creditRelationshipOreoSaveReportBaseUrl() : 
            m_configs.creditRelationshipSaveReportBaseUrl();
            
        calloutForGeneratingReport(archivedReportId, reportBaseUrl);
    }

    public Integer getReportIdForUrl(Boolean isOreo){
        if(isOreo){
            return m_configs.creditRelationshipOreoReportId();
        }
        return m_configs.creditRelationshipReportId();
    }

    public String getArchiveReportName(Boolean isOreo){
        return (isOreo) ? OREO_REPORT_NAME : REPORT_NAME;
    }

    public CreditRelationship.ArchivedReportSm buildArchivedReportSm(DmArchivedReport dm){
        CreditRelationship.ArchivedReportSm archivedReport = new CreditRelationship.ArchivedReportSm();
        archivedReport.name = dm.Name;
        archivedReport.creditRelationshipId = dm.creditRelationship.Id;
        return archivedReport;
    }

    @future(callout=true)
    private static void calloutForGeneratingReport(String archivedReportId, String baseUrl){

        try{
            postReportGenerationRequest(archivedReportId, baseUrl); 
        }catch(exception ex){
        }        
    }
    
    private static void postReportGenerationRequest(String archivedReportId, String baseUrl)
    {   
        archivedReportId = RestUtility.convertid15ToId18(archivedReportId);
        String url = baseUrl + archivedReportId;
        String body = 'reportid='+ EncodingUtil.urlEncode(archivedReportId,'UTF-8');
        WebServices.IRestService restService = new RestService(new GatewayApiMetadataProvider(), Configurations.bootstrap());
        restService.Post(url, body);          
    }
}