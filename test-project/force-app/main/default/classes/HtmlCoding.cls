public class HtmlCoding implements IHtmlCoding{
    public interface IHtmlCoding{
        String unEscape(string encodedText);
        String httpRequestSanitizer(string text);
    }

    public String unEscape(string encodedText){
        if(string.isBlank(encodedText) == true){return encodedText;}
        return encodedText.unescapeHtml4();
    }

    public String httpRequestSanitizer(string text) {
        if (string.isBlank(text) == true) {return text;}
        text = text.replaceAll('&', '&amp;');
        text = text.replaceAll('<', '&lt;');
        text = text.replaceAll('>', '&gt;');
        return text;
    }
}