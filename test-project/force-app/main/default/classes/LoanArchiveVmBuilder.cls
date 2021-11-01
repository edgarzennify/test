public class LoanArchiveVmBuilder implements LoanArchive.IVmBuilder {
    
    private final String RECORD_TYPE_PROSPECT = 'Prospect';
    private final String RECORD_TYPE_CLIENT = 'Client';
    
     public List<LoanArchive.MergeObjectVm> buildEntityMergeList(List<LLC_BI__Legal_Entities__c> involvements){
        Map<Id,LoanArchive.MergeObjectVm> vms = new Map<Id,LoanArchive.MergeObjectVm>();
        for(LLC_BI__Legal_Entities__c involvement : involvements){
            Account entity = involvement.LLC_BI__Account__r;
            if(isProspect(entity)){

                LoanArchive.MergeObjectVm vm = new LoanArchive.MergeObjectVm();
                vm.description = getDescription(entity);
                vm.objectId = entity.Id;
                vm.createdDate = entity.CreatedDate;
                vms.put(vm.objectId, vm);
            }
        }
        return vms.values();
    }

    public List<LoanArchive.MergeObjectVm> buildEntityCoreMergeList(List<SelectOption> selectedOptions, List<LLC_BI__Legal_Entities__c> involvements){
        List<LoanArchive.MergeObjectVm> vms = new List<LoanArchive.MergeObjectVm>();
        for(SelectOption o : selectedOptions){
            for(LLC_BI__Legal_Entities__c involvement : involvements){
                Account core = involvement.LLC_BI__Account__r;
                String selectedOptionId = o.getValue();
                if((core != null && selectedOptionId != '0')  && core.Id == selectedOptionId){
                    LoanArchive.MergeObjectVm vm = new LoanArchive.MergeObjectVm();
                    vm.description = getDescription(core);
                    vm.objectId = core.Id;
                    vm.createdDate = core.CreatedDate;
                    vms.add(vm);
                }
            }
        }
        return vms;
    }
    
    public List<LoanArchive.MergeObjectVm> buildCollateralMergeList(List<LLC_BI__Loan_Collateral2__c> pledged){
        Map<Id,LoanArchive.MergeObjectVm> vms = new Map<Id,LoanArchive.MergeObjectVm>();
        for(LLC_BI__Loan_Collateral2__c pledge : pledged){
            LLC_BI__Collateral__c collateral = pledge.LLC_BI__Collateral__r;
            if(isProspect(collateral)){
                LoanArchive.MergeObjectVm vm = new LoanArchive.MergeObjectVm();
                vm.description = getDescription(pledge);
                vm.objectId = collateral.Id;
                vm.createdDate = collateral.CreatedDate;
                vms.put(vm.objectId, vm);
            }
        }
        return vms.values();
    }

    public List<LoanArchive.MergeObjectVm> buildCollateralCoreMergeList(List<SelectOption> selectedOptions, List<LLC_BI__Loan_Collateral2__c> pledged){
        List<LoanArchive.MergeObjectVm> vms = new List<LoanArchive.MergeObjectVm>();
        for(SelectOption o : selectedOptions){
            for(LLC_BI__Loan_Collateral2__c pledge : pledged){
                LLC_BI__Collateral__c core = pledge.LLC_BI__Collateral__r;
                String selectedOptionId = o.getValue();
                if((core != null && selectedOptionId != '0')  && core.Id == selectedOptionId){
                    LoanArchive.MergeObjectVm vm = new LoanArchive.MergeObjectVm();
                    vm.description = getDescription(pledge);
                    vm.objectId = core.Id;
                    vm.createdDate = core.CreatedDate;
                    vms.add(vm);
                }
            }
        }
        return vms;
    }
    
    public List<SelectOption> buildCoreEntityOptions(List<LLC_BI__Legal_Entities__c> involvements){
        Map<String,SelectOption> options = new Map<String,SelectOption>();
        for(SelectOption o: defaultOptions()) {
            options.put(o.getLabel(), new SelectOption(o.getValue(), o.getLabel()));
        }
        for(LLC_BI__Legal_Entities__c involvement : involvements){
            Account entity = involvement.LLC_BI__Account__r;
            if(isCore(entity)){
                options.put(entity.Id, new SelectOption(entity.Id, getDescription(entity)));
            }
        }
        return options.values();
    }
    
    public List<SelectOption> buildCoreCollateralOptions(List<LLC_BI__Loan_Collateral2__c> pledged){
        Map<String,SelectOption> options = new Map<String,SelectOption>();
        for(SelectOption o: defaultOptions()) {
            options.put(o.getLabel(), new SelectOption(o.getValue(), o.getLabel()));
        }
        for(LLC_BI__Loan_Collateral2__c pledge : pledged){
            LLC_BI__Collateral__c collateral = pledge.LLC_BI__Collateral__r;
            if(isCore(collateral)){
                options.put(collateral.Id, new SelectOption(collateral.Id, getDescription(pledge)));
            }
        }
        return options.values();
    }

    private String getDescription(Account entity){
        if(entity == null) return '';

        String name = removeTick(entity.Name);
        if(String.isBlank(entity.EB_Client_Name__c)) {
            return name;
        }
        String clientName = removeTick(entity.EB_Client_Name__c);
        if(entity.Name.toUpperCase() == entity.EB_Client_Name__c.toUpperCase()) {
            return clientName;
        }
        return String.format('{0} ({1})', new List<String>{clientName, name});
    }
    
    private String getDescription(LLC_BI__Loan_Collateral2__c pledge){
        LLC_BI__Collateral__c collateral = pledge.LLC_BI__Collateral__r;
        String name = collateral.LLC_BI__Collateral_Name__c;
        if(String.isBlank(name)){
            name = collateral.Name;
        }
        String description = pledge.Description__c;
        if(String.isBlank(description)){
            description = String.isBlank(collateral.LLC_BI__Description__c) ? collateral.LLC_BI__Collateral_Type__r.Name : collateral.LLC_BI__Description__c;       
        }
        String owner = getDescription(collateral.Primary_Owner__r);
        return String.format('{0} | {1} ({2})', new List<String>{ name, description, owner });
    }
    
    private Boolean isProspect(Account entity){
        return entity.RecordType.Name == RECORD_TYPE_PROSPECT;
    }
    
    private Boolean isCore(Account entity){
        return entity.RecordType.Name == RECORD_TYPE_CLIENT;
    }
    
    private Boolean isProspect(LLC_BI__Collateral__c collateral){
        return String.isBlank(collateral.Sync_Key__c);
    }
    
    private Boolean isCore(LLC_BI__Collateral__c collateral){
        return !isProspect(collateral);
    }
    
    private List<SelectOption> defaultOptions(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('0', '--None--'));
        return options;
    }

    private String removeTick(String description) {
        return description.replace('\'', '`');
    }
}