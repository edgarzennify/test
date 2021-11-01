public class SystemWrapper implements ISystem{
    public DateTime now(){
        return System.now();
    }
    
    public Date today(){
        return System.today();
    }
}