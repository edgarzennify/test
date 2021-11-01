public class TmFeeCalculator implements ITmFeeCalculator{
    public interface ITmFeeCalculator{
        List<TM_Service_Request__c> Calculate(List<TM_Service_Request__c> requests); 
        List<TM_Service_Request__c> Calculate(List<TM_Fee__c> fees); 
    }
    public interface IDataProvider{
        List<Tm_fee__c> getAllFees();
        List<Tm_Service_Request_Packet__c> getAllPackets();
        List<TM_Fee_Schedule__c> getAllSchedules();
        List<TM_Product__c> getAllProducts();
        List<Tm_Service_Request__c> getAllRequests();
        List<TM_Service_Request_Stage__c> getAllStages();
    }
    public interface ITmFeeCalculatorHelper{ 
        List<Tm_Fee__c> GetFees(String clientType, String bundleType, String productType);
		String GetBundleType(TM_Service_Request__c tmRequest); 
        String GetClientType(TM_Service_Request__c tmRequest);
        String GetProductType(TM_Service_Request__c tmRequest);
        Tm_Service_Request_Packet__c GetPacket(Id packetId);
        Tm_Fee_Schedule__c GetSchedule(Id scheduleId);
        Tm_Product__c GetProductType(Id productId);
        List<Tm_Service_Request__c> GetRequests(String clientType, String bundleType, String productName);
        Tm_Service_Request_Stage__c GetStage(Id stageId);
    }
    private static ITmFeeCalculatorHelper m_helper;

    public TmFeeCalculator(ITmFeeCalculatorHelper helper){
        m_helper = helper;
    }    
    public List<TM_Service_Request__c> Calculate(List<TM_Service_Request__c> requests){ 
        List<Tm_Service_Request__c> updatedRequests = new List<Tm_Service_Request__c>();
        for(TM_Service_Request__c req : requests){
            if(shouldFeesUpdate(req)){
                String clientType  = m_helper.GetClientType(req); 
                String bundleType  = m_helper.GetBundleType(req);     
                String productType = m_helper.GetProductType(req);
                List<TM_Fee__c> fees = m_helper.GetFees(clientType, bundleType, productType);
                updatedRequests.add(updateRequestsFromFees(fees, req));
            }
        }	
        return updatedRequests;
    }
    public List<Tm_Service_Request__c> Calculate(List<Tm_Fee__c> fees){
        Set<Tm_Service_Request__c> calculateSet = new Set<Tm_Service_Request__c>();
        for(Tm_Fee__c f : fees){
            if(f.TM_Fee_Schedule__c != null){
                Tm_Fee_Schedule__c sched = m_helper.GetSchedule(f.TM_Fee_Schedule__c);
                Tm_Product__c product = m_helper.GetProductType(sched.Tm_Product__c);
                if(sched.Client_Type__c != null && sched.Bundle_Type__c != null && product.Name != null){
                    List<Tm_Service_Request__c> tmRequests = m_helper.GetRequests(sched.Client_Type__c, sched.Bundle_Type__c, product.Name);
                    if(tmRequests != null){
                    calculateSet.addAll(tmRequests);
                    }
                }
            }
        }
        return Calculate(new List<Tm_Service_Request__c>(calculateSet));
    }
////////////////    
    private Tm_Service_Request__c updateRequestsFromFees(List<Tm_Fee__c> fees, Tm_Service_Request__c tmRequest){
        if(fees != null){
            for(Tm_Fee__c f : fees){
                tmRequest.put(f.Fee_API_Name__c, 0);
            }
            for(TM_Fee__c f : fees){
                Boolean isFeeFeatureDependent = !string.isBlank(f.Feature_Fee_Dependency__c);
                if(isFeeFeatureDependent){
                    Boolean requestHasFeature = (Boolean)tmRequest.get(f.Feature_Fee_Dependency__c);                             
                    if(requestHasFeature){
                        tmRequest.put(f.Fee_API_Name__c, f.Fee_Amount__c);
                    }
                }else {tmRequest.put(f.Fee_API_Name__c, f.Fee_Amount__c);}
            }
        }
        return tmRequest;
    }
    private Boolean shouldFeesUpdate(Tm_Service_Request__c request){
        Tm_Service_Request_Stage__c stage = m_helper.GetStage(request.Stage__c);
        return stage != null ? stage.Name == 'New' || stage.Name == 'Documentation Cycle' : false;
    }   
}