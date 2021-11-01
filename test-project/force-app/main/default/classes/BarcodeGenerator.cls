global class BarcodeGenerator {
     
    public interface IDataProvider {
        List<BarcodeGeneratorCfgJunction__c> getJunctions();
        List<BarcodeGeneratorCfgDocType__c> getDocTypes();
        void save(List<SObject> sObjects);
    }

    public interface IDmBuilder {
        DmBgBatch buildBatch(Id batchId);
        DmBgContext buildDmContext(Id contextId, List<BarcodeGeneratorCfgJunction__c> contextJxs, Map<Id, List<BarcodeGeneratorCfgDocType__c>> doctypes);
    } 

    public interface IPmBuilder {
        BarcodeGeneratorBatch__c buildBatch(String contextId);
        BarcodeConfig buildChildrenAndSiblings(BarcodeGeneratorBatch__c batch, BarcodeGenerator.FormSm formSm);
        BarcodeGenerator.BarcodeConfig updateSiblingsWithChildKeys(BarcodeGenerator.BarcodeConfig config);
    }

    public interface IPresenter {
        BarcodeGenerator.FormVm getFormVm(Id contextId);
        FormVm categorySelected(FormVm vm, Integer selectedRowIndex);
        FormVm addRowsClicked(FormVm vm);
        String generateClicked(FormVm vm);
    }

    public interface IRepository {
        List<DmBgContext> getContexts();
        DmBgBatch createBatch(FormSm sm);
    }
    
    public interface IVmBuilder {
        List<CategoryVm> buildCategoryVms(List<DmBgCategory> categories, Id contextId);
        List<SelectOption> buildCategoryOptions(List<CategoryVm> categoryVms);   
        List<RowVm> buildRows(Integer count);
        List<RowVm> addRows(List<RowVm> vms, Integer count);
        FormSm convertToFormSm(FormVm vm);
        List<SelectOptionVm> buildSelectOptionVms(List<SelectOption> selectOptions);
    }

    global class PageKey {
        public String PageKey {get;set;}
        public String PageKeyType {get;set;}
    }

    global class FormVm {
        public List<CategoryVm> categories {get;set;}
        public List<SelectOption> categoryOptions {get;set;}
        public List<SelectOptionVm> categoryOptionVms {get;set;}
        public List<RowVm> rows {get;set;}
        public Integer addRowsCount {get;set;}
        public String batchTitle {get;set;}
        public String contextId {get;set;}
        public String documentUploadFinalizationUrl {get;set;}
    }

    public class CategoryVm {
        public String name {get;set;}
        public String junctionId {get;set;}
        public String junctionType {get;set;}
        public List<SelectOption> doctypes {get;set;}
        public List<SelectOption> relatedObjects {get;set;}
        public List<SelectOptionVm> doctypeVms {get;set;}
        public List<SelectOptionVm> relatedObjectVms {get;set;}
    }
    
    public class RowVm {
        public Integer rowIndex {get;set;}
        public String selectedCategoryValue {get;set;}
        public String selectedDocTypeValue {get;set;}
        public List<String> selectedObjectValues {get;set;}
        public BarcodeGenerator.CategoryVm selectedCategory {get;set;}
        public String comment {get;set;}
        public Grenzsoldat__c dateObj {get;set;}
    }

    public class FormSm {
        public String batchTitle {get;set;}
        public String contextId {get;set;}
        public List<RowSm> rows {get;set;}
    }

    public class RowSm {        
        public Integer rowIndex {get;set;}
        public String category {get;set;}
        public String documentType {get;set;}
        public List<String> objects {get;set;}
        public Date documentDate {get;set;}
        public String comment {get;set;}        
    }

    public Class BarcodeConfig {
        public List<BarcodeGeneratorChildKey__c> children{get;set;}
        public List<BarcodeGeneratorSibling__c> siblings {get;set;}
    }
    
    public class SelectOptionVm {
        public String Label {get;set;}
        public String Value {get;set;}
        public SelectOptionVm(){}
        public SelectOptionVm(String l, String v){
            Label = l;
            Value = v;
        }
    }
    
}