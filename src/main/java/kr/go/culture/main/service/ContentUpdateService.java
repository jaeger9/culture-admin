package kr.go.culture.main.service;

import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.service.FileService;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

@Service("ContentUpdateService")
public class ContentUpdateService {
	
	@Resource(name="CkDatabaseService")
	CkDatabaseService ckDatabaseService;

	@Resource(name = "FileService")
	private FileService fileService;

	@Value("#{contextConfig['file.upload.base.location.dir']}")
	private String fileUploadBaseLocaionDir;
	
	@Transactional(value="ckTransactionManager" , rollbackFor={Exception.class})
	public void update(ParamMap paramMap) throws Exception {
		List<HashMap<String , Object>> paramList = null;
		
		ckDatabaseService.save("content.update" , paramMap);
		
		paramList = setParamData(paramMap);
		
		for(HashMap<String , Object> param : paramList)
			ckDatabaseService.save("content.updateContentSub", param);
	}
	
	public List<HashMap<String , Object>> setParamData(ParamMap paramMap) throws Exception {
		List<HashMap<String , Object>> paramList = new ArrayList<HashMap<String , Object>> ();
		
		int data_count = paramMap.getArray("title").length;
		
		for(int index = 0 ; index < data_count ; index++) {
			HashMap<String , Object> param = new HashMap<String, Object>();

			if( "704".equals( paramMap.get("menu_type") ) ){
				param.put("title", paramMap.getArray("title")[index]);
				//마지막 한셋트는 이미지가 없다.
				if( paramMap.getArray("image_name").length == index ){
					param.put("image_name", "");
				}else{
					param.put("image_name", paramMap.getArray("image_name")[index]);
				}
				
				//연구보고서 url입력시 사용자쪽에서 한글깨지는것 인코딩 변환
				String url = paramMap.getArray("url")[index];
				if(url.indexOf("knowledge/reportList.do") != -1){

					String[] split = url.split("&");				
					String urlParam = split[0].substring(split[0].indexOf("sWord")+6);
					String enUrlParam = URLEncoder.encode(urlParam,"UTF-8");
					String enUrl = "http://www.culture.go.kr/knowledge/reportList.do?sWord="+enUrlParam+"&sGubun=title";
					param.put("url", enUrl);
				}else{
					param.put("url", paramMap.getArray("url")[index]);
				}
				
				param.put("pseq", paramMap.get("pseq"));
				param.put("summary", paramMap.getArray("summary")[index]);
				param.put("category", paramMap.getArray("code")[index]);
				param.put("seq", paramMap.getArray("seq")[index]);
			}else if ( "705".equals( paramMap.get("menu_type") ) ){
				param.put("title", paramMap.getArray("title")[index]);
				param.put("image_name", paramMap.getArray("image_name")[index]);
				param.put("image_name2", paramMap.getArray("image_name2")[index]);
				param.put("url", paramMap.getArray("url")[index]);
				param.put("place", paramMap.getArray("place")[index]);
				param.put("pseq", paramMap.get("pseq"));
				param.put("summary", paramMap.getArray("summary")[index]);
				param.put("category", paramMap.getArray("code")[index]);
				param.put("seq", paramMap.getArray("seq")[index]);
				param.put("rights", paramMap.getArray("rights")[index]);
			}else if ( "706".equals( paramMap.get("menu_type") ) ){
				param.put("title", paramMap.getArray("title")[index]);
				param.put("url", paramMap.getArray("url")[index]);
				param.put("uci", paramMap.getArray("uci")[index]);
				param.put("cont_date", paramMap.getArray("cont_date")[index]);
				param.put("rights", paramMap.getArray("rights")[index]);
				param.put("image_name", paramMap.getArray("image_name")[index]);
				param.put("category", paramMap.getArray("code")[index]);
				param.put("pseq", paramMap.get("pseq"));
				param.put("seq", paramMap.getArray("seq")[index]);
			}else if ( "707".equals( paramMap.get("menu_type") ) ){
				param.put("title", paramMap.getArray("title")[index]);
				param.put("url", paramMap.getArray("url")[index]);
				param.put("category", paramMap.getArray("code")[index]);
				param.put("new_win_yn", paramMap.getArray("new_win_yn")[index]);
				param.put("pseq", paramMap.get("pseq"));
				param.put("seq", paramMap.getArray("seq")[index]);
			}else if ( "752".equals( paramMap.get("menu_type") ) ){
				param.put("title", paramMap.getArray("title")[index]);
				param.put("url", paramMap.getArray("url")[index]);
				param.put("uci", paramMap.getArray("uci")[index]);
				param.put("cont_date", paramMap.getArray("cont_date")[index]);
				param.put("rights", paramMap.getArray("rights")[index]);
				param.put("image_name", paramMap.getArray("image_name")[index]);
				param.put("category", paramMap.getArray("code")[index]);
				param.put("pseq", paramMap.get("pseq"));
				param.put("seq", paramMap.getArray("seq")[index]);
			}else if ( "753".equals( paramMap.get("menu_type") ) ){
				param.put("seq", paramMap.get("seq"));
				param.put("pseq", paramMap.get("pseq"));
				param.put("title", paramMap.getArray("title")[index]);
				param.put("image_name", paramMap.getArray("image_name")[index]);
				param.put("url", paramMap.getArray("url")[index]);
				param.put("category", paramMap.getArray("code")[index]);
				param.put("uci", paramMap.getArray("uci")[index]);
				param.put("new_win_yn", paramMap.getArray("new_win_yn")[index]);
			}else{
				param.put("title", paramMap.getArray("title")[index]);
				param.put("image_name", paramMap.getArray("image_name")[index]);
				param.put("image_name2", paramMap.getArray("image_name2")[index]);
				param.put("url", paramMap.getArray("url")[index]);
				param.put("uci", paramMap.getArray("uci")[index]);
				param.put("seq", paramMap.getArray("seq")[index]);
				param.put("category", paramMap.getArray("category")[index]);
				param.put("place", paramMap.getArray("place")[index]);
				param.put("discount", paramMap.getArray("discount")[index]);
				param.put("period", paramMap.getArray("period")[index]);
				param.put("summary", paramMap.getArray("summary")[index]);
				param.put("cont_date", paramMap.getArray("cont_date")[index]);
				param.put("rights", paramMap.getArray("rights")[index]);
				param.put("pseq", paramMap.get("pseq"));
			}
			
			paramList.add(param);
		}
		
		return paramList;
	}

