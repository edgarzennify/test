public class TmBoardingVmFieldBuilder implements TmBoarding.IVmFieldBuilder {
	private final TmBoarding.IInputTypeVmBuilder m_inputTypeBuilder;
	public TmBoardingVmFieldBuilder(TmBoarding.IInputTypeVmBuilder inputTypeBuilder) {
		m_inputTypeBuilder = inputTypeBuilder;
	}
    public TmBoarding.Field build(DmField dm) {
        try{
        TmBoarding.Field fieldVm = new TmBoarding.Field();
        fieldVm.Label = dm.label;
        fieldVm.Name = getName(dm.ObjectName, dm.Name);
        fieldVm.InputType = getInputType(m_inputTypeBuilder.build(dm.Type, ''), dm.SectionGroupType);
        fieldVm.Multilist = dm.sectionGroupName;
        fieldVm.ObjectId = String.format('{0}.Id', new LIST<String>{dm.ObjectName});
        fieldVm.ObjectName = dm.ObjectName;
        fieldVm.SortOrder = dm.SortBySelectedPlacement == null 
                            ? 0 : Integer.valueof(dm.SortBySelectedPlacement);
        fieldVm.HelpText = String.IsNotBlank(dm.HelpText)? dm.HelpText : '';
        fieldVm.Options = getPicklistOptions(fieldVm.InputType, dm);
        fieldVm.Correlated = dm.correlated;
        if(String.isNotBlank(dm.AlternateName)){
            fieldVm.AlternateName = getName(dm.ObjectName,dm.AlternateName);
        }
        fieldVm.Readonly = dm.Readonly;
        return fieldVm;
        }catch(exception ex) {

        }
        return null;
    }

    public TmBoarding.Field build(DmField dm, Decimal sortOrder) {
        try{
        TmBoarding.Field fieldVm = new TmBoarding.Field();
        fieldVm.Label = dm.label;
        fieldVm.Name = getName(dm.ObjectName, dm.name);
        fieldVm.InputType = getInputType(m_inputTypeBuilder.build(dm.Type, ''), dm.SectionGroupType);
        fieldVm.Multilist = dm.sectionGroupName;
        fieldVm.ObjectId = String.format('{0}.Id', new LIST<String>{dm.ObjectName});
        fieldVm.ObjectName = dm.ObjectName;
        fieldVm.SortOrder = sortOrder == null 
                            ? 0 : Integer.valueof(sortOrder);
        fieldVm.HelpText = String.IsNotBlank(dm.HelpText)? dm.HelpText : '';
        fieldVm.Options = getPicklistOptions(fieldVm.InputType, dm);
        fieldVm.Correlated = dm.correlated;
        if(String.isNotBlank(dm.AlternateName)){
            fieldVm.AlternateName = getName(dm.ObjectName, dm.AlternateName);
        }
        fieldVm.Readonly = dm.Readonly;
        return fieldVm;
        }catch(exception ex) {
        }
        return null;
    }

    private string getInputType(String inputType, String overrideType) {
    	return String.isBlank(overrideType) ? inputType : overrideType;
    }
    private string getName(String ObjectName , String fieldName) {
        return String.isNotBlank(ObjectName) 
               ? String.format('{0}.{1}', new LIST<String>{ObjectName, fieldName})
               : fieldName; 
    }

    private List<Tmboarding.FieldOption> getPicklistOptions(string input ,DmField fld) {
        List<Tmboarding.FieldOption> tmOptions = new List<Tmboarding.FieldOption>();
        if(string.isBlank(input) || String.IsBlank(fld.Name)){return tmOptions; }
        if(isPicklist(fld) == true) {
            if(fld.Picklist == null){
                return tmOptions;
            }
            
            Integer counter = 0;

            TmBoarding.FieldOption emptyOption = new TmBoarding.FieldOption();
            emptyOption.Label = '--None--';
            emptyOption.Value = '';
            emptyOption.SortOrder = counter;
            tmOptions.add(emptyOption);
            counter++;

            for(IPicklistEntry o : fld.picklist) {
                TmBoarding.FieldOption tmso = new TmBoarding.FieldOption();
                tmso.Label = o.getLabel();
                tmso.Value = o.getValue();
                tmso.SortOrder = counter;
                tmOptions.add(tmso);
                counter++;
            }
        }
        return tmOptions;
    }

    private Boolean isPicklist(DmField fld) {
       return  fld.Type == DescribeFieldResultWrapper.Type.TypePicklist || fld.Type == DescribeFieldResultWrapper.Type.TypeMultipicklist;
    }
}