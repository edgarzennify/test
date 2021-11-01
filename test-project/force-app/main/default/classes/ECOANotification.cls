public class ECOANotification {

	public interface IDataProvider {
		List<LLC_BI__Loan__c> getLoansForNotification(Date startDate, Date endDate);
		List<EB_loan_Application__c> getLoanAppsForNotification(Date startDate, Date endDate);
		void save(List<SObject> sobjects);
	}

	public interface IPresenter {
		FormVm buildVm();
		void print(String selectedDate, FormVm formVm);
		FormVm filterNotifications(Date startDate, Date endDate);
	}

	public interface IRepository {
		List<DmLoan> getLoansForNotification(Date startDate, Date endDate);
		void save(List<NotificationSm> notifications);
	}

	public class FormVm {
		public Date startDate {get;set;}
		public Date endDate {get;set;}
		public List<NotificationVm> notifications {get;set;}
	}

	public class NotificationVm implements Comparable {
		public Boolean readyToPrint {get;set;}
		public Date flaggedDate {get;set;}
		public String flaggedDateDisplay {get;set;}
		public String documentURL {get;set;}
		public String loanCount {get;set;}
		public String printDate {get;set;}
		public List<DmLoan> loans {get;set;}

		public Integer compareTo(Object compareTo){
			NotificationVm compareToObject = (NotificationVm)compareTo;
			if (flaggedDate > compareToObject.flaggedDate) return -1;
			if (flaggedDate == compareToObject.flaggedDate) return 0;
			return 1;
		}
	}

	public class NotificationSm {
		public String id {get;set;}
		public Date printDate {get;set;}
	}
}