public class ECOANotificationMock {
    public class ofIDataProvider extends ApexMoq implements ECOANotification.IDataProvider {
        public List<LLC_BI__Loan__c> getLoansForNotification(Date startDate, Date endDate) {
            return (List<LLC_BI__Loan__c>)handleMethodInvocation('getLoansForNotification', new List<Object>{startDate, endDate});
        }
        public List<EB_loan_Application__c> getLoanAppsForNotification(Date startDate, Date endDate) {
            return (List<EB_loan_Application__c>)handleMethodInvocation('getLoanAppsForNotification', new List<Object>{startDate, endDate});
        }
        public void save(List<SObject> sObjects) {
            handleMethodInvocation('save', new List<Object>{sObjects});
        }
    }
    public class ofIPresenter extends ApexMoq implements ECOANotification.IPresenter {
  		public ECOANotification.FormVm buildVm(){
  			return (ECOANotification.FormVm)handleMethodInvocation('buildVm');
  		}
  		public void print(String selectedDate, ECOANotification.FormVm formVm){
  			handleMethodInvocation('print', new List<Object>{selectedDate,formVm});
  		}
  		public ECOANotification.FormVm filterNotifications(Date startDate, Date endDate){
  			return (ECOANotification.FormVm)handleMethodInvocation('filterNotifications', new List<Object>{startDate,endDate});
  		}
  	}
  	public class ofIRepository extends ApexMoq implements ECOANotification.IRepository {
  		public List<DmLoan> getLoansForNotification(Date startDate, Date endDate){
  			return (List<DmLoan>)handleMethodInvocation('getLoansForNotification', new List<Object>{startDate,endDate});
  		}
  		public void save(List<ECOANotification.NotificationSm> notifications){
  			handleMethodInvocation('save', new List<Object>{notifications});
  		}
  	}
}