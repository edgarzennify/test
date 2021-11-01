public class ObjectForward {
    
    public interface IManager{
        IForwardingInfo getForwardingInfo(String origObjName, String origObjRecordTypeName, Id origObjId);
        PageReference redirect(IForwardingInfo forwardingInfo, String originalUrl);
    }
     
    public interface IDataProvider {
        List<DmForward> getForwards(String origObjName, String origObjRecordTypeName);
        SObject queryOne(String queryString);
        List<SObject> query(String queryString);
    }
    
    public interface IDmBuilder{
        List<DmForward> buildDmForwards(List<Object_Forward__mdt> objForwards);
    }
        
    public interface IForwardingInfo{
        String getUrl();
        String getObjectLabel();
        String getRecordName();
        Boolean getShowInterstitial();
    }
    
    public class ForwardingInfo implements IForwardingInfo{
        public String url { get; set; }
        public String getUrl(){ return Url;}
        public String objectLabel {get;set;}
        public String getObjectLabel(){ return ObjectLabel;}
        public String recordName {get;set;}
        public String getRecordName(){ return RecordName;}
        public Boolean showInterstitial {get;set;}
        public Boolean getShowInterstitial(){ return ShowInterstitial;}
        public ForwardingInfo(String u, String l, String r, Boolean s){
            Url = u;
            ObjectLabel = l;
            RecordName = r;
            ShowInterstitial = s;
        }
        public ForwardingInfo(){            
        }
    }
    
    public class DmForward {
        public Schema.sObjectType sObjectType {get;set;}        
        public String lookupField {get;set;}
        public Boolean showInterstitial {get;set;}
        public String objectLabel {
            get{ return (sObjectType != null) ? sObjectType.getDescribe().getLabel() : ''; }
        }
        public String objectName {
            get{ return (sObjectType != null) ? sObjectType.getDescribe().getName() : ''; }
        }        
        public String originalObjectName {get;set;}
        public String originalObjectLookupField {get;set;}
    }
}