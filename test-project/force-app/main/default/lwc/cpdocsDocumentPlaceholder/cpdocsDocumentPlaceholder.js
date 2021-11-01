import { LightningElement, api } from 'lwc';
import postUpload from '@salesforce/apex/CPDocsDocumentUploadController.postUpload';

export default class CPDocsDocumentPlaceholder extends LightningElement {
    @api documentplaceholder;
    acceptedUploadFormats;
    duedatetext;
    uploadComplete;
    
	connectedCallback() {
        this.uploadComplete = this.documentplaceholder.status.toUpperCase() === 'DOCUMENT UPLOADED';
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