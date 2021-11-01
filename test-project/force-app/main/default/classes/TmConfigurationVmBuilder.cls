public class TmConfigurationVmBuilder implements TmConfiguration.IVmBuilder {

	private final String REQUEST_NAME = 'TM_Service_Request__c';
	private final String REQUEST_CONTACT = 'TM_Service_Request_Contact__c';
	private final String REQUEST_ACCOUNT = 'TM_Servive_Request_Account__c';
	private final String REQUEST_CONTACT_ACCOUNT = 'TM_Service_Request_Contact_Account__c';

	private final TmConfiguration.IVmMetadataBuilder m_metadataBuilder;

	public TmConfigurationVmBuilder(TmConfiguration.IVmMetadataBuilder metadataBuilder) {
		m_metadataBuilder = metadataBuilder;
	}

	public TmConfiguration.FormComponent build(String objectName, List<DmSection> sectionDms, List<DmSection> objectSections) {
		TmConfiguration.FormComponent component = new TmConfiguration.FormComponent();
		component.sections = m_metadataBuilder.build(sectionDms);
		component.allFields = buildObjectFields(objectName, objectSections);
		return component;
	}

	public TmConfiguration.FormComponent buildDetails(String objectName, List<DmSection> detailSections, List<DmSection> scheduleSections, List<DmSection> objectSections) {
		TmConfiguration.FormComponent component = new TmConfiguration.FormComponent();
		component.sections = m_metadataBuilder.buildDetails(objectName, detailSections, scheduleSections);
		component.allFields = buildObjectFields(objectName, objectSections);
		return component;
	}

	private List<TmConfiguration.ObjectField> buildObjectFields(String objectName, List<DmSection> objectSections) {
		List<TmConfiguration.ObjectField> allFields = new List<TmConfiguration.ObjectField>();
		for(DmSection s : objectSections) {
			List<TmConfiguration.ObjectField> objs = m_metadataBuilder.getObjectFields(objectName, s);
			allFields.addAll(objs);
		}

		return allFields;
	}
}