import { LightningElement, api } from 'lwc';
import postUpload from '@salesforce/apex/DocumentUploadController.postUpload';

export default class DocumentPlaceholder extends LightningElement {
    @api documentplaceholder;
    duedatetext;
    uploadComplete;
    
	connectedCallback() {
        this.uploadComplete = this.documentplaceholder.readyStatus;
        this.duedatetext = this.documentplaceholder.isPastDueDate ? 'slds-text-color_error' : '';
	}

	handleUploadFinished(event) {
		postUpload({ 
            docRequestId : this.documentplaceholder.documentRequestId
        })
        .then(result => {
            this.uploadComplete = true;
        })
        .catch(error => {
			console.error('Failed uploading file');
            console.error(error);
        });
	}
}