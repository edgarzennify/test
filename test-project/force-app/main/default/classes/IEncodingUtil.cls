public interface IEncodingUtil {
	Blob fromBase64(String content);
    String toBase64(Blob content);
}