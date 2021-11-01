({
	_oObj : null,
	_aFields : null,
	_oOverlay : null,
	_sGoogle : "https://maps.googleapis.com/maps/api/staticmap?size=640x400&key=",
	init: function(oComponent) {
		var aData = [],
			aAllFields = [],
			self = this;
		if (!$A.util.isEmpty(oComponent.get('v.sListFields'))) {
			aAllFields = aAllFields.concat(oComponent.get('v.sListFields').toLowerCase().split(','));
		}
		if (!$A.util.isEmpty(oComponent.get('v.sDetailsFields'))) {
			aAllFields = aAllFields.concat(oComponent.get('v.sDetailsFields').toLowerCase().split(','));
		}
		if (!$A.util.isEmpty(oComponent.get('v.sTZ'))) {
			aAllFields.push(oComponent.get('v.sTZ').toLowerCase());
		}
		if (!$A.util.isEmpty(oComponent.get('v.sPhoto'))) {
			aAllFields.push(oComponent.get('v.sPhoto').toLowerCase());
		}
		if (!$A.util.isEmpty(oComponent.get('v.sAddress'))) {
			aAllFields.push(oComponent.get('v.sAddress').toLowerCase());
		}
		if (!$A.util.isEmpty(oComponent.get('v.sSort'))) {
			aAllFields.push(oComponent.get('v.sSort').trim().replace(/(\sDESC|\sASC)/gi, '').toLowerCase());
		}
		aAllFields = aAllFields.unique();
		self._aFields = aAllFields;
		this._request(
			oComponent, 
			{
			'event' : 'getStructure',
			'object' : oComponent.get('v.sOfficeObject'),
			'fields' : aAllFields.join(',')
		}, function(data){
//			console.log('== data ', data);
			self._oObj = data;
			self._oObj.fields = JSON.parse(data.fields);
			self.load(oComponent);
		});
	},

	load : function(oComponent) {
		var self = this,
			sTZ = oComponent.get('v.sTZ'),
			sFormat = $A.get("$Locale.timeFormat").replace(':ss', '').replace(':s', ''),
			aAllFields = oComponent.get('v.sListFields').toLowerCase().split(','),
			aDetailFields = oComponent.get('v.sDetailsFields').toLowerCase().split(','),
			sAddrField = oComponent.get('v.sAddress').toLowerCase(),
			sImgField = oComponent.get('v.sPhoto').toLowerCase(),
			sImgType = !$A.util.isEmpty(sImgField) ? this._getField(sImgField).type : null,
			//sSort = !$A.util.isEmpty(oComponent.get('v.sSort')) ? this._getField(oComponent.get('v.sSort').toLowerCase()).name : null;
			sSort = !$A.util.isEmpty(oComponent.get('v.sSort')) ? oComponent.get('v.sSort').toLowerCase() : null;
		if (sTZ != undefined) {
			sTZ = sTZ.toLowerCase();
		}
		

		this._request(
			oComponent, 
			{
			'event' : 'getData',
			'title' : 'name',
			'filter' : oComponent.get('v.sFilter'),
			'object' : oComponent.get('v.sOfficeObject'),
			'sort'   : sSort != null ? sSort + (oComponent.get('v.bSortDesc') ? ' DESC ' : '') : '',
			'fields' : self._aFields.join(',').toLowerCase(),
		}, function(data){
			var dD = moment(),
				aOffices = JSON.parse(data.events),
				aResult = [],
				oEvent,
				mFieldValue;
			for (var nJ = 0; nJ < aOffices.length; nJ++) {
				oEvent = {
					"title" 	: aOffices[nJ].title,
					"id" 		: aOffices[nJ].id,
					'fields' 	: [],
					'date'      : dD.format(sFormat),
					"idx"  		: aResult.length,
					"detail"	: [],
					"img"		: sImgType === 'URL'&& !$A.util.isEmpty(sImgField) ? aOffices[nJ][sImgField] : "",
					"imgRich"	: sImgType === 'TEXTAREA' && !$A.util.isEmpty(sImgField) ? aOffices[nJ][sImgField] : "",
					'mapPath'   : self._sGoogle + oComponent.get('v.sGoogleKey')  
									+ '&markers=' + aOffices[nJ][sAddrField],
					"address"   : aOffices[nJ][sAddrField]
				};
				if (!$A.util.isEmpty(sTZ)) {
					oEvent.date = dD.clone().tz(aOffices[nJ][sTZ]).format(sFormat);
				}
                var bCut = oComponent.get('v.sStripTags');
				oEvent.fields = self._getFieldsValues(aOffices[nJ], aAllFields, bCut);
				oEvent.detail = self._getFieldsValues(aOffices[nJ], aDetailFields);
				aResult.push(oEvent);
			}
			oComponent.set('v._aData', aResult);
			//console.log(aResult);
		});
	},

	_request : function(oComponent, aParams, fFunc, fError){
		var oAction = oComponent.get("c.CA_Remote"),
            aResult = {};
        
        
		oAction.setParams({'sIncomeParams' : JSON.stringify(aParams)});
		oAction.setCallback(oComponent, function(oResponse) {
            var sState = oResponse.getState();
            if (sState === "SUCCESS") {
                
                try {
                    aResult = JSON.parse(oResponse.getReturnValue());
                } catch (e){
//                    console.log(oResponse.getReturnValue(), e);
                    
                }
            	
                fFunc(aResult);
            } else if (sState === "ERROR") {
                var aErrors = oResponse.getError();
                if (aErrors) {
                    if (aErrors[0] && aErrors[0].message) {
                    	console.log('Lighthning error: ' + aErrors[0].message);
                    }
                } else {
                	console.log('Lighthning error');
                }
                if (typeof(fError) == 'function') {
                	fError(aErrors);
                }
            }
        });
        $A.enqueueAction(oAction);
	},

	_getField : function(sName) {
		return this._oObj.fields[sName] !== undefined ? this._oObj.fields[sName] : null;
	},

	_getFieldAsString : function(aField, mValue, oAllEvent, bCut) {
		var mResult,
			dD;
		switch(aField.type) {
			case 'DATE':
				dD = SFParse(mValue);
				//$A.localizationService.parseDateTime(mValue);
				mResult = $A.localizationService.formatDate(dD);
				break;
			case 'DATETIME':
				dD = SFParse(mValue, true);
					//$A.localizationService.parseDateTime(mValue);
				mResult = $A.localizationService.formatDateTime(dD);
				break;
			case 'REFERENCE':
				if (oAllEvent[aField.name + '.name'] !== undefined) {
					mResult = {'link' : mValue, 'value' : this._cutString(oAllEvent[aField.name + '.name'], 50)};
				} else {
					mResult = mValue;
				}
				break;
			case 'TEXTAREA' :
				if (aField.isHTML == 'true' || aField.isHTML === true) {
					if (bCut) {
						mResult = this._cutString(mValue.strip_tags(), 50);
                        console.log(mValue, ' mResult')
					} else {
						mResult = {"html" : true, "value" : mValue};
					}
				} else {
					if (bCut) {
						mResult = this._cutString(mValue, 50);
					} else {
						mResult = {"html" : true, "value" : mValue.nl2br()};
					}
				} 
				break;
			default:
				if (bCut) {
					mResult = this._cutString(mValue, 50);
				} else {
					mResult = mValue;
				}
		}
		return mResult;
	},

	_cutString : function(sStr, nLength) {
		nLength = nLength || 0;
		if (nLength < 1 || !sStr.length || sStr.length < nLength) {
			return sStr;
		}
		var nPos = sStr.indexOf(' ', nLength) || sStr.indexOf('.', nLength) || sStr.indexOf(',', nLength);
		if (nPos >= nLength){
			sStr = sStr.substring(0, nPos) + '...';
		}
		return sStr;
	},
	_getFieldsValues : function(oRecord, aFields, bCut) {
		var aRes = [],
			mFieldValue,
			aFieldData,
			aField;
		for (var nF = 0; nF < aFields.length; nF++) {
			aField = this._getField(aFields[nF]);
			if (aField === undefined || aField === null ) {
				continue;
			}
			aFieldData = {"label" : aField.label};
			if (oRecord[aFields[nF]] === undefined) {
				aFieldData.value = '';
			} else {
				mFieldValue = this._getFieldAsString(aField, oRecord[aFields[nF]], oRecord, bCut);
		
				if (mFieldValue.link !== undefined && mFieldValue.value !== undefined) {
					aFieldData.value = mFieldValue.value;
					aFieldData.link = mFieldValue.link;
				} else if (mFieldValue.value !== undefined){
					aFieldData.value = mFieldValue.value;
					aFieldData.html = mFieldValue.html;
				} else {
					aFieldData.value = mFieldValue;
				}
			}

			aRes.push(aFieldData);
		}
		return aRes;
	},
	_showDetail : function(oComponent, oEl) {
		var self = this;
		oComponent.set('v._oEl', oEl);
	}
})