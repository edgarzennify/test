@IsTest
public class LoanBoardingPresenterTests {
    private static final LoanBoardingPresenter sut;
    private static final LoanBoardingMock.ofVmBuilder mockVmBuilder;
    private static final LoanBoardingMock.ofDmBuilder mockNcinoDmBuilder;
    private static final LoanBoardingMock.ofDmBuilder mockLoanForceDmBuilder;
    
    static{
        mockNcinoDmBuilder = new LoanBoardingMock.ofDmBuilder();
        mockLoanForceDmBuilder = new LoanBoardingMock.ofDmBuilder();
        List<LoanBoardingMock.ofDmBuilder> mockDmBuilders = new List<LoanBoardingMock.ofDmBuilder>{mockNcinoDmBuilder,mockLoanForceDmBuilder};
        mockVmBuilder = new LoanBoardingMock.ofVmBuilder();
        sut = new LoanBoardingPresenter(mockDmBuilders, mockVmBuilder);
    }
    
    @IsTest
    static void given_ncino_loanId_it_should_return_this_vmLoan() {
        Id loanId = ObjectFactory.getFakeId(LLC_BI__Loan__c.SObjectType, '1');
        DmLoan dmLoan = new DmLoan();
        dmLoan.Name = 'test-loan';

        mockNcinoDmBuilder.setup('isType').returns(loanId.getSobjectType());
        mockNcinoDmBuilder.setup('buildDmLoan', new List<Object>{loanId}).returns(dmLoan);
        mockVmBuilder.setup('buildFormVm', new List<Object>{dmLoan}).returns(new LoanBoarding.FormVm());
        //act
        LoanBoarding.FormVm results = sut.build(loanId);
        //assert
        mockNcinoDmBuilder.verify('isType', Times.Once);
        mockNcinoDmBuilder.verify('buildDmLoan', new List<Object>{loanId}, Times.Once);
        mockVmBuilder.verify('buildFormVm', new List<Object>{dmLoan}, Times.Once);
    }

    @IsTest
    static void given_loanforce_loanId_it_should_return_this_vmLoan() {
        Id loanId = ObjectFactory.getFakeId(EB_Loan_Application__c.SObjectType, '1');
        DmLoan dmLoan = new DmLoan();
        dmLoan.Name = 'test-loan';

        mockLoanForceDmBuilder.setup('isType').returns(loanId.getSobjectType());
        mockLoanForceDmBuilder.setup('buildDmLoan', new List<Object>{loanId}).returns(dmLoan);
        mockVmBuilder.setup('buildFormVm', new List<Object>{dmLoan}).returns(new LoanBoarding.FormVm());
        //act
        LoanBoarding.FormVm results = sut.build(loanId);
        //assert
        mockLoanForceDmBuilder.verify('isType', Times.Once);
        mockLoanForceDmBuilder.verify('buildDmLoan', new List<Object>{loanId}, Times.Once);
        mockVmBuilder.verify('buildFormVm', new List<Object>{dmLoan}, Times.Once);
    }
}