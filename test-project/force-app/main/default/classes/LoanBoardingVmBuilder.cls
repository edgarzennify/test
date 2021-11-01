public  class LoanBoardingVmBuilder implements LoanBoarding.IVmBuilder {

    private final LoanBoarding.IVmBuilderHelper m_vmBuilderHelper;
    
    public LoanBoardingVmBuilder(LoanBoarding.IVmBuilderHelper vmBuilderHelper) {
        m_vmBuilderHelper = vmBuilderHelper;
    }
    
    public LoanBoarding.FormVm buildFormVm(DmLoan dmLoan) {
        LoanBoarding.FormVm vm = new LoanBoarding.FormVm();
        vm.Loan = m_vmBuilderHelper.buildVmLoan(dmLoan);
        vm.AccountToCustomerRelationships = buildAccountToCustomerRelationships(dmLoan.RelatedEntities);
        
        Map<String, List<LoanBoarding.CollateralVm>> vmCollaterals = buildCollateralVms(dmLoan.PledgedCollateral);
        vm.BorrowerCollateral = vmCollaterals.get('Collateral');
        vm.OtherCollateral = vmCollaterals.get('Other');

        vm.Participations = buildParticipationVms(dmLoan.Participations);
        vm.ChangeMemos = buildChangeMemoVms(dmLoan.Memos);
        vm.PayStreams = buildPayStreamVms(dmLoan.PayStreams);
        vm.RateStreams = buildRateStreamVms(dmLoan.RateStreams);
        
        return vm;
    }

    private List<LoanBoarding.CustomerVm> buildAccountToCustomerRelationships(List<DmLoanEntityRelationship> dms) {
        List<LoanBoarding.CustomerVm> vms = new List<LoanBoarding.CustomerVm>();
        if(dms == null) { return vms; }
        for(DmLoanEntityRelationship dm : dms){
            vms.add(m_vmBuilderHelper.buildAccountToCustomerRelationship(dm));
        }
        vms.sort();
        return vms;
    }

    private Map<String, List<LoanBoarding.CollateralVm>> buildCollateralVms(List<DmLoanCollateralRelationship> dms) {
        Map<String, List<LoanBoarding.CollateralVm>> vmMap = new Map<String, List<LoanBoarding.CollateralVm>>();
        vmMap.put('Collateral', new List<LoanBoarding.CollateralVm>());
        vmMap.put('Other', new List<LoanBoarding.CollateralVm>());
        if(dms == null) { return vmMap; }
        for (DmLoanCollateralRelationship dm : dms) {
            if (dm.IsPrimary) {
                vmMap.get('Collateral').add(m_vmBuilderHelper.buildVmCollateral(dm));
            } else {
                vmMap.get('Other').add(m_vmBuilderHelper.buildVmCollateral(dm));
            }
        }
        return vmMap;
    }

    private List<LoanBoarding.ParticipationVm> buildParticipationVms(List<DmParticipation> dms) {
        List<LoanBoarding.ParticipationVm> vms = new List<LoanBoarding.ParticipationVm>();
        if(dms == null) { return vms; }
        for (DmParticipation dm : dms) {
            vms.add(m_vmBuilderHelper.buildVmParticipation(dm));
        }
        return vms;
    }

    private List<LoanBoarding.MemoVm> buildChangeMemoVms(List<DmMemo> dms) {
        List<LoanBoarding.MemoVm> vms = new List<LoanBoarding.MemoVm>();
        if (dms == null) { return vms; }
        for (DmMemo dm : dms) {
            vms.add(m_vmBuilderHelper.buildVmMemo(dm));
        }
        return vms;
    }

    private List<LoanBoarding.LoanPaymentStreamVm> buildPayStreamVms(List<DmLoanPaymentStream> dms) {
        List<LoanBoarding.LoanPaymentStreamVm> vms = new List<LoanBoarding.LoanPaymentStreamVm>();
        if (dms == null) { return vms; }
        for (DmLoanPaymentStream dm : dms) {
            vms.add(m_vmBuilderHelper.buildVmPayStream(dm));
        }
        return vms;
    }

    private List<LoanBoarding.LoanRateStreamVm> buildRateStreamVms(List<DmLoanRateStream> dms) {
        List<LoanBoarding.LoanRateStreamVm> vms = new List<LoanBoarding.LoanRateStreamVm>();
        if (dms == null) { return vms; }
        for (DmLoanRateStream dm : dms) {
            vms.add(m_vmBuilderHelper.buildVmRateStream(dm));
        }
        return vms;
    }   
}