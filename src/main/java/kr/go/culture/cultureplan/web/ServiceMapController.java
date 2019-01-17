package kr.go.culture.cultureplan.web;

import java.util.ArrayList;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.CommonModel;
import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.util.SessionMessage;
import net.sf.json.JSONObject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

@RequestMapping("/cultureplan/servicemap")
@Controller
public class ServiceMapController {

	private static final Logger logger = LoggerFactory
			.getLogger(ServiceMapController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService service;

	@RequestMapping("/list.do")
	public String list(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) service.readForObject("serviceMap.count", paramMap));
		model.addAttribute("list", service.readForList("serviceMap.list", paramMap));
		

		return "/cultureplan/servicemap/list";
	}

	@RequestMapping(value = "/view.do", method = RequestMethod.GET)
	public String form(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);
		CommonModel resultMap = null;
		
		if (paramMap.isNotBlank("seq")) {
			resultMap = (CommonModel) service.readForObject("serviceMap.view", paramMap);
			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/cultureplan/servicemap/list.do";
			}
		}

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("view", resultMap);

		
		
		return "/cultureplan/servicemap/view";
	}

	@RequestMapping(value = "/view.do", method = RequestMethod.POST)
	public String merge(HttpServletRequest request, ModelMap model)
			throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		//paramMap.put("org_url", "http://"+paramMap.get("org_url"));
		
		CommonModel resultMap = null;

		if (paramMap.isNotBlank("seq")) {
			resultMap = (CommonModel) service.readForObject("serviceMap.view", paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return "redirect:/cultureplan/servicemap/list.do";
			}

			// update
			service.save("serviceMap.update", paramMap);
			SessionMessage.update(request);

		} else {
			// insert
			service.insert("serviceMap.insert", paramMap);
			SessionMessage.insert(request);
		}

		return "redirect:/cultureplan/servicemap/list.do";
	}

	@RequestMapping(value = "/popup.do", method = RequestMethod.GET)
	public String popup(HttpServletRequest request, ModelMap model)
			throws Exception {

		String pnum = request.getParameter("pnum");
		

		ArrayList<String> mapData = null;
		String mmData[]=null;
		String serviceTitle="";
		
		if ("1".equals(pnum)) {
			mapData = new ArrayList<String>();
			mmData = new String[]{ "유료", "무료", "할인" }; // 비용
			serviceTitle="서비스 비용구분";
		} else if ("2".equals(pnum)) {
			mapData = new ArrayList<String>();
			mmData = new String[]{ "체험", "관람", "감상" }; // 유형- 오프라인
			serviceTitle="서비스 유형-오프라인";
		} else if ("3".equals(pnum)) {
			mapData = new ArrayList<String>();
			mmData = new String[]{ "동영상", "자료", "문서" }; // 유형-온라인
			serviceTitle="서비스 유형-온라인";
		} else if ("4".equals(pnum)) {
			mapData = new ArrayList<String>();
			mmData = new String[]{ "어린이", "청소년", "성인","어르신" }; // 대상 - 연령
			serviceTitle="서비스 대상-연령";
		} else if ("5".equals(pnum)) {
			mapData =new ArrayList<String>();
			mmData = new String[]{ "다문화","장애인","외국인" }; // 대상- 다양성
			serviceTitle="서비스 대상-다양성";
		} else if ("6".equals(pnum)) {
			mapData = new ArrayList<String>();
			mmData = new String[]{ "예술인", "교사", "운동선수" }; // 대상 - 직업
			serviceTitle="서비스 대상-직업";
		} else if ("7".equals(pnum)) {
			mapData = new ArrayList<String>();
			mmData = new String[]{ "문화예술", "문화유산", "문화복지", "관광", "여건조성", "체육", "도서", "홍보" }; // 장르
			serviceTitle="서비스 장르";
		} else if ("8".equals(pnum)) {// 서비스 구분
			mapData = new ArrayList<String>();
			mmData = new String[]{ "강연/강의", "교육/학습", "공연/전시","봉사/교류", "뉴스/지식", "대회/행사","대관/대여", "자격/증명", "연구/자료" }; 
			serviceTitle="서비스 구분";
		}

		
		 for(int i=0; i<mmData.length; i++){ 
			 System.out.println("::pnum:::"+pnum+"::::"+mmData[i]);
			 mapData.add(mmData[i]);
		 }
		 
		 model.addAttribute("pnum", pnum);
		 model.addAttribute("mapData", mapData);
		 model.addAttribute("serviceTitle", serviceTitle);

		return "/cultureplan/servicemap/popup";
	}

	@RequestMapping(value = "/approval.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject approval(String[] seqs, String approval, ModelMap model)
			throws Exception {
		JSONObject jo = new JSONObject();

		if (seqs == null || seqs.length == 0) {
			jo.put("success", false);
			return jo;
		}

		ParamMap paramMap = new ParamMap();
		paramMap.put("approval", "Y".equals(approval) ? "Y" : "N");
		paramMap.putArray("seqs", seqs);
		service.save("serviceMap.updateApproval", paramMap);

		jo.put("success", true);
		return jo;
	}

	@RequestMapping(value = "/delete.do", method = RequestMethod.POST)
	@ResponseBody
	public JSONObject delete(String[] seqs, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		if (seqs == null || seqs.length == 0) {
			jo.put("success", false);
			return jo;
		}

		ParamMap paramMap = new ParamMap();
		paramMap.putArray("seqs", seqs);
		service.delete("serviceMap.delete", paramMap);

		jo.put("success", true);
		return jo;
	}

}