public class TmBoardingVmBuilder implements TmBoarding.IVmBuilder {

    private final TmBoarding.IInputTypeVmBuilder m_inputTypeBuilder;
    private final TmBoarding.IVmFieldBuilder m_fieldBuilder;
    private final List<TmBoarding.IVmMetadataTypeBuilder> m_metadataBuilders;
    private final TmBoarding.IVmBuilderHelper m_vmHelper;
    private final CardRepository.ICardRepository m_cardRepository;

    public TmBoardingVmBuilder(TmBoarding.IInputTypeVmBuilder inputTypeBuilder, TmBoarding.IVmFieldBuilder fieldBuilder, List<TmBoarding.IVmMetadataTypeBuilder> metadataBuilders, TmBoarding.IVmBuilderHelper vmHelper, CardRepository.ICardRepository cardRepository) {
        m_inputTypeBuilder = inputTypeBuilder;
        m_fieldBuilder = fieldBuilder;
        m_metadataBuilders = metadataBuilders;
        m_vmHelper = vmHelper;
        m_cardRepository = cardRepository;
    }

    public TmBoarding.FormComponent buildDetails(List<DmSection> allDetailDms, List<DmSection> allDependentDms, TmBoarding.DataComponent dataComponent) {
           
        TmBoarding.FormComponent component = new TmBoarding.FormComponent();
        component.EditMetadata = new TmBoarding.FormMetadata();
        component.ViewMetadata = new TmBoarding.FormMetadata();
        TmBoarding.IVmMetadataTypeBuilder edit = findTypeBuilder(TmConfiguration.Placement.Edit);
        TmBoarding.IVmMetadataTypeBuilder view = findTypeBuilder(TmConfiguration.Placement.View);
        
        List<TmBoarding.FormSection> editSections = new List<TmBoarding.FormSection>();
        List<TmBoarding.FormSection> viewSections = new List<TmBoarding.FormSection>();

        Map<string, DmSection> allDependentMap = new Map<string, DmSection>();
        for(DmSection s : allDependentDms) {
            allDependentMap.put(s.Lookup, s);
        }

        for(DmSection dm : allDetailDms) {
            TmBoarding.FormSection editSection = buildOneSection(dm, edit, allDependentMap);
            TmBoarding.FormSection viewSection = buildOneSection(dm, view, allDependentMap);
           
            if(editSection != null && editSection.fields.size() > 0){editSections.add(editSection);}
            if(viewSection != null && viewSection.fields.size() > 0){viewSections.add(viewSection);}
        }

        editSections.sort();
        viewSections.sort();
        component.EditMetadata.Sections = editSections;
        component.ViewMetadata.Sections = viewSections;
        component.Data = dataComponent.Data;
        
        return component;
    }

    public TmBoarding.FormComponent buildContacts(List<DmSection> allContactDms, TmBoarding.DataComponent dataComponent) {
        return build(allContactDms, dataComponent);
    }

    public TmBoarding.FormComponent buildAccounts(List<DmSection> allAccountDms, TmBoarding.DataComponent dataComponent) {
        return build(allAccountDms, dataComponent);
    }

    public TmBoarding.LayoutComponent2 getPacket(TmBoarding.RequestPm pm, List<DmRecordType> products, Map<string, TmConfiguration.ProductInfo> productInfos, List<DmTmRequestStage> stageDms){
        return m_vmHelper.getPacket(pm, products, productInfos, stageDms);
    }
    public TmBoarding.LayoutComponent getEntity(TmBoarding.RequestPm pm) {
        return m_vmHelper.getEntity(pm);
    }
    public TmBoarding.LayoutComponentStage buildStages(TM_Service_Request__c record, DmTmRequestStage stageDm) {
        return m_vmHelper.buildStages(record, stageDm);
    }
    public TmBoarding.LayoutComponentPermission getPermission(DmTmRequestStage stage) {
        return m_vmHelper.getPermission(stage);
    }

    public TmBoarding.FormComponent buildContactAccount(TM_Service_Request__c record) {
        return null;
    }

    public TmBoarding.FormComponent buildAccountContact(TM_Service_Request__c record) {
        return null;
    }

    public List<TmBoarding.LayoutPickList> getAccountTypes() {
        List<TmBoarding.LayoutPickList> options = new List<TmBoarding.LayoutPickList>();
        List<DmCardInformation> tmCards =  m_cardRepository.getTmCards();
        TmBoarding.LayoutPickList noneOption = new TmBoarding.LayoutPickList();
        noneOption.Label = '--None--';
        noneOption.Value = '';
        options.add(noneOption);
        if(tmCards == null || tmCards.size() == 0) {return options;}
        for(DmCardInformation card : tmCards) {
            TmBoarding.LayoutPickList option = new TmBoarding.LayoutPickList();
            option.label = card.cardType;
            option.value = card.apiResource;
            options.add(option);
        }
        return options;
    }

    public List<TmBoarding.LayoutComponentStage> getAllStages(List<DmTmRequestStage> stageDms) {
        List<TmBoarding.LayoutComponentStage> stageVms = new List<TmBoarding.LayoutComponentStage>();
        if(stageDms == null || stageDms.size() == 0) { return stageVms;}

        for(DmTmRequestStage dm : stageDms) {
            TmBoarding.LayoutComponentStage ls = new TmBoarding.LayoutComponentStage();
            ls.Id = dm.Id;
            ls.Name = dm.Name;
            ls.StageType = dm.type;
            stageVms.add(ls);
        }

        return stageVms;
    }

