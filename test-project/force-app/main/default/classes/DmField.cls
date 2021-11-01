public class DmField implements Comparable {
    public String Name{get;set;}
    public string AlternateName{get;set;}
    public String Label{get;set;}
    public String ObjectName {get;set;}
    public String HelpText {get;set;}
    public Boolean Correlated {get;set;}
    public Boolean Readonly {get;set;}
    public Boolean Edit {get;set;}
    public Boolean View {get;set;}
    public Boolean Report {get;set;}
    public Decimal EditPlacement{get;set;}
    public Decimal ViewPlacement{get;set;}
    public Decimal ReportPlacement{get;set;}
    public String SectionId {get;set;}
    public String SectionGroupName {get;set;}
    public String SectionGroupType {get;set;}
    public Decimal SortBySelectedPlacement {get;set;}
    public Boolean IsUpdatable {get;set;}
    public Boolean IsCreatable {get;set;}
    public Boolean IsAccessible {get;set;}
    public DescribeFieldResultWrapper.Type  Type {get;set;}
    public List<IPicklistEntry> Picklist {get;set;}


    public Integer compareTo(Object compareTo) {
            DmField other = (DmField) compareTo;
            if (SortBySelectedPlacement == other.SortBySelectedPlacement) return 0;
            if (SortBySelectedPlacement > other.SortBySelectedPlacement) return 1;
            return -1;
    }
}