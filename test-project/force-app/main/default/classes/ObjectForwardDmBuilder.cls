public class ObjectForwardDmBuilder implements ObjectForward.IDmBuilder {

    public List<ObjectForward.DmForward> buildDmForwards(List<Object_Forward__mdt> objForwards){
        List<ObjectForward.DmForward> dmForwards = new List<ObjectForward.DmForward>();
        for(Object_Forward__mdt objFwd : objForwards){
            dmForwards.add(buildDmForward(objFwd));
        }
        return dmForwards;
    }
    
    private ObjectForward.DmForward buildDmForward(Object_Forward__mdt f){
        ObjectForward.DmForward dmForward = new ObjectForward.DmForward();
        
        Type t = Type.forName(f.ForwardObjectName__c);
        SObject o = (SObject)t.newInstance();
        dmForward.sObjectType = o.getSObjectType();            
        dmForward.lookupField = f.ForwardObjectLookupField__c;            
        dmForward.showInterstitial = f.Show_Interstitial__c;
        dmForward.originalObjectName = f.OriginalObjectName__c;
        dmForward.originalObjectLookupField = f.OriginalObjectLookupField__c;
        
        return dmForward;        
    }
    
}