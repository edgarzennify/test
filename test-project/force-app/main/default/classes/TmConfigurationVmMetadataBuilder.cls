public class TmConfigurationVmMetadataBuilder implements TmConfiguration.IVmMetadataBuilder {

    public List<TmConfiguration.FormSection> build(List<DmSection> sections) {
    	List<TmConfiguration.FormSection> vms = new List<TmConfiguration.FormSection>();
    	for(DmSection dm : sections) {
    		vms.add(buildOne(dm));
    	}
    	return vms;
    }
   
    public List<TmConfiguration.FormSection> buildDetails(String objectName , List<DmSection> detailSections, List<DmSection> scheduleSections) {
    	List<TmConfiguration.FormSection> vms = new List<TmConfiguration.FormSection>();
    	Map<String ,DmSection> schedules = new Map<String, DmSection>();

    	for(DmSection dm : scheduleSections) {
    		schedules.put(dm.lookup, dm);
    	}

    	for(DmSection dm : detailSections) {
    		TmConfiguration.formSection section = buildOne(dm);
    		for(DmField fld : dm.Fields) {
    			if(schedules.containsKey(fld.name)) {
    				DmSection scheduleSection = schedules.get(fld.name);
    				if(section.DependentFields == null) {section.DependentFields = new List<TmConfiguration.FormSection>();}
    				section.DependentFields.add(buildSchedule(scheduleSection));
    			}
    		}

    		vms.add(section);
    	}

    	return vms;
    }

    public List<TmConfiguration.ObjectField> getObjectFields(String objectName, DmSection allFieldsSection) {
    	List<TmConfiguration.ObjectField> allObjectFields = new List<TmConfiguration.ObjectField>();
    	for(DmField fld : allFieldsSection.Fields) {
    		//if(fld.IsCreatable == true) {
	    		TmConfiguration.ObjectField ofld = new TmConfiguration.ObjectField();
	    		ofld.Name = fld.Name;
	    		ofld.Label = fld.Label;
	    		ofld.ObjectName = fld.ObjectName;
	    		ofld.InputType = getInputType(fld);
	    		ofld.Updatable = fld.IsUpdatable;
	    		allObjectFields.add(ofld);
    		//}
    	}
    	allObjectFields.sort();
    	return allObjectFields;
    }

    private TmConfiguration.FormSection buildOne(DmSection dm) {
    	TmConfiguration.FormSection newSection = new TmConfiguration.FormSection();
		newSection.Id = dm.Id;
		newSection.name = dm.name;
		newSection.columns = Integer.valueOf(dm.columns);
		newSection.visible = dm.show;
		newSection.sortOrder = dm.placement;
		newSection.fields = buildFields(dm.fields);
		return newSection;
    }

    private TmConfiguration.FormSection buildSchedule( DmSection scheduleSection) {
    	TmConfiguration.FormSection section = buildOne(scheduleSection);
    	section.name = scheduleSection.Lookup;
    	return section;
    }

    private List<TmConfiguration.ConfigurationField> buildFields(List<DmField> dms) {
    	List<TmConfiguration.ConfigurationField> vms = new List<TmConfiguration.ConfigurationField>();
    	if(dms == null || dms.size() == 0) return vms;
    	for(DmField dm : dms) {
    		TmConfiguration.ConfigurationField vm = new TmConfiguration.ConfigurationField();
    		vm.name = dm.name;
    		vm.objectName = dm.objectName;
    		vm.view = dm.view;
    		vm.edit = dm.edit;
    		vm.report = dm.report;
    		vm.editPlacement = dm.editPlacement;
    		vm.viewPlacement = dm.viewPlacement;
    		vm.reportPlacement = dm.reportPlacement;
    		vms.add(vm);
    	}
    	return vms;
    }

    private string getInputType(DmField fld) {

    	if(fld.Type == DescribeFieldResultWrapper.Type.TypePhone) {
    		return 'Phone';
    	} else if(fld.Type == DescribeFieldResultWrapper.Type.TypeTextArea) {
    		return 'TextArea';
    	} else if(fld.Type == DescribeFieldResultWrapper.Type.TypeCurrency) {
    		return 'Currency';
    	} else if(fld.Type == DescribeFieldResultWrapper.Type.TypeDate || fld.Type == DescribeFieldResultWrapper.Type.TypeDateTime) {
    		return 'Date';
    	} else if(fld.Type == DescribeFieldResultWrapper.Type.TypeInteger || fld.Type == DescribeFieldResultWrapper.Type.TypeDouble) {
    		return 'Numeric';
    	} else if(fld.Type == DescribeFieldResultWrapper.Type.TypePicklist) {
    		return 'Dropdown';
    	} else if(fld.Type == DescribeFieldResultWrapper.Type.TypeBoolean) {
    		return 'Checkbox';
    	} else if(fld.Type == DescribeFieldResultWrapper.Type.TypeMultipicklist) {
            return 'MultiPicklist';
        }

    	return 'Text';
    }
}