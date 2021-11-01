@IsTest
private class TmConfigurationPresenterTests {
	
    private static final TmConfigurationPresenter sut;
    private static final TmConfigurationMock.ofIRepository mockRepository;
	private static final TmConfigurationMock.ofIVmBuilder mockVmBuilder;
    
    static {
        mockRepository = new TmConfigurationMock.ofIRepository();
        mockVmBuilder = new TmConfigurationMock.ofIVmBuilder();
        sut = new TmConfigurationPresenter(mockRepository, mockVmBuilder); 
    }
    
    @IsTest
    static void it_should_call_the_repository_to_get_all_objects() {
        String productName = 'Lockbox';
        
        TmConfiguration.FormVm result = sut.build(productName);
        
        mockRepository.verify('getAllObjectSections', Times.Once); 
    }
    
    @IsTest
    static void it_should_call_the_repository_to_get_details() {
        String productName = 'Lockbox';
        String sectionId = 'section-id';
        DmSection sectionDm = new DmSection();
        sectionDm.id = sectionId;
        Map<String, DmSection> sectionMap = new Map<String, DmSection>{sectionID => sectionDm};
        mockRepository.setup('getAllObjectSections').returns(sectionMap); 
        
        TmConfiguration.FormVm result = sut.build(productName);
        
        mockRepository.verify('getDetailSections', new List<Object>{productName, TmConfiguration.Placement.All}, Times.Once);
    }
    
    @IsTest
    static void it_should_get_contacts_from_repository() {
        String productName = 'Lockbox';
        String sectionId = 'section-id';
        DmSection sectionDm = new DmSection();
        sectionDm.id = sectionId;
        Map<String, DmSection> sectionMap = new Map<String, DmSection>{sectionID => sectionDm};
        mockRepository.setup('getAllObjectSections').returns(sectionMap); 
        mockRepository.setup('getDetailSections', new List<Object>{productName, TmConfiguration.Placement.All}).returns(new List<DmSection>());
        
        TmConfiguration.FormVm result = sut.build(productName);
        
        mockRepository.verify('getContactSections', new List<Object>{productName, TmConfiguration.Placement.All}, Times.Once);
    }
    
    @IsTest
    static void it_should_get_accounts_from_repository() {
        String productName = 'Lockbox';
        String sectionId = 'section-id';
        DmSection sectionDm = new DmSection();
        sectionDm.id = sectionId;
        Map<String, DmSection> sectionMap = new Map<String, DmSection>{sectionID => sectionDm};
        mockRepository.setup('getAllObjectSections').returns(sectionMap); 
        mockRepository.setup('getDetailSections', new List<Object>{productName, TmConfiguration.Placement.All}).returns(new List<DmSection>());
        mockRepository.setup('getContactSections', new List<Object>{productName, TmConfiguration.Placement.All}).returns(new List<DmSection>());
        
        TmConfiguration.FormVm result = sut.build(productName);
        
        mockRepository.verify('getAccountSections', new List<OBject>{productName, TmConfiguration.Placement.All}, Times.Once);
    }
}