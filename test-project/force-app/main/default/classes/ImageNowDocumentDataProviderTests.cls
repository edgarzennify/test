@IsTest
public class ImageNowDocumentDataProviderTests {
    private static final Mock.ofIRESTService mockRestSvc = new Mock.ofIRESTService(); 
    private static final ImageNowDocumentDataProvider sut = new ImageNowDocumentDataProvider(mockRestSvc);

    @IsTest
    static void it_should_call_GET_in_RESTService_once_if_req_for_document_is_made() {
        String returnValue = sut.GetDocumentByDocID('myReqURL');

        mockRestSvc.verify('GET', ApexMoq.Arguments.HAVE_ANY_VALUE, Times.Once);
    }

    @IsTest
    static void it_should_return_results_of_GET_function_if_req_for_document_is_made() {
        RestUtility.result expectedResult = new RestUtility.result();
        expectedResult.response = 'responseFromRestUtility';
        mockRestSvc.setup('GET', ApexMoq.Arguments.HAVE_ANY_VALUE).returns(expectedResult);
        String returnValue = sut.GetDocumentByDocID('myReqURL');

        system.assertequals('responseFromRestUtility', returnValue);
    }
}