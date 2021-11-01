public class BarcodeGeneratorVmBuilder implements BarcodeGenerator.IVmBuilder {
    
    private final String CONTEXTID_SOQL_TOKEN = '{!contextId}';
    private final IUserInfoService m_userInfo;
    private final DataProvider.IDataProvider m_dataProvider;
    
    public BarcodeGeneratorVmBuilder(IUserInfoService userInfo, DataProvider.IDataProvider dataProvider){
        m_userInfo = userInfo;
        m_dataProvider = dataProvider;
    }

    public List<BarcodeGenerator.RowVm> buildRows(Integer count){
        List<BarcodeGenerator.RowVm> rows = new List<BarcodeGenerator.RowVm>();
        return addRows(rows, count);
    }
    
    public List<BarcodeGenerator.RowVm> addRows(List<BarcodeGenerator.RowVm> vms, Integer count){
        Integer startingSize = vms.size();
        Integer endingSize = startingSize + count;
        for(Integer i=startingSize; i<endingSize; ++i){
            BarcodeGenerator.RowVm r = new BarcodeGenerator.RowVm();
            r.rowIndex = i;
            r.dateObj = new Grenzsoldat__c();
            vms.add(r);
        }
        return vms;
    }
    
    public List<BarcodeGenerator.CategoryVm> buildCategoryVms(List<DmBgCategory> categories, Id contextId){
        List<BarcodeGenerator.CategoryVm> vms = new List<BarcodeGenerator.CategoryVm>();
        if(categories != null){
            for(DmBgCategory dm : categories){
                String categoryPermissionSetName = dm.permissionSet;
                Boolean addCategory = true;
                if(!String.isBlank(categoryPermissionSetName)){
                    addCategory = m_userInfo.hasPermissionSet(categoryPermissionSetName);
                }
                if(addCategory){
                    BarcodeGenerator.CategoryVm cvm = new BarcodeGenerator.CategoryVm();
                    cvm.name = dm.name;
                    cvm.junctionId = dm.junctionId;
                    cvm.junctionType = dm.junctionType;
                    cvm.doctypes = buildDocTypeOptions(dm.docTypes);
                    cvm.relatedObjects = buildRelatedObjectOptions(dm, contextId);
                    cvm.doctypeVms = buildSelectOptionVms(cvm.doctypes);
                    cvm.relatedObjectVms = buildSelectOptionVms(cvm.relatedObjects);
                    if(cvm.relatedObjects != null && cvm.relatedObjects.size() > 0) {
                        vms.add(cvm);
                    }
                 }
            }
        }
        return vms;
    }
    
    public List<SelectOption> buildCategoryOptions(List<BarcodeGenerator.CategoryVm> vms){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '--None--'));
        for(BarcodeGenerator.CategoryVm vm : vms){
            options.add(new SelectOption(vm.name, vm.name));
        }
        return options;
    }
    
    public BarcodeGenerator.FormSm convertToFormSm(BarcodeGenerator.FormVm vm){
        BarcodeGenerator.FormSm formSm = new BarcodeGenerator.FormSm();
        formSm.batchTitle = vm.batchTitle;
        formSm.contextId = vm.contextId;
        formSm.rows = convertToRowSms(vm.rows);        
        return formSm;
    }
    
    public List<BarcodeGenerator.SelectOptionVm> buildSelectOptionVms(List<SelectOption> selectOptions){
        List<BarcodeGenerator.SelectOptionVm> options = new List<BarcodeGenerator.SelectOptionVm>();
        for(SelectOption selectOption : selectOptions){
            options.add(new BarcodeGenerator.SelectOptionVm(selectOption.getLabel(), selectOption.getValue()));
        }
        return options;
    }

    private List<BarcodeGenerator.RowSm> convertToRowSms(List<BarcodeGenerator.RowVm> vms){
        List<BarcodeGenerator.RowSm> sms = new List<BarcodeGenerator.RowSm>();
        for(BarcodeGenerator.RowVm vm : vms){
            BarcodeGenerator.RowSm sm = new BarcodeGenerator.RowSm();
            sm.rowIndex = vm.rowIndex;
            sm.category = vm.selectedCategoryValue;
            sm.documentType = vm.selectedDocTypeValue;
            sm.objects = vm.selectedObjectValues;
            sm.documentDate = vm.dateObj.Bogus_Date_1__c;
            sm.comment = vm.comment;
            sms.add(sm);
        }
        return sms;
    }
    
    private List<SelectOption> buildDocTypeOptions(List<DmBgDocType> doctypes){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '--None--'));
        for(DmBgDocType dt : doctypes){
            options.add(new SelectOption(dt.name, dt.name));
        }
        return options;
    }  
    
    private List<SelectOption> buildRelatedObjectOptions(DmBgCategory category, String contextId){
        List<SelectOption> options = new List<SelectOption>();
        for(DmBgQuery qdm : category.queries){
            String query = buildQueryFromTemplate(qdm.queryTemplate, contextId);
            if(!String.isBlank(query)){
                List<String> fields = new List<String> { qdm.queryDescription, qdm.queryValue };
                List<DataProvider.DynamicQueryResult> results = m_dataProvider.executeDynamicQuery(query, fields);
                if(results != null && results.size() > 0) {
                    options.addAll(buildOptions(results));
                }
            }else{
                options.add(new SelectOption('N/A','N/A'));
            }
        }
        return Utility.sortOptionList(options);
    }
        
    private String buildQueryFromTemplate(String template, String contextId){
        if(String.isBlank(contextId) || String.isBlank(template) || !template.contains(CONTEXTID_SOQL_TOKEN)){
            return template;
        }else{
            return template.replace(CONTEXTID_SOQL_TOKEN, contextId);
        }            
    }
    
    private List<SelectOption> buildOptions(List<DataProvider.DynamicQueryResult> values){
        List<SelectOption> options = new List<SelectOption>();
        for(DataProvider.DynamicQueryResult result : values){
            String value = String.valueOf(result.fieldValues[1].fieldValue);
            String label = String.valueOf(result.fieldValues[0].fieldValue);
            options.add(new SelectOption(value, label));
        }
        return options;
    }
}