<%@page import="kr.go.culture.common.util.DateUtil"%>
<%@page import="java.util.Enumeration"%>
<%@page import="javax.imageio.ImageIO"%>
<%@page import="java.awt.image.BufferedImage"%>
<%@page import="kr.go.culture.common.util.FileUtil"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="java.io.File"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%String cp = request.getContextPath();%>
<%
	try{
		
	
		request.setCharacterEncoding("utf-8");
		//오늘 날짜 문자열로 구하기
		String today = DateUtil.getToday();
		String path = File.separator+"data"+File.separator+"nas"+File.separator+"upload"+File.separator+"app"+File.separator+today;
	// 	String rt = session.getServletContext().getRealPath("/");
	// 	String rt = pageContext.getServletContext().getRealPath("/");
		String rt = "";
// 		String rt = "c:\\temp";
				
		
		String filePath = rt + path; //실제 파일이 저장될 path
		String savepath = cp + path + File.separator; //이미지 파일 불러올 주소\
		String smartEditPath = cp + File.separator+"upload"+File.separator+"app"+File.separator+today+File.separator;
		
		
		File dir= new File(filePath);
		if(!dir.exists()){//폴더가 존재하지 않으면
			dir.mkdirs(); //존재하지 않는 모든 폴더를 작성한다.(하위폴더도)
		}
		
		String charset="utf-8";
		int maxFileSize=5*1024*1024;
		
		/*
		MultipartRequest : 파일을 업로드함과 동시에 parameter를 분리 시켜줌
		생성자 인수 : request, 파일을 저장할경로, 최대업로드 파일크기, 문자셋
					동일파일을 보호할지 여부
		*/
		MultipartRequest mReq = new MultipartRequest(request,filePath,maxFileSize,charset, new DefaultFileRenamePolicy());//-->같은 파일을 업로드시 보호여부 
		//서버에 저장된 파일명
		File uploadedFile = mReq.getFile("Filedata");
		//오리지날 파일명
		String orgFileName = uploadedFile.getName();
		//확장자 구하기
		String ext = FileUtil.getExt(uploadedFile);
		//이름 바꾸기 현제 시간(밀리세컨드)
		String rename = System.currentTimeMillis()+"."+ext;
		
		uploadedFile = FileUtil.rename(uploadedFile, rename);
		if(uploadedFile == null){//이름 변경 실패시..
			
		}
		//사이즈 조절하기..
		BufferedImage bi = ImageIO.read(uploadedFile);
	    int image_w = bi.getWidth();
	    int image_h = bi.getHeight();
	    if(image_w > 650){
	    	image_h = (650 *(image_h)) / image_w;
	    	image_w = 650;
	    }
		
		String callback = mReq.getParameter("callback");
		String callbackFunc = mReq.getParameter("callback_func");
		String param = 
				"?callback_func="+callbackFunc+
				"&sFileName="+ orgFileName + 
				"&bNewLine=true" + 
				"&sFileURL=" + smartEditPath+rename + 
				"&width="+image_w + 
				"&height="+image_h;
		
		response.sendRedirect(callback+param);
		//out.println(savepath+File.separator+rename);
	}
	catch(Exception e){
		e.getStackTrace();
	}
%>

