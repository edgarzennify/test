public with sharing class OwnerSelectionComponent {

	public Interface IOwnerSelectionComponentDataProv{
		List<User> getOwners();
	}

	public List<User> owners{get;set;}

	private IOwnerSelectionComponentDataProv m_dataProvider;

	public OwnerSelectionComponent() {
		OwnerSelectionComponentDataProv dataProvider = new OwnerSelectionComponentDataProv();
		initialize(dataProvider);	
	}
  
	public OwnerSelectionComponent(IOwnerSelectionComponentDataProv dataProvider) {
		initialize(dataProvider);	
	}

	private void initialize(IOwnerSelectionComponentDataProv dataProvider){
		m_dataProvider = dataProvider;
		owners = m_dataProvider.getOwners();
	}
  
}