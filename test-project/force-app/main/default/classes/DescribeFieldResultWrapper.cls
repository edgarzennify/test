public class DescribeFieldResultWrapper implements IDescribeFieldResult {
    
    private final Schema.DescribeFieldResult m_describeFieldResult;
    
    public DescribeFieldResultWrapper(Schema.DescribeFieldResult describeFieldResult) {
        m_describeFieldResult = describeFieldResult;
    }
    
    public string getLabel() {
        return m_describeFieldResult.getLabel();
    }
    
    public string getName() {
        return m_describeFieldResult.getName();
    }

    public String getInlineHelpText() {
        return m_describeFieldResult.getInlineHelpText();
    }


    public List<ISObjectType> getReferenceTo(){
        List<ISObjectType> sobjTypes = new List<ISObjectType>();
        for(Schema.SObjectType st: m_describeFieldResult.getReferenceTo()){
            ISObjectType stype = new SObjectTypeWrapper(st);
            sobjTypes.add(stype);
        }
        return sobjTypes;
    }

    public Type getType() {
        if(m_describeFieldResult.getType() == Schema.DisplayType.Reference){
            return Type.TypeReference;        
        }else if(m_describeFieldResult.getType() == Schema.DisplayType.Boolean) {
            return Type.TypeBoolean;
        }else if(m_describeFieldResult.getType() == Schema.DisplayType.Picklist) {
            return Type.TypePicklist;
        }else if(m_describeFieldResult.getType() == Schema.DisplayType.Date) {
            return Type.TypeDate;
        }else if(m_describeFieldResult.getType() == Schema.DisplayType.DateTime) {
            return Type.TypeDateTime;
        }else if(m_describeFieldResult.getType() == Schema.DisplayType.Double) {
             return Type.TypeDouble;
        }else if(m_describeFieldResult.getType() == Schema.DisplayType.Integer) {
            return Type.TypeInteger;
        }else if(m_describeFieldResult.getType() == Schema.DisplayType.Currency) {
            return Type.TypeCurrency;
        }else if(m_describeFieldResult.getType() == Schema.DisplayType.TextArea) {
            return Type.TypeTextArea;
        }else if(m_describeFieldResult.getType() == Schema.DisplayType.Phone) {
            return Type.TypePhone;
        }else if(m_describeFieldResult.getType() == Schema.DisplayType.Multipicklist) {
            return Type.TypeMultipicklist;
        }
        return Type.TypeText;
    }
    
    public Boolean isUpdateable() {
        return m_describeFieldResult.isUpdateable();
    }

    public Boolean isCreateable() {
        return m_describeFieldResult.isCreateable();
    }

    public Boolean isCalculated() {
        return m_describeFieldResult.isCalculated();
    }

    public Boolean isAccessible() {
        return m_describeFieldResult.isAccessible();
    }
    
    public List<IPicklistEntry> getPicklistValues() {
        List<IPicklistEntry> picklist = new List<IPicklistEntry>();
        for(Schema.PicklistEntry pe : m_describeFieldResult.getPicklistValues()) {
            picklist.add(new PicklistEntryWrapper(pe));
        }
        return picklist;
    }

    public Enum Type {
        TypeBoolean,
        TypeCurrency,
        TypeDate,
        TypeDateTime,
        TypePicklist,
        TypeDouble,
        TypeInteger,
        TypeText,
        TypeTextArea,
        TypePhone,
        TypeMultipicklist,
        TypeReference
    }
}