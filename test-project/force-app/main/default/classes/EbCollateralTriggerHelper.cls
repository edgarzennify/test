public  class EbCollateralTriggerHelper {

     private Map<string , Utility.QueryParam> QueryParamMap{
	    	get{
		    	if(QueryParamMap == null) QueryParamMap = new Map<string , Utility.QueryParam>();
		    	return QueryParamMap;
	    	}
	    	set;
	 }
	private Map<id,EB_Loan_App_Collateral_Relationship__c> LoanAppCollateralMap{
	    	get{
	    		if(LoanAppCollateralMap == null) LoanAppCollateralMap = new Map<id,EB_Loan_App_Collateral_Relationship__c>();
	    		return LoanAppCollateralMap;
	    	}
	    	set;
	} 
	private Map<id,EB_Loan_App_Stage_Validation_Rule__c> relatedCollateralRuleMap{
	        get{
	            if(relatedCollateralRuleMap == null){
	                relatedCollateralRuleMap = new Map<id,EB_Loan_App_Stage_Validation_Rule__c>([SELECT id,Name,Object_Name__c,Field_Name__c,Error_Text__c,Operation__c,Operand__c FROM EB_Loan_App_Stage_Validation_Rule__c WHERE Object_Name__c =: 'EB_Loan_App_Collateral_Relationship__c']);
	                system.debug('###' + string.valueof(relatedCollateralRuleMap.values().size()));
	            }
	            return relatedCollateralRuleMap;
	        }
	        set;
	}

	//public void updateValidationForRelatedCollaterals(List<EB_Collateral__c> editCollaterals){
	//	List<EB_Loan_App_Collateral_Relationship__c> updatecolRels = new List<EB_Loan_App_Collateral_Relationship__c>();
	//	for(EB_Collateral__c col: editCollaterals){
	//		for(EB_Loan_App_Collateral_Relationship__c colrel : [Select Id, Has_Missing_required_Fields__c, Missing_Required_Fields_For_Approval__c, Missing_Required_Fields_For_Doc__c FROM EB_Loan_App_Collateral_Relationship__c WHERE EB_Collateral_ID__c =:col.id]){
	//            if(colrel.Has_Missing_required_Fields__c > 0 && colrel.Missing_Required_Fields_For_Approval__c == 0 && colrel.Missing_Required_Fields_For_Doc__c == 0){
	//              colrel.Has_Missing_required_Fields__c = 0;	           
	//              updatecolrels.add(colrel);	                      
	//            }
	//            if(colrel.Has_Missing_required_Fields__c == 0 && (colrel.Missing_Required_Fields_For_Approval__c > 0 || colrel.Missing_Required_Fields_For_Doc__c > 0)){  
	//              colrel.Has_Missing_required_Fields__c = colrel.Missing_Required_Fields_For_Approval__c + colrel.Missing_Required_Fields_For_Doc__c;
	//              updatecolrels.add(colrel);          
	//            }
	//          LoanAppCollateralMap.put(colrel.id,colrel);
	//		}
	//    }
	//    if(updatecolrels.size() > 0) update updatecolrels;
	    
	//    CalculateStageValidation();
	    
	//}

	public void updateValidationForRelatedCollaterals(List<EB_Collateral__c> editCollaterals) {
		List<EB_Loan_App_Collateral_Relationship__c> updatecolRels = new List<EB_Loan_App_Collateral_Relationship__c>();
		List<EB_Collateral__c> collateralsWithRelated = getCollateralsWithLoanRelationship(editCollaterals);
		for(EB_Collateral__c col: collateralsWithRelated){
			for(EB_Loan_App_Collateral_Relationship__c related : col.EB_Collateral_Relationships__r) {
	            if(related.Has_Missing_required_Fields__c > 0 && related.Missing_Required_Fields_For_Approval__c == 0 && related.Missing_Required_Fields_For_Doc__c == 0){
	              related.Has_Missing_required_Fields__c = 0;	           
	              updatecolrels.add(related);	                      
	            }
	            if(related.Has_Missing_required_Fields__c == 0 && (related.Missing_Required_Fields_For_Approval__c > 0 || related.Missing_Required_Fields_For_Doc__c > 0)){  
	              related.Has_Missing_required_Fields__c = related.Missing_Required_Fields_For_Approval__c + related.Missing_Required_Fields_For_Doc__c;
	              updatecolrels.add(related);          
	            }
	          LoanAppCollateralMap.put(related.id,related);
			}
	    }
	    if(updatecolrels.size() > 0) update updatecolrels;
	    
	    CalculateStageValidation();
	}

	private List<EB_Collateral__c> getCollateralsWithLoanRelationship(List<EB_Collateral__c> editCollaterals) {
		return [
			SELECT
				    Id,
				    Name,
					(Select Id,
					       Has_Missing_required_Fields__c,
					       Missing_Required_Fields_For_Approval__c,
					       Missing_Required_Fields_For_Doc__c 
					FROM EB_Collateral_Relationships__r
					)
			FROM
				    EB_Collateral__c
		    WHERE
		    	    Id in: editCollaterals
		];
	}

	private Map<Id, EB_Collateral__c> getCollaterals(List<EB_Collateral__c> editCollaterals) {
		Map<Id, EB_Collateral__c> colls = new Map<Id, EB_Collateral__c>();
		for(EB_Collateral__c col: editCollaterals) {
			colls.put(col.Id, col);
		}
		return colls;
	}
	
	 public void CalculateStageValidation( ){
	    
	    	system.debug('%% calc' + string.valueof(LoanAppCollateralMap.values().size()));
	    	
	    	if(LoanAppCollateralMap.values().size()> 0){
	    		Map<id,string> errorMap = StageActionValidation( );
		    	List<EB_Loan_App_Collateral_Relationship__c> updateList = new List<EB_Loan_App_Collateral_Relationship__c>();
		    	
			    	for(EB_Loan_App_Collateral_Relationship__c rel : LoanAppCollateralMap.values()){
			    		if(errorMap!= null){ 
			    			   system.debug('### error ' + string.valueof(errorMap.values().size()) );
				    			if(errorMap.containskey(rel.id)){
					    		rel.Stage_Validation_Details__c = errorMap.get(rel.id);
					    		updateList.add(rel);
			    			}
			    		}else{
			    			rel.Stage_Validation_Details__c =  '';
			    			updateList.add(rel);
			    		}
			    			
			    	}
		
		    	if(updateList.size() > 0) update updateList;
	    	}
	    }    
        public Map<id,String> StageActionValidation(){
    	                     
    	                   
            Map<id,String> errorMap = new Map<id,String>();
            
            String sReturn = '';
            String sDelimiter = ' / ';
            system.debug('%% 1' );
            for(EB_Loan_App_Collateral_Relationship__c rel : LoanAppCollateralMap.values()){
            	String Error = '';
	            for(EB_Loan_App_Stage_Validation_Rule__c rule : relatedCollateralRuleMap.values()){             
	                String objectName = rule.Object_Name__c;
	                String fieldName = rule.Field_Name__c;                  
	                String operator = rule.Operation__c;
	                String operand = rule.Operand__c;
	                 system.debug('##:StageActionValidation 2');
	                //Code is used to override rule name with a custom description
	                String ruleName = '';
	                if(rule.Error_Text__c == '' || rule.Error_Text__c == null )
	                	 ruleName = rule.Name;
	                else
	                	ruleName = rule.Error_Text__c;
	                	
	                Id objID = rel.id;     
	                QueryParamMap.put(ruleName , new utility.QueryParam(objID,objectName,fieldName,operator,operand,ruleName));                     
	                 system.debug('%% rule: ' +  ruleName + '/' + objectName + '/' + fieldName + '/' + operator + '/' + operand);
	        	} 
	        	String errors = '';
	        	system.debug('%% errortrap: ' +  errors);
	        	Map<String,String> results = utility.IsStageActionFieldValid('EB_Collateral_ID__r',QueryParamMap);
	        	for(string s : results.values()){
	        		errors = errors + s + '; ';
	        	}
	        	errorMap.put(rel.id,errors); 
	        	system.debug('%% errortrap2: ' +  errors);
            }

            return errorMap;
	        
        }
      
}