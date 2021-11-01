@IsTest
private class SystemWrapperTests {
	private final static SystemWrapper sut;
	static{
		sut = new SystemWrapper();
	}

	private static testMethod void it_should_get_the_todays_date_with_time() {

		DateTime result = sut.now();

		System.assertEquals(System.Now(), result);
	}

	private static testMethod void it_should_get_the_todays_date() {

		DateTime result = sut.today();

		System.assertEquals(System.today(), result);
	}
}