package kr.go.culture.facility.service;

import javax.annotation.Resource;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.service.FileService;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

@Service("PlaceUpdateService")
public class PlaceUpdateService {

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDataBaseService;

	@Resource(name = "FileService")
	private FileService fileService;

	@Transactional(value = "ckTransactionManager", rollbackFor = { Exception.class })
	public void update(ParamMap paramMap, MultipartFile multi) throws Exception {
		
		String fileName = fileService.writeFile(multi, "place");

		paramMap.put("file_sysname", fileName);

		if ("Y".equals(paramMap.getString("rental_yn"))) {
			paramMap.put("rental_yn", "Y");
		} else {
			paramMap.put("rental_yn", "N");
		}
		ckDataBaseService.save("place.update", paramMap);

		/*
		 * if(paramMap.containsKey("imagedelete") && paramMap.get("imagedelete").toString().equals("Y"))
		 * fileService.deleteFile("show", paramMap.get("imagedelete").toString());
		 */

		if (paramMap.getString("rental_yn") != null && paramMap.getString("rental_yn").equals("Y")) {
			if (paramMap.getString("apply_url") == null || "".equals(paramMap.getString("apply_url"))) {
				if (paramMap.containsKey("rental_seq")) {
					ckDataBaseService.save("place.updateRental", paramMap);
				} else {
					ckDataBaseService.insert("place.insertRental", paramMap);
				}
			}
		} else if (paramMap.containsKey("rental_seq")) {
			paramMap.put("rental_approval", "N");
			ckDataBaseService.save("place.updateRental", paramMap);
		}
		
		/*
		 * 2016.03.17
		 * GIS_FACILITY_INFO INSERT
		 * PCN Choi Won-Young
		 */
		if (paramMap.getString("cul_gps_x") != null && paramMap.getString("cul_gps_Y") != null) {
			
			String facilityCode = StringUtils.isEmpty(paramMap.getString("cul_grp1")) ? paramMap.getString("cul_grp2") : paramMap.getString("cul_grp1");
			paramMap.put("facility_code", facilityCode);
			
			ckDataBaseService.delete("place.deleteFacilityMapInfo", paramMap);
			ckDataBaseService.insert("place.insertFacilityMapInfo", paramMap);
			
		}
	}

}
