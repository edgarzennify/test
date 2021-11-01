@isTest
public class BarcodeGeneratorMock {

	public class ofIPmBuilder extends ApexMoq implements BarcodeGenerator.IPmBuilder {
		public BarcodeGeneratorBatch__c buildBatch(String contextId) {
			return (BarcodeGeneratorBatch__c)handleMethodInvocation('buildBatch', new List<Object>{contextId});
		}
		public BarcodeGenerator.BarcodeConfig buildChildrenAndSiblings(BarcodeGeneratorBatch__c batch, BarcodeGenerator.FormSm formSm) {
			return (BarcodeGenerator.BarcodeConfig)handleMethodInvocation('buildChildrenAndSiblings', new List<Object>{batch, formSm});
		}
		public BarcodeGenerator.BarcodeConfig updateSiblingsWithChildKeys(BarcodeGenerator.BarcodeConfig config) {
			return (BarcodeGenerator.BarcodeConfig)handleMethodInvocation('updateSiblingsWithChildKeys', new List<Object>{config});
		}
	}

	public class ofIDmBuilder extends ApexMoq implements BarcodeGenerator.IDmBuilder {
		public DmBgBatch buildBatch(Id batchId) {
			return (DmBgBatch)handleMethodInvocation('buildBatch', new List<Object>{batchId});
		}
		public DmBgContext buildDmContext(Id contextId, List<BarcodeGeneratorCfgJunction__c> contextJxs, Map<Id, List<BarcodeGeneratorCfgDocType__c>> doctypes) {
			return (DmBgContext)handleMethodInvocation('buildDmContext', new List<Object>{contextId, contextJxs, docTypes});
		}
	}

	public class ofIRepository extends ApexMoq implements BarcodeGenerator.IRepository {
		public List<DmBgContext> getContexts() {
			return (List<DmBgContext>)handleMethodInvocation('getContexts');
		}
		public DmBgBatch createBatch(BarcodeGenerator.FormSm formSm) {
            return (DmBgBatch)handleMethodInvocation('createBatch', new List<Object>{formSm});
		}
	}

	public class ofIDataProvider extends ApexMoq implements BarcodeGenerator.IDataProvider {
		public List<BarcodeGeneratorCfgJunction__c> getJunctions() {
			return (List<BarcodeGeneratorCfgJunction__c>)handleMethodInvocation('getJunctions');
		}
		public List<BarcodeGeneratorCfgDocType__c> getDocTypes() {
			return (List<BarcodeGeneratorCfgDocType__c>)handleMethodInvocation('getDocTypes');
		}
		public void save(List<SObject> sObjects) {
			handleMethodInvocation('save', new List<Object>{sObjects});
		}
	}

	public class ofIVmBuilder extends ApexMoq implements BarcodeGenerator.IVmBuilder {
        public List<BarcodeGenerator.CategoryVm> buildCategoryVms(List<DmBgCategory> categories, Id contextId) {
        	return (List<BarcodeGenerator.CategoryVm>)handleMethodInvocation('buildCategoryVms', new List<Object>{categories, contextId});
        }
        public List<SelectOption> buildCategoryOptions(List<BarcodeGenerator.CategoryVm> categoryVms) {
        	return (List<SelectOption>)handleMethodInvocation('buildCategoryOptions', new List<Object>{categoryVms});
        } 
        public List<BarcodeGenerator.RowVm> buildRows(Integer count) {
        	return (List<BarcodeGenerator.RowVm>)handleMethodInvocation('buildRows', new list<Object>{count});
        }
        public List<BarcodeGenerator.RowVm> addRows(List<BarcodeGenerator.RowVm> vms, Integer count) {
        	return (List<BarcodeGenerator.RowVm>)handleMethodInvocation('addRows', new List<Object>{vms, count});
        }
        public BarcodeGenerator.FormSm convertToFormSm(BarcodeGenerator.FormVm vm) {
        	return (BarcodeGenerator.FormSm)handleMethodInvocation('convertToFormSm', new List<Object>{vm});
        }
        public List<BarcodeGenerator.SelectOptionVm> buildSelectOptionVms(List<SelectOption> selectOptions){
            return (List<BarcodeGenerator.SelectOptionVm>)handleMethodInvocation('buildSelectOptionVms', new List<Object>{selectOptions});
        }
	}

	public class ofIPresenter extends ApexMoq implements BarcodeGenerator.IPresenter {
		public BarcodeGenerator.FormVm getFormVm(Id contextId) {
			return (BarcodeGenerator.FormVm)handleMethodInvocation('getFormVm', new List<Object>{contextId});
		}
		public BarcodeGenerator.FormVm categorySelected(BarcodeGenerator.FormVm vm, Integer selectedRowIndex) {
			return (BarcodeGenerator.FormVm)handleMethodInvocation('categorySelected',new List<Object>{vm, selectedRowIndex});
		}
        public BarcodeGenerator.FormVm addRowsClicked(BarcodeGenerator.FormVm vm) {
        	return (BarcodeGenerator.FormVm)handleMethodInvocation('addRowsClicked', new List<Object>{vm});
        }
        public String generateClicked(BarcodeGenerator.FormVm vm) {
        	return (String)handleMethodInvocation('generateClicked', new List<Object>{vm});
        }
	}
}