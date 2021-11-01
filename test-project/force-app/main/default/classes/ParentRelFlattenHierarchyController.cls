public with sharing class ParentRelFlattenHierarchyController {

	public Account entity {get; set;}

	private ParentRelationshipSvc.IParentRelationshipSvc m_parentRelSvc;
	private ParentRelTreeBuilderDataProv.IParentRelTreeBuilderDataProv m_dataProv;
	private IApexPages m_apexPages;
	private Utility.IUtility m_utility;

	public ParentRelFlattenHierarchyController() {
		ParentRelationshipSvc parentRelSvc = new ParentRelationshipSvc();
		ParentRelTreeBuilderDataProv dataProv = new ParentRelTreeBuilderDataProv();
		ApexPagesWrapper apexPages = new ApexPagesWrapper();
		Utility utility = new Utility();
		initialize(parentRelSvc, dataProv, apexPages, utility);				
	}

	public ParentRelFlattenHierarchyController(ParentRelationshipSvc.IParentRelationshipSvc parentRelSvc, ParentRelTreeBuilderDataProv.IParentRelTreeBuilderDataProv dataProv, 
												IApexPages apexPages, Utility.IUtility utility) {
		initialize(parentRelSvc, dataProv, apexPages, utility);
	}

	private void initialize(ParentRelationshipSvc.IParentRelationshipSvc parentRelSvc, ParentRelTreeBuilderDataProv.IParentRelTreeBuilderDataProv dataProv, 
												IApexPages apexPages, Utility.IUtility utility){
		m_parentRelSvc = parentRelSvc;
		m_dataProv = dataProv;
		m_apexPages = apexPages;
		m_utility = utility;

		Id entityId = m_apexPages.getParameter('id');
		entity=m_dataProv.getEntity(entityId);		
	}

	public PageReference flattenHierarchyForEntity(){
		m_parentRelSvc.flattenRelatedChildrenForEntity(entity);
		return getDestination();
	}

	public PageReference cancel(){
		return getDestination();
	}

	private PageReference getDestination(){
		PageReference destination = new PageReference(m_utility.getServerURL()+'/apex/OwnerOverview?id='+ entity.OwnerId);
		destination.setRedirect(true);
		return destination;
	}

}