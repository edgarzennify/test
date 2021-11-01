public with sharing class OpportunityRecordTypeChange {

	public Interface IOpportunityRecordTypeChangeDataProv{
		List<RecordType> getRecordTypesForOpportunityObject();
		void updateOpportunity(Opportunity opp);
	}

	private IOpportunityRecordTypeChangeDataProv m_dataProvider;

	public Opportunity opport {get; set;}
	public List<SelectOption> opportunityRecordTypes {get; set;}

	public OpportunityRecordTypeChange(ApexPages.StandardController stdController) {
		LIST<String> fieldsToAdd = new LIST<String>{'Name'};
		try{
			stdController.addFields(fieldsToAdd);
		}catch(Exception e){
		}
		Opportunity opp = (Opportunity)stdController.getRecord();
		OpportunityRecordTypeChangeDataProv dataProvider = new OpportunityRecordTypeChangeDataProv();	
		initialize(opp, dataProvider);
	}
  
	public OpportunityRecordTypeChange(Opportunity opp, IOpportunityRecordTypeChangeDataProv dataProvider) {
		initialize(opp, dataProvider);
	}

	private void initialize(Opportunity opp, IOpportunityRecordTypeChangeDataProv dataProvider) {
		opport = opp;
		m_dataProvider = dataProvider;
		opportunityRecordTypes = new List<SelectOption>();
		for(RecordType oppRecordType : m_dataProvider.getRecordTypesForOpportunityObject()){
			opportunityRecordTypes.add(new SelectOption(oppRecordType.Id, oppRecordType.Name));
		}
	}

	public PageReference save(){
		m_dataProvider.updateOpportunity(opport);
		return getDestinationURL();
	}

	public PageReference cancel(){
		return getDestinationURL();
	}

	private PageReference getDestinationURL(){
		PageReference destination = new PageReference('/' + opport.Id);
		destination.setRedirect(true);
		return destination;
	}
  
}