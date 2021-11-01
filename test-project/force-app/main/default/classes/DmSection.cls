public class DmSection implements Comparable {
	public String Id {get;set;}
	public String Name {get;set;}
    public String Label {get;set;}
	public String Lookup {get;set;}
    public Decimal Columns {get;set;}
    public Boolean Show {get;set;}
    public Decimal Placement{get;set;}
    public String Type{get;set;}
    public List<DmField> Fields{get;set;}

    public Integer compareTo(Object compareTo) {
            DmSection other = (DmSection) compareTo;
            if (Placement == other.Placement) return 0;
            if (Placement > other.Placement) return 1;
            return -1;
    }
}