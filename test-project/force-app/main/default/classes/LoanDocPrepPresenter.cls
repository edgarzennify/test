public class LoanDocPrepPresenter implements LoanDocPrep.IPresenter {
    
    private final LoanDocPrep.IDataProvider m_dataProvider;
    private final LaserProTransformer.IService m_lpService;
    private final LoanDocPrep.IDmBuilder m_dmBuilder;
    
    public LoanDocPrepPresenter(LoanDocPrep.IDataProvider dataProvider, LaserProTransformer.IService lpService, LoanDocPrep.IDmBuilder dmBuilder){
        m_dataProvider = dataProvider;
        m_lpService = lpService;
        m_dmBuilder = dmBuilder;
    }
    
    public LoanDocPrep.FormVm trialExport(Id loanId){
        DmLoan dm = getLoan(loanId);
        LaserProTransformer.LpLoan lploan =  m_lpService.trialExport(dm);
        return buildVm(dm, lploan);
    }
    
    public LoanDocPrep.GenerateResponseVm generateExportFile(Id loanId){
        DmLoan dm = getLoan(loanId);
        LaserProTransformer.ExportResponse response = m_lpService.export(dm);
        LoanDocPrep.GenerateResponseVm responseVm = new LoanDocPrep.GenerateResponseVm();
        responseVm.status = response.Status;
        if(response.Status.toLowerCase() == 'success'){
            responseVm.message = 'The LaserPro Export file has been generated for this loan and is available for import: "' + response.ExportPath + '"';    
        }else{
            responseVm.message = response.Status;
        }        
        return responseVm;
    }

    private LoanDocPrep.FormVm buildVm(DmLoan dm, LaserProTransformer.LpLoan lploan){
        LoanDocPrep.FormVm vm = new LoanDocPrep.FormVm();
        vm.loanName = dm.name;
        vm.loanAccountNumber = (dm.isRenewal || dm.isModification) ? dm.name : dm.lookupKey;
        vm.loanRenewalFlag = getflag(dm);
        vm.loanId = dm.id;
        vm.loan = lploan;
        vm.includedEntities = getIncludedEntities(lploan.Entities);
        vm.excludedEntities = getExcludedEntities(lploan.Entities);
        vm.includedCollaterals = getIncludedCollaterals(lploan.Collaterals);
        vm.excludedCollaterals = getExcludedCollaterals(lploan.Collaterals);
        return vm;
    }

    private string getflag(DmLoan dm){
        if(dm.isRenewal) return 'Renewal';
        if(dm.isModification) return 'Modification';
        return 'New';
    }

    private DmLoan getLoan(Id loanId){
        LoanDocPrep.NcinoLoanPm pm = new LoanDocPrep.NcinoLoanPm();
        pm.loanApplication = m_dataProvider.getLoan(loanId);        
        pm.loanAppCollaterals =  m_dataProvider.getLoanCollateral(loanId);
        pm.loanAppCollateralOwnerships = m_dataProvider.getLoanCollateralOwnerships(loanId);
        pm.loanAppEntities = m_dataProvider.getLoanEntities(loanId);
        pm.loanAppFees = m_dataProvider.getLoanFees(loanId);
        pm.loanAppOfficer = m_dataProvider.getLoanOfficer(loanId);
        return m_dmBuilder.build(pm);
    }

    private List<LaserProTransformer.LpEntity> getIncludedEntities(List<LaserProTransformer.LpEntity> entities){
        List<LaserProTransformer.LpEntity> filtered = new List<LaserProTransformer.LpEntity>();
        if(entities == null || entities.size() == 0) return filtered;
        for(LaserProTransformer.LpEntity e : entities){
            if(e.ExcludeFromExtract != true){
                filtered.add(e);
            }
        }
        return filtered;
    }

    private List<LaserProTransformer.LpEntity> getExcludedEntities(List<LaserProTransformer.LpEntity> entities){
        List<LaserProTransformer.LpEntity> filtered = new List<LaserProTransformer.LpEntity>();
        if(entities == null || entities.size() == 0) return filtered;
        for(LaserProTransformer.LpEntity e : entities){
            if(e.ExcludeFromExtract == true){
                filtered.add(e);
            }
        }
        return filtered;
    }
    
    private List<LaserProTransformer.LpCollateral> getIncludedCollaterals(List<LaserProTransformer.LpCollateral> collaterals){
        List<LaserProTransformer.LpCollateral> filtered = new List<LaserProTransformer.LpCollateral>();
        if(collaterals == null || collaterals.size() == 0) return filtered;
        for(LaserProTransformer.LpCollateral c : collaterals){
            if(c.ExcludeFromExtract != true){
                filtered.add(c);
            }
        }
        return filtered;
    }

    private List<LaserProTransformer.LpCollateral> getExcludedCollaterals(List<LaserProTransformer.LpCollateral> collaterals){
        List<LaserProTransformer.LpCollateral> filtered = new List<LaserProTransformer.LpCollateral>();
        if(collaterals == null || collaterals.size() == 0) return filtered;
        for(LaserProTransformer.LpCollateral c : collaterals){
            if(c.ExcludeFromExtract == true){
                filtered.add(c);
            }
        }
        return filtered;
    }
}