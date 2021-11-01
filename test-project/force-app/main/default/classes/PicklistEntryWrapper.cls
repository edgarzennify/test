public class PicklistEntryWrapper implements IPicklistEntry {
    
    private final Schema.PicklistEntry m_picklistEntry;
    
    public PicklistEntryWrapper(Schema.PicklistEntry picklistEntry) {
        m_picklistEntry = picklistEntry;
    }
    
    public string getLabel() {
        return m_picklistEntry.getLabel();
    }
    
    public String getValue() {
        return m_picklistEntry.getValue();
    }
    
    public Boolean isActive() {
        return m_picklistEntry.isActive();
    }
    
    public Boolean isDefaultValue() {
        return m_picklistEntry.isDefaultValue();
    }
}