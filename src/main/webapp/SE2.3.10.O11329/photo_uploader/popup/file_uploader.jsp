<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.UUID"%>
<%@ page import="java.io.FileOutputStream"%>
<%@ page import="java.io.OutputStream"%>
<%@ page import="java.io.InputStream"%>
<%@ page import="java.io.File"%>
<%@ page import="java.util.List"%>
<%@ page import="org.apache.commons.fileupload.FileItem"%>
<%@ page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@ page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%
	String return1="";
	String return2="";
	String return3="";
	String name = "";

	if (ServletFileUpload.isMultipartContent(request)){
	    ServletFileUpload uploadHandler = new ServletFileUpload(new DiskFileItemFactory());
	    //UTF-8 인코딩 설정
	    uploadHandler.setHeaderEncoding("UTF-8");
	    List<FileItem> items = uploadHandler.parseRequest(request);
	    //각 필드태그들을 FOR문을 이용하여 비교를 합니다.
	    for (FileItem item : items) {
	        if(item.getFieldName().equals("callback")) {
	            return1 = item.getString("UTF-8");
	        } else if(item.getFieldName().equals("callback_func")) {
	            return2 = "?callback_func="+item.getString("UTF-8");
	        } else if(item.getFieldName().equals("Filedata")) {
	            //FILE 태그가 1개이상일 경우
	            if(item.getSize() > 0) {
	                String ext = item.getName().substring(item.getName().lastIndexOf(".")+1);
	                //파일 기본경로
	                String defaultPath = getServletContext().getRealPath("/");
	                //파일 기본경로 _ 상세경로
	                String path = defaultPath + "upload" + File.separator + "editor_upload" + File.separator;
	                 
	                File file = new File(path);
	                 
	                //디렉토리 존재하지 않을경우 디렉토리 생성
	                if(!file.exists()) {
	                    file.mkdirs();
	                }
	                //서버에 업로드 할 파일명(한글문제로 인해 원본파일은 올리지 않는것이 좋음)
	                String realname = UUID.randomUUID().toString() + "." + ext;
	                ///////////////// 서버에 파일쓰기 ///////////////// 
	                InputStream is = item.getInputStream();
	                OutputStream os = new FileOutputStream(path + realname);
	                // OutputStream os2 = new FileOutputStream("/workspace-egov/admin/src/main/webapp/upload/editor_upload/" + realname);
	                
	                int numRead;
	                byte b[] = new byte[(int)item.getSize()];
	                while((numRead = is.read(b,0,b.length)) != -1){
	                    os.write(b,0,numRead);
	                	// os2.write(b,0,numRead);
	                }
	                if(is != null)  is.close();
	                os.flush();
	                os.close();

	                // os2.flush();
	                // os2.close();
	                ///////////////// 서버에 파일쓰기 /////////////////
	                return3 += "&bNewLine=true&sFileName="+name+"&sFileURL=/upload/editor_upload/"+realname;
	            }else {
	                return3 += "&errstr=error";
	            }
	        }
	    }
	}
	response.sendRedirect(return1+return2+return3);
%>
<%--
<?php
// default redirection
$url = $_REQUEST["callback"].'?callback_func='.$_REQUEST["callback_func"];
$bSuccessUpload = is_uploaded_file($_FILES['Filedata']['tmp_name']);

// SUCCESSFUL
if(bSuccessUpload) {
	$tmp_name = $_FILES['Filedata']['tmp_name'];
	$name = $_FILES['Filedata']['name'];
	
	$filename_ext = strtolower(array_pop(explode('.',$name)));
	$allow_file = array("jpg", "png", "bmp", "gif");
	
	if(!in_array($filename_ext, $allow_file)) {
		$url .= '&errstr='.$name;
	} else {
		$uploadDir = '../../upload/';
		if(!is_dir($uploadDir)){
			mkdir($uploadDir, 0777);
		}
		
		$newPath = $uploadDir.urlencode($_FILES['Filedata']['name']);
		
		@move_uploaded_file($tmp_name, $newPath);
		
		$url .= "&bNewLine=true";
		$url .= "&sFileName=".urlencode(urlencode($name));
		$url .= "&sFileURL=upload/".urlencode(urlencode($name));
	}
}
// FAILED
else {
	$url .= '&errstr=error';
}
	
header('Location: '. $url);
?>
--%>