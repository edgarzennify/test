@IsTest
public class EntityTMSAGeneratorMock {

    public class ofIDataProvider extends Mock.ofIDataProvider implements EntityTMSAGenerator.IDataProvider{
        public EntityTMSAGenerator.EntityPm getExtendedEntity(Id entityId){
            return (EntityTMSAGenerator.EntityPm)handleMethodInvocation('getExtendedEntity', new List<Object>{entityId});
        }
    }

    public class ofIPresenter extends ApexMoq implements EntityTMSAGenerator.IPresenter{
        public EntityTMSAGenerator.FormVm buildFormVm(Account entity){
            return (EntityTMSAGenerator.FormVm)handleMethodInvocation('buildFormVm', new List<Object>{entity});
        }
        public Boolean sendForSignature( string entityId, List<TmBoarding.SignerInfo> signers){
            return (Boolean)handleMethodInvocation('sendForSignature', new List<Object>{ entityId, signers});
        }     
    }
}