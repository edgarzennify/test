public class TmConfigurationPresenter implements TmConfiguration.IPresenter {

	private final TmConfiguration.IRepository m_repository;
	private final TmConfiguration.IVmBuilder m_VmBuilder;

	public TmConfigurationPresenter(TmConfiguration.IRepository repository, TmConfiguration.IVmBuilder vmBuilder) {
		m_repository = repository;
		m_VmBuilder = vmBuilder;
	}

	public TmConfiguration.FormVm build(String productName) {
		TmConfiguration.FormVm formVm = new TmConfiguration.FormVm();
		Map<String, DmSection> objectSections =  m_repository.getAllObjectSections();
		formVm.details = getDetails(productName, objectSections);
		formVm.contacts = getContacts(productName, objectSections);
		formVm.accounts = getAccounts(productName, objectSections);
		formVm.contactAccounts = getContactAccounts(productName, objectSections);

		return formVm;
	}

	private TmConfiguration.FormComponent getDetails(String productName, Map<String, DmSection> objectSections) {
		List<DmSection> details = m_repository.getDetailSections(productName, TmConfiguration.Placement.All);
		List<DmSection> schedules = m_repository.getScheduleSections(productName, TmConfiguration.Placement.All);
		return buildDetailComponent(TmConfiguration.TM_REQUEST, details, schedules, objectSections);
	}

	private TmConfiguration.FormComponent getContacts(String productName, Map<String, DmSection> objectSections) {
		List<DmSection> contacts = m_repository.getContactSections(productName, TmConfiguration.Placement.All);
		List<String> contactObjs = new List<String>{TmConfiguration.CORE_CONTACT, TmConfiguration.TM_REQUEST_CONTACT};
		return buildComponent(TmConfiguration.TM_REQUEST_CONTACT,contactObjs, contacts, objectSections);
	}

	private TmConfiguration.FormComponent getAccounts(String productName, Map<String, DmSection> objectSections) {
		List<DmSection> accounts = m_repository.getAccountSections(productName, TmConfiguration.Placement.All);
		List<String> accountObjs = new List<String>{TmConfiguration.CORE_ACCOUNT, TmConfiguration.TM_REQUEST_ACCOUNT};
		return buildComponent(TmConfiguration.TM_REQUEST_ACCOUNT, accountObjs, accounts, objectSections);
	}

	private TmConfiguration.FormComponent getContactAccounts(String productName, Map<String, DmSection> objectSections) {
		List<DmSection> contactAccounts = m_repository.getContactAccountSections(productName, TmConfiguration.Placement.All);
		List<String> contactAccountObjs = new List<String>{TmConfiguration.TM_REQUEST_CONTACT_ACCOUNT};
		return buildComponent(TmConfiguration.TM_REQUEST_CONTACT_ACCOUNT,contactAccountObjs, contactAccounts, objectSections);
	}

	private TmConfiguration.FormComponent buildDetailComponent(String objectName, List<DmSection> detailSections, List<DmSection> scheduleSections, Map<String,DmSection> objectFields ) {
		return m_vmBuilder.buildDetails(objectName, detailSections, scheduleSections, getDmSections(new List<String>{objectName}, objectFields));
	}

	private TmConfiguration.FormComponent buildComponent(String objectName, List<String> allFieldsForObjects, List<DmSection> sections, Map<String, DmSection> lookup ) {
		return m_VmBuilder.build(objectName, sections, getDmSections(allFieldsForObjects, lookup));
	}

	private List<DmSection> getDmSections(List<String> objectNames, Map<String, DmSection> lookup) {

		List<DmSection> sections = new List<DmSection>();
		if(lookup == null){return sections;}
		for(String objectName : objectNames) {
			DmSection section = lookup.get(objectName);
			if(section != null) {sections.add(section);}
		}
		return sections;
	}
}