	@Transactional(value="ckTransactionManager" , rollbackFor={Exception.class})
	public void updateMain(ParamMap paramMap) throws Exception {
		List<HashMap<String , Object>> paramList = null;
		
		ckDatabaseService.save("content.update" , paramMap);
		
		//기존 데이터를 전부 삭제한 후 입력한다.
		ckDatabaseService.delete("content.deleteContentSub", paramMap);
		paramList = setParamDatas(paramMap, 4);
		
		for(HashMap<String , Object> param : paramList)
			ckDatabaseService.save("content.insertContentSub", param);
	}
	
	public List<HashMap<String , Object>> setParamDatas(ParamMap paramMap, int groupSize) throws Exception {
		List<HashMap<String , Object>> paramList = new ArrayList<HashMap<String , Object>> ();
		int data_count = 0;
		
		for(int gIndex = 1; gIndex <= groupSize; gIndex++){
			data_count = paramMap.getArray("title_grp"+gIndex).length;
			for(int index = 0 ; index < data_count ; index++) {
				HashMap<String , Object> param = new HashMap<String, Object>();
				
				param.put("title", paramMap.getArray("title_grp"+gIndex)[index]);
				param.put("image_name", paramMap.getArray("image_name_grp"+gIndex)[index]);
				param.put("image_name2", paramMap.getArray("image_name2_grp"+gIndex)[index]);
				param.put("url", paramMap.getArray("url_grp"+gIndex)[index]);
				param.put("title_top", paramMap.get("title_top_grp"+gIndex));
				param.put("uci", paramMap.getArray("uci_grp"+gIndex)[index]);
				param.put("category", paramMap.getArray("category_grp"+gIndex)[index]);
				param.put("place", paramMap.getArray("place_grp"+gIndex)[index]);
				param.put("discount", paramMap.getArray("discount_grp"+gIndex)[index]);
				param.put("period", paramMap.getArray("period_grp"+gIndex)[index]);
				param.put("summary", paramMap.getArray("summary_grp"+gIndex)[index]);
				param.put("cont_date", paramMap.getArray("cont_date_grp"+gIndex)[index]);
				param.put("rights", paramMap.getArray("rights_grp"+gIndex)[index]);
				param.put("pseq", paramMap.get("pseq"));
				param.put("group_num", paramMap.getArray("group_num_grp"+gIndex)[index]);
				param.put("group_type", paramMap.getArray("group_type_grp"+gIndex)[index]);
				param.put("main_text", paramMap.getArray("main_text_grp"+gIndex)[index]);
				param.put("category", paramMap.getArray("code_grp"+gIndex)[index]);
				param.put("type", paramMap.getArray("sub_type_grp"+gIndex)[index]);
				if(paramMap.getArray("seq_grp"+gIndex)[index]!=null) {
					String seq=paramMap.getArray("seq_grp"+gIndex)[index];
					if(!seq.equals("")) {
						param.put("seq", seq);
					}
				}
				
				paramList.add(param);
			}
		}
		
		return paramList;
	}
	
