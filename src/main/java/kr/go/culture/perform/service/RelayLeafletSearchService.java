package kr.go.culture.perform.service;

import java.util.HashMap;

import javax.annotation.Resource;

import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.service.FileService;

import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

@Service("RelayLeafletSearchService")
public class RelayLeafletSearchService {

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;
	
	@Resource(name = "FileService")
	private FileService fileService;
	
	public void list(ModelMap model) throws Exception { 
		
		try {

			model.addAttribute("list", ckDatabaseService.readForList("relay_leaflet.list", null)); //해당 년도 1~6까지
			model.addAttribute("count", ckDatabaseService.readForObject("relay_leaflet.listCnt", null)); //count 6개 고정이다;;;
			model.addAttribute("fileList", getFileList()); //리플렛 파일 리스트
			
		} catch (Exception e) {
			throw e;
		}
	}
	
	private HashMap<String , String> getFileList() throws Exception { 
		
		HashMap<String , String> fileList = null;
		String[] fileNames = null;
		
		try {
			fileList = new HashMap<String , String>();
			
			fileNames = fileService.fileList("leaflet");
			
			for(String fileName : fileNames)  
				fileList.put(fileName , "Y");
			
			return fileList;
			
		} catch (Exception e) {
			throw e;
		}
	}
}
