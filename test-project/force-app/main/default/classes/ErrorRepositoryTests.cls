@Istest
private class ErrorRepositoryTests {

	private static final ErrorRepository sut;

	static {
		sut = new ErrorRepository();
	}

	private static testMethod void it_should_add_an_error(){
		String error = 'test-error';

		sut.addError(error);

		ErrorRepository.ErrorDetails errors = sut.get();
		System.assertEquals(1,  errors.Errors.size());
		System.assertEquals(error,  errors.Errors[0]);
	}

	private static testMethod void it_should_add_an_info(){
		String info = 'test-info';

		sut.addInfo(info);

		ErrorRepository.ErrorDetails errors = sut.get();
		System.assertEquals(1,  errors.Infos.size());
		System.assertEquals(info,  errors.Infos[0]);
	}

	private static testMethod void it_should_add_a_warning(){
		String warning = 'test-warning';

		sut.addWarning(warning);

		ErrorRepository.ErrorDetails errors = sut.get();
		System.assertEquals(1,  errors.Warnings.size());
		System.assertEquals(warning,  errors.Warnings[0]);
	}


}