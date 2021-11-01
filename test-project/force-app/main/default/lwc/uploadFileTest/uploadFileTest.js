import { LightningElement, api } from 'lwc';
export default class FileUploadExample extends LightningElement {
	@api
	myRecordId;
	jsonResponse = '{ ' +
		'"userName":"John Hammond", ' +
		'"documentRequests": [ ' +
			'{ ' +
				'"documentRequestId": "aBw7d000000CpGTCA0", ' +
				'"objectType": "Entity", ' +
				'"objectId": "0013000000jLJhx", ' +
				'"objectDescription": "InGen Corporation", ' +
				'"documentName": "Credit - Tax Return", ' +
				'"documentDueDate": "2021-11-15" ' +
			'}, ' + 
			'{ '+
				'"documentRequestId": "aBw7d000000CpGYCA0", ' +
				'"objectType": "Entity", ' +
				'"objectId": "0013000000jLJhx", ' +
				'"objectDescription": "InGen Corporation", ' +
				'"documentName": "Credit - Brokerage Statement", ' +
				'"documentDueDate": "2021-11-15" ' +
			'}, ' +
			'{ ' +
				'"documentRequestId": "aBw7d000000CpGdCAK", ' +
				'"objectType": "Account", ' +
				'"objectId": "a7C1B000000kPdV", ' +
				'"objectDescription": "Loan - Jurassic Park Fixed Line", ' +
				'"documentName": "Construction - Cost Breakdown", ' +
				'"documentDueDate": "2021-11-15" ' +
			'}, ' +
			'{ ' +
				'"documentRequestId": "aBw7d000000CpGiCAK", ' +
				'"objectType": "Collateral", ' +
				'"objectId": "a6T4X0000008782", ' +
				'"objectDescription": "Isla Nublar", ' +
				'"documentName": "Insurance - Flood", ' +
				'"documentDueDate": "2021-11-15" ' +
			'}, ' +
			'{ ' +
				'"documentRequestId": "aBw7d000000CpGnCAK", ' +
				'"objectType": "Account", ' +
				'"objectId": "a024X00000QetBLQAZ", ' +
				'"objectDescription": "Wealth Management - 047512", ' +
				'"documentName": "Corporate Resolution", ' +
				'"documentDueDate": "2022-04-15" ' +
		'} ' +
		']' +
	'}';

	get acceptedFormats() {
		return ['.txt', '.xlsx', '.xls', '.csv', '.png', '.doc', '.docx', '.pdf'];
	}

	get requestDocs() {
		const docNames = [];
		const dataMap = JSON.parse(this.jsonResponse);
		dataMap["documentRequests"].forEach(function(val, key) { 
			var docName = val["documentName"];
			console.log(docName);
			docNames.push(val);
		})
		return docNames;
	}

	handleUploadFinished(event) {
		console.log('uploading...');
		const uploadedFiles = event.detail.files;
		alert('No. of files uploaded : ' + uploadedFiles.length);
	}
}