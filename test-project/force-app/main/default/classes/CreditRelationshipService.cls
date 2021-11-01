public with sharing class CreditRelationshipService implements CreditRelationship.ICreditRelationshipService {
	private static String MINUTE_RECORD_TYPE_NAME ='Minute';
    private static String ANALYSIS_RECORD_TYPE_NAME = 'Analysis';
    private static String OREO_RECORD_TYPE_NAME = 'Credit Relationship OREO';
    private static String REPORT_NAME = 'Watch Credit Report';
    private static String OREO_REPORT_NAME = 'Watch Credit OREO Report';
    private static Set<String> INVALID_STATUS_VALUES = new Set<String>{'C','R','P'};
    private static Set<String> OREO_INVALID_STATUS_VALUES = new Set<String>{'R','P'};
    private static Integer OREO_APPLICATION = 91;

	private final CreditRelationship.ICreditRelationshipVmBuilder m_vmBuilder;
	private final CreditRelationship.ICreditRelationshipData m_dataProvider;
	private final CreditRelationship.ICreditRelationshipReportManager m_reportManager;
	private final ReportUrlProvider.IReportUrlProvider m_urlProvider;
	private final IUserInfoService m_userInfoService;

	public CreditRelationshipService(CreditRelationship.ICreditRelationshipVmBuilder vmBuilder
		                            ,CreditRelationship.ICreditRelationshipData dataProvider
		                            ,CreditRelationship.ICreditRelationshipReportManager reportManager
		                            ,ReportUrlProvider.IReportUrlProvider urlProvider
		                            ,IUserInfoService userInfoService) {
		m_vmBuilder = vmBuilder;
		m_dataProvider = dataProvider;
		m_reportManager = reportManager;
		m_urlProvider = urlProvider;
		m_userInfoService = userInfoService;
	}

	public CreditRelationship.CreditRelationshipVm getCreditRelationshipViewModel(String creditRelationshipId) {
		DmCreditRelationship dm = m_dataProvider.getCreditRelationshipById(creditRelationshipId);
		List<DmEbAccount> relatedAccounts = getRelatedAccounts(dm);
		List<DmEntity> possibleRelatedEntities = m_dataProvider.getPossibleRelatedEntities(relatedAccounts, dm.relatedEntities);
		
		CreditRelationship.CreditRelationshipVm vm = new CreditRelationship.CreditRelationshipVm();
        vm.archivedReports = m_vmBuilder.buildArchivedReportVms(dm.archivedReports);
        vm.relatedEntities = m_vmBuilder.buildRelatedEntityVms(dm.relatedEntities);
        vm.relatedAccounts = m_vmBuilder.buildRelatedAccountVms(relatedAccounts);
        vm.excludedAccounts = m_vmBuilder.buildExcludedAccountVms(dm.excludedAccounts);
        vm.possibleRelatedEntities = m_vmBuilder.buildPossibleRelatedEntityVms(possibleRelatedEntities);
        vm.minutes = m_vmBuilder.buildNoteVms(getMinutes(dm.notes));
        vm.situationAnalysis = m_vmBuilder.buildNoteVms(getSituationAnalysis(dm.notes));
        return vm;
	}

	public void addArchivedReport(String creditRelationshipId) {
		Boolean isOreo = IsOreo(creditRelationshipId);
		String reportName = m_reportManager.getArchiveReportName(isOreo);
		String archivedReportId = createArchivedReport(creditRelationshipId, reportName);
        lockAllSituationAnalysis(creditRelationshipId);
        
        m_reportManager.generateReportOutput(archivedReportId, isOreo);

	}

	public void addRelatedEntity(CreditRelationship.RelatedEntitySm sm) {
		m_dataProvider.addRelatedEntity(sm);
	}

	public void addExcludedAccount(CreditRelationship.ExcludedAccountSm sm) {
		if (!excludedAccountIds(sm.creditRelationshipId).contains(sm.accountId)) {
			m_dataProvider.addExcludedAccount(sm);
		}
	}
		
	public void addNote(CreditRelationship.NoteSm sm) {
		m_dataProvider.addNote(sm);
	}

	public void deleteRelatedEntity(String recordId) {
		m_dataProvider.deleteRelatedEntity(recordId);
	}

	public void deleteExcludedEbAccount(String recordId) {
		m_dataProvider.deleteExcludedEbAccount(recordId);
	}

	public void deleteNote(String recordId) {
		m_dataProvider.deleteNote(recordId);
	}

	public String getReportUrl(String creditRelationshipId) {
		Boolean isOreo = isOreo(creditRelationshipId);
		String reportId = String.valueOf(m_reportManager.getReportIdForUrl(isOreo));
		return m_urlProvider.getReportUrl(reportId, new List<string>{creditRelationshipId});
	}

	public Boolean hasPermissionAdmin() {
	    return m_userInfoService.isSystemAdministrator() 
                || m_userInfoService.hasPermissionSet('Function - Credit Relationship Admin');
	}

	public Boolean hasPermissionToEdit() {
		 return hasPermissionAdmin() 
                || m_userInfoService.hasPermissionSet('Function - Credit Relationship Editor');
	}

	public Boolean hasPermissionToView() {
		 return hasPermissionAdmin() 
                || m_userInfoService.hasPermissionSet('Function - Credit Relationship View');
	}
    
    private Id createArchivedReport(String creditRelationshipId, String reportName) {
    	DmArchivedReport dm = new DmArchivedReport();
    	dm.name = reportName;
    	dm.creditRelationship = new DmCreditRelationship();
    	dm.creditRelationship.Id = creditRelationshipId;
        CreditRelationship.ArchivedReportSm archivedReport = m_reportManager.buildArchivedReportSm(dm);
        return m_dataProvider.addArchivedReport(archivedReport);
	}

	private void lockAllSituationAnalysis(Id creditRelationshipId) {
        DmCreditRelationship dm = m_dataProvider.getCreditRelationshipById(creditRelationshipId);
    	List<Id> updates = new List<Id>();
        for (DmCreditRelationshipNote n : getSituationAnalysis(dm.notes)) {
            if (!n.SituationFlag) {
                updates.add(n.id);
            }
        }
       
        m_dataProvider.lockNotesById(updates);
    }

    private List<DmCreditRelationshipNote> getSituationAnalysis(List<DmCreditRelationshipNote> notes) {
        List<DmCreditRelationshipNote> analysis = new List<DmCreditRelationshipNote>();

        for (DmCreditRelationshipNote note : notes) {
            if (note.recordType.name == ANALYSIS_RECORD_TYPE_NAME) analysis.add(note);
        }

        return analysis;
    }

	private Boolean isOreo(DmCreditRelationship cr) {
        return cr.recordType.name == OREO_RECORD_TYPE_NAME;
    }

    private Boolean isOreo(Id creditRelationshipId) {
    	return isOreo(m_dataProvider.getCreditRelationshipById(creditRelationshipId));
    }

    private List<DmEbAccount> getRelatedAccounts(DmCreditRelationship creditRelationship) {
		Boolean isOreo = isOreo(creditRelationship);
		List<DmEbAccount> filtered = new List<DmEbAccount>();
		for (DmEbAccount a : m_dataProvider.getRelatedAccounts(creditRelationship.relatedEntities)) {
			if (isValidRelatedAccount(isOreo, a)) {
				filtered.add(a);
			}
		}
		return filtered;
	}

	private List<DmCreditRelationshipNote> getMinutes(List<DmCreditRelationshipNote> notes) {
        List<DmCreditRelationshipNote> minutes = new List<DmCreditRelationshipNote>();
        for (DmCreditRelationshipNote note : notes) {
            if (note.recordType.name == MINUTE_RECORD_TYPE_NAME) minutes.add(note);
        }
        return minutes;
    }

    private Boolean isValidRelatedAccount(Boolean isOreo, DmEbAccount acct) {
		if (isOreo && !OREO_INVALID_STATUS_VALUES.contains(acct.Status) && acct.Application == OREO_APPLICATION) {
			return true;
		} else if (!isOreo && !INVALID_STATUS_VALUES.contains(acct.Status) && acct.Application != OREO_APPLICATION) {
			return true;
		}
		return false;
	}

	 private Set<String> excludedAccountIds(String creditRelationshipId) {
     	DmCreditRelationship dm = m_dataProvider.getCreditRelationshipById(creditRelationshipId);
		Set<String> ids = new Set<String>();
		if (dm != null) {
			for (DmCreditRelationshipExcludedAccount a : dm.excludedAccounts) {
				ids.add(a.ebAccount.id);
			}
		}
		return ids;
    }
}