	@Transactional(value="ckTransactionManager" , rollbackFor={Exception.class})
	public void updateKnow(ParamMap paramMap, MultipartFile[] multi) throws Exception { 
		String fileName = "";
		MultipartFile mfile = null;
		String[] imageNames = new String[multi.length];
		List<HashMap<String , Object>> paramList = null;
		String uploadPath = "/upload/mainContent/";

		for ( int i=0; i < multi.length; i++ ) {
			mfile = multi[i];
			if( !mfile.isEmpty() && mfile.getSize() > 0 ){
				fileName = fileService.writeFile(mfile, "main_content");
				imageNames[i] = uploadPath+fileName;
			}else{
				imageNames[i] = paramMap.getArray("imgFile")[i];
			}
		}
		
		paramMap.putArray("image_name", imageNames);
		
		ckDatabaseService.save("content.update" , paramMap);
		
		paramList = setParamData(paramMap);
		
		for(HashMap<String , Object> param : paramList)
			ckDatabaseService.save("content.updateContentSub", param);
		
	}
	
	@Transactional(value="ckTransactionManager" , rollbackFor={Exception.class})
	public void updateMainContents(ParamMap paramMap,MultipartFile[]multipartFiles) throws Exception {
		List<HashMap<String , Object>> paramList = null;
		
		ckDatabaseService.save("content.update" , paramMap);
		paramList = setParamDatas(paramMap, paramMap.getInt("groupSize"));
		
		int indexForFile=0;
		
		for(HashMap<String, Object> param : paramList) {
			if(multipartFiles!=null && !multipartFiles[indexForFile].isEmpty()) {
				String fileName=fileService.writeFile(multipartFiles[indexForFile++], "cultureagree");
				param.put("main_image_name",fileName);
			}
			ckDatabaseService.save("content.updateContentSub",param);
		}
		
		
		//기존 데이터를 전부 삭제한 후 입력한다.
		/*
		 * ckDatabaseService.delete("content.deleteContentSub", paramMap); paramList =
		 * setParamDatas(paramMap, paramMap.getInt("groupSize"));
		 * 
		 * for(HashMap<String , Object> param : paramList)
		 * ckDatabaseService.save("content.insertContentSub", param);
		 */
		
		
	}
	
}
