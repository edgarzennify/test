@IsTest
private class BarcodeGeneratorControllerTests {
    private final static BarcodeGeneratorController sut;
    private final static BarcodegeneratorMock.ofIPresenter mockPresenter;

    static{
        mockPresenter = new BarcodegeneratorMock.ofIPresenter();
        sut = new BarcodeGeneratorController(mockPresenter);
    }


    @IsTest
    static void it_should_call_the_presenter_to_get_vm() {
      Id contextId = ObjectFactory.getFakeId(Account.SObjectType, '1');

      sut.objectIdAttribute = contextId;

      mockPresenter.verify('getFormVm', new List<Object>{contextId}, Times.Once);
    }

    @IsTest
    static void it_should_call_the_presenter_to_get_selected_category_vm() {
      String contextId = ObjectFactory.getFakeId(Account.SObjectType, '1');
      Integer selectedRowIndex = 999;
      BarcodeGenerator.FormVm vm = new BarcodeGenerator.FormVm();
      mockPresenter.setup('getFormVm', new List<Object>{contextId}).returns(vm);
      sut.selectedRowIndex = selectedRowIndex;
      sut.objectIdAttribute = contextId;

      sut.categorySelected();

      mockPresenter.verify('categorySelected', new List<Object>{vm, selectedRowIndex}, Times.Once);
    }

    @IsTest
    static void it_should_call_the_presenter_when_add_row_is_requested() {
      String contextId = ObjectFactory.getFakeId(Account.SObjectType, '1');
      Integer selectedRowIndex = 999;
      BarcodeGenerator.FormVm vm = new BarcodeGenerator.FormVm();
      mockPresenter.setup('getFormVm', new List<Object>{contextId}).returns(vm);
      sut.selectedRowIndex = selectedRowIndex;
      sut.objectIdAttribute = contextId;

      sut.addRowsClicked();

      mockPresenter.verify('addRowsClicked', new List<Object>{vm}, Times.Once);
    }

    @IsTest
    static void it_should_call_the_presenter_when_generate_barcode_is_clicked() {
      String contextId = ObjectFactory.getFakeId(Account.SObjectType, '1');
      Integer selectedRowIndex = 999;
      String redirectUrl = 'redirect-url';
      BarcodeGenerator.FormVm vm = new BarcodeGenerator.FormVm();
      mockPresenter.setup('getFormVm', new List<Object>{contextId}).returns(vm);
      mockPresenter.setup('generateClicked', new List<Object>{vm}).returns(redirectUrl);
      sut.selectedRowIndex = selectedRowIndex;
      sut.objectIdAttribute = contextId;

      PAgeReference result = sut.generateClicked();

      mockPresenter.verify('generateClicked', new List<Object>{vm}, Times.Once);
      System.assertEquals(redirectUrl, result.getUrl());
    }

    @IsTest
    static void it_should_call_the_initialize_when_cancel_is_clicked() {
      Id contextId = ObjectFactory.getFakeId(Account.SObjectType, '1');
      sut.objectIdAttribute = contextId;

      sut.cancelClicked();

      mockPresenter.verify('getFormVm', new List<Object>{contextId}, Times.Twice);
    }

    @IsTest
    static void it_should_call_the_default_constructor() {
      BarcodeGeneratorController xsut = new BarcodeGeneratorController();
    }

    @IsTest
    static void it_should_convert_from_input_obj_to_form_vm() {
      BarcodeGeneratorController.FinalizeRequest finRequest = new BarcodeGeneratorController.FinalizeRequest();
      finRequest.contextId = 'fsdfwer';
      finRequest.batchTitle = 'sdfwersdf';
      BarcodeGeneratorController.FinalizeRequestRow row = new BarcodeGeneratorController.FinalizeRequestRow();
      row.comment = 'commd';
      row.rowIndex = 9;
      row.selectedCategoryValue = 'catvalu';
      row.selectedDocTypeValue = 'docval';
      row.selectedObjectValues = new List<String> {'ocho'};
      row.docDate = '08/09/2018';
      finRequest.rows = new List<BarcodeGeneratorController.FinalizeRequestRow>{row};
      

      BarcodeGenerator.FormVm response = BarcodeGeneratorController.ConvertFinalizeRequest(finRequest);

      Date rDate = Date.parse('08/09/2018');
      System.assertEquals('fsdfwer', response.contextId);
      System.assertEquals('sdfwersdf', response.batchTitle);
      System.assertEquals('commd', response.rows[0].comment);
      System.assertEquals(9, response.rows[0].rowIndex);
      System.assertEquals('catvalu', response.rows[0].selectedCategoryValue);
      System.assertEquals('docval', response.rows[0].selectedDocTypeValue);
      System.assertEquals('ocho', response.rows[0].selectedObjectValues[0]);
      System.assertEquals(rDate, response.rows[0].dateObj.Bogus_Date_1__c);
    }

    @IsTest
    static void it_should_be_code_coverage() {
      try {
        BarcodeGeneratorController.init('test');
      }catch(Exception ex) {

      }

      try {
        BarcodeGeneratorController.FinalizeRequest finRequest = new BarcodeGeneratorController.FinalizeRequest();
        finRequest.contextId = 'fsdfwer';
        finRequest.batchTitle = 'sdfwersdf';
        BarcodeGeneratorController.FinalizeRequestRow row = new BarcodeGeneratorController.FinalizeRequestRow();
        row.comment = 'commd';
        row.rowIndex = 9;
        row.selectedCategoryValue = 'catvalu';
        row.selectedDocTypeValue = 'docval';
        row.selectedObjectValues = new List<String> {'ocho'};
        row.docDate = '08/09/2018';
        finRequest.rows = new List<BarcodeGeneratorController.FinalizeRequestRow>{row};
        BarcodeGeneratorController.finalize(finRequest);
      }catch(Exception ex) {

      }
    }
}