@IsTest
public class LoanBoardingControllerTests {

    private static LoanBoardingController sut;
    private static final LoanBoardingMock.ofPresenter mockPresenter;
    private static final Mock.ofIApexPages mockApexPages;
    
    static {
        mockPresenter = new LoanBoardingMock.ofPresenter();
        mockApexPages = new Mock.ofIApexPages();
        sut = new LoanBoardingController(mockPresenter, mockApexPages);
    }

    @IsTest
    static void it_should_call_the_apex_pages_to_get_id() {
        sut.initialize();

        mockApexPages.verify('getParameter', new List<Object>{'id'}, Times.Once);
    }

    @IsTest
    static void it_should_call_the_presenter_to_get_vm() {
        mockApexPages.setup('getParameter', new List<Object>{'id'}).returns('test-id');

        sut.initialize();

        mockPresenter.verify('build', new List<Object>{'test-id'}, Times.Once);
    }

    @IsTest
    static void it_should_call_the_default_constructor() {
        sut = new LoanBoardingController();
    }
}