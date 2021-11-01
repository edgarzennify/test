public class AgreementClientRelationshipEdit {
	private Agreements.IAgreementStatusManager m_agreementStatusManager;
	private Agreements.IAgreementClientRelationshipEditDataProvider m_dataProvider;
	private Agreements.IAgreementValidator m_agreementValidator;
	public ApexPages.standardcontroller controller {get;set;}
	public Agreement_Client_Relationships__c agmtClientRel {get;set;}
	public FinancialReportingRequirements finRptReqs {get;set;}
	public List<Agreement_Client_Relationships__c> agmtClientRelList {get;set;}
	public List<Agreement_Financial_Documents__c> agmtFinDocListIncluded {get;set;}
	public List<Agreement_Financial_Documents__c> agmtFinDocListExcluded {get;set;}
	public Agreement__c agmt {get;set;}
	public Account client {get;set;}
	public boolean displayDialog {get; set;}
	public Boolean AgmtOverrideActive {get;set;}
	public Map<Id,String> RecordTypeIdMap {get;set;}
	public Map<Id,Agreement_Financial_Documents__c> MapOfAllDocs {get;set;}
	public Boolean loadOnce {get; set;}
	public Map<String,String> availablePicklists {get; set;}
	public List<RecordTypePicklistObject> rtPickObjs {get;set;}
	public Map<String,RecordTypePicklistObject> FinancialReqObjMap {get;set;}
	
	public Map<String,RecordTypePicklistObject> AgreementReqObjMap {get;set;}
	public List<RecordTypePicklistObject> AgreementReqObjs {get;set;}
	public List<String> AgreementReqObjsOrder{
		get{
			List<String> theOrder = new List<String>();
			theOrder.add('A/P Detailed Agings');
			theOrder.add('A/R Detailed Agings');
			theOrder.add('Borrowing Base Certificate');
			theOrder.add('Brokerage Statement');
			theOrder.add('Compliance Certificate');
			theOrder.add('Inventory Report');
			theOrder.add('Pro Forma');
			theOrder.add('Rent Roll');
			theOrder.add('Work in Process');
			return theOrder;
		}
	}
	public Integer ObjectNum {get;set;}
	public Integer PicklistNum {get;set;}
	public String PicklistName {get;set;}
	public String PicklistValues {get;set;}
	public String RtName {get;set;}
	public String pickvalue {get;set;}
	public String dropdownSelectedDocTypeIncludeId{
		 get{
			 String dpDownValue = null;
			 dpDownValue = dropdownSelectedDocTypeIncludeId;
			 if(dpDownValue==null){
				 dpDownValue='No';
			 }
			 return dpDownValue;
		 }
		 set{}
	}
	public string dropdownSelectedFrequencyId{get;set;}
	public string dropdownSelectedPeriodDueId{get;set;}
	public string dropdownSelectedOtherTypeId{get;set;}
	List<SelectOption> availableClients = new List<SelectOption>();

	public AgreementClientRelationshipEdit() {
		m_agreementStatusManager = new AgreementStatusManager(new UserInfoService(Configurations.bootstrap(), new UserInfoServiceDataProv()), new AgreementEntityManager(new AgreementEntityManagerDataProvider()), new AgreementStatusManagerDataProvider());
		m_dataProvider = new AgreementClientRelEditDataProv();
		m_agreementValidator = AgreementValidator.getInstance();
		initialize();
	}
		
	public AgreementClientRelationshipEdit(Agreements.IAgreementStatusManager statusManager, Agreements.IAgreementClientRelationshipEditDataProvider dataProvider, Agreements.IAgreementValidator validator){
		m_agreementStatusManager = statusManager;
		m_dataProvider = dataProvider;
		m_agreementValidator = validator;
		initialize();
	}

	public class RecordTypePicklistObject{
		public Id rtId {get;set;}
		public String rtName {get;set;}
		public String rtDevName {get;set;}
		public Agreement_Financial_Documents__c sObj {get;set;}
		public String  sObjLabel {get;set;}
		public List<String> pkListWorder {get;set;}
		public Map<String,String> picklistFieldNameAndLabel  {get;set;}
		public Map<String,List<String>> picklistFieldNameAndValues {get;set;}
		public Map<String,List<SelectOption>> picklistFieldNameAndSelectOption {get;set;}
		public Map<String,Integer> picklistFieldNameAndMaxNumericValue {get;set;}
		public List<String> pckNameList {get;set;}
		public String pckValue {get;set;}
		public List<String> pickListVals {get;set;}
		public String PicklistName {get;set;}
		public String pickValue {get;set;}
		public RecordTypePicklistObject(){
			showOverrideField = false;
		}
		public String dropdownSelectedDocTypeIncludeId{
		get;
		set{
				sObj.Include_In_Agreement__c = value;
				dropdownSelectedDocTypeIncludeId = value;
			}
		}
		public string dropdownSelectedFrequencyId{
		get;
		set{
				sObj.Frequency__c = value;
				dropdownSelectedFrequencyId = value;
			}
		}
		public string dropdownSelectedPeriodDueId{
		get;
		set{
				sObj.Period_Due__c = value;
				dropdownSelectedPeriodDueId = value;
			}
		}
		public string dropdownSelectedOtherTypeId{
		get;
		set{
				sObj.Other_Type__c = value;
				dropdownSelectedOtherTypeId = value;
			}
		}
		public Integer MaxValue {get;set;}
		public Boolean showOverrideField {get;set;}
		
		public PageReference setNewValue(){
			List<String> setPicklistList = new List<String>();
			Map<String,List<String>> setPicklistFieldNamesAndVals = new Map<String,List<String>>();
			setPicklistFieldNamesAndVals = picklistFieldNameAndValues;
			if(setPicklistFieldNamesAndVals.containsKey(PicklistName) == false){
				pickListVals=new List<String>();
					Boolean skip=true;
					for (String val : pickValue.split(':')){
						 if (skip){
							skip=false;
						 }
						 else{
							pickListVals.add(val);
						 }
					}
				setPicklistFieldNamesAndVals.put(PicklistName,pickListVals);
			}
			return null;
		}
		
		public PageReference showOtherField(){
			if(dropdownSelectedPeriodDueId == 'Other'){
				if(sObj.Period_Due_Override__c == null){
					System.Debug('*********** Period Override: ' + String.valueOf(sObj.Period_Due_Override__c));
					System.Debug('*********** Period Override RtName: ' + rtName + ' is in map ?? = ' + String.valueOf(picklistFieldNameAndMaxNumericValue.containsKey(rtName)));
					if(picklistFieldNameAndMaxNumericValue.containsKey(rtName) == true){
						MaxValue = picklistFieldNameAndMaxNumericValue.get(rtName);
						sObj.Period_Due_Override__c = MaxValue;
						sObj.Period_Due_Maximum__c = MaxValue;
					}
				}
				showOverrideField = true;
			}
			else{
				if(sObj.Period_Due_Override__c != null){
					sObj.Period_Due_Override__c = null;
					showOverrideField = false;
				}
			}
			return null;
		}
		
		public Boolean showStartDate{
			get{
				return (rtName == 'Compliance Certificate') ? true : false;
			}
		}
	}

	public class FinancialReportingRequirements{
		public String Personal_Financial_Statement {get;set;}
		public String Personal_Financial_Statement_Frequency {get;set;}
		
		public String Annual_Financial_Statements {get;set;}
		public String Annual_Statement_Quality {get;set;}
		public String AFS_Fiscal_Year_End {get;set;}
		public String Annual_Stmt_Days_Due_After_Fiscal_Y_E {
				get{         
					if(Annual_Stmt_Days_Due_After_Fiscal_Y_E == '-1'){
						return 'Other (' + Annual_Financial_Statement_Period_Other + ')';
					}
					return Annual_Stmt_Days_Due_After_Fiscal_Y_E;
				}
				set;
		}
		public String Annual_Financial_Statement_Period_Other {get;set;}
		public String Other_Type {
				get{
					String otherType = Other_Type != null ? Other_Type : '';
					otherType += Other_Type == 'Combined' ? ' (' + AFS_Entities_To_Combine + ')' : '';
					return otherType;
				}
				set;
		}
		public String AFS_Entities_To_Combine {get;set;}
		
		public String Interim_Statements {get;set;}
		public String Interim_Stm_Prepared_By {get;set;}
		public String Interim_Stmt_Days_Due_After_Period_End {
				get{
					if(Interim_Stmt_Days_Due_After_Period_End == '-1'){
						return 'Other (' + Interim_Stmt_Days_Due_After_Period_End_Other + ')';
					}
					return Interim_Stmt_Days_Due_After_Period_End;
				}
				set;
		}
		public String Interim_Stmt_Days_Due_After_Period_End_Other {get;set;}
		
		public String Tax_Returns {get;set;}
		public String Tax_Return_Days_Due_After_Filing {
				get{
					if(Tax_Return_Days_Due_After_Filing == '-1'){
						return 'Other (' + Tax_Return_Days_Due_After_Filing_Other + ')';
					}
					return Tax_Return_Days_Due_After_Filing;
				}
				set;
		}
		public String Tax_Return_Days_Due_After_Filing_Other {get;set;}
	}

	public PageReference setLoadOnceFlag(){
		Map<String,RecordTypePicklistObject> agmtMap = new Map<String,RecordTypePicklistObject>();
		List<RecordTypePicklistObject> agmtObjs = new List<RecordTypePicklistObject>();

		for(RecordTypePicklistObject rtObj : rtPickObjs){
			rtObj.pckNameList = new List<String>();
			rtObj.picklistFieldNameAndValues = new Map<String,List<String>>();
			rtObj.picklistFieldNameAndSelectOption = new Map<String,List<SelectOption>>();
			rtObj.picklistFieldNameAndMaxNumericValue = new Map<String,Integer>();
			String rtNm = '';
			List<String> pkOpts = new List<String>();
			List<SelectOption> pkSopts = new List<SelectOption>();
			String pkName = '';
			Integer idxVal = -1;
			Integer valLen = -1;
			Integer idxOptVal = -1;
			Integer idxOptEnd = -1;
			Integer MaxNumericValue = 0;
			Integer r;

			for(String records : rtObj.pckValue.split('<NextRecord>')){
				pkOpts = new List<String>();
				pkSopts = new List<SelectOption>();
				for(String pListNm : records.split('<PListName>')){
					idxVal = pListNm.indexOf('<RecordTypeName>');
					valLen = ('<RecordTypeName>').length();
					if(idxVal >= 0){
						rtNm = pListNm.subString(0,idxVal);
						pkName = pListNm.subString(idxVal + valLen, pListNm.length());
					}
					if(idxVal < 0){
						idxOptVal = pListNm.indexOf('<PListOption>');
						if(idxOptVal >= 0){
							MaxNumericValue = 0;
							for(String opts : pListNm.split('<PListOption>')){
								idxOptEnd = opts.indexOf('<PListOptions>');
								if(idxOptEnd >= 0){
									if(opts.subString(0,idxOptEnd) != ''){
										if((opts.subString(0,idxOptEnd) != '--None--' && pkName == 'Include_In_Agreement__c') || (opts.subString(0,idxOptEnd) == '--None--' && pkName != 'Include_In_Agreement__c') || pkName != 'Include_In_Agreement__c'){
											pkOpts.add(opts.subString(0,idxOptEnd));
											pkSopts.add(new SelectOption(opts.subString(0,idxOptEnd),opts.subString(0,idxOptEnd)));
											try{
												if(Integer.valueOf(opts.subString(0,idxOptEnd)) > MaxNumericValue){
													MaxNumericValue = Integer.valueOf(opts.subString(0,idxOptEnd));
													System.Debug('****** Max Value: A : ' + String.valueOf(MaxNumericValue));
													if(rtObj.picklistFieldNameAndMaxNumericValue.containsKey(rtObj.rtName) == true){
														r = rtObj.picklistFieldNameAndMaxNumericValue.remove(rtObj.rtName);
													}
													rtObj.picklistFieldNameAndMaxNumericValue.put(rtObj.rtName,MaxNumericValue);
												}
											}catch(Exception e){}
										}
									}
								}else{
									if(opts != ''){
										if((opts != '--None--' && pkName == 'Include_In_Agreement__c') || (opts == '--None--' && pkName != 'Include_In_Agreement__c') || pkName != 'Include_In_Agreement__c'){
											pkOpts.add(opts);
											pkSopts.add(new SelectOption(opts,opts));
											try{
												if(Integer.valueOf(opts) > MaxNumericValue){
													MaxNumericValue = Integer.valueOf(opts);
													System.Debug('****** Max Value: B : ' + String.valueOf(MaxNumericValue));
													if(rtObj.picklistFieldNameAndMaxNumericValue.containsKey(rtObj.rtName) == true){
														r = rtObj.picklistFieldNameAndMaxNumericValue.remove(rtObj.rtName);
													}
													rtObj.picklistFieldNameAndMaxNumericValue.put(rtObj.rtName,MaxNumericValue);
												}
											}catch(Exception e){}
										}
									}
								}
							}
						}
					}
				}
				if(rtNm != '' && pkOpts.size() > 0 && pkName != ''){
					rtObj.pckNameList.add(pkName);
					rtObj.rtDevName = rtNm;
					rtObj.picklistFieldNameAndValues.put(pkName,pkOpts);
					rtObj.picklistFieldNameAndSelectOption.put(pkName,pkSopts);

					agmtObjs.add(rtObj);
					agmtMap.put(rtObj.rtName,rtObj);

					rtNm = '';
					pkOpts = new List<String>();
					pkSopts = new List<SelectOption>();
					pkName = '';
					MaxNumericValue = 0;
				}else{
					rtNm = '';
					pkOpts = new List<String>();
					pkSopts = new List<SelectOption>();
					pkName = '';
					MaxNumericValue = 0;
				}
			}
		}

		//Reorder the objects to support the correct order on the page.
		List<RecordTypePicklistObject> newAgmtOrder = new List<RecordTypePicklistObject>();
		for(String recordTypeName : this.AgreementReqObjsOrder){
			System.Debug('***** >>>>> AGMT REQ TYPE NAME: ' + recordTypeName + ' IS IN MAP??? == ' + String.valueOf(agmtMap.containsKey(recordTypeName)));
			if(agmtMap.containsKey(recordTypeName) == true /*|| finMap.containsKey(recordTypeName) == false*/){
				RecordTypePicklistObject newRtObj = agmtMap.get(recordTypeName);
				newAgmtOrder.add(newRtObj);
			}
		}

		if(newAgmtOrder.size() > 0){this.AgreementReqObjs = newAgmtOrder;}
		if(agmtMap.size() > 0){this.AgreementReqObjMap = agmtMap;}

		this.loadOnce = false;

		return null;
	}
		
	private void initialize(){
		agmtClientRel = m_dataProvider.getAgreementClientRelationshipById(apexpages.currentpage().getparameters().get('id'));
		client = agmtClientRel.Entity__r;
		if(agmtClientRel.Agreement__c <> null){
			agmt = m_dataProvider.getAgreementById(agmtClientRel.Agreement__c);
		}
		initializeFinancialReportingRequirementsPicklists();
		initializePicklistLabels();
		initializeRecordTypes();
		initializeFinDocTypesIncludedList();
		initializeFinancialReportingRequirements();
		AgmtOverrideActive = false;
	}

	private void initializeFinancialReportingRequirementsPicklists(){
		personalFinancialStatementId = client.Pending_PFS__c;
		annualFinancialStatementId = client.Pending_AFS__c;
		annualFinancialStatementPeriodId = String.valueOf(client.Pending_AFS_Days_Due_After_FYE__c);
		annualFinancialStatementOtherTypeId = client.Pending_AFS_Other_Type__c;
		interimStatementId = client.Pending_IntStmts__c;
		interimStatementPeriodId = String.valueOf(client.Pending_IntStmts_Days_Due_After_PE__c);
		taxReturnsId = client.Pending_TaxReturns__c;
		taxReturnsPeriodId = String.valueOf(client.Pending_TaxReturns_Days_Due_After_Filing__c);
	}

	private void initializeFinancialReportingRequirements(){
		finRptReqs = new FinancialReportingRequirements();      
		if(agmt.RecordType.Name == 'Active'){
			finRptReqs.Tax_Returns = client.Tax_Returns__c;
			finRptReqs.Tax_Return_Days_Due_After_Filing = String.valueOf(client.Tax_Return_Days_Due_After_Filing__c);
			finRptReqs.Tax_Return_Days_Due_After_Filing_Other = String.valueOf(client.Tax_Return_Period_Other__c);     
			finRptReqs.Annual_Financial_Statements = client.Annual_Financial_Statements__c;
			finRptReqs.Annual_Statement_Quality = client.Annual_Statement_Quality__c;
			finRptReqs.Annual_Stmt_Days_Due_After_Fiscal_Y_E = String.valueOf(client.Annual_Stmt_Days_Due_After_Fiscal_Y_E__c);
			finRptReqs.Annual_Financial_Statement_Period_Other = String.valueOf(client.Annual_Financial_Statement_Period_Other__c);
			finRptReqs.AFS_Fiscal_Year_End = String.valueOf(client.Fiscal_Year_End_Date__c);
			finRptReqs.AFS_Entities_To_Combine = String.valueOf(client.Entities_To_Combine__c);
			finRptReqs.Other_Type = String.valueOf(client.Other_Type__c);
			finRptReqs.Personal_Financial_Statement = client.Personal_Financial_Statement__c;
			finRptReqs.Personal_Financial_Statement_Frequency = client.Personal_Financial_Statement_Frequency__c;
			finRptReqs.Interim_Statements = client.Interim_Statements__c;
			finRptReqs.Interim_Stm_Prepared_By = client.Interim_Stm_Prepared_By__c;
			finRptReqs.Interim_Stmt_Days_Due_After_Period_End = String.valueOf(client.Interim_Stmt_Days_Due_After_Period_End__c);
			finRptReqs.Interim_Stmt_Days_Due_After_Period_End_Other = String.valueOf(client.Interim_Statement_Period_Other__c);
		}else if(agmt.RecordType.Name == 'Pending'){
			finRptReqs.Tax_Returns = client.Pending_TaxReturns__c;
			finRptReqs.Tax_Return_Days_Due_After_Filing = String.valueOf(client.Pending_TaxReturns_Days_Due_After_Filing__c);
			finRptReqs.Tax_Return_Days_Due_After_Filing_Other = String.valueOf(client.Pending_TaxReturns_Period_Other__c);     
			finRptReqs.Annual_Financial_Statements = client.Pending_AFS__c;
			finRptReqs.Annual_Statement_Quality = client.Pending_AFS_Quality__c;
			finRptReqs.Annual_Stmt_Days_Due_After_Fiscal_Y_E = String.valueOf(client.Pending_AFS_Days_Due_After_FYE__c);
			finRptReqs.Annual_Financial_Statement_Period_Other = String.valueOf(client.Pending_AFS_Period_Other__c);
			finRptReqs.AFS_Fiscal_Year_End = String.valueOf(client.Pending_AFS_FYE__c);
			finRptReqs.AFS_Entities_To_Combine = String.valueOf(client.Pending_AFS_Entities_To_Combine__c);
			finRptReqs.Other_Type = String.valueOf(client.Pending_AFS_Other_Type__c);
			finRptReqs.Personal_Financial_Statement = client.Pending_PFS__c;
			finRptReqs.Personal_Financial_Statement_Frequency = client.Pending_PFS_Frequency__c;
			finRptReqs.Interim_Statements = client.Pending_IntStmts__c;
			finRptReqs.Interim_Stm_Prepared_By = client.Pending_IntStmts_Quality__c;
			finRptReqs.Interim_Stmt_Days_Due_After_Period_End = String.valueOf(client.Pending_IntStmts_Days_Due_After_PE__c);
			finRptReqs.Interim_Stmt_Days_Due_After_Period_End_Other = String.valueOf(client.Pending_IntStmts_Period_Other__c);
		}else{
			finRptReqs.Tax_Returns = agmtClientRel.Tax_Returns__c;
			finRptReqs.Tax_Return_Days_Due_After_Filing = String.valueOf(agmtClientRel.Tax_Return_Days_Due_After_Filing__c);  
			finRptReqs.Tax_Return_Days_Due_After_Filing_Other = String.valueOf(agmtClientRel.Tax_Return_Period_Other__c);              
			finRptReqs.Annual_Financial_Statements = agmtClientRel.Annual_Financial_Statements__c;
			finRptReqs.Annual_Statement_Quality = agmtClientRel.Annual_Statement_Quality__c;
			finRptReqs.Annual_Stmt_Days_Due_After_Fiscal_Y_E = String.valueOf(agmtClientRel.Annual_Stmt_Days_Due_After_Fiscal_Y_E__c);
			finRptReqs.Annual_Financial_Statement_Period_Other = String.valueOf(agmtClientRel.Annual_Financial_Statement_Period_Other__c);
			finRptReqs.AFS_Fiscal_Year_End = String.valueOf(agmtClientRel.Fiscal_Year_End_Date__c);
			finRptReqs.AFS_Entities_To_Combine = String.valueOf(agmtClientRel.Entities_To_Combine__c);
			finRptReqs.Other_Type = String.valueOf(agmtClientRel.Other_Type__c);
			finRptReqs.Personal_Financial_Statement = agmtClientRel.Personal_Financial_Statement__c;
			finRptReqs.Personal_Financial_Statement_Frequency = agmtClientRel.Personal_Financial_Statement_Frequency__c;
			finRptReqs.Interim_Statements = agmtClientRel.Interim_Statements__c;
			finRptReqs.Interim_Stm_Prepared_By = agmtClientRel.Interim_Stm_Prepared_By__c;
			finRptReqs.Interim_Stmt_Days_Due_After_Period_End = String.valueOf(agmtClientRel.Interim_Stmt_Days_Due_After_Period_End__c);
			finRptReqs.Interim_Stmt_Days_Due_After_Period_End_Other = String.valueOf(agmtClientRel.Interim_Statement_Period_Other__c);
		}
	}

	private void initializeFinDocTypesIncludedList(){
		List<Agreement_Financial_Documents__c> thisDocList = new List<Agreement_Financial_Documents__c>();
		thisDocList = m_dataProvider.getAgreementFinancialDocumentsFilteredByRecordType(agmtClientRel.Id, RecordTypeIdMap.keySet());
		this.agmtFinDocListIncluded = thisDocList;
	}

	private void initializePicklistLabels(){
		Map<String,String> fieldNamesAndLabels = new Map<String,String>();
		String type='Agreement_Financial_Documents__c';
		Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
		Schema.SObjectType thisObjType = schemaMap.get(type);
		Map<String, Schema.SObjectField> fieldMap = thisObjType.getDescribe().fields.getMap();
		for (String fieldName: fieldMap.keySet()){
			Schema.DisplayType fielddataType = fieldMap.get(fieldName).getDescribe().getType();
			if(fielddataType == Schema.DisplayType.Picklist){
				System.debug('##Field API Name='+fieldName);
				System.debug('##Field API Label='+fieldMap.get(fieldName).getDescribe().getLabel());
				fieldNamesAndLabels.put(fieldName,fieldMap.get(fieldName).getDescribe().getLabel());
			}
		}
		this.availablePicklists = fieldNamesAndLabels;	
	}
		
	private void initializeRecordTypes(){
		 Map<Id,String> rtMap = new Map<Id,String>();
		 Map<Id,Agreement_Financial_Documents__c> allDocs = new Map<Id,Agreement_Financial_Documents__c>();
		 List<RecordTypePicklistObject> rObjList = new List<RecordTypePicklistObject>();
		 List<Agreement_Financial_Documents__c> thisDocList = new List<Agreement_Financial_Documents__c>();
		 Map<Id,Agreement_Financial_Documents__c> thisDocMap = new Map<Id,Agreement_Financial_Documents__c>();
		 thisDocList = m_dataProvider.getAgreementFinancialDocuments(agmtClientRel.Id);
		 for(Agreement_Financial_Documents__c thisDoc : thisDocList){
			Id DocRecTypeId = thisDoc.RecordTypeId;
			thisDocMap.put(DocRecTypeId,thisDoc);
		 }
		 
		 for (RecordType rt : Utility.recordTypeObjects('Agreement_Financial_Documents__c')){
			RecordTypePicklistObject rtObj = new RecordTypePicklistObject();
			rtObj.rtId = rt.Id;
			rtObj.rtName = rt.Name;
			rtObj.rtDevName = rt.DeveloperName;
			rtMap.put(rt.Id, rt.Name);
			Agreement_Financial_Documents__c aDoc = new Agreement_Financial_Documents__c();
			if(thisDocMap.containsKey(rt.Id) == true){
				 aDoc = thisDocMap.get(rt.Id);
				 rtObj.sObj = aDoc;
				 rtObj.sObj.Agreement__c = agmt.Id;
				 rtObj.dropdownSelectedDocTypeIncludeId = aDoc.Include_In_Agreement__c;
				 rtObj.dropdownSelectedFrequencyId = aDoc.Frequency__c;
				 rtObj.dropdownSelectedPeriodDueId = aDoc.Period_Due__c;
				 if(rtObj.dropdownSelectedPeriodDueId == 'Other'){
					rtObj.showOverrideField = true;
				 }
				 rtObj.dropdownSelectedOtherTypeId = aDoc.Other_Type__c;
			}
			else{
				aDoc.RecordTypeId = rt.Id;
				rtObj.sObj = aDoc;
				rtObj.sObj.Agreement__c = agmt.Id;
				rtObj.sObjLabel = String.valueOf(aDoc.getSObjectType());
			}
			List<String> pFields = new List<String>();
			pFields.add('Include_In_Agreement__c');
			pFields.add('Frequency__c');
			pFields.add('Period_Due__c');
			pFields.add('Other_Type__c');
			rtObj.pkListWorder = pFields;
			rtObj.picklistFieldNameAndLabel = this.availablePicklists;
			this.loadOnce=true;
			allDocs.put(rt.Id, aDoc);
			rObjList.add(rtObj);
		}
		this.RecordTypeIdMap = rtMap;
		this.MapOfAllDocs = allDocs;
		this.rtPickObjs = rObjList;
	}
	
	public PageReference CancelClicked(){
		if(agmt.id == null) {
			try{
				String newPageUrl = String.valueOf(agmt.id);
				PageReference newPage = new PageReference(newPageUrl);
				newPage.setRedirect(true);
				return newPage;
			 }catch(exception ex){

			 }
		 }
		 controller = new ApexPages.standardController(agmt);
		 return Controller.view();
	}

	private void validateIncludeInAgreement(RecordTypePicklistObject agmObj){
		if((String.isBlank(agmObj.sObj.Frequency__c)|| agmObj.sObj.Frequency__c == '--None--') || (String.isBlank(agmObj.sObj.Period_Due__c)|| agmObj.sObj.Period_Due__c == '--None--')){ 
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, '"'+'Include ' + agmObj.rtName +'"' + ' :Selecting YES requires frequency and period to be filled out.');
			ApexPages.addMessage(myMsg);
		}
	}

	private void validateFinancialReportingRequirements(){
		List<String>errors = new List<String>();
		if(agmtClientRel.Entity__r.Pending_PFS__c == 'Yes' && String.IsBlank(agmtClientRel.Entity__r.Pending_PFS_Frequency__c)){
			errors.add('"Personal Financial Statements" and "Personal Financial Statement Frequency" fields are mis-matched.');
		}
		if(agmtClientRel.Entity__r.Pending_PFS__c != 'Yes' && String.IsNotBlank(agmtClientRel.Entity__r.Pending_PFS_Frequency__c)){
			errors.add('\"Personal Financial Statements\" and \"Personal Financial Statement Frequency\" fields are mis-matched.');
		}				
		if(agmtClientRel.Entity__r.Pending_AFS__c == 'Yes' && String.IsBlank(agmtClientRel.Entity__r.Pending_AFS_Quality__c)){
			errors.add('\"Annual Financial Statements\" and \"Annual Statement Quality\" fields are mis-matched.');
		}
		if(agmtClientRel.Entity__r.Pending_AFS__c != 'Yes' && String.IsNotBlank(agmtClientRel.Entity__r.Pending_AFS_Quality__c)){
			errors.add('\"Annual Financial Statements\" and \"Annual Statement Quality\" fields are mis-matched.');
		}
		if(agmtClientRel.Entity__r.Pending_AFS__c == 'Yes' && agmtClientRel.Entity__r.Pending_AFS_Days_Due_After_FYE__c == 0){
			errors.add('\"Annual Financial Statements\" and \"Annual Statement Days Due After Fiscal Y/E\" fields are mis-matched.');
		}
		if(agmtClientRel.Entity__r.Pending_AFS__c != 'Yes' && agmtClientRel.Entity__r.Pending_AFS_Days_Due_After_FYE__c != 0){
			errors.add('\"Annual Financial Statements\" and \"Days Due After Period End\" fields are mis-matched.');
		}
		if(agmtClientRel.Entity__r.Pending_AFS__c != 'Yes' && String.IsNotBlank(agmtClientRel.Entity__r.Pending_AFS_FYE__c)){
			errors.add('\"Annual Financial Statements\" and \"Fiscal Year End\" fields are mis-matched.');
		}
		if(String.isNotBlank(agmtClientRel.Entity__r.Pending_AFS_FYE__c) && !Pattern.matches('[0-1][0-9]/[0-3][0-9]', agmtClientRel.Entity__r.Pending_AFS_FYE__c)){
			errors.add('\"Fiscal Year End\" must be in the format MM/DD.');
		}
		if(agmtClientRel.Entity__r.Pending_AFS__c != 'Yes' && String.isNotBlank(agmtClientRel.Entity__r.Pending_AFS_Other_Type__c)){
			errors.add('\"Annual Financial Statements\" and \"Other Type\" fields are mis-matched.');
		}
		if(agmtClientRel.Entity__r.Pending_AFS_Other_Type__c == 'Combined' && String.isBlank(agmtClientRel.Entity__r.Pending_AFS_Entities_To_Combine__c)){
			errors.add('Please indicate which entities should be combined.');
		}
		if(agmtClientRel.Entity__r.Pending_IntStmts__c == 'Not Required' && String.IsNotBlank(agmtClientRel.Entity__r.Pending_IntStmts_Quality__c)){
			errors.add('\"Interim Statements\" and \"Interim Statement Quality\" fields are mis-matched.');
		}
		if(agmtClientRel.Entity__r.Pending_IntStmts__c != 'Not Required' && String.IsBlank(agmtClientRel.Entity__r.Pending_IntStmts_Quality__c)){
			errors.add('\"Interim Statements\" and \"Interim Statement Quality\" fields are mis-matched.');
		}
		if(agmtClientRel.Entity__r.Pending_IntStmts__c == 'Not Required' && agmtClientRel.Entity__r.Pending_IntStmts_Days_Due_After_PE__c != 0){
			errors.add('\"Interim Statements\" and \"Interim Statement Days Due After Period End\" fields are mis-matched.');
		}				
		if(agmtClientRel.Entity__r.Pending_IntStmts__c != 'Not Required' && agmtClientRel.Entity__r.Pending_IntStmts_Days_Due_After_PE__c == 0){
			errors.add('\"Interim Statements\" and \"Interim Statement Days Due After Period End\" fields are mis-matched.');
		}
		if(agmtClientRel.Entity__r.Pending_TaxReturns__c == 'Yes' && agmtClientRel.Entity__r.Pending_TaxReturns_Days_Due_After_Filing__c == 0){
			errors.add('\"Tax Returns\" and \"Tax Return Days Due After Filing\" fields are mis-matched.');
		}
		if(agmtClientRel.Entity__r.Pending_TaxReturns__c == 'No' && agmtClientRel.Entity__r.Pending_TaxReturns_Days_Due_After_Filing__c != 0){
			errors.add('\"Tax Returns\" and \"Tax Return Days Due After Filing\" fields are mis-matched.');
		}
		
		for(String e : errors){
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, e);
			ApexPages.addMessage(myMsg);                
		}       
	}

	public PageReference SaveClicked(){  
		try{
			List<Agreement_Financial_Documents__c> docsToSave = new List<Agreement_Financial_Documents__c>();
			List<Agreement_Financial_Documents__c> docsToDelete = new List<Agreement_Financial_Documents__c>();
			
			agmtClientRel.Entity__r.Pending_PFS__c = personalFinancialStatementId;
			agmtClientRel.Entity__r.Pending_AFS__c = annualFinancialStatementId;
			agmtClientRel.Entity__r.Pending_AFS_Other_Type__c = annualFinancialStatementOtherTypeId;
			agmtClientRel.Entity__r.Pending_AFS_Days_Due_After_FYE__c = Decimal.valueOf(annualFinancialStatementPeriodId);
			agmtClientRel.Entity__r.Pending_IntStmts__c = interimStatementId;
			agmtClientRel.Entity__r.Pending_IntStmts_Days_Due_After_PE__c = Decimal.valueOf(interimStatementPeriodId);
			agmtClientRel.Entity__r.Pending_TaxReturns__c = taxReturnsId;
			agmtClientRel.Entity__r.Pending_TaxReturns_Days_Due_After_Filing__c = Decimal.valueOf(taxReturnsPeriodId);
			
			validateFinancialReportingRequirements();

			if(AgreementReqObjs != null){
				for(RecordTypePicklistObject agmObj : AgreementReqObjs){
					if(agmObj.sObj.Include_In_Agreement__c.startsWith('Yes')){
						validateIncludeInAgreement(agmObj);												
						if(agmObj.sObj.Id == null){
							agmObj.sObj.Agreement_Client_Relationship__c = agmtClientRel.Id;
						}
						docsToSave.add(agmObj.sObj);												
					}else if(agmObj.sObj.Include_In_Agreement__c == 'No' && agmObj.sObj.Id != null){
						docsToDelete.add(agmObj.sObj);   
					}
				}
			}

			if(pageHasErrors()) return null;

			m_dataProvider.updateAgreementClientRelationships(agmtClientRel);
			m_dataProvider.updateAccount(agmtClientRel.Entity__r);
			m_dataProvider.saveAgreementFinancialDocuments(docsToSave);
			m_dataProvider.deleteAgreementFinancialDocuments(docsToDelete);						
			m_agreementValidator.ValidateAndSave(new Agreement__c(Id=agmtClientRel.Agreement__c));

			if(!pageHasErrors()){
				controller = new ApexPages.standardController(agmt);
				return Controller.view();
			}
		}catch(Exception ex){
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage());
			ApexPages.addMessage(myMsg);           
		}
		return null;
	}

	public Boolean pageHasErrors(){
		return (ApexPages.getMessages().size() > 0) ? true : false;
	}

	public String personalFinancialStatementId {get;set;}
	public String annualFinancialStatementId {get;set;}
	public String annualFinancialStatementOtherTypeId {get;set;}
	public String interimStatementId {get;set;}
	public String taxReturnsId {get;set;}
	public String annualFinancialStatementPeriodId {get;set;}
	public String interimStatementPeriodId {get;set;}
	public String taxReturnsPeriodId {get;set;}
	public List<SelectOption> personalFinancialStatementOptions{
		get{
				return getSelectOptionsForFieldResult(Agreement_Client_Relationships__c.Personal_Financial_Statement__c.getDescribe(),false);
		}
	}
	public List<SelectOption> annualFinancialStatementOptions{
		get{
				return getSelectOptionsForFieldResult(Agreement_Client_Relationships__c.Annual_Financial_Statements__c.getDescribe(),false);
		}
	}
	public List<SelectOption> otherTypeOptions{
		get{
				return getSelectOptionsForFieldResult(Agreement_Client_Relationships__c.Other_Type__c.getDescribe(),true);
		}
	}
	public List<SelectOption> interimStatementOptions{
		get{
				return getSelectOptionsForFieldResult(Agreement_Client_Relationships__c.Interim_Statements__c.getDescribe(),false);
		}
	}
	public List<SelectOption> taxReturnsOptions{
		get{
				return getSelectOptionsForFieldResult(Agreement_Client_Relationships__c.Tax_Returns__c.getDescribe(),false);
		}
	}
	public List<SelectOption> annualFinancialStatementPeriodOptions{
		get{
			//return getSelectOptionsForFieldResult(Agreement_Client_Relationships__c.Annual_Stmt_Days_Due_After_Fiscal_Y_E__c.getDescribe(),true);
			List<SelectOption> options = new List<SelectOption>();
			options.add(new SelectOption('0','--None--'));
			options.add(new SelectOption('15','15'));
			options.add(new SelectOption('30','30'));
			options.add(new SelectOption('45','45'));
			options.add(new SelectOption('60','60'));
			options.add(new SelectOption('90','90'));
			options.add(new SelectOption('120','120'));
			options.add(new SelectOption('-1','Other'));            
			return options;
		}
	}
	public List<SelectOption> interimStatementPeriodOptions{
		get{
			//return getSelectOptionsForFieldResult(Agreement_Client_Relationships__c.Interim_Stmt_Days_Due_After_Period_End__c.getDescribe(),true);
			List<SelectOption> options = new List<SelectOption>();
			options.add(new SelectOption('0','--None--'));
			options.add(new SelectOption('15','15'));
			options.add(new SelectOption('30','30'));
			options.add(new SelectOption('45','45'));           
			options.add(new SelectOption('-1','Other'));         
			return options;
		}
	}
	public List<SelectOption> taxReturnPeriodOptions{
		get{
			//return getSelectOptionsForFieldResult(Agreement_Client_Relationships__c.Tax_Return_Days_Due_After_Filing__c.getDescribe(),true);
			List<SelectOption> options = new List<SelectOption>();
			options.add(new SelectOption('0','--None--'));
			options.add(new SelectOption('15','15'));
			options.add(new SelectOption('30','30'));            
			options.add(new SelectOption('-1','Other'));         
			return options;
		}
	}
	private List<SelectOption> getSelectOptionsForFieldResult(Schema.DescribeFieldResult fieldResult, Boolean includeNoneOption){
		List<SelectOption> options = new List<SelectOption>();
		if(includeNoneOption){
			options.add(new SelectOption('','--None--'));
		}
		List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
		for(Schema.PicklistEntry p : pList){
			options.add(new SelectOption(p.getLabel(),p.getLabel()));
		}
		return options;
	}
	
	public Boolean showAnnualStatementPeriodOther{
		get{
			return annualFinancialStatementPeriodId == '-1' ? true : false;
		}
	}
	
	public Boolean showInterimStatementPeriodOther{
		get{
			return interimStatementPeriodId == '-1' ? true : false;
		}
	}
	
	public Boolean showTaxReturnPeriodOther{
		get{
			return taxReturnsPeriodId == '-1' ? true : false;
		}
	}
	
	public Boolean showEntitiesToCombine {
		get {
			return annualFinancialStatementOtherTypeId == 'Combined' ? true : false;
		}
	}

  	public boolean canEditAgreement{
  		get{
  			if(canEditAgreement == null){
  				canEditAgreement = m_agreementStatusManager.isAgreementEditable(agmt,UserInfo.getUserId());
  			}
  			return canEditAgreement;
  		}
  		private set;
  	}

}