@isTest
private class TmOpportunityConverterControllerTests {
		
	private static testMethod void getOpportunity() {
		String opportunityId = 'terr';

		try {
			TmOpportunityConverterController.getOpportunity(opportunityId);
		} catch (Exception ex) {

		}
	}

	private static testMethod void convertOpportunity() {
		TmOpportunityConverter.ConvertRequest request = new TmOpportunityConverter.ConvertRequest();
		
		try {
			TmOpportunityConverterController.convertOpportunity(request);
		} catch (Exception ex) {

		}

	}
}