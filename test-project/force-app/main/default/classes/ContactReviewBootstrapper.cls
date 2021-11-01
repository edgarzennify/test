public class ContactReviewBootstrapper {
    
    public static ContactReview.IPresenter getInstanceOfIPresenter(){
		ContactReview.IDataProvider dataProvider = new ContactReviewDataProvider();
        ContactReview.IDmBuilder dmBuilder = new ContactReviewDmBuilder();		
        ContactReview.IRepository repository = new ContactReviewRepository(dataProvider, dmBuilder);		
		ContactReview.IVmBuilder vmBuilder = new ContactReviewVmBuilder();
		return new ContactReviewPresenter(repository, vmBuilder);		
	}

    public static IApexPages getInstanceOfIApexPages(){
		return new ApexPagesWrapper();
	}
}