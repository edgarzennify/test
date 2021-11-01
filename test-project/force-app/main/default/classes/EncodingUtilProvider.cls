public class EncodingUtilProvider implements IEncodingUtil {
	public Blob fromBase64(String content) {
		return EncodingUtil.base64Decode(content);
	}

	public String toBase64(Blob content) {
		return EncodingUtil.base64Encode(content);
	}

	public Blob toBytes(String content) {
    	return Blob.valueOf(content);
    }
}