    public TmBoarding.ExistingDataValidationVm build(List<DmTmRequestStage> stageDms , Map<string, List<TmValidator.ValidationResult>> validationResults) {
        TmBoarding.ExistingDataValidationVm vm = new TmBoarding.ExistingDataValidationVm();
        List<TmBoarding.LayoutComponentStage> stageVms = new List<TmBoarding.LayoutComponentStage>();
        Map<string, DmTmRequestStage> stageLookup = new Map<string, DmTmRequestStage>();

        if(validationResults == null || validationResults.keySet().size() == 0) {return vm; }

        for(DmTmRequestStage dm : stageDms) {
            if(!stageLookup.containsKey(dm.id)) {
                stageLookup.put(dm.Id, dm);
            }
        }

        for(String stageId : validationResults.keySet()) {
            TmBoarding.LayoutComponentStage stageVm = new TmBoarding.LayoutComponentStage();
            DmTmRequestStage currentStage = stageLookup.get(stageId);
            if(currentStage != null) {
                stageVm.Id = stageId;
                stageVm.Name = currentStage.name;
                stageVm.StageType = currentStage.type;
                stageVms.add(stageVm);
            }

        }

        vm.StageDetails = stageVms;
        vm.ValidationsByStage = validationResults;

        return vm;
    }

    private TmBoarding.FormComponent build(List<DmSection> allDms, TmBoarding.DataComponent dataComponent) {
        TmBoarding.FormComponent component = new TmBoarding.FormComponent();
        component.EditMetadata = new TmBoarding.FormMetadata();
        component.ViewMetadata = new TmBoarding.FormMetadata();
        TmBoarding.IVmMetadataTypeBuilder edit = findTypeBuilder(TmConfiguration.Placement.Edit);
        TmBoarding.IVmMetadataTypeBuilder view = findTypeBuilder(TmConfiguration.Placement.View);

        List<TmBoarding.FormSection> editSections = new List<TmBoarding.FormSection>();
        List<TmBoarding.FormSection> viewSections = new List<TmBoarding.FormSection>();

        for(DmSection dm : allDms) {
            TmBoarding.FormSection editSection = buildOneSection(dm, edit, null);
            TmBoarding.FormSection viewSection = buildOneSection(dm, view, null);
           
            if(editSection != null && editSection.fields.size() > 0){editSections.add(editSection);}
            if(viewSection != null && viewSection.fields.size() > 0){viewSections.add(viewSection);}
        }

        editSections.sort();
        viewSections.sort();
        viewSections = consolidatedSections(viewSections);
        component.EditMetadata.Sections = editSections;
        component.ViewMetadata.Sections = viewSections;

        component.Data = dataComponent.Data;
        
        return component;
    }

    private TmBoarding.IVmMetadataTypeBuilder findTypeBuilder(TmConfiguration.Placement placement) {
        for(TmBoarding.IVmMetadataTypeBuilder vm : m_metadataBuilders) {

            if(vm.getType() == placement) {
                return vm;
            }
        }
        return null;
    }

    private TmBoarding.FormSection buildOneSection(DmSection dm,TmBoarding.IVmMetadataTypeBuilder typeBuilder, Map<string, DmSection> dependents ) {
        if(dm.Fields != null && dm.Fields.size() > 0 ) {
            TmBoarding.FormSection sectionVm = new TmBoarding.FormSection();
            sectionVm.Name = dm.Show == true ? dm.Name : '.';
            sectionVm.Columns = dm.Columns == null? 0:Integer.valueOf(dm.Columns);
            sectionVm.Visible = dm.Show;
            sectionVm.PrimaryKeyFieldName = dm.lookup;

            sectionVm.Fields = dm.Fields != null && dm.Fields.size() > 0 
                                    ? typeBuilder.build(dm.Fields, m_fieldBuilder)
                                    : null;
            sectionVm.SortOrder = dm.Placement;
            sectionVm.DependentFields = dependents !=null && dependents.size() > 0
                                        ? buildDependents(dependents,dm.Fields, typeBuilder)
                                        : new List<TmBoarding.DependentFields>();

            return sectionVm;
        }
        return null;
    }

    private List<TmBoarding.DependentFields> buildDependents(Map<string, DmSection> dependents, List<DmField> fields, TmBoarding.IVmMetadataTypeBuilder typeBuilder) {
        List<TmBoarding.DependentFields> vms = new List<TmBoarding.DependentFields>();
        for(DmField f : fields) {
            DmSection section = dependents.get(f.name);
            if(section != null) {
                if(f != null){
                    TmBoarding.DependentFields vm = new TmBoarding.DependentFields();
                    vm.Name = f.Label;
                    vm.Label = section.Label;
                    vm.KeyFieldName = string.format('{0}.{1}', new List<string>{f.ObjectName, section.lookup});
                    vm.type = String.isBlank(section.type)?'':section.type;
                    vm.Fields = typeBuilder.build(section.Fields, m_fieldBuilder);
                    vms.add(vm);
                }
            }
        }
        return vms;
    }

    private List<TmBoarding.FormSection> consolidatedSections(List<TmBoarding.FormSection> sections) {
        if(sections == null || sections.size() == 0) return sections;
        TmBoarding.FormSection consolidated = sections[0];

        consolidated.Name = '.';
        consolidated.SortOrder = 1.00;
        List<TmBoarding.Field> fields = new List<TmBoarding.Field>();
        
        for(TmBoarding.FormSection s : sections) {
            fields.addAll(s.Fields);
        }
        
        fields.sort();
        consolidated.Fields = fields;
        return new List<TmBoarding.FormSection>{consolidated};
    }
}