public class ECOANotificationRepository implements ECOANotification.IRepository{

	private final ECOANotification.IDataProvider m_dataProvider;

	public ECOANotificationRepository(ECOANotification.IDataProvider dataProvider) {
		m_dataProvider = dataProvider;
	}

	public List<DmLoan> getLoansForNotification(Date startDate, Date endDate) {
		List<LLC_BI__Loan__c> loanPms = m_dataProvider.getLoansForNotification(startDate, endDate);
		List<EB_Loan_Application__c> loanAppPms = m_dataProvider.getLoanAppsForNotification(startDate, endDate);
		List<DmLoan> dms = new List<DmLoan>();
		if(loanPms != null && loanPms.size() > 0)dms.addall(buildDms(loanPms));
		if(loanAppPms != null && loanAppPms.size() > 0)dms.addAll(buildDms(loanAppPms));

		return dms;
	}

	public void save(List<ECOANotification.NotificationSm> sms) {
		List<SObject> pms = new List<SObject>();
		for(ECOANotification.NotificationSm sm : sms) {	
		    SObject pm  = buildPm(sm);	
			if(pm != null)pms.add(pm);
		}

		m_dataProvider.save(pms);
	}

	private List<DmLoan> buildDms(List<LLC_BI__Loan__c> pms) {
		List<DmLoan> dms = new List<DmLoan>();

		for(LLC_BI__Loan__c pm : pms) {
			dms.add(assembleDm(pm));
		}
		return dms;
	}

	private List<DmLoan> buildDms(List<EB_Loan_Application__c> pms) {
		List<DmLoan> dms = new List<DmLoan>();

		for(EB_Loan_Application__c pm : pms) {
			dms.add(assembleDm(pm));
		}
		return dms;
	}

	private DmLoan assembleDm(LLC_BI__Loan__c pm) {
		DmLoan dm = new DmLoan();
		dm.id = pm.Id;
		dm.name = pm.Name;
		dm.loanType = pm.LLC_BI__Product__c;
		dm.productLine = pm.LLC_BI__Product_Line__c;
		dm.ecoaDateFlagged = pm.ECOA_Date_Flagged__c;
		dm.ecoaDatePrinted = pm.ECOA_Date_Printed__c;
		dm.ecoaDocumentUrl = pm.ECOA_URL__c;
		dm.primaryBorrower = assembleEntity(pm);
		
		return dm;
	}

	private DmLoan assembleDm(EB_Loan_Application__c pm) {
		DmLoan dm = new DmLoan();
		dm.id = pm.Id;
		dm.name = pm.Name;
		dm.loanType = pm.Loan_Type__c;
		dm.productLine = pm.Business_Purpose__c == 'Yes' ? 'Business' : 'Personal';
		dm.ecoaDateFlagged = pm.ECOA_Date_Flagged__c;
		dm.ecoaDatePrinted = pm.ECOA_Date_Printed__c;
		dm.ecoaDocumentUrl = pm.ECOA_Document_URL__c;
		dm.primaryBorrower = assembleEntity(pm);

		return dm;
	}

	private DmEntity assembleEntity(LLC_BI__Loan__c pm) {
		DmEntity dm = new DmEntity();
		if(!String.isBlank(pm.LLC_BI__Account__c)) {
			dm.id = pm.LLC_BI__Account__c;
			dm.name = pm.LLC_BI__Account__r.Name;
		}
		return dm;
	}

	private DmEntity assembleEntity(EB_Loan_Application__c pm) {
		DmEntity dm = new DmEntity();
		if(!String.isBlank(pm.EB_Loan_Packet__r.Lead_Entity__c)) {
			dm.id = pm.EB_Loan_Packet__r.Lead_Entity__c;
			dm.name = pm.EB_Loan_Packet__r.Lead_Entity__r.Name;
		}
		return dm;
	}

	private SObject buildPm(ECOANotification.NotificationSm sm) {
		Id smid = Id.valueOf(sm.id);
		if(smid.getSobjectType() == LLC_BI__Loan__c.SObjectType) return buildLoanPm(sm);
		if(smid.getSobjectType() == EB_Loan_Application__c.SObjectType) return buildLoanAppPm(sm);
		return null;
	}

	private SObject buildLoanAppPm(ECOANotification.NotificationSm sm) {
		EB_Loan_Application__c pm = new EB_Loan_Application__c();
		pm.Id = sm.id;
		pm.ECOA_Date_Printed__c = sm.printDate;
		return pm;
	}

	private SObject buildLoanPm(ECOANotification.NotificationSm sm) {
		LLC_BI__Loan__c pm = new LLC_BI__Loan__c();
		pm.Id = sm.id;
		pm.ECOA_Date_Printed__c = sm.printDate;
		return pm;
	}
}