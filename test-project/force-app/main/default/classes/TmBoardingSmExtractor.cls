public class TmBoardingSmExtractor implements TmBoarding.ISmExtractor {
	private String SPLIT_DELIMITER = '\\.';
	private String SELECTED_FIELD = 'selected';


	public Map<String, List<TmBoarding.SaveSm>> getObjectsById(String objectName, List<TmBoarding.SaveSm> sms) {
		Map<String, List<TmBoarding.SaveSm>> fields = new Map<String, List<TmBoarding.SaveSm>>();
		for(TmBoarding.SaveSm sm: sms) {
			Map<String, String> objAndFld = getObjectAndField(sm);
			if(objAndFld != null) {
				if(objAndFld.ContainsKey(objectName.tolowercase())){
					if(!fields.containsKey(sm.ObjectId)) {
						fields.put(sm.ObjectId, new List<TmBoarding.SaveSm>());
					}
					fields.get(sm.ObjectId).add(sm);
				}
			}
		}
		return fields;
	}

	public List<TmBoarding.SaveSm> getObjectsWithoutId(String objectName, List<TmBoarding.SaveSm> sms) {
		Map<String, List<TmBoarding.SaveSm>> fields = new Map<String, List<TmBoarding.SaveSm>>();
		String objName = objectName.tolowercase();
		for(TmBoarding.SaveSm sm : sms) {
			
			if(String.isBlank(sm.ObjectId)){
				Map<String, String> objAndFld = getObjectAndField(sm);
				if(objAndFld != null && objAndFld.ContainsKey(objName)){
					if(!fields.containsKey(objName)) {
						fields.put(objName, new List<TmBoarding.SaveSm>());
					}
					fields.get(objName).add(sm);
				}
			}
		}

		return fields.get(objName);
	}

	public Map<String, List<TmBoarding.SaveSm>> getNewObjectsByParentId(String objectName, List<TmBoarding.SaveSm> sms) {
		Map<String, List<TmBoarding.SaveSm>> fields = new Map<String, List<TmBoarding.SaveSm>>();
		for(TmBoarding.SaveSm sm: sms) {
			Map<String, String> objAndFld = getObjectAndField(sm);
			if(objAndFld != null) {
				if(objAndFld.ContainsKey(objectName.tolowercase())){

					if(String.IsBlank(sm.ObjectId) && String.IsNotBlank(sm.ParentId) && String.IsBlank(sm.RelatedId)) {
						if(!fields.containsKey(sm.ParentId)) {
							fields.put(sm.ParentId, new List<TmBoarding.SaveSm>());
						}
						fields.get(sm.ParentId).add(sm);
					}
				}
			}
		}
		return fields;
	}

	public List<TmBoarding.SaveSm> getNewObjectWithoutId(String objectName, List<TmBoarding.SaveSm> sms) {
		List<TmBoarding.SaveSm> fields = new List<TmBoarding.SaveSm>();
		for(TmBoarding.SaveSm sm : sms) {
			Map<String, String> objAndFld = getObjectAndField(sm);
			if(objAndFld != null) {
				if(objAndFld.ContainsKey(objectName.tolowercase())){
					if(String.IsBlank(sm.ObjectId) && String.IsBlank(sm.ParentId)) {
						fields.add(sm);
					}
				}
			}
		}
		return fields;
	}

	public Map<String, List<TmBoarding.SaveSm>> getObjectsWithoutIdAndParentId(String objectName, List<TmBoarding.SaveSm> sms) {
		Map<String, List<TmBoarding.SaveSm>> fields = new Map<String, List<TmBoarding.SaveSm>>();
		for(TmBoarding.SaveSm sm : sms) {
			Map<String, String> objAndFld = getObjectAndField(sm);
			if(objAndFld != null) {
				if(objAndFld.ContainsKey(objectName.tolowercase())){
					if(String.IsBlank(sm.ObjectId) && String.IsBlank(sm.ParentId) && String.IsNotBlank(sm.RelatedId)) {
						if(!fields.containsKey(sm.RelatedId)) {
							fields.put(sm.RelatedId, new List<TmBoarding.SaveSm>());
						}
						fields.get(sm.RelatedId).add(sm);
					}
				}
			}
		}

		return fields;
	}

	public Map<String, List<TmBoarding.SaveSm>> getObjectsByParentAndRelated(String objectName, List<TmBoarding.SaveSm> sms) {
		Map<String, List<TmBoarding.SaveSm>> fields = new Map<String, List<TmBoarding.SaveSm>>();
		for(TmBoarding.SaveSm sm: sms) {
			Map<String, String> objAndFld = getObjectAndField(sm);
			if(objAndFld != null) {
				if(objAndFld.ContainsKey(objectName.tolowercase())){

					if(String.IsBlank(sm.ObjectId) && String.IsNotBlank(sm.ParentId) && String.IsNotBlank(sm.RelatedId)) {
						String key = String.format('{0}|{1}', new LIST<String> {sm.ParentId , sm.RelatedId});
						if(!fields.containsKey(key)) {
							fields.put(key, new List<TmBoarding.SaveSm>());
						}
						fields.get(key).add(sm);
					}
				}
			}
		}
		return fields;
	}

	public Map<String, Object> getObjectFields(String objectName, List<TmBoarding.SaveSm> sms) {
		Map<String, Object> fields = new Map<String, Object>();
		for(TmBoarding.SaveSm sm: sms) {
			String fieldName = getValidField(sm);

			if(String.IsNotBlank(fieldName)) {
				fields.put(fieldName, sm.FieldValue);
			}
		}
		return fields;
	}

	public Map<String, Object> getSelectedFields(String objectId ,List<TmBoarding.SaveSm> sms) {
		Map<String, Object> fields = new Map<String, Object>();
		for(TmBoarding.SaveSm sm: sms) {
			if(String.IsNotBlank(sm.FieldName) && String.IsNotBlank(sm.ObjectId)
				            && sm.FieldName.toLowerCase() == SELECTED_FIELD.toLowerCase()) {
				if(sm.ObjectId == objectId) {
					fields.put(sm.ObjectId, sm.FieldValue);
				}
			}
		}
		return fields;
	}

	public String getValidField(TmBoarding.SaveSm sm) {
		List<String> items = sm.FieldName.split(SPLIT_DELIMITER);
		return items.size() == 2 ? items[1] : '';
	}

	private Map<String,String> getObjectAndField(TmBoarding.SaveSm sm) {
		List<String> items = sm.FieldName.split(SPLIT_DELIMITER);
		return items.size() == 2 ? new Map<string, string>{items[0].toLowerCase() => items[1]} : null;
	}
}