package kr.go.culture.festival.service;

import java.awt.image.BufferedImage;
import java.io.File;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.Resource;
import javax.imageio.ImageIO;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import net.coobird.thumbnailator.Thumbnails;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service("FestivalMobileUpdateService")
public class FestivalMobileUpdateService {

	@Value("#{contextConfig['file.upload.base.location.dir']}")
	private String fileUploadBaseLocaionDir;
	
	@Resource(name = "CkDatabaseService")
	private  CkDatabaseService ckDataBaseService;
	
	
	
	static String cont1="";
	final static String regex="src";
	
	static int callNum=0;
	static int hit=0;
	
	static String fileDir="";
	static String hostName="";
	
	static String uci="";
	static String cont="";
	
	static String upDirGubun="";
	
	static int FindHit=0;
	
	/**네이버 에디터**/ 
	//개발서버
	//static String fileDir="/data/nas/upload/";
	//static String hostName="/upload/";
	//운영
	//	static String fileDir="/data/nas/upload/";
	//	static String hostName="/upload/";
	//로컬
	/** 나모에디터**/
    //로컬
	//static String fileDir="D:eGovFrameDev-3.5.0-64bitworkspace.metadata.pluginsorg.eclipse.wst.server.core/tmp2wtpwebapps/culture_admin_2015/crosseditor/";
	//static String hostName="http://127.0.0.1:9999/crosseditor/";
	//개발
	//static String fileDir="/data/culture_admin_2015";
	//static String hostName="http://175.125.91.124:9999";
	//운영
	//static String fileDir="/data/nas/upload/";
	//static String hostName="http://culture.go.kr/upload/";
	
	/** openapi**/
    //로컬
	//static String fileDir="D:eGovFrameDev-3.5.0-64bitworkspace.metadata.pluginsorg.eclipse.wst.server.core/tmp2wtpwebapps/culture_admin_2015/crosseditor/";
	//static String hostName="http://127.0.0.1:9999/crosseditor/";
	//개발
	//static String fileDir="/data/culture_admin_2015";
	//static String hostName="http://175.125.91.124:9999";
	//운영
	//static String fileDir="/data/nas/upload/";
	//static String hostName="http://culture.go.kr/upload/";
	
	
	
	public void Mupdate(ParamMap paramMap) throws Exception {
		
		int hit1=0;
		int hit2=0;
		int hit3=0;
		//String cont="";
		uci=paramMap.getString("uci");
		cont=paramMap.getString("description");
		
		//String editGubun="editor_upload";
		
		
		String editGubun1="editor_upload";
		String editGubun2="crosseditor";
		String editGubun3="rdf";
		
		Pattern pattern1 = Pattern.compile(editGubun1);
		Pattern pattern2 = Pattern.compile(editGubun2);
		Pattern pattern3 = Pattern.compile(editGubun3);
		Matcher matcher1 = pattern1.matcher(cont);
		Matcher matcher2 = pattern2.matcher(cont);
		Matcher matcher3 = pattern3.matcher(cont);
		
		/*Pattern pattern = Pattern.compile(editGubun);
		Matcher matcher = pattern.matcher(cont);*/
		
		if(matcher1.find()==true){
			
//			fileDir="D:/eGovFrameDev-3.5.0-64bit/workspace/.metadata/.plugins/org.eclipse.wst.server.core/tmp0/wtpwebapps/culture_portal_2015/upload/";
			fileDir=fileUploadBaseLocaionDir+"/upload/";
			hostName="/upload/";
			upDirGubun="upload";
			hit1=hit1+1;
			
		}
		
		if(matcher2.find()==true){
			
//			fileDir="D:/eGovFrameDev-3.5.0-64bit/workspace/.metadata/.plugins/org.eclipse.wst.server.core/tmp2/wtpwebapps/culture_admin_2015/crosseditor/";
//			hostName="http://127.0.0.1:9999/crosseditor/";
			fileDir=fileUploadBaseLocaionDir+"/crosseditor/";
			hostName="http://175.125.91.124:9999/crosseditor/";
			upDirGubun="crosseditor";
			hit2=hit2+1;
		}
		
		if(matcher3.find()==true){
			
			/*fileDir="D:/eGovFrameDev-3.5.0-64bit/workspace/.metadata/.plugins/org.eclipse.wst.server.core/tmp0/wtpwebapps/culture_portal_2015/upload/";
			hostName="/upload/";
			upDirGubun="upload";*/
			
//			fileDir="G:/data/nas/upload/";
			fileDir=fileUploadBaseLocaionDir+"/upload/";
			hostName="http://www.culture.go.kr/upload/";
			upDirGubun="upload";
			hit3=hit3+1;
		}
		

		int totHit=	hit1+hit2+hit3;
		
		if(totHit>0) 
		{
			MobileDesc(cont);
		}else{
			cont1=cont;
			CallCont();
		}
		
//		MobileDesc(cont);
	}
	

