public class CPDocsAdminBootstrap {
    
    public static CPDocsAdmin.IRepository getIRepositoryInstance(){

        CPDocsAdmin.IDmBuilder dmbldr = new CPDocsAdminDmBuilder();
        CPDocsAdmin.IDataProvider dp = new CPDocsAdminDataProvider();

        return new CPDocsAdminRepository(dmbldr, dp);
    }
}