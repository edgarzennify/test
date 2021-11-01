@isTest
public class InterstitialMock {

    public class ofIEbAccount_InterstitialDataProvider extends ApexMoq implements Interstitial.IEbAccount_InterstitialDataProvider{
        public List<EB_Account__c> getEbAccountById(Id recordId){
            return (List<EB_Account__c>)handleMethodInvocation('getEbAccountById', new List<Object>{recordId});
        } 
    } 

	public class ofIEbCollateral_InterstitialDataProvider extends ApexMoq implements Interstitial.IEbCollateral_InterstitialDataProvider{
        public List<EB_Collateral__c> getEbCollateralById(Id recordId){
            return (List<EB_Collateral__c>)handleMethodInvocation('getEbCollateralById', new List<Object>{recordId});
        } 
    } 

    public class ofIObjectForwardManager extends ApexMoq implements ObjectForward.IManager{
        public ObjectForward.IForwardingInfo getForwardingInfo(String origObjName, String origObjRecordTypeName, String origObjLookupFieldValue){
            return (ObjectForward.IForwardingInfo)handleMethodInvocation('getForwardingInfo', new List<Object>{origObjName, origObjRecordTypeName, origObjLookupFieldValue});
        }
        public PageReference redirect(ObjectForward.IForwardingInfo forwardingInfo, String originalUrl){
            return (PageReference)handleMethodInvocation('redirect', new List<Object>{forwardingInfo, originalUrl});
        }
    }
    
    public class ofIForwardingInfo extends ApexMoq implements ObjectForward.IForwardingInfo{
        public String getUrl(){
            return (String)handleMethodInvocation('getUrl');
        }
        public String getObjectLabel(){
            return (String)handleMethodInvocation('getObjectLabel');
        }
        public String getRecordName(){
            return (String)handleMethodInvocation('getRecordName');
        }
        public Boolean getShowInterstitial(){
            return (Boolean)handleMethodInvocation('getShowInterstitial');
        }
    }
}