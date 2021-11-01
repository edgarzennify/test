@IsTest
private class TmBoardingViewVmBuilderTests {
    
    private static TmBoardingViewVmBuilder sut;
    
    static {
        sut = new TmBoardingViewVmBuilder();
    }
    
    @IsTest
    static void it_should_get_view_handle() {
        TmConfiguration.Placement result = sut.getType();
        
        System.assertEquals(TmConfiguration.Placement.View, result);
    }
    
    @IsTest
    static void it_should_build_view_vm_fields() {
        DmField fld = new DmField();
        fld.Name = 'test-field';
        fld.IsAccessible = true;
        fld.View = true;
        fld.ViewPlacement = 2.00;
        List<DmField> fields = new List<DmField>{fld};
        TmBoardingMock.ofIVmFieldBuilder mockFieldBuilder = new TmBoardingMock.ofIVmFieldBuilder();
        
        List<TmBoarding.Field> result = sut.build(fields, mockFieldBuilder);

        mockFieldBuilder.verify('build', new List<Object>{fld, fld.ViewPlacement}, Times.Once);
    }
}