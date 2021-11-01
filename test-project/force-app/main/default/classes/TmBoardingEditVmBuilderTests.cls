@IsTest
private class TmBoardingEditVmBuilderTests {
	
	private static TmBoardingEditVmBuilder sut;
    
    static {
        sut = new TmBoardingEditVmBuilder();
    }
    
    @IsTest
    static void it_should_get_edit_type_when_get_type_is_called() {
        TmConfiguration.Placement result = sut.getType();
        
        System.assertEquals(TmConfiguration.Placement.Edit, result);
    }

    @IsTest
    static void it_should_build_vm_builder() {
    	TmBoarding.Field fld = new TmBoarding.Field();
    	fld.name = 'field-name';
    	DmField dm = new DmField();

    	dm.IsAccessible = true ;
    	dm.Edit = true;
        dm.IsUpdatable = true;
    	List<DmField> fields = new List<DmField>{dm};
    	TmBoardingMock.ofIVmFieldBuilder mockVmFieldBuilder = new TmBoardingMock.ofIVmFieldBuilder();
    	mockVmFieldBuilder.setup('build', new List<Object>{dm, dm.EditPlacement}).returns(fld);

    	List<TmBoarding.Field> result =  sut.build(fields, mockVmFieldBuilder);

    	mockVmFieldBuilder.verify('build', new List<Object>{dm, dm.EditPlacement}, Times.Once);
    }
}