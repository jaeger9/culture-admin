package kr.go.culture.main.service;

import javax.annotation.Resource;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.service.FileService;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

@Service("BannerInsertService")
public class BannerInsertService {

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDataBaseService;

	@Resource(name = "FileService")
	private FileService fileService;

	@Transactional(value = "ckTransactionManager", rollbackFor = { Exception.class })
	public void insert(ParamMap paramMap, MultipartFile multi) throws Exception {

		String fileName = fileService.writeFile(multi, "banner");
		paramMap.put("file_sysname", fileName);

		ckDataBaseService.save("banner.insert", paramMap);
	}
	
	@Transactional(value = "ckTransactionManager", rollbackFor = { Exception.class })
	public void insertMulti(ParamMap paramMap, MultipartFile[] tMulti, MultipartFile[] mMulti) throws Exception {
		String fileName = "";
		MultipartFile mfile = null;

		for ( int i=1; i <= tMulti.length; i++ ) {
			mfile = tMulti[i-1];
			if( !mfile.isEmpty() && mfile.getSize() > 0 ){
				fileName = fileService.writeFile(mfile, "banner");
				if( i == 1 ){
					paramMap.put("file_sysname", fileName);
				}else{
					paramMap.put("file_sysname"+i, fileName);
				}
			}
		}
		
		for ( int i=1; i <= mMulti.length; i++ ) {
			mfile = mMulti[i-1];
			if( !mfile.isEmpty() && mfile.getSize() > 0 ){
				fileName = fileService.writeFile(mfile, "banner");
				if( i == 1 ){
					paramMap.put("mobile_file_sysname", fileName);
				}else{
					paramMap.put("mobile_file_sysname"+i, fileName);
				}
			}
		}
		
		ckDataBaseService.save("banner.insert", paramMap);
	}

}
