@IsTest
private class ImageNowDocumentTests {

	private static testMethod void it_should_return_list_of_ImageNowDocuments_from_call_to_dataprovider() {
		MockOfIImageNowDocumentDataProvider mockDataProvider = new MockOfIImageNowDocumentDataProvider();
		mockDataProvider.GetDocumentByDocID_return = '{"imageNowGetSingleDocumentResult":["myPageImage"]}';
		ImageNowDocument sut = new ImageNowDocument(mockDataProvider);
		String myDocID = 'myDocID';

		String returnResult = sut.GetImageNowDocumentByID(myDocID);

		system.assertequals('myPageImage', returnResult);
		system.assertequals(1, mockDataProvider.GetDocumentByDocID_TimesCalled);
		system.assertequals(myDocID, mockDataProvider.GetDocumentByDocID_docID[0]);
	}

	private class MockOfIImageNowDocumentDataProvider Implements ImageNowDocument.IImageNowDocumentDataProvider{

	    public Integer GetDocumentByDocID_TimesCalled=0;
	    public List<string> GetDocumentByDocID_docID = new List<string>();
	    public String GetDocumentByDocID_return;

	    public String GetDocumentByDocID(string docID){
	        GetDocumentByDocID_TimesCalled += 1;
	        GetDocumentByDocID_docID.add(docID);
	    	return GetDocumentByDocID_return;
	    }

	}

}