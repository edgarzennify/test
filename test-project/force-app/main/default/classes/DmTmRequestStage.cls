public class DmTmRequestStage {
    public String id{get;set;}
    public String name{get;set;}
    public String type{get;set;}
    public String permission{get;set;}
    public DmTmRequestStage autoForwardStage{get;set;}    
    public List<DmTmRequestStage> relatedStages{get;set;}
}