public class LoanArchiveValidator implements LoanArchive.IValidator {

    private String ENTITY = 'entity';
    private String COLLATERAL = 'collateral';
    private String ENTITY_CREATED_DAYS_KEY = 'ArchiveEntityValidDateOfCreation';
    private String COLLATERAL_CREATED_DAYS_KEY = 'ArchiveCollateralValidDateOfCreation';
    private String ERROR_ENTITY_CREATED_DATE_OLD = 'Error : Created Date {0} of {1} {2} is too old for merge. Please call IT for manual merge';
    private String ERROR_NOT_MAPPED = '"{0}" is not mapped to a Core {1}';
    private String ERROR_MAPPED_TO_SAME_CORE ='"{0}" and "{1}" are mapped to the same Core {2}';
    
    private Configurations.IConfigurations m_configs;
    private ISystem m_sys;

    public LoanArchiveValidator(Configurations.IConfigurations configs, ISystem sys) {
        m_configs = configs;
        m_sys = sys;
    }

    public List<string> validateCoreAge(List<LoanArchive.MergeObjectVm> prospectVms, List<LoanArchive.MergeObjectVm> coreVms , String objType){
        List<String> errors = new List<String>();
        Map<String, LoanArchive.MergeObjectVm> coreLookup = new Map<String, LoanArchive.MergeObjectVm>();
        for(LoanArchive.MergeObjectVm vm : coreVms){
            coreLookup.put(vm.ObjectId , vm);
        }
        
        Integer createdDaysLimit = getDays(objType);
        Datetime currentDate = m_sys.now();     
        Datetime testDate = currentDate.addDays(-createdDaysLimit);
        for(LoanArchive.MergeObjectVm vm : prospectVms) {
            if(vm.selectedOptionId != null && vm.selectedOptionId != '0') {
                LoanArchive.MergeObjectVm selectedCore = coreLookup.get(vm.selectedOptionId);
                if(selectedCore != null && testDate > selectedCore.createdDate){
                    String dateMessage = '(' + string.valueof(selectedCore.createdDate.format('MM/dd/yyyy')) + ')';
                    errors.add(String.Format(ERROR_ENTITY_CREATED_DATE_OLD, new List<String>{dateMessage, objType, selectedCore.description}));
                }
            }
        }   
        return errors;
    }

    public List<String> validateCoreMerge(List<LoanArchive.MergeObjectVm> vms, String objType){
        List<String> errors = new List<String>();
        Map<String, LoanArchive.MergeObjectVm> selectedIds = new Map<String, LoanArchive.MergeObjectVm>();
        for(LoanArchive.MergeObjectVm vm : vms){
            String thisOptionId = vm.selectedOptionId;
            if(thisOptionId == '0'){
                errors.add(String.format(ERROR_NOT_MAPPED, new List<String>{vm.description,objType}));
            }else if(selectedIds.containsKey(thisOptionId)){
                LoanArchive.MergeObjectVm otherVm = selectedIds.get(thisOptionId);
                errors.add(String.format(ERROR_MAPPED_TO_SAME_CORE, new List<String>{vm.description,otherVm.description,objType}));
            }
            selectedIds.put(thisOptionId, vm);
        }
        return errors;
    }

    private Integer getDays(String objType) {      
        if(objType.toLowerCase() == ENTITY) {         
            return Integer.valueOf(m_configs.get(ENTITY_CREATED_DAYS_KEY));
        }
        if(objType.toLowerCase() == COLLATERAL) {
            return Integer.valueOf(m_configs.get(COLLATERAL_CREATED_DAYS_KEY));
        }

        throw new UnknownObjTypeException();
    }

    public class UnknownObjTypeException extends Exception{}

}