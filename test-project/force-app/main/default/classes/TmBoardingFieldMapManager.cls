public class TmBoardingFieldMapManager implements TmBoarding.IFieldMapManager {

	private static Map<string, Map<string,Schema.SObjectField>> m_fieldMap;

	public Schema.SObjectField getField(string objectName, string fieldName) {
		if(m_fieldMap == null) {
			m_fieldMap = new Map<string, Map<string,Schema.SObjectField>>();
		}
		if(!m_fieldMap.containsKey(objectName)){
			m_fieldMap.put(objectName,Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap());
		}
    	return m_fieldMap.get(objectName).get(fieldName);
    }

    public String getFieldHelpText(Schema.SObjectField fld) {
        if(fld == null) {return '';}
        Schema.DescribeFieldResult fieldDescribe = fld.getDescribe();
        return fieldDescribe.getInlineHelpText();
    }

    public String getFieldName(Schema.SObjectField fld) {
        if(fld == null) {return '';}
        Schema.DescribeFieldResult fieldDescribe = fld.getDescribe();
        return fieldDescribe.getName();
    }

    public Schema.DisplayType getType(Schema.SObjectField fld) {
        if(fld == null) {return null;}
        Schema.DescribeFieldResult fieldDescribe = fld.getDescribe();
        return fieldDescribe.getType();
    }

    public List<Schema.PicklistEntry> getPicklist(Schema.SObjectField fld) {
        if(fld == null) {return null;}
        Schema.DescribeFieldResult fieldDescribe = fld.getDescribe();
        return fieldDescribe.getPicklistValues();
    }

    public boolean IsFieldValid(string objectName, string fieldName) {
    	Schema.SObjectField f = getField(objectName, fieldName);
    	return f == null ? false : true;
    }

    public boolean IsFieldUpdatable(Schema.SObjectField field) {
    	return field == null? false: field.getDescribe().isUpdateable();
    }

    public boolean IsFieldAccessible(Schema.SObjectField field) {
        return field == null? false: field.getDescribe().isAccessible();
    }

    public object Convert(Schema.SObjectField field, Object fieldValue) {
    	Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
    	if(fieldDescribe.getType() == Schema.DisplayType.Date) {
    		return (Object)ConvertToDate(fieldValue);
    	} else if (fieldDescribe.getType() == Schema.DisplayType.DateTime) {
    		return (Object)ConvertToDateTime(fieldValue);
    	} else if (fieldDescribe.getType() == Schema.DisplayType.Currency) {
    		return (Object)ConvertToDecimal(fieldValue);
    	} else if (fieldDescribe.getType() == Schema.DisplayType.Boolean) {
    		return (Object)ConvertToBoolean(fieldValue);
    	} else if (fieldDescribe.getType() == Schema.DisplayType.Integer) {
            return (Object)ConvertToInteger(fieldValue);
        } else if (fieldDescribe.getType() == Schema.DisplayType.Double) {
            return (Object)ConvertToDouble(fieldValue);
        }
    	return fieldValue;
    }

    public object fillEmpty(Schema.SObjectField field) {
    	Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
    	if(fieldDescribe.getType() == Schema.DisplayType.Date) {
    		return null;
    	} else if (fieldDescribe.getType() == Schema.DisplayType.DateTime) {
    		return null;
    	} else if (fieldDescribe.getType() == Schema.DisplayType.Currency) {
    		return (Object)ConvertToDecimal('');
    	} else if (fieldDescribe.getType() == Schema.DisplayType.Boolean) {
    		return (Object)ConvertToBoolean('');
    	} else if (fieldDescribe.getType() == Schema.DisplayType.Integer) {
            return (Object)ConvertToInteger('');
        } else if (fieldDescribe.getType() == Schema.DisplayType.Double) {
            return (Object)ConvertToDouble('');
        }
    	return null;
    }

    private DateTime ConvertToDateTime(Object dateValue) {
    	String dateValueStr = String.valueOf(dateValue);
    	if(string.isBlank(dateValueStr)) return null;
    	Decimal dtInt = Decimal.valueOf(dateValueStr);
        DateTime dt =  DateTime.newInstance(1970, 1, 1);
        DateTime dt2 = dt.addSeconds((Integer)(dtInt/1000));
        return dt2;
    }

    private Date ConvertToDate(Object dateValue) {
    	DateTime dt1 = ConvertToDateTime(dateValue);
    	if(dt1 == null) return null;
    	Date dt2 = Date.ValueOf(dt1);
        return dt2;
    }

    private Decimal ConvertToDecimal(Object value) {
    	String sValue = String.valueOf(value);
    	return String.IsBlank(sValue)  ?  Decimal.valueOf('0.00') : Decimal.valueOf(sValue);
    }

    private Decimal ConvertToInteger(Object value) {
        String sValue = String.valueOf(value);
        return String.IsBlank(sValue)  ?  Integer.valueOf('0') : Integer.valueOf(sValue);
    }

    private Decimal ConvertToDouble(Object value) {
        String sValue = String.valueOf(value);
        return String.IsBlank(sValue)  ?  Double.valueOf('0') : Double.valueOf(sValue);
    }

    private Boolean ConvertToBoolean(Object value) {
    	String sValue = String.valueOf(value);
    	return String.IsBlank(sValue)  ?  false : Boolean.valueOf(sValue);
    }
}