	public void MobileDesc(String cont) {
		
		
		cont1=cont;
		
		 Pattern pattern1= Pattern.compile("(?i)png|jpg|gif|jpeg");
		 Matcher matcher1 = pattern1.matcher(cont);
		  
		  while (matcher1.find()) {
			    hit++;
			    FindHit++;
			    
			}
	
		  FindImage(cont);
	}
	
	
	public String FindImage(String cont) {
		  
		  Pattern pattern = Pattern.compile(regex);
		  Matcher matcher = pattern.matcher(cont);
		
		  Pattern pattern1= Pattern.compile("(?i)png|jpg|gif|jpeg");
		  Matcher matcher1 = pattern1.matcher(cont);
		  
		  int hit=0;
		  
		  if(matcher.find()==true && matcher1.find()==true){
//			  System.out.println("::"+cont.substring(matcher.end()+2, matcher1.end()));
			  TotProcess(cont.substring(matcher.end()+2, matcher1.end()));
//			  cont=cont.replaceAll(cont.substring(matcher.end()-9, matcher1.end()),"");
			  cont=cont.replaceAll(cont.substring(matcher.start()+5, matcher1.end()),"");
//			  System.out.println(":::::cont:::"+cont);
		      if(FindHit>1) {
		    	  //return FindPng(cont.replaceAll(cont.substring(matcher.start(), matcher1.end()),""));
		    	  return FindImage(cont);
		    	  }
		  }
		return "";
		 }
/*	
	public String FindPng(String cont) {
	  
	  Pattern pattern = Pattern.compile(regex);
	  Matcher matcher = pattern.matcher(cont);
	
	  Pattern pattern1= Pattern.compile("(?i)png");
	  Matcher matcher1 = pattern1.matcher(cont);
	  
	  Pattern pattern2= Pattern.compile("(?i)png");
	  Matcher matcher2 = pattern2.matcher(cont);
	  
	  int hit=0;
	  
	  while (matcher2.find()) {
		    hit++;
		}
	  
	  if(hit==0){
		  FindJpg(cont); 
	  }
	  
	  if(matcher.find()==true && matcher1.find()==true){
		  TotProcess(cont.substring(matcher.end()+2, matcher1.end()));
		  cont=cont.replaceAll(cont.substring(matcher.end()+2, matcher1.end()),"");
	      if(hit>1) {
//	    	  return FindPng(cont.replaceAll(cont.substring(matcher.start(), matcher1.end()),""));
	    	  return FindPng(cont);
	    	  }else{
	    	  FindJpg(cont); 
	    	  }
	  }
	return "";
	 }
	 
	public String FindJpg(String cont) {
	  
		  Pattern pattern = Pattern.compile(regex);
		  Matcher matcher = pattern.matcher(cont);
		
		  Pattern pattern1= Pattern.compile("(?i)jpg");
		  Matcher matcher1 = pattern1.matcher(cont);

		  Pattern pattern2= Pattern.compile("(?i)jpg");
		  Matcher matcher2 = pattern2.matcher(cont);
		  
		  int hit=0;
		  
		  while (matcher2.find()) {
			    hit++;
			}
		  
		  if(hit==0){
			  FindGif(cont);
		  }
		
		  if(matcher.find()==true && matcher1.find()==true){
			  TotProcess(cont.substring(matcher.end()+2, matcher1.end()));
			  cont=cont.replaceAll(cont.substring(matcher.end()+2, matcher1.end()),"");
			  if(hit>1) {
				  return FindJpg(cont);
//				  return FindJpg(cont.replaceAll(cont.substring(matcher.start(), matcher1.end()),""));
				  }else{
		    	  FindGif(cont); 
		    	  }
		  }
		  
		return "";
		 }
	 
	 
	public String FindGif(String cont) {
		  
		  Pattern pattern = Pattern.compile(regex);
		  Matcher matcher = pattern.matcher(cont);
		
		  Pattern pattern1= Pattern.compile("(?i)gif");
		  Matcher matcher1 = pattern1.matcher(cont);

		  Pattern pattern2= Pattern.compile("(?i)gif");
		  Matcher matcher2 = pattern2.matcher(cont);
		  
		  int hit=0;
		  
		  while (matcher2.find()) {
			    hit++;
			}
		  
		  if(hit==0){
			  FindJpeg(cont); 
		  }
		
		  if(matcher.find()==true && matcher1.find()==true){
			  TotProcess(cont.substring(matcher.end()+2, matcher1.end()));
			  cont=cont.replaceAll(cont.substring(matcher.end()+2, matcher1.end()),"");
			  if(hit>1) {
				  return FindGif(cont);
//				  return FindGif(cont.replaceAll(cont.substring(matcher.start(), matcher1.end()),""));
				  }else{
				  FindJpeg(cont); 
		    	  }
		  }
		  
		return "";
		 }

	public String FindJpeg(String cont) {
		  
		  Pattern pattern = Pattern.compile(regex);
		  Matcher matcher = pattern.matcher(cont);
		
		  Pattern pattern1= Pattern.compile("(?i)jpeg");
		  Matcher matcher1 = pattern1.matcher(cont);

		  Pattern pattern2= Pattern.compile("(?i)jpeg");
		  Matcher matcher2 = pattern2.matcher(cont);
		  
		  int hit=0;
		  
		  while (matcher2.find()) {
			    hit++;
			}
		  
		  if(hit==0){호출없음}
		
		  if(matcher.find()==true && matcher1.find()==true){
			  
			  TotProcess(cont.substring(matcher.end()+2, matcher1.end()));
			  cont=cont.replaceAll(cont.substring(matcher.end()+2, matcher1.end()),"");
			  if(hit>1) {
				  return FindJpeg(cont);
//				  return FindJpeg(cont.replaceAll(cont.substring(matcher.start(), matcher1.end()),""));
				  }else{}
		  }
		  
		return "";
		 }
*/
	 @Transactional(value = "ckTransactionManager", rollbackFor = { Exception.class })
	 public  void TotProcess(String chRegex){
		 
		 callNum++;
		 
		 ReplCont(chRegex);
		 
		 if(callNum==hit){
			 try {
				CallCont();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		 }
	 }
	 
	 
	 
	 public String ReplCont(String chRegex) {
		  
		  Pattern pattern = Pattern.compile(chRegex);
		  Matcher matcher = pattern.matcher(cont1);
		  
		  String reNm="";
		  
		  if(matcher.find()==true ){
			  reNm=reName(chRegex);
		  }
		  
		  Pattern pattern1 = Pattern.compile(upDirGubun);
		  Matcher matcher1 = pattern1.matcher(chRegex);
		  
		  String filePPath="";
		  if(matcher1.find()==true){
				 int start=matcher1.end()+1;
				 int endLen = chRegex.length();
				 filePPath=chRegex.substring(start, endLen);
		    }
		  filePPath=hostName+filePPath;
		  cont1=cont1.replaceAll(filePPath, reNm);
		  return "";
		
		 }
	 
	 public String reName(String imageUrl)
	{
		
		Pattern pattern = Pattern.compile(upDirGubun);
		Matcher matcher = pattern.matcher(imageUrl);
		
		String filePPath="";
		String filePath="";
		
		if(matcher.find()==true){
			 int start=matcher.end()+1;
			 int endLen = imageUrl.length();
			 filePPath=imageUrl.substring(start, endLen);
	    }		
		String fullfileNm = filePPath.substring(filePPath.lastIndexOf("/") + 1);
		String file_ext = fullfileNm.substring(fullfileNm.lastIndexOf('.')+1,fullfileNm.length());
		String fileNm=fullfileNm.replaceAll("."+file_ext, "");
	    String reName=fileNm+"_M."+file_ext;
	    String Path=filePPath.replaceAll(fullfileNm,"");
	    String Path1=filePPath.replaceAll(fullfileNm,"");
	    
	    filePath=fileDir+Path+fullfileNm;
	    
	    Path=fileDir+Path;
	    
	    reName=hostName+Path1+reName;
	    
		try {
			makeThumbnail(filePath,fileNm,file_ext, Path);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	    
	    return reName;
	     
	}
	
	 public void makeThumbnail(String filePath, String fileName, String fileExt,String path) throws Exception { 
		String thumbName = path + fileName+"_M."+fileExt;
			
		BufferedImage originalImage = ImageIO.read(new File(filePath));
		BufferedImage thumbnail = Thumbnails.of(originalImage)
		        .scale(0.60)
		        .asBufferedImage();
		
		ImageIO.write(thumbnail,fileExt, new File(thumbName));
	}
	
	
	
	@Transactional(value = "ckTransactionManager", rollbackFor = { Exception.class })
	public void CallCont() throws Exception {

		ParamMap paramMap = new ParamMap();
		paramMap.put("MDESCRIPTION",cont1);
		paramMap.put("uci",uci);
		
		ckDataBaseService.save("festival.event.updateMDesc", paramMap);
		
		System.out.println(":::ShowMUpdateService:::ShowMUpdateService_OK:::::");
	}
	
	@Transactional(value = "ckTransactionManager", rollbackFor = { Exception.class })
	public void MdescUpdate(ParamMap paramMap) throws Exception {
		
		paramMap.put("MDESCRIPTION","");
		
		ckDataBaseService.save("show.updateMDesc", paramMap);
		
		System.out.println(":::ShowMUpdateService:::MdescUpdate_OK:::::");
	}

}