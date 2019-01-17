<%@ Page Language="cs"%>
<%@ Import Namespace="System.Text" %>
<% 
string Filename = Request.QueryString["filepath"];
string pattern1 = "<!--.*-->";
string pattern2 = "(?:(#.*\\n{0,1})|//.*\\n{0,1})|(?:/\\*(?:.|\\s)*?\\*/\\n{0,1}|<(?i)script[^>]*>[\\w\\W\\r]*</(?i)script>|<(?i)style[^>]*>[\\w\\W\\r]*</(?i)style>)";

Regex regex1 = new Regex(pattern1);
Regex regex2 = new Regex(pattern2);
string Filepath = Server.MapPath(Filename);
try{
	string Contents = System.IO.File.ReadAllText(@Filepath);
	Contents = regex1.Replace(Contents, ""); 
	Contents = regex2.Replace(Contents, ""); 

	if(Contents.IndexOf("initCheckWebfilter.aspx") != -1){
		Response.Write("insert");
	}else{
		Response.Write("delete");
	}
}catch (Exception e){
	Response.Write("delete");
}
%>

