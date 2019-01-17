package kr.go.culture.perform.service;

import java.io.File;
import java.io.IOException;

import kr.go.culture.common.domain.ParamMap;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service("RelayLeafletDistributeService")
public class RelayLeafletDistributeService {

	@Value("#{contextConfig['file.upload.base.location.dir']}")
	private String fileUploadBaseLocaionDir;
	
	public void distribute(MultipartFile multi, ParamMap paramMap)
			throws Exception {
		
		File file = multipartToFile(multi , paramMap);
	}

	public File multipartToFile(MultipartFile multipart, ParamMap paramMap)
			throws Exception {
		
		File convFile = new File(getDistributesPath(paramMap));
		multipart.transferTo(convFile);
		
		return convFile;
	}
	
	private String getFileName(ParamMap param) throws Exception {
		
		if(param.containsKey("gubun")) 
			return param.get("gubun").toString() + ".jpg";	
		else 
			throw new Exception("File Name(Param gubun) is Null");
	}
	
	private String getDistributesPath(ParamMap param) throws Exception {
		return fileUploadBaseLocaionDir + File.separator + "upload/leaflet" + File.separator + getFileName(param);
	}
}
