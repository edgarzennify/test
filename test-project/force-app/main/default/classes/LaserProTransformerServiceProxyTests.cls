@IsTest
private class LaserProTransformerServiceProxyTests {

	private final static LaserProTransformerServiceProxy sut;
	private final static Mock.ofIRESTService mockRestService;
    private final static Mock.OfIJson mockJsonSerializer;

	static {
		mockRestService = new Mock.ofIRESTService();
		mockJsonSerializer = new Mock.OfIJson();
		sut = new LaserProTransformerServiceProxy(mockRestService, mockJsonSerializer);
	}

	@IsTest
    static void it_should_call_the_rest_service_when_doing_trial_export() {
		DmLoan dm = new DmLoan();
		String requestJson = '{test:one}';
		mockJsonSerializer.setup('serialize', new List<Object>{dm}).returns(requestJson);
		String SERVICE_API_NAME = 'LaserProTransformerUrl';
		String TRIAL_EXPORT_URI = '/export/trial';
		RestUtility.Result result = new RestUtility.Result();
		result.Status = 'OK';
		result.response = '{test:succeeded}';
		mockRestService.setup('POST', new List<Object>{SERVICE_API_NAME, TRIAL_EXPORT_URI, requestJson}).returns(result);

		sut.trialExport(dm);

		mockJsonSerializer.verify('deserialize', new List<Object>{result.response, LaserProTransformer.LpLoan.class}, Times.Once);
	}

	@IsTest
    static void it_should_call_the_rest_service_when_doing_trial_export_and_return_null_when_service_response_is_not_OK() {
		DmLoan dm = new DmLoan();
		String requestJson = '{test:one}';
		mockJsonSerializer.setup('serialize', new List<Object>{dm}).returns(requestJson);
		String SERVICE_API_NAME = 'LaserProTransformerUrl';
		String TRIAL_EXPORT_URI = '/export/trial';
		RestUtility.Result res = new RestUtility.Result();
		res.Status = 'Failed';
		res.response = '{test:failed}';
		mockRestService.setup('POST', new List<Object>{SERVICE_API_NAME, TRIAL_EXPORT_URI, requestJson}).returns(res);

		LaserProTransformer.LpLoan  result = sut.trialExport(dm);

		System.assertEquals(null, result);
	}

	@IsTest
    static void it_should_call_the_rest_service_when_doing_export_file() {
		DmLoan dm = new DmLoan();
		String requestJson = '{test:one}';
		mockJsonSerializer.setup('serialize', new List<Object>{dm}).returns(requestJson);
		String SERVICE_API_NAME = 'LaserProTransformerUrl';
		String EXPORT_URI = '/export';
		RestUtility.Result result = new RestUtility.Result();
		result.Status = 'OK';
		result.response = '{test:succeeded}';
		mockRestService.setup('POST', new List<Object>{SERVICE_API_NAME, EXPORT_URI, requestJson}).returns(result);

		sut.export(dm);

		mockJsonSerializer.verify('deserialize', new List<Object>{result.response, LaserProTransformer.ExportResponse.class}, Times.Once);
	}

	@IsTest
    static void it_should_call_the_rest_service_when_doing_export_file_and_return_null_when_response_is_not_OK() {
		DmLoan dm = new DmLoan();
		String requestJson = '{test:one}';
		mockJsonSerializer.setup('serialize', new List<Object>{dm}).returns(requestJson);
		String SERVICE_API_NAME = 'LaserProTransformerUrl';
		String EXPORT_URI = '/export';
		RestUtility.Result res = new RestUtility.Result();
		res.Status = 'Failed';
		res.response = '{test:failed}';
		mockRestService.setup('POST', new List<Object>{SERVICE_API_NAME, EXPORT_URI, requestJson}).returns(res);

		LaserProTransformer.ExportResponse result =  sut.export(dm);

		System.assertEquals(null, result);
	}
}