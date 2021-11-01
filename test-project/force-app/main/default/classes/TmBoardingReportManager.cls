public class TmBoardingReportManager implements TmBoarding.IReportManager {

    private final TmConfiguration.IRepository m_repository;
    private final TmBoarding.IRepository m_tmRepository;
    private final TmBoarding.IDataMapBuilder m_dataMapBuilder;
    private final HtmlReportingServiceProxy.IHtmlReportingService m_reportingProxy;
    private final IJson m_jsonSerializer;
    private final IEncodingUtil m_encodingUtil;
    private final TmBoarding.IReportHelper m_reportHelper;
    private final EbDocRepoProvider.IEbDocRepoProvider m_docRepoProvider;

    public TmBoardingReportManager(TmConfiguration.IRepository repository, TmBoarding.IDataMapBuilder dataMapBuilder, HtmlReportingServiceProxy.IHtmlReportingService reportingProxy, IJson jsonSerializer, TmBoarding.IRepository tmRepository, IEncodingUtil encodingUtil, TmBoarding.IReportHelper reportHelper, EbDocRepoProvider.IEbDocRepoProvider docRepoProvider) {
        m_repository = repository;
        m_dataMapBuilder = dataMapBuilder;
        m_reportingProxy = reportingProxy;
        m_jsonSerializer = jsonSerializer;
        m_tmRepository = tmRepository;
        m_encodingUtil = encodingUtil;
        m_reportHelper = reportHelper;
        m_docRepoProvider = docRepoProvider;
    }

    public TmBoarding.ReportDetails getReport(Tm_Service_Request__c record) {   
        String productName = m_repository.getRecordTypeName(record);

        TmBoarding.ProductConfig product = m_repository.getProduct(productName);
        
        Blob templateBytes = buildTemplate(productName, product.TemplateFileName, product.ProductId);
        TmBoarding.BoardingData data = m_reportHelper.buildJsonData(record, productName);

        String jsonData = m_jsonSerializer.serialize(data);
        Blob b = m_reportingProxy.getPdf(templateBytes, jsonData);
        if(b == null){b = Blob.valueOf('');}
        TmBoarding.ReportDetails details = new TmBoarding.ReportDetails();
        details.reportData = b;
        details.data = new List<TmBoarding.BoardingData>();
        details.data.add(data);

        return details;
    }

    public TmBoarding.ReportDetails getEmptyReports(List<string> products) {
         List<HtmlReportingServiceProxy.MergeRequest> reports = new List<HtmlReportingServiceProxy.MergeRequest>();
        List<TmBoarding.BoardingData> allData = new List<TmBoarding.BoardingData>();
        Map<string,boolean> includedMap = new Map<string,boolean>{'Selected' => true};
        Map<string,object> includedData = new Map<string, object>{'Included' => includedMap};
        Map<string, object> includedDetails = new Map<string,object>{'TM_Service_Request__c.Same_Day_ACH_Addendum__c' => true};
        for (String p: products) {
            TmBoarding.BoardingData boardingData = new TmBoarding.BoardingData();
            
            boardingData.Accounts = new TmBoarding.DataComponent();
            boardingData.Contacts = new TmBoarding.DataComponent();
            boardingData.Packet = new TmBoarding.LayoutComponent2();
            boardingData.Packet.Type = p;
            boardingData.Details = new TmBoarding.DataComponent();
            boardingData.Details.Data = new List<Map<string,object>>{includedDetails};
            boardingData.Accounts.Data = new List<Map<string,object>>{includedData, includedData, includedData, includedData, includedData, includedData};
            boardingData.Contacts.Data = new List<Map<string,object>>{includedData, includedData, includedData, includedData, includedData, includedData};
            TmBoarding.ProductConfig product = m_repository.getProduct(p);
            Blob templateBytes = buildTemplate(p, product.TemplateFileName, product.ProductId);

            if (templateBytes != null) {
                String jsonData = m_jsonSerializer.serialize(boardingData);
                allData.add(boardingData);
                reports.add(build(templateBytes, jsonData, null));
            }
        }

        Blob b = reports.size() > 0 ? m_reportingProxy.getMergedPdfs(reports) : Blob.valueof('');
        TmBoarding.ReportDetails details = new TmBoarding.ReportDetails();
        details.reportData = b;
        details.data = allData;
        return details;
    }

    public TmBoarding.ContactSummaryDetails getContactSummaryDetails(String packetId) {
        TmBoarding.ContactSummaryDetails details = new TmBoarding.ContactSummaryDetails();
        Id packet = Id.valueOf(packetId);
        
        Map<string, TmConfiguration.ProductInfo> requests =  m_repository.getProductInfos(packet);
        if (requests == null || requests.keyset().size() == 0) { return null; }

        details.Products = new List<TmBoarding.ContactSummaryProduct>();
        details.Contacts = new List<TmBoarding.ContactSummaryContact>();
        Map<string, List<TM_Service_Request_Contact__c>> serviceContacts = new Map<string, List<TM_Service_Request_Contact__c>>();
        List<TmBoarding.RequestPm> dataRequests = new List<TmBoarding.RequestPm>();

        TmBoarding.ProductConfig productConfig = null;
        String productName = null;
        for( TmConfiguration.ProductInfo prod : requests.values()) {
            TM_Service_Request__c r = new Tm_Service_Request__c(Id = prod.requestId, RecordTypeId = prod.productType.id);
            TmBoarding.RequestPm requestPm = m_tmRepository.getData(r);
            serviceContacts.put(requestPm.requestPm.Id, requestpm.serviceContactPms);
            dataRequests.add(requestPm);
            if (productConfig == null) {
                productName = m_repository.getRecordTypeName(r);
                productConfig = m_repository.getProduct(productName);
                if (productConfig.ContactSummaryReportTemplateName == null) {
                    productConfig = null;
                }
            }
        }

        if (dataRequests.size() == 0)
        {
            return null;
        }

        for (TmBoarding.RequestPm request: datarequests) {
            TmBoarding.ContactSummaryProduct product = new TmBoarding.ContactSummaryProduct();
            product.Id = request.requestPm.Id;
            product.Name = request.requestPm.recordtype.Name;
            details.Products.add(product);
        }

        for (Contact contact: datarequests[0].contactPms) {
            TmBoarding.ContactSummaryContact c = new TmBoarding.ContactSummaryContact();
            c.Id = contact.Id;
            c.Name = contact.Name;
            c.Products = new List<TmBoarding.ContactSummaryProduct>();
            for (TmBoarding.ContactSummaryProduct product: details.Products) {
                TmBoarding.ContactSummaryProduct enabledProduct = new TmBoarding.ContactSummaryProduct();
                enabledProduct.Id = product.Id;
                enabledProduct.Name = product.Name;
                enabledProduct.Selected = false;
                List<TM_Service_Request_Contact__c> rc = serviceContacts.get(product.Id);
                for (TM_Service_Request_Contact__c con: rc) {
                    if (contact.id == con.contact__c) {
                        enabledProduct.Selected = true;
                    }
                }
                c.Products.add(enabledProduct);
            }
            details.Contacts.add(c);
        }

        if (productConfig != null) {

            Blob templateBytes = buildTemplate(productName, productConfig.ContactSummaryReportTemplateName, productConfig.ProductId);
            String jsonData = m_jsonSerializer.serialize(details);
            Blob b = m_reportingProxy.getPdf(templateBytes, jsonData);
            details.data = m_encodingUtil.toBase64(b);
        }
        return details;
    }

    public TmBoarding.ReportDetails getTmOperationsReport(Tm_Service_Request__c record) {
        String productName = m_repository.getRecordTypeName(record);    
        TmBoarding.ProductConfig product = m_repository.getProduct(productName);
        Blob templateBytes = buildTemplate(productName, product.TmScreenTemplateFileName, product.ProductId);

        TmBoarding.BoardingData data = m_reportHelper.buildJsonData(record, productName);
        String jsonData = m_jsonSerializer.serialize(data);
        Blob b = m_reportingProxy.getHtml(templateBytes, jsonData);

        TmBoarding.ReportDetails details = new TmBoarding.ReportDetails();
        details.reportData = b;
        details.data = new List<TmBoarding.BoardingData>();
        details.data.add(data);
        return details;
    }

    public Blob getMasterServiceAgreement(string packetId) {
        return m_reportHelper.getMasterServiceAgreement(packetId);
    }
    
    public TmBoarding.ReportDetails getPacketReport(String packetId, Boolean isMasterSvcRequired) {
        
        List<HtmlReportingServiceProxy.MergeRequest> reports = new List<HtmlReportingServiceProxy.MergeRequest>();
        List<TmBoarding.BoardingData> boardingData = new List<TmBoarding.BoardingData>();
        Map<string, TmConfiguration.ProductInfo> productInfos = m_repository.getProductInfosByRequestId(packetId);
        
        Map<string, Tm_Service_Request__c> jsonRequest = new Map<string, Tm_Service_Request__c>();
        for(string requestId : productInfos.keyset()) {
            TmConfiguration.ProductInfo info = productInfos.get(requestId);
            jsonRequest.put(info.requestId, new Tm_Service_Request__c(Id = info.requestId, RecordTypeId = info.productType.Id ));
        }

        TmBoarding.ReportDataHolder dataHolder = m_reportHelper.buildJsonDataBulk(jsonRequest);
        Map<string, TmBoarding.BoardingData> allData = dataHolder.allBoardingData;
        TmConfiguration.ProductInfo masterSvcProd = m_reportHelper.getProductWithMasterServiceAgreement(packetId);

        Blob masterSvcTemplateBytes = null;
        Integer masterSvcCounter = 0;
        if(isMasterSvcRequired == true && masterSvcProd != null){
            DmDocument masterSvcDoc = m_docRepoProvider.GetFileByEbDocId(masterSvcProd.masterAgreementTemplateName);
            masterSvcTemplateBytes = masterSvcDoc.body;         
        }

        try{
            Blob footerBytes = null;
            for(string requestId : productInfos.keyset()) {

                TmConfiguration.ProductInfo info = productInfos.get(requestId); 

                String product = info.productType.name;
                Blob templateBytes = buildTemplate(product, info.TemplateFileName, info.configId);

                if(footerBytes == null && String.isnotBlank(info.footerTemplateId)){
                    DmDocument doc = m_docRepoProvider.getFileByEbDocId(info.footerTemplateId);
                    footerBytes = doc.body;

                }

                if(templateBytes != null){

                    TmBoarding.BoardingData data = allData.get(requestId);
                    String jsonData = m_jsonSerializer.serialize(data);
                    reports.add(build(templateBytes, jsonData, footerBytes));
                    boardingData.add(data);
                }
            
            }
        }catch(exception ex){

        }
        
        Blob b = reports.size() > 0 ? m_reportingProxy.getMergedPdfs(reports) : Blob.valueof('');
        
        TmBoarding.ReportDetails details = new TmBoarding.ReportDetails();
        details.reportData = b;
        details.data = boardingData;
        details.MasterAgreement = masterSvcTemplateBytes;
        
        return details;
    }


    public TmBoarding.ProductConfig getTemplatesForProduct(string product) {
        TmBoarding.ProductConfig cfg = m_repository.getProduct(product);
        Blob docTemplate = m_repository.getTemplateFromAttachment(cfg.TemplateFileName, cfg.ProductId);
        Blob screenTemplate = m_repository.getTemplateFromAttachment(cfg.TmScreenTemplateFileName, cfg.ProductId);
        Blob contactTemplate = m_repository.getTemplateFromAttachment(cfg.ContactSummaryReportTemplateName, cfg.ProductId);
        if(docTemplate == null){cfg.TemplateFileName = '';}
        if(screenTemplate == null){cfg.TmScreenTemplateFileName = '';}
        if(contactTemplate == null){cfg.ContactSummaryReportTemplateName = '';}

        return cfg;
    }

    public TmBoarding.UserBoardingDetails getBoardingUserInfo(string packetId) {

        TmBoarding.UserBoardingDetails details = new TmBoarding.UserBoardingDetails();
        List<TmBoarding.RequestPm> requestPms = m_tmRepository.getRequestPmsForPacket(packetId);

        TmConfiguration.ProductInfo cfg = getProductWithUserBoarding(requestPms, packetId);
        if(cfg == null){return details;}

        DmDocument doc = m_docRepoProvider.GetFileByEbDocId(cfg.UserBoardingTemplateName);
        Blob templateBytes = doc.body;
        
        Map<string, TmBoarding.UserProductsVm> userMap = buildUserBoardingData(packetId, requestPms);

        List<TmBoarding.UserProductsVm> data = userMap != null? userMap.values() : null;
        Map<string, List<TmBoarding.UserProductsVm>> dataMap = new Map<string, List<TmBoarding.UserProductsVm>>{'data' =>data};
        String jsonData = data != null? m_jsonSerializer.serialize(dataMap):'';
        
        Blob b = m_reportingProxy.getHtml(templateBytes, jsonData);
        if(b == null){b = Blob.valueOf('');}
        details.reportData = b;
        details.data = new List<TmBoarding.UserProductsVm>();
        details.data.addAll(data);
        return details;
    }

    private TmConfiguration.ProductInfo getProductWithUserBoarding(List<TmBoarding.RequestPm> requestPms, String packetId){
        Map<string, TmConfiguration.ProductInfo> productInfos =  m_repository.getProductInfos(packetId);
        
        if(requestPms == null || requestPms.Size() == 0){return null;}

        for(TmBoarding.RequestPm pm : requestPms) {
            String product = pm.requestPm.RecordType.Name;
            TmConfiguration.ProductInfo productInfo = productInfos.get(product);
            if(productInfo != null){
                String userBoardingTemplateName = productInfo.UserBoardingTemplateName;
                if(String.isNotBlank(userBoardingTemplateName) ){
                    return productInfo;
                }
            }
        }

        return null;
    }

    private Map<string, TmBoarding.UserProductsVm> buildUserBoardingData(string packetId, List<TmBoarding.RequestPm> requestPms) {
        Map<string, TmBoarding.UserProductsVm> userMap = new Map<string, TmBoarding.UserProductsVm>();
        
        for(TmBoarding.RequestPm pm : requestPms) {

            if(pm.contactPms != null && pm.contactPms.size() > 0){  
                    
                for(Contact c : pm.contactPms) {
                    if(!userMap.containsKey(c.Id)) {
                        TmBoarding.UserProductsVm vm = new TmBoarding.UserProductsVm();
                        vm.UserInfo = new TmBoarding.UserVm();
                        vm.UserInfo.name = c.Name;
                        vm.Services = new List<TmBoarding.UserServiceVm>();
                        vm.Accounts = new List<TmBoarding.UserAccountVm>();
                        userMap.put(c.Id, vm );
                    }
                    TmBoarding.UserServiceVm currentSvcVm = new TmBoarding.UserServiceVm();
                    currentSvcVm.Product = pm.requestPm.RecordType.Name;
                    Set<String> products = getProductSet(userMap.get(c.Id).Services);
                    if(!products.contains(currentSvcVm.Product)){ userMap.get(c.Id).Services.add(currentSvcVm);}

                    if(pm.accountPms != null) {
                        for(Eb_Account__c a : pm.accountPms) {
                            TmBoarding.UserAccountVm currentAcctVm = new TmBoarding.UserAccountVm();
                            currentAcctVm.Name = a.Name;
                            List<TmBoarding.UserAccountVm> accounts = userMap.get(c.Id).Accounts;
                            if(isAccountExists(accounts, currentAcctVm) == false){
                                userMap.get(c.Id).Accounts.add(currentAcctVm);
                            }
                        } 
                    }
                }
            }
        }

        return userMap;
    }

    private Set<String> getProductSet(List<TmBoarding.UserServiceVm> vms) {
        Set<String> products = new Set<String>();
        for(TmBoarding.UserServiceVm vm : vms) {
            products.add(vm.Product);
        }
        return products;
    }

    private boolean isAccountExists(List<TmBoarding.UserAccountVm> accounts , TmBoarding.UserAccountVm currentAccount) {
        for(TmBoarding.UserAccountVm vm : accounts) {
            if(vm.Name == currentAccount.Name) {
                return true;
            }
        }
        return false;
    }

    private Blob buildTemplate(String productName, String templateFileName, String productId) {
        if(String.isBlank(templateFileName)) {return null;}
        return m_repository.getTemplateFromAttachment(templateFileName, productId);
    }

    private HtmlReportingServiceProxy.MergeRequest build(Blob template, String jsonData, Blob footerBytes) {
        HtmlReportingServiceProxy.MergeRequest r = new HtmlReportingServiceProxy.MergeRequest();
        r.Template = template;
        r.JsonData = jsonData;
        r.FooterTemplate = footerBytes == null? Blob.valueof(''): footerBytes;
        return r;
    }
}