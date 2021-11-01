public class ECOANotificationPresenter implements ECOANotification.IPresenter {
    
    private final ECOANotification.IRepository m_repository;
    private final ISystem m_system;
    
    public ECOANotificationPresenter(ECOANotification.IRepository repository, ISystem systemWrapper){
        m_repository = repository;
        m_system = systemWrapper;
    }
    
    public ECOANotification.FormVm buildVm(){
        Date today = m_system.today();
        return filterNotifications(today - 30, today - 1);
    }
  
    public void print(String selectedDate, ECOANotification.FormVm formVm){
        Date today = m_system.today();
        List<DmLoan> loansForDate = getLoansForDateFromVm(selectedDate, formVm);
        List<ECOANotification.NotificationSm> saves = new List<ECOANotification.NotificationSm>();
        for(DmLoan ln : loansForDate){
            if(ln.ecoaDatePrinted == null){
                ECOANotification.NotificationSm sm = new ECOANotification.NotificationSm();
                sm.id = ln.id;
                sm.printDate = today;
                saves.add(sm);
            }
        }
        m_repository.save(saves);
    }
  	
    public ECOANotification.FormVm filterNotifications(Date startDate, Date endDate){
        return buildForDates(startDate, endDate);
    }
    
    private List<DmLoan> getLoansForDateFromVm(String flaggedDate, ECOANotification.FormVm formVm){
        for(ECOANotification.NotificationVm nvm : formVm.notifications){
            if(nvm.flaggedDateDisplay == flaggedDate){
                return nvm.loans;
            }
        }
        return new List<DmLoan>();
    }
    
    private ECOANotification.FormVm buildForDates(Date startDate, Date endDate){
        List<DmLoan> loans = m_repository.getLoansForNotification(startDate, endDate);
        Map<String, List<DmLoan>> loansByFlaggedDate = groupByFlaggedDate(loans);
        
        ECOANotification.FormVm vm = new ECOANotification.FormVm();        
        vm.startDate = startDate;
        vm.endDate = endDate;        
        vm.notifications = buildNotificationVms(loansByFlaggedDate);
        
        return vm;
    }
    
    private List<ECOANotification.NotificationVm> buildNotificationVms(Map<String, List<DmLoan>> loansByFlaggedDate){
        List<ECOANotification.NotificationVm> vms = new List<ECOANotification.NotificationVm>();
        for(String dt : loansByFlaggedDate.keySet()){
            DmLoan first = loansByFlaggedDate.get(dt).size() > 0 ? loansByFlaggedDate.get(dt)[0] : null;
            ECOANotification.NotificationVm nvm = new ECOANotification.NotificationVm();
            nvm.readyToPrint = first != null ? !String.isEmpty(first.ecoaDocumentURL) : false;
            nvm.documentURL = first != null ? first.ecoaDocumentURL : '';
            nvm.loans = loansByFlaggedDate.get(dt);
            nvm.flaggedDate = first.ecoaDateFlagged;
            nvm.flaggedDateDisplay = first.ecoaDateFlagged != null ? formatDate(first.ecoaDateFlagged) : '';
            nvm.loanCount = String.valueOf(loansByFlaggedDate.get(dt).size());
            nvm.printDate = first != null ? formatDate(first.ecoaDatePrinted) : '';
            vms.add(nvm);
        }
        vms.sort();
        return vms;
    }
    
    private Map<String, List<DmLoan>> groupByFlaggedDate(List<DmLoan> loans){
        Map<String, List<DmLoan>> grouped = new Map<String, List<DmLoan>>();
        if(loans != null){
            for(DmLoan ln : loans){
                String key = formatDate(ln.ecoaDateFlagged);
                if(!grouped.containsKey(key)){
                    grouped.put(key, new List<DmLoan>());
                }
                grouped.get(key).add(ln);
            }
        }
        return grouped;
    }
    
    public String formatDate(Date dt){
		return dt == null ? '' : String.valueOf(dt.Month()) + '/' + String.valueOf(dt.day()) + '/' + String.valueOf(dt.year());
	}
    
}