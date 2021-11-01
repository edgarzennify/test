public class TmBoardingVmBuilderHelper implements TmBoarding.IVmBuilderHelper {

    private final TmBoarding.IPermission m_permission;
    private final Utility.IUtility m_util;

    public TmBoardingVmBuilderHelper(TmBoarding.IPermission permission, Utility.IUtility util) {
        m_permission = permission;
        m_util = util;
    }

    public TmBoarding.LayoutComponent2 getPacket(TmBoarding.RequestPm pm, List<DmRecordType> products, Map<string, TmConfiguration.ProductInfo> productInfos, List<DmTmRequestStage> stageDms) {
        TmBoarding.LayoutComponent2 packet = new TmBoarding.LayoutComponent2();
        packet.PacketDetail = new TmBoarding.LayoutComponentRelated();
        packet.PacketDetail.Id = pm.packetPm == null? '' : pm.packetPm.Id;
        packet.PacketDetail.Name = pm.packetPm == null? '' : pm.packetPm.Name;
        packet.Entity = new TmBoarding.LayoutComponentRelated();
        packet.Entity.Id = pm.entityPm == null ? '': pm.entityPm.Id;
        packet.Entity.Name = pm.entityPm == null ? '': pm.entityPm.Name;
        packet.Request = new TmBoarding.LayoutComponentRelated();
        packet.Request.Id = pm.requestPm == null? '' : pm.requestPm.Id;
        packet.Request.Name = pm.requestPm == null? '' : pm.requestPm.Name;
        packet.Type =  pm.requestPm.RecordType == null ? '' : pm.requestPm.RecordType.Name;
        packet.RequestObjectId = '';
        packet.Requests = new List<TmBoarding.LayoutComponentRelated>();
        
        Map<string, DmTmRequestStage> stageMap = new Map<string, DmTmRequestStage>();
        for(DmTmRequestStage dm: stageDms){
            stageMap.put(dm.id, dm);
        }

        if(pm.packetRequestsPm != null) {
            for(TM_Service_Request__c req :   pm.packetRequestsPm) {
                TmBoarding.LayoutComponentRelated rel = new TmBoarding.LayoutComponentRelated();
                rel.Id = req.Id;
                rel.Name = req.RecordType == null?'' : req.RecordType.Name;               
                rel.Stage = req.Stage__r == null ? '' : req.Stage__r.Name;
                string stageId = m_util.convertid15ToId18(req.Stage__c);
                DmTmRequestStage stageDm = stageMap.get(stageId);

                rel.StageDetails = buildStage(stageDm);
              
                SignerCode sig = getSigners(rel.Name ,productInfos);
                if(sig !=  null){
                    rel.primarySignerCode = sig.primary;
                    rel.secondarySignerCode = sig.secondary;
                    rel.tmoSignerCode = sig.tmo;
                }
               
                packet.Requests.add(rel);
            }
            if(packet.Requests != null){packet.Requests.sort();}
        }

        packet.AllProducts = new List<TmBoarding.LayoutComponentRelated>();

        
        for(DmRecordType r :  products) {
            TmBoarding.LayoutComponentRelated rel = new TmBoarding.LayoutComponentRelated();
            rel.Id = r.Id;
            rel.Name = r.Name;
            packet.AllProducts.add(rel);
        }
        if(packet.AllProducts != null) { packet.AllProducts.sort();}

        return packet;
    }

    public TmBoarding.LayoutComponent getEntity(TmBoarding.RequestPm pm) {
        TmBoarding.LayoutComponent entity = new TmBoarding.LayoutComponent();
        entity.Name = pm.entityPm == null ? '': pm.entityPm.Name;
        entity.Type = pm.requestPm.RecordType == null ? '' : pm.requestPm.RecordType.Name;
        entity.PacketId = pm.requestPm.Tm_Service_Request_Packet__c == null ? '' : pm.requestPm.Tm_Service_Request_Packet__c;
        entity.TmMasterAgreementDate = pm.entityPm == null ? null:pm.entityPm.Date_TM_Master_Agmt_Signed__c;
        return entity;
    }


    public TmBoarding.LayoutComponentStage buildStages(TM_Service_Request__c record, DmTmRequestStage stageDm) {
        if(record == null || record.id == null){return new TmBoarding.LayoutComponentStage();}
        if(stageDm == null){return new TmBoarding.LayoutComponentStage();}
        return buildStage(stageDm);
    }

    private SignerCode getSigners(string product ,Map<string, TmConfiguration.ProductInfo> productInfos){
        SignerCode sig = new SignerCode();
        sig.primary = '';
        sig.secondary = '';
        sig.tmo = '';

        if(String.isBlank(product) || productInfos == null){return sig;}
        TmConfiguration.ProductInfo info = productInfos.get(product);
        if(info != null){        
            sig.primary =  String.isBlank(info.primarySignerCode)?'':info.primarySignerCode;
            sig.secondary = String.IsBlank(info.secondarySignerCode)?'':info.secondarySignerCode;
            sig.tmo = String.isBlank(info.tmoSignerCode)?'':info.tmoSignerCode;
        }
        return sig;
    }

    private TmBoarding.LayoutComponentStage buildStage(DmTmRequestStage stageDm){
        TmBoarding.LayoutComponentStage layout = new TmBoarding.LayoutComponentStage();
        if(stageDm == null){return layout;}

        layout.id = stageDm.id;
        layout.name = stageDm.name;
        layout.StageType = stageDm.type;
        layout.RelatedStages = new List<TmBoarding.LayoutComponentStage>();

        if(stageDm.relatedStages != null) {
            for(DmTmRequestStage s : stageDm.relatedStages) {
                if(s != null){
                    TmBoarding.LayoutComponentStage layoutRelated = new TmBoarding.LayoutComponentStage();
                    layoutRelated.id = s.id;
                    layoutRelated.name = s.name;
                    layoutRelated.StageType = s.type;                                            
                    layout.RelatedStages.add(layoutRelated);
                }
            }
        }
     
        return layout;
    }

    public TmBoarding.LayoutComponentPermission getPermission(DmTmRequestStage stage) {
        return m_permission.getPermissionByRequestStage(stage);
    }

    private class SignerCode{
        public string Primary{get;set;}
        public string Secondary{get;set;}
        public string Tmo{get;set;}
    }
}