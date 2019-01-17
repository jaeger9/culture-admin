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
	String sFileInfo = "";
	//파일명 - 싱글파일업로드와 다르게 멀티파일업로드는 HEADER로 넘어옴 
	String name = request.getHeader("file-name");
	String ext = name.substring(name.lastIndexOf(".") + 1);
	//파일 기본경로
	String defaultPath = getServletContext().getRealPath("/");
	//파일 기본경로 _ 상세경로
	String path = defaultPath + "upload" + File.separator + "editor_upload" + File.separator;
	File file = new File(path);
	if (!file.exists()) {
		file.mkdirs();
	}
	String realname = UUID.randomUUID().toString() + "." + ext;
	InputStream is = request.getInputStream();
	OutputStream os = new FileOutputStream(path + realname);
	// OutputStream os2 = new FileOutputStream("/workspace-egov/admin/src/main/webapp/upload/editor_upload/" + realname);

	int numRead;
	//파일쓰기
	byte b[] = new byte[Integer.parseInt(request.getHeader("file-size"))];
	while ((numRead = is.read(b, 0, b.length)) != -1) {
		os.write(b, 0, numRead);
		// os2.write(b, 0, numRead);
	}
	if (is != null) {
		is.close();
	}
	os.flush();
	os.close();

	// os2.flush();
	// os2.close();

	sFileInfo += "&bNewLine=true&sFileName=" + name + "&sFileURL=" + "/upload/editor_upload/" + realname;
	out.println(sFileInfo);
%>
<%--
<?php
 	$sFileInfo = '';
	$headers = array();
	 
	foreach($_SERVER as $k => $v) {
		if(substr($k, 0, 9) == "HTTP_FILE") {
			$k = substr(strtolower($k), 5);
			$headers[$k] = $v;
		} 
	}
	
	$file = new stdClass;
	$file->name = str_replace("\0", "", rawurldecode($headers['file_name']));
	$file->size = $headers['file_size'];
	$file->content = file_get_contents("php://input");
	
	$filename_ext = strtolower(array_pop(explode('.',$file->name)));
	$allow_file = array("jpg", "png", "bmp", "gif"); 
	
	if(!in_array($filename_ext, $allow_file)) {
		echo "NOTALLOW_".$file->name;
	} else {
		$uploadDir = '../../upload/';
		if(!is_dir($uploadDir)){
			mkdir($uploadDir, 0777);
		}
		
		$newPath = $uploadDir.iconv("utf-8", "cp949", $file->name);
		
		if(file_put_contents($newPath, $file->content)) {
			$sFileInfo .= "&bNewLine=true";
			$sFileInfo .= "&sFileName=".$file->name;
			$sFileInfo .= "&sFileURL=upload/".$file->name;
		}
		
		echo $sFileInfo;
	}
?>
--%>