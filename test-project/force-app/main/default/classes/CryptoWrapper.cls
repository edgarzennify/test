public class CryptoWrapper implements ICrypto{
    
    public interface ICrypto{
        Blob generateDigest(string algo, Blob textAsBlob);
    }
    
    public Blob generateDigest(string algo, Blob textAsBlob){
        return Crypto.generateDigest(algo, textAsBlob);
    }
}