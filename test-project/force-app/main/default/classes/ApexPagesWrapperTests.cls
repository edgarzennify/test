@IsTest
private class ApexPagesWrapperTests {

	private final static ApexPagesWrapper sut;
	static{
		sut = new ApexPagesWrapper();
	}

	private static testMethod void it_should_set_an_error_message() {
		ApexPages.Severity sev = ApexPages.Severity.ERROR;
		String msgDetail = 'test';

		sut.addMessage(sev, msgDetail);

		List<ApexPages.Message> queriedMessages = ApexPages.getMessages();
		System.assertEquals(1, queriedMessages.size());
		System.assertEquals(msgDetail, queriedMessages[0].getDetail());
	}

	private static testMethod void it_should_set_an_error_message_without_severity_parameter() {
		String msgDetail = 'test';
		ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, msgDetail);

		sut.addMessage(msg);

		List<ApexPages.Message> queriedMessages = ApexPages.getMessages();
		System.assertEquals(1, queriedMessages.size());
		System.assertEquals(msgDetail, queriedMessages[0].getDetail());
	}

	private static testMethod void it_should_return_false_when_no_message_exists() {

		Boolean result = sut.hasMessages();

		System.assertEquals(false , result);
	}

	private static testMethod void it_should_return_true_when_message_exists() {
		String msgDetail = 'test';
		ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, msgDetail);
		sut.addMessage(msg);

		Boolean result = sut.hasMessages();

		System.assertEquals(true , result);
	}

	private static testMethod void it_should_return_true_when_messsage_exists_for_the_passed_in_severity(){
		String msgDetail = 'test';
		ApexPages.Severity sev = ApexPages.Severity.ERROR;
		ApexPages.Message msg = new ApexPages.Message(sev, msgDetail);
		sut.addMessage(msg);

		Boolean result = sut.hasMessages(sev);

		System.assertEquals(true , result);
	}

	private static testMethod void it_should_get_the_current_page(){
		PageReference pr = new PageReference('http://test.com');
        test.setCurrentPage(pr);

		PageReference result = sut.currentPage();

		System.assertEquals(pr, result);
	}

	private static testMethod void it_should_get_the_current_parameter(){
		String testParam = 'id';
		PageReference pr = new PageReference('http://test.com?'+ testParam +'=123');
        test.setCurrentPage(pr);

		String result = sut.getParameter(testParam);

		System.assertEquals('123', result);
	}
}