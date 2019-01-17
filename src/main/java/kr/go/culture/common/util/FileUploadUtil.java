package kr.go.culture.common.util;

import java.io.File;
import java.io.FileOutputStream;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.lang.RandomStringUtils;
import org.springframework.web.multipart.MultipartFile;

public class FileUploadUtil {

	public static Map<String, Object> uploadFileMap(MultipartFile file, Map<String, Object> paramMap) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		FileOutputStream fos = null;
		
		try {
			String menuType = paramMap.get("menuType").toString();
			String filePath = paramMap.get("filePath").toString();
			String fileName = file.getOriginalFilename();
			String fileExt = fileName.substring(fileName.lastIndexOf("."), fileName.length());
			String saveFileName = null;
			
			File dir = new File(filePath);
			if(!dir.exists()) {
				dir.mkdirs();
			}
			
			boolean fileExists = true;
			do {
				String randomNum = RandomStringUtils.random(5, false, true);
				saveFileName = menuType+"_"+DateUtil.getDateTime("YMDhms")+randomNum+fileExt;
				File checkFile = new File(filePath, saveFileName);
				fileExists = checkFile.exists();
			} while (fileExists);
			
			byte bytes[] = file.getBytes();
			fos = new FileOutputStream(filePath + File.separator + saveFileName);
			fos.write(bytes);
			
			map.put("fileName", fileName);
			map.put("saveFileName", saveFileName);
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if(fos != null) {
				try {
					fos.close();
					fos = null;
				} catch (Exception e2) {}
			}
		}
		
		return map;
	}
	
}
