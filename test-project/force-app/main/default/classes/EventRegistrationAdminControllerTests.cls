@IsTest
private class EventRegistrationAdminControllerTests {

	private static testmethod void it_should_get_all_classes() {
		EventRegistrationAdminController.getAllClasses();
	}

	private static testmethod void it_should_get_attendees_for_class() {
		String classId = 'sdfwer';
		EventRegistrationAdminController.getAttendeesForClass(classId);
	}

	private static testmethod void it_should_get_a_search_result() {
		String param = 'dfdf';
		EventRegistrationAdminController.search(param);
	}
}