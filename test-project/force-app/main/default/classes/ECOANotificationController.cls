public class ECOANotificationController {

    private final ECOANotification.IPresenter m_presenter;

    public ECOANotificationController() {
        m_presenter = ECOANotificationBootstrapper.getInstanceOfIPresenter();
    }

    public ECOANotificationController(ECOANotification.IPresenter presenter){
        m_presenter = presenter;
    }

    public ECOANotification.FormVm vm {get;set;}
    public Grenzsoldat__c dateObject {get;set;}
    public String selectedDate {get;set;}
    public String selectedUrl {get;set;}
    public Boolean navigate {get;set;}

    public void initialize(){
        vm = m_presenter.buildVm(); 
        dateObject = new Grenzsoldat__c();     
        dateObject.Bogus_Date_1__c = vm.startDate;
        dateObject.Bogus_Date_2__c = vm.endDate;
        navigate = false;
    }

    public void print(){
        m_presenter.print(selectedDate, vm);
        filterNotifications();
        navigate = true;
    }

    public void filterNotifications(){
        navigate = false;
        vm = m_presenter.filterNotifications(dateObject.Bogus_Date_1__c, dateObject.Bogus_Date_2__c);
    }  
}