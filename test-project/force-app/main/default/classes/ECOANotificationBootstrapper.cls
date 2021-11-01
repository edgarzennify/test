public class ECOANotificationBootstrapper {
    public static ECOANotification.IPresenter getInstanceOfIPresenter(){
        ECOANotification.IDataProvider dataProvider = new ECOANotificationDataProvider();
        ECOANotification.IRepository repository = new ECOANotificationRepository(dataProvider);
        ISystem systemWrapper = new SystemWrapper();
        return new ECOANotificationPresenter(repository, systemWrapper);
    }
}