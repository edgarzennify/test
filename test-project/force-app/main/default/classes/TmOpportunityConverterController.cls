global class TmOpportunityConverterController {

	@RemoteAction
	global static TmOpportunityConverter.OpportunityDetails getOpportunity(String opportunityId) {
		TmOpportunityConverter.IPresenter presenter = TmOpportunityConverterBootstrapper.getInstanceOfIPresenter();
		TmOpportunityConverter.OpportunityDetails details = presenter.getOpportunityDetails(opportunityId);
		return details;
	}

	@RemoteAction
	global static string convertOpportunity(TmOpportunityConverter.ConvertRequest request) {
		TmOpportunityConverter.IPresenter presenter = TmOpportunityConverterBootstrapper.getInstanceOfIPresenter();
		return presenter.save(request);
	}
}