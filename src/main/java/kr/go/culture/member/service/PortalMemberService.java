package kr.go.culture.member.service;

import javax.annotation.Resource;

import kr.go.culture.common.domain.CommonModel;
import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;

import org.springframework.stereotype.Service;
import org.springframework.ui.ModelMap;

@Service("PortalMemberService")
public class PortalMemberService {

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService service;

	public boolean setMemberInfo(CommonModel resultMap) {

		if (resultMap == null) {
			return false;
		}

		String[] temps = null;

		if (resultMap.get("tel") != null) {
			temps = ((String) resultMap.get("tel")).split("-");
			for (int i = 0; i < temps.length; i++) {
				resultMap.put("tel" + (i + 1), temps[i]);
			}
		}
		if (resultMap.get("hp") != null) {
			temps = ((String) resultMap.get("hp")).split("-");
			for (int i = 0; i < temps.length; i++) {
				resultMap.put("hp" + (i + 1), temps[i]);
			}
		}
		if (resultMap.get("email") != null) {
			temps = ((String) resultMap.get("email")).split("@");
			for (int i = 0; i < temps.length; i++) {
				resultMap.put("email" + (i + 1), temps[i]);
			}
		}
		if (resultMap.get("birth") != null) {
			temps = ((String) resultMap.get("birth")).split("-");
			for (int i = 0; i < temps.length; i++) {
				resultMap.put("birth" + (i + 1), temps[i]);
			}
		}

		return true;
	}

	public void setMemberCategory(ModelMap model) throws Exception {

		// 정보
		ParamMap tmpMap = new ParamMap();

		tmpMap.put("common_code_type", "PHONE");
		model.addAttribute("phoneList", service.readForList("common.codeList", tmpMap));

		tmpMap.put("common_code_type", "EMAIL");
		model.addAttribute("mailList", service.readForList("common.codeList", tmpMap));

	}

}