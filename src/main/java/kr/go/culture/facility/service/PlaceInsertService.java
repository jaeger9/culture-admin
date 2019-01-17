package kr.go.culture.facility.service;

import javax.annotation.Resource;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.service.FileService;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

@Service("PlaceInsertService")
public class PlaceInsertService {

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDataBaseService;

	@Resource(name = "FileService")
	private FileService FileService;

	@Transactional(value = "ckTransactionManager", rollbackFor = { Exception.class })
	public void insert(ParamMap paramMap, MultipartFile multi) throws Exception {

		String fileName = FileService.writeFile(multi, "place");
		paramMap.put("file_sysname", fileName);

		int cul_seq = (Integer) ckDataBaseService.insert("place.insert", paramMap);
		paramMap.put("cul_seq", cul_seq);
		
		if (paramMap.getString("rental_yn") != null && paramMap.getString("rental_yn").equals("Y")) {
			ckDataBaseService.insert("place.insertRental", paramMap);
		}
		
		/*
		 * 2016.03.17
		 * GIS_FACILITY_INFO INSERT
		 * PCN Choi Won-Young
		 */
		if (paramMap.getString("cul_gps_x") != null && paramMap.getString("cul_gps_Y") != null) {
			
			String facilityCode = StringUtils.isEmpty(paramMap.getString("cul_grp1")) ? paramMap.getString("cul_grp2") : paramMap.getString("cul_grp1");
			paramMap.put("facility_code", facilityCode);
			
			paramMap.putArray("cul_seq", new String[]{Integer.toString(cul_seq)});
			ckDataBaseService.delete("place.deleteFacilityMapInfo", paramMap);
			ckDataBaseService.insert("place.insertFacilityMapInfo", paramMap);
			
		}
	}

}