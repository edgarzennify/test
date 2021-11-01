import { LightningElement, api } from 'lwc';
import fetchDocumentCollection from '@salesforce/apex/CPDocsDocumentUploadController.fetchDocumentCollection';
export default class CPDocsDocumentUploadContainer extends LightningElement {
	@api flexipageRegionWidth;
	selectedTitle;
	isLoading;
	noContent;
	verticalTitleCollection = [];
	documentCollection = [];

	connectedCallback() {
		this.isLoading = true;
		this.updateDocumentCollection('All Documents', true);
	}

	handleSelection(event) {
		this.isLoading = true;
		this.updateDocumentCollection(event.detail.name, false);
	}

	handleMobileSelection(event) {
		this.isLoading = true;
		this.updateDocumentCollection(event.target.value, false);
	}

	updateDocumentCollection(selectedValue, isInit) {
		this.selectedTitle = selectedValue;
		selectedValue = selectedValue === 'All Documents' ? '' : selectedValue;
		fetchDocumentCollection({ 
            filterCriteria : selectedValue
        })
        .then(result => {
			this.isLoading = false;
			this.documentCollection = result;
			this.noContent = this.documentCollection.length > 0 ? false : true;
			if (isInit) {
				this.organizeVerticalNavigation();
			}
        })
        .catch(error => {
			this.isLoading = false;
			this.noContent = this.documentCollection.length > 0 ? false : true;
			console.error(error);
        });
    }

	organizeVerticalNavigation() {
		var stagingSet = new Set();
		this.documentCollection.forEach(function(val, key) {
			stagingSet.add(val.objectDescription);
		});
		var titleCollection = [];
		stagingSet.forEach(function(val, key) {
			titleCollection.push(val);
		});
		this.verticalTitleCollection = titleCollection;
	}
}