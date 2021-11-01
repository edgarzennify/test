public class LoanBoardingPresenter implements LoanBoarding.IPresenter {

	private final LoanBoarding.IVmBuilder m_vmBuilder;
	private final List<LoanBoarding.IDmBuilder> m_dmBuilders;

	public LoanBoardingPresenter(List<LoanBoarding.IDmBuilder> dmBuilders, LoanBoarding.IVmBuilder vmBuilder) {
		m_dmBuilders = dmBuilders;
		m_vmBuilder = vmBuilder;
	}

	public LoanBoarding.FormVm build(Id loanId) {       
		LoanBoarding.IDmBuilder dmBuilder = determineDmBuilder(loanId);
		DmLoan dmLoan = dmBuilder.buildDmLoan(loanId);
		return m_vmBuilder.buildFormVm(dmLoan);
	}

	private LoanBoarding.IDmBuilder determineDmBuilder(Id loanId) {
        SObjectType loanSObjType = loanId.getSobjectType();
        for (LoanBoarding.IDmBuilder builder : m_dmBuilders) {
            if (builder.isType() == loanSObjType) {
				return builder;
            }
		}
        return null;
    }
}