public with sharing class LoanApplicationSnapshotController {

    private String m_type;
    private String m_mintuteId;
    private String m_loanAppId;
    private final WebServices.IRestService m_restService;
    private final IApexPages m_apexPages;
    
    public LoanApplicationSnapshotController()
    {
        m_apexPages = new ApexPagesWrapper();
        Configurations.IConfigurations cfgs = Configurations.bootstrap();
        m_restService =new RestService(new GatewayApiMetadataProvider(), cfgs);     
    }

    public LoanApplicationSnapshotController (IApexPages apexPages, WebServices.IRestService restService)
    {
        m_apexPages = apexPages;
        m_restService = restService;
    }

    public String serviceResponse{get;set;}

    public void GenerateSnapShot()
    {
        String response = 'No response received';
        readUrlParamaters();
        if(m_type == 'minute')
        {
            response = generateLoanAppSnapshotForMinute();
        }

        if(m_type == 'archive')
        {
            response = generateLoanAppSnapshotForArchive();
        }

        serviceResponse = response;
    }

    private void readUrlParamaters()
    {
        m_type = m_apexPages.getParameter('type');
        m_mintuteId = m_apexPages.getParameter('minuteId');
        m_loanAppId = m_apexPages.getParameter('loanAppId');
    }

    private String generateLoanAppSnapshotForMinute()
    {
        String queryParameters = m_type + '&minuteId=' + m_mintuteId;
        return generateSnapshot(queryParameters);
    }

    private String generateLoanAppSnapshotForArchive()
    {       
        String queryParameters = m_type + '&minuteId=' + m_mintuteId + '&loanAppId=' + m_loanAppId;
        return generateSnapshot(queryParameters);
    }

    private String generateSnapshot(String queryParameters)
    {
        String url = RestUtility.SnapshotUrl + queryParameters;
        RESTutility.result result = m_restService.Post(url,'');
        return result.response;
    }

}