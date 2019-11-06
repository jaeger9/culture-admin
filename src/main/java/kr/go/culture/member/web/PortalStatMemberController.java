package kr.go.culture.member.web;

import java.util.Calendar;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

@RequestMapping("/member/portalStat")
@Controller
public class PortalStatMemberController {

	private static final Logger logger = LoggerFactory.getLogger(PortalStatMemberController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService service;

	// 특정 월 말일
	private String getActualMaximum(String year, String month) {
		Calendar c = Calendar.getInstance();
		int nYear = 0;
		int nMonth = 0;
		int nDay = 0;

		nYear = Integer.parseInt(year);
		nMonth = Integer.parseInt(month) - 1;
		c.set(nYear, nMonth, 1);

		nDay = c.getActualMaximum(Calendar.DAY_OF_MONTH);

		return nDay < 10 ? "0" + nDay : String.valueOf(nDay);
	}

	@RequestMapping("/list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		String view = paramMap.getString("view", "list");
		String dateFormat = paramMap.getString("date_format", "YYYY");
		String dateStart = paramMap.getString("display_date_start");
		String dateEnd = paramMap.getString("display_date_end");
		String member_type = paramMap.getString("member_type"); 

		String year = null;
		String month = null;
		
		if(member_type == null || "".equals(member_type)){
			paramMap.put("member_type", "newmember");
		}

		if ("YYYY".equals(dateFormat)) {
			// 년도별
			if (dateStart.split("-").length > 2) {
				year = dateStart.split("-")[0];
				month = dateStart.split("-")[1];

				dateStart = year + "-01-01";
			}
			if (dateEnd.split("-").length > 2) {
				year = dateEnd.split("-")[0];
				month = dateEnd.split("-")[1];

				dateEnd = year + "-12-31";
			}
		} else if ("YYYY-MM".equals(dateFormat)) {
			// 월별
			if (dateStart.split("-").length > 2) {
				year = dateStart.split("-")[0];
				month = dateStart.split("-")[1];

				dateStart = year + "-" + month + "-01";
			}
			if (dateEnd.split("-").length > 2) {
				year = dateEnd.split("-")[0];
				month = dateEnd.split("-")[1];

				dateEnd = year + "-" + month + "-" + getActualMaximum(year, month);
			}
		} else {
			// 일자
			dateFormat = "YYYY-MM-DD";
		}

		paramMap.put("date_format", dateFormat);
		paramMap.put("date_start", dateStart);
		paramMap.put("date_end", dateEnd);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("list", service.readForList("portalStatMember.list", paramMap));

		//return "/member/portalStat/" + view;
		return "thymeleaf/member/portalStat/" + view;
	}

}