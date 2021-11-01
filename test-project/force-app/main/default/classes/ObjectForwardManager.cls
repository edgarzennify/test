public class ObjectForwardManager implements ObjectForward.IManager{
    
    private final ObjectForward.IDataProvider m_dataProvider;
    private final ObjectForward.IForwardingInfo m_forwardingInfo;
    private final IUserInfoService m_userInfo;
    
    public ObjectForwardManager(ObjectForward.IDataProvider dataProvider, ObjectForward.IForwardingInfo forwardingInfo, IUserInfoService userInfo){
        m_dataProvider = dataProvider;
        m_forwardingInfo = forwardingInfo;
        m_userInfo = userInfo;
    }
    
    public ObjectForward.IForwardingInfo getForwardingInfo(String origObjName, String origObjRecordTypeName, Id origObjId){
        List<ObjectForward.DmForward> dmForwards = m_dataProvider.getForwards(origObjName, origObjRecordTypeName);
        return getForwardingInfo(dmForwards, origObjId);
    }
    
    private ObjectForward.ForwardingInfo getForwardingInfo(List<ObjectForward.DmForward> dmForwards, Id origObjId){
        if(dmForwards != null && dmForwards.size() > 0){
            for(ObjectForward.DmForward fwd : dmForwards){
                ObjectForward.ForwardingInfo info = buildForwardingInfo(fwd, origObjId);
                if(info != null){
                    return info;
                }
            }            
        }
        return new ObjectForward.ForwardingInfo();
    }

    private ObjectForward.ForwardingInfo buildForwardingInfo(ObjectForward.DmForward dmForward, Id origObjId){
        String namespace = getObjectNamespace(dmForward.objectName);
        if(m_userInfo.isCurrentUserLicensed(namespace)){
            SObject origObj = m_dataProvider.queryOne(buildOriginalObjectQuery(dmForward,origObjId));
            String fwdObjQuery = buildForwardObjectQuery(dmForward, (String)origObj.get(dmForward.originalObjectLookupField));
            try{
                List<sObject> sobjList = m_dataProvider.query(fwdObjQuery);
                if(sobjList.size() == 1){
                    return new ObjectForward.ForwardingInfo(
                        '/' + sobjList[0].Id, 
                        dmForward.objectLabel, 
                        String.valueOf(sobjList[0].get('Name')),
                        dmForward.showInterstitial);
                }
            }catch(Exception ex){
            }
        }        
        return null;
    }

    private String getObjectNamespace(String objectName){
        if(objectName.countMatches('__') > 1){
            return objectName.substringBefore('__');
        }
        return '';
    }
    
    private String buildOriginalObjectQuery(ObjectForward.DmForward dmForward, Id origObjId){
        String origObjectTemplate = 'SELECT {0} FROM {1} WHERE Id = \'\'{2}\'\' LIMIT 1';
        return String.format(origObjectTemplate, new String[]{dmForward.originalObjectLookupField,dmForward.originalObjectName,origObjId});
    }
    
    private String buildForwardObjectQuery(ObjectForward.DmForward dmForward, String origObjLookupFieldValue){
        String template = 'SELECT Id, Name FROM {0} WHERE {1} = \'\'{2}\'\' LIMIT 1';
        return String.format(template, new String[]{dmForward.objectName, dmForward.lookupField, origObjLookupFieldValue});
    } 
    
    public PageReference redirect(ObjectForward.IForwardingInfo forwardingInfo, String originalUrl){
            if(forwardingInfo.getUrl() != null){
                if(forwardingInfo.getShowInterstitial()) return null;
                return new PageReference(forwardingInfo.getUrl());
            }
            return new PageReference(originalUrl);
    }
}