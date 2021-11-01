@IsTest
private class TmBoardingVmFieldBuilderTests {
	
    private static TmBoardingVmFieldBuilder sut;
    private static final TmBoardingMock.ofIInputTypeVmBuilder mockInputTypeVmBuilder;

    static {
        mockInputTypeVmBuilder = new TmBoardingMock.ofIInputTypeVmBuilder();
        sut = new TmBoardingVmFieldBuilder(mockInputTypeVmBuilder);
    }
    
    @IsTest
    static void it_should_build_a_vm_field() {
        String fieldName = 'test-name';
        DmField dm = new DmField();
        dm.Name = fieldName;
        dm.Type = DescribeFieldResultWrapper.Type.TypeBoolean;
        
        TmBoarding.Field result = sut.build(dm);
        
        System.assertEquals(fieldName , result.name);
    }
    
    @IsTest
    static void it_should_build_a_vm_field_when_dm_and_sort_is_given() {
        String fieldName = 'test-name';
        Mock.ofIPicklistEntry mockofIPicklistEntry = new Mock.ofIPicklistEntry();
        mockofIPicklistEntry.setup('getValue').returns('val');
        mockofIPicklistEntry.setup('getLabel').returns('label');
        Decimal sortOrder = 2.00;
        DmField dm = new DmField();
        dm.Name = fieldName;
        dm.Picklist = new List<IPicklistEntry>{mockofIPicklistEntry};
        dm.Type =  DescribeFieldResultWrapper.Type.TypePicklist;
        mockInputTypeVmBuilder.setup('build', new List<Object>{dm.Type, ''}).returns('Dropdown');
        
        TmBoarding.Field result =  sut.build(dm, sortOrder);
        
        mockofIPicklistEntry.verify('getValue', Times.Once);
        mockofIPicklistEntry.verify('getLabel', Times.Once);
    }

    @IsTest
    static void it_should_build_a_vm_field_when_dm_and_sort_is_given_and_objectName_is_provided() {
        String fieldName = 'test-name';
        String objectName = 'object-name';
        Mock.ofIPicklistEntry mockofIPicklistEntry = new Mock.ofIPicklistEntry();
        mockofIPicklistEntry.setup('getValue').returns('val');
        mockofIPicklistEntry.setup('getLabel').returns('label');
        Decimal sortOrder = 2.00;
        DmField dm = new DmField();
        dm.Name = fieldName;
        dm.objectName = objectName;
        dm.Picklist = new List<IPicklistEntry>{mockofIPicklistEntry};
        dm.Type =  DescribeFieldResultWrapper.Type.TypePicklist;
        mockInputTypeVmBuilder.setup('build', new List<Object>{dm.Type, ''}).returns('Dropdown');
        
        TmBoarding.Field result =  sut.build(dm, sortOrder);
        
        mockofIPicklistEntry.verify('getValue', Times.Once);
        mockofIPicklistEntry.verify('getLabel', Times.Once);
    }
}