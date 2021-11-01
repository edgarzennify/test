public with sharing class PricingWkstSvcProxy implements PricingWkst.IPricingWkstSvcProxy{

    private WebServices.IRestService m_restService;
	private PricingWkst.IPricingWkstSvcMapper m_svcMapper;

	public PricingWkstSvcProxy() {
		RESTService restService = new RestService(new GatewayApiMetadataProvider(), Configurations.bootstrap());
		PricingWkstSvcMapper mapper = new PricingWkstSvcMapper();
		initialize(restService, mapper);
	}

	public PricingWkstSvcProxy(WebServices.IRestService restService, PricingWkst.IPricingWkstSvcMapper mapper) {
		initialize(restService, mapper);
	}

	public void initialize(WebServices.IRestService restService, PricingWkst.IPricingWkstSvcMapper mapper) {
		m_restService = restService;
		m_svcMapper = mapper;
	}

	public PricingWkstResults getPricingInformation(PricingWkstRequest request){
		PricingWkst.PricingRequestForJSON requestConvertedToJSONRequestObject = m_svcMapper.convertToJSONRequestObject(request);
		String jsonRequest = serializeRequestToJSON(requestConvertedToJSONRequestObject);
		String serviceResponse = getResponseFromService(jsonRequest);
		PricingWkst.PricingResponseForJSON responseDeserializedToObject = deserializeJSONToPricingResponse(serviceResponse);
		PricingWkstResults results = m_svcMapper.generatePricingRequestResults(request, responseDeserializedToObject);

		return results;	
	}

	private String getResponseFromService(String jsonRequest)
	{
        try
        {
            m_restService.Wakeup();
            System.debug('*** getResponseFromService-jsonRequest: ' + jsonRequest);
            RestUtility.result res = m_restService.Post(m_restService.GetApiResource('PricingWorksheetUrl'), jsonRequest);//RESTUtility.PricingWorksheetUrl, jsonRequest);
            return res.response;
        }
        catch(exception ex)
        {
            return '';
        }

	}

	private String serializeRequestToJSON(PricingWkst.PricingRequestForJSON requestObject){
		return JSON.serialize(requestObject);
	} 

	private PricingWkst.PricingResponseForJSON deserializeJSONToPricingResponse(String jsonResults){
		System.debug('*** deserializeJSONToPricingResponse-jsonResults: ' + jsonResults);
		jsonResults = EncodingUtil.urlDecode(jsonResults, 'UTF-8');
		jsonResults = jsonResults.replace('\\', '');
		jsonResults = jsonResults.substring(1);
		System.debug('*** deserializeJSONToPricingResponse-jsonResults: ' + jsonResults);
		try{
			PricingWkst.PricingResponseForJSON pricingResponse = (PricingWkst.PricingResponseForJSON)JSON.deserialize(jsonResults, PricingWkst.PricingResponseForJSON.class);
			return pricingResponse;
		}catch(Exception e){
			throw new applicationException('Error parsing response: ' + jsonResults);
		}
	}




}