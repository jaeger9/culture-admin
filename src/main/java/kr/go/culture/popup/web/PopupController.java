package kr.go.culture.popup.web;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.regex.Pattern;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.jdom.Document;
import org.jdom.Element;
import org.jdom.input.SAXBuilder;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.service.CuldataDatabaseService;
import kr.go.culture.common.service.FileService;
import kr.go.culture.common.service.FileService.MenuUploadFilePath;
import kr.go.culture.common.service.KiissDataBaseService;
import kr.go.culture.common.util.CommonUtil;

@RequestMapping("/popup")
@Controller
public class PopupController {

	private static final Logger logger = LoggerFactory.getLogger(PopupController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService service;
	
	@Resource(name = "CuldataDatabaseService")
	private CuldataDatabaseService culdataService;

	@Resource(name = "FileService")
	private FileService fileService;

	@Resource(name = "KiissDataBaseService")
	private KiissDataBaseService kiissDataBaseService;

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;
	
	@RequestMapping("/uciOrg.do")
	public String uciOrg(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) service.readForObject("uciOrg.count", paramMap));
		model.addAttribute("list", service.readForList("uciOrg.list", paramMap));
		model.addAttribute("categoryList", service.readForList("uciOrg.categoryList", null));

		return "/popup/uciOrg";
	}

	// 문화초대이벤트 참여자 목록
	@RequestMapping("/invitationApplicant.do")
	public String invitation(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) service.readForObject("invitationPerson.count", paramMap));
		model.addAttribute("list", service.readForList("invitationPerson.list", paramMap));

		return "/popup/invitationApplicant";
	}
	
	//문화초대이벤트 당첨자 승인 
	@RequestMapping("statusUpdate.do")
	public String statusUpdate(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		String[] arr_seq = request.getParameterValues("seq");
		String str_seq = "";
		for(int i=0 ; i < arr_seq.length ; i++){
			str_seq += arr_seq[i] + ",";
		}
		str_seq = str_seq.substring(0, str_seq.length()-1);
		paramMap.put("str_seq", str_seq);
		paramMap.put("win_yn",paramMap.get("updateStatus").toString());
		try {
			model.addAttribute("paramMap", paramMap);
			service.save("invitation.statusUpdate", paramMap);
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
		return "forward:/popup/invitationApplicant.do";
	}
	

	// 문화초대이벤트 통계
	@RequestMapping("/invitationStat.do")
	public String statistics(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);

		int reg_per_cnt = (Integer) service.readForObject("invitationStat.countByDailyRegdate", paramMap);
		if (reg_per_cnt > 0) {
			paramMap.put("reg_per_cnt", reg_per_cnt);
			model.addAttribute("listByDailyRegdate", service.readForList("invitationStat.listByDailyRegdate", paramMap));
		}

		int member_per_cnt = (Integer) service.readForObject("invitationStat.countByDailyJoinMember", paramMap);
		if (member_per_cnt > 0) {
			paramMap.put("member_per_cnt", member_per_cnt);
			model.addAttribute("listByDailyJoinMember", service.readForList("invitationStat.listByDailyJoinMember", paramMap));
		}

		return "/popup/invitationStat";
	}

	@RequestMapping("/place.do")
	public String popupList(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		paramMap.put("post_flag", "Y");

		try {
			model.addAttribute("paramMap", paramMap);

			model.addAttribute("count", (Integer) service.readForObject("place.listCnt", paramMap));
			model.addAttribute("list", service.readForList("place.list", paramMap));

		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		return "popup/place";
	}

	@RequestMapping("/coordinate.do")
	public String coordinate(HttpServletRequest request, ModelMap model) throws Exception {

		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);

		return "popup/coordinate";
	}
	
	@RequestMapping(value = "/gpsMapajax.do")
	public String gpsMapajax(HttpServletRequest request, Model model) throws Exception {
		
		try {
			// ajax 한글 깨짐 현상으로 인코딩 하였습니다.
			String addr = URLDecoder.decode((String) request.getParameter("addr"), "utf-8");
			URL url = null;
			HttpURLConnection con = null;
			InputStream is = null;
			SAXBuilder builder = null;
			Document doc = null;
			Element root = null;
			String getGpsX = null;
			String getGpsY = null;

			// 다음 오픈 api
			// url = new URL("http://apis.daum.net/local/geo/addr2coord?apikey=52554b335295a8d2bd8a86fab1efd8ac3018659a&q=" + URLEncoder.encode(addr, "utf-8") + "&output=xml");
			url = new URL("http://apis.daum.net/local/geo/addr2coord?apikey=370baf7a93479c4170abda015eb4f42303058b62&q=" + URLEncoder.encode(addr, "utf-8") + "&output=xml");
			con = (HttpURLConnection) url.openConnection();
			is = con.getInputStream();
			builder = new SAXBuilder();
			doc = builder.build(is);
			root = doc.getRootElement(); // 최상위 엘리먼트를 root에 저장한다.
			getGpsX = root.getChild("item").getChildText("lng"); // item이라는 장식항목중 lng의 text값을 가져와 result에 저장하여 준다.
			getGpsY = root.getChild("item").getChildText("lat"); // item이라는 장식항목중 lng의 text값을 가져와 result에 저장하여 준다.
			
			model.addAttribute("getGpsX", getGpsX);
			model.addAttribute("getGpsY", getGpsY);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "/popup/gpsxy";
	}
	
	@RequestMapping("/postalcode.do")
	public String postalcode(HttpServletRequest request, ModelMap model) throws Exception {

		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);

		if (paramMap.containsKey("searchYN")) {
			
			String dong = request.getParameter("dong") == null ? null : request.getParameter("dong").replaceAll(" ", "");
			String road = request.getParameter("road") == null ? null : request.getParameter("road").replaceAll(" ", "");

			Pattern p = Pattern.compile("[0-9]");

			if ("63".equals(paramMap.get("zip_yn")) || paramMap.get("zip_yn") == null) {
				// 지번검색일 경우 구로3동 이면 구로는 법정동명 3동은 행정동명으로 검색

				if (dong != null) {
					paramMap.put("dong", dong.substring(0, p.split(dong)[0].length()));
					paramMap.put("GI_NUM1", under(p.split(dong)[0].length()) + dong.substring(p.split(dong)[0].length()));
				}
			} else {
				// 도로명검색일 경우 월드컵북로400 이면 월드컵북로는 도로명 400은 건물번호 검색
				// 월드컵북로44길 이면 도로명으로만 검색

				p = Pattern.compile("[로]");
				if (road != null && road.indexOf("길") == -1 && road.indexOf("로") > -1) {
					System.out.println("p.matcher(road)=" + p.matcher(road).matches());
					paramMap.put("road", road.substring(0, p.split(road)[0].length() + 1));
					paramMap.put("BUIL_NUM1", road.substring(p.split(road)[0].length() + 1));
				} else {
					paramMap.put("road", road);
				}
			}
			model.addAttribute("count", service.readForObject("common.zipCodeListCnt", paramMap));
			model.addAttribute("postalCodeList", service.readForList("common.zipCodeList", paramMap));
		}

		return "popup/postalcode";
	}
	
	public String under(int j) {
		String under = "";

		for (int i = 0; i < j; i++) {
			under += "_";
		}

		return under;
	}

	// 공연 검색
	@RequestMapping("/rdfMetadata.do")
	public String uciPerform(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) service.readForObject("rdfMetadata.count", paramMap));
		model.addAttribute("list", service.readForList("rdfMetadata.list", paramMap));

		return "/popup/rdfMetadata";
	}
	@RequestMapping("/rdfMetadataNew.do")
	public String uciPerform6(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) service.readForObject("rdfMetadataCommon.rdfNewcount", paramMap));
		model.addAttribute("list", service.readForList("rdfMetadataCommon.rdfNewlist", paramMap));

		return "/popup/rdfMetadataNew";
	}
		@RequestMapping("/rdfMetadataEvent.do")
		public String uciPerform1(HttpServletRequest request, ModelMap model) throws Exception {
			ParamMap paramMap = new ParamMap(request);

			model.addAttribute("paramMap", paramMap);
			model.addAttribute("count", (Integer) service.readForObject("rdfMetadataCommon.rdfEventcount", paramMap));
			model.addAttribute("list", service.readForList("rdfMetadataCommon.rdfEventlist", paramMap));

			return "/popup/rdfMetadataEvent";
		}
		
		@RequestMapping("/rdfMetadataBoth.do")
		public String uciPerform5(HttpServletRequest request, ModelMap model) throws Exception {
			ParamMap paramMap = new ParamMap(request);

			model.addAttribute("paramMap", paramMap);
			model.addAttribute("count", (Integer) service.readForObject("rdfMetadataCommon.rdfBothcount", paramMap));
			model.addAttribute("list", service.readForList("rdfMetadataCommon.rdfBothlist", paramMap));

			return "/popup/rdfMetadataBoth";
		}
		
		
		@RequestMapping("/rdfMetadataFestival.do")
		public String uciPerform2(HttpServletRequest request, ModelMap model) throws Exception {
			ParamMap paramMap = new ParamMap(request);

			model.addAttribute("paramMap", paramMap);
			model.addAttribute("count", (Integer) service.readForObject("rdfMetadataCommon.rdfFestivalcount", paramMap));
			model.addAttribute("list", service.readForList("rdfMetadataCommon.rdfFestivallist", paramMap));

			return "/popup/rdfMetadataFestival";
		}
		
		@RequestMapping("/rdfMetadataPerform.do")
		public String uciPerform3(HttpServletRequest request, ModelMap model) throws Exception {
			ParamMap paramMap = new ParamMap(request);

			model.addAttribute("paramMap", paramMap);
			model.addAttribute("count", (Integer) service.readForObject("rdfMetadataCommon.rdfPerformcount", paramMap));
			model.addAttribute("list", service.readForList("rdfMetadataCommon.rdfPerformlist", paramMap));

			return "/popup/rdfMetadataPerform";
		}
		
		@RequestMapping("/rdfMetadataDisplay.do")
		public String uciPerform4(HttpServletRequest request, ModelMap model) throws Exception {
			ParamMap paramMap = new ParamMap(request);

			model.addAttribute("paramMap", paramMap);
			model.addAttribute("count", (Integer) service.readForObject("rdfMetadataCommon.rdfDisplaycount", paramMap));
			model.addAttribute("list", service.readForList("rdfMetadataCommon.rdfDisplaylist", paramMap));

			return "/popup/rdfMetadataDisplay";
		}
	

	// 우편번호 - 지번
	@RequestMapping("/zipcode.do")
	public String zipcode(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		Pattern p = null;
		String dong = paramMap.getString("dong");

		// 지번검색일 경우 구로3동 이면 구로는 법정동명 3동은 행정동명으로 검색
		if (!"".equals(dong)) {
			p = Pattern.compile("[0-9]");
			dong = dong.substring(0, p.split(dong)[0].length());

			paramMap.put("dong", dong);
		}

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) service.readForObject("zipcode.count", paramMap));
		model.addAttribute("list", service.readForList("zipcode.list", paramMap));

		return "/popup/zipcode";
	}

	// 우편번호 - 도로명
	@RequestMapping("/zipcodeRoad.do")
	public String zipcodeRoad(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		Pattern p = null;
		String roadName = paramMap.getString("road_name");

		// road_name, buil_num1

		// 도로명검색일 경우 월드컵북로400 이면 월드컵북로는 도로명 400은 건물번호 검색
		// 월드컵북로44길 이면 도로명으로만 검색
		if (!"".equals(roadName)) {
			p = Pattern.compile("[로]");

			if (roadName != null && roadName.indexOf("길") == -1 && roadName.indexOf("로") > -1) {
				paramMap.put("road_name", roadName.substring(0, p.split(roadName)[0].length() + 1));
				paramMap.put("buil_num1", roadName.substring(p.split(roadName)[0].length() + 1));
			}
		}

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) service.readForObject("zipcodeRoad.count", paramMap));
		model.addAttribute("list", service.readForList("zipcodeRoad.list", paramMap));

		return "/popup/zipcodeRoad";
	}

	// 아이디 중복
	@RequestMapping("/userId.do")
	public String userId(String user_id, ModelMap model) throws Exception {
		if (StringUtils.isBlank(user_id)) {
			model.addAttribute("user_id", user_id);
			model.addAttribute("user_id_count", 1);
			return "/popup/userId";
		}

		int count = (Integer) service.readForObject("portalMember.countByUserId", user_id);

		model.addAttribute("user_id", user_id);
		model.addAttribute("user_id_count", count);

		return "/popup/userId";
	}

	// relay group
	@RequestMapping("/relayGroup.do")
	public String relayGroup(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) service.readForObject("relay_gourp.listCnt", paramMap));
		model.addAttribute("list", service.readForList("relay_gourp.list", paramMap));

		return "/popup/relayGroup";
	}

	@RequestMapping("/author.do")
	public String author(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		paramMap.put("approval", "Y");

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) service.readForObject("author.listCnt", paramMap));
		model.addAttribute("list", service.readForList("author.list", paramMap));

		return "/popup/author";
	}

	@RequestMapping("/code.do")
	public String code(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		paramMap.put("approval", "Y");

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) service.readForObject("common.codeListCnt", paramMap));
		model.addAttribute("list", service.readForList("common.codeList", paramMap));
		model.addAttribute("codeTypeList", service.readForList("common.codeTypeList", paramMap));
		model.addAttribute("parentCodeList", service.readForList("common.parentCodeList", paramMap));

		return "/popup/code";
	}

	@RequestMapping("/tag.do")
	public String cultureAgreeTag(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		paramMap.put("approval", "Y");
		paramMap.put("common_code_type", "RECOM_CULTURE_TAG");

		model.addAttribute("count", (Integer) service.readForObject("common.codeListCnt", paramMap));
		model.addAttribute("list", service.readForList("common.codeList", paramMap));

		return "/popup/tag";
	}

	@RequestMapping("/cultureagree.do")
	public String cultureagree(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		paramMap.put("searchGubun", "");

		model.addAttribute("paramMap", paramMap);

		model.addAttribute("count", (Integer) service.readForObject("culture.agree.listCnt", paramMap));
		model.addAttribute("list", service.readForList("culture.agree.list", paramMap));

		return "/popup/cultureagree";
	}

	@RequestMapping("/magazineagency.do")
	public String magazineagency(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);

		model.addAttribute("list", service.readForList("agency.image.creatorList", paramMap));

		return "/popup/magazineagency";
	}

	@RequestMapping("/pattern.do")
	public String pattern(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);

		model.addAttribute("list", service.readForList("apply.design.patternList", paramMap));
		model.addAttribute("count", service.readForObject("apply.design.patternListCnt", paramMap));

		return "/popup/pattern";
	}

	@RequestMapping("/patterncode.do")
	public String patterncode(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);

		//		model.addAttribute("list", service.readForList("db.manage.list", paramMap));
		//		model.addAttribute("count", service.readForObject("db.manage.listCnt", paramMap));
		
		model.addAttribute("list", service.readForList("db.manage.listAllPattern", paramMap));
		model.addAttribute("count", service.readForObject("db.manage.listAllPatternCnt", paramMap));

		return "/popup/patterncode";
	}

	@RequestMapping("/education.do")
	public String education(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);

		model.addAttribute("list", service.readForList("education.class.list", paramMap));
		model.addAttribute("count", service.readForObject("education.class.listCnt", paramMap));

		return "/popup/education";
	}

	@RequestMapping("/portalmember.do")
	public String portalmember(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);

		model.addAttribute("list", service.readForList("education.apply.memberList", paramMap));
		model.addAttribute("count", service.readForObject("education.apply.memberListCnt", paramMap));

		return "/popup/portalmember";
	}

	@RequestMapping("/relayticket.do")
	public String relayticket(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);

		model.addAttribute("list", service.readForList("relay_discount.list", paramMap));
		model.addAttribute("count", service.readForObject("relay_discount.listCnt", paramMap));

		return "/popup/relayticket";
	}

	@RequestMapping("/discountticket.do")
	public String discountticket(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);

		model.addAttribute("list", service.readForList("content.popup.ticketList", paramMap));
		model.addAttribute("count", service.readForObject("content.popup.ticketListCnt", paramMap));

		return "/popup/discountticket";
	}

	// 관리자 ADMIN_USER_ID 중복
	@RequestMapping("/adminId.do")
	public String adminId(String user_id, ModelMap model) throws Exception {
		if (StringUtils.isBlank(user_id)) {
			model.addAttribute("user_id", user_id);
			model.addAttribute("admin_id_count", 1);
			return "/popup/adminId";
		}

		int count = (Integer) service.readForObject("adminMember.countByUserId", user_id);

		model.addAttribute("user_id", user_id);
		model.addAttribute("user_id_count", count);

		return "/popup/adminId";
	}

	// 관리자 ADMIN_ROLE_ID 중복
	@RequestMapping("/roleId.do")
	public String roleId(String role_id, ModelMap model) throws Exception {
		if (StringUtils.isBlank(role_id)) {
			model.addAttribute("role_id", role_id);
			model.addAttribute("role_id_count", 1);
			return "/popup/roleId";
		}

		int count = (Integer) service.readForObject("adminRole.countByRoleId", role_id);

		model.addAttribute("role_id", role_id);
		model.addAttribute("role_id_count", count);

		return "/popup/roleId";
	}

	// file upload
	@RequestMapping(value = "/fileupload.do", method = RequestMethod.GET)
	public String fileUpload(String menu_type, String file_type, ModelMap model) throws Exception {

		logger.debug(">>>>> file_type : "+file_type);
		
		if (StringUtils.isBlank(menu_type)) {
			model.addAttribute("valid", "0");
			return "/popup/fileupload";
		}

		model.addAttribute("valid", "1");
		model.addAttribute("menu_type", menu_type);
		model.addAttribute("full_file_path", "");
		model.addAttribute("file_path", "");
		model.addAttribute("file_type", file_type);

		return "/popup/fileupload";
	}

	// file upload regist
	@RequestMapping(value = "/fileupload.do", method = RequestMethod.POST)
	public String fileUploadRegist(String menu_type, ModelMap model, @RequestParam("file") MultipartFile multi) throws Exception {

		try {
			if (StringUtils.isBlank(menu_type) || multi == null || multi.isEmpty()) {
				model.addAttribute("valid", "0");
				return "/popup/fileupload";
			}

			String filePath = MenuUploadFilePath.valueOf(menu_type).getMenuUploadPath();
			String fileName = fileService.writeFile(multi, menu_type);
			
			model.addAttribute("valid", "2");
			model.addAttribute("menu_type", menu_type);
			model.addAttribute("full_file_path", filePath + fileName);
			model.addAttribute("file_path", fileName);
			model.addAttribute("message", "첨부파일이 등록되었습니다.");
			
		} catch (Exception e) {
			e.printStackTrace();
		}

		return "/popup/fileupload";
	}

	@RequestMapping(value = "/message.do")
	public String message(String message, ModelMap model) throws Exception {
		model.addAttribute("message", message);
		return "/popup/message";
	}

	//태그관리 매뉴 추가로 인한 신규 태그 팝업 추가
	@RequestMapping("/newTag.do")
	public String magazineTag(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		paramMap.put("sort_type", "name");
		model.addAttribute("paramMap", paramMap);
		//총갯수
		model.addAttribute("count", service.readForObject("magazine.tags.listCnt", paramMap));
		//태그 리스트
		model.addAttribute("list", service.readForList("magazine.tags.list", paramMap));

		return "/popup/newTag";
	}
	
	//문화체험 팝업
	/*
	 * 탭구분 :
	 * 1 : 공연
	 * 2 : 전시
	 * 3 : 문화릴레이티켓
	 * 4 : 할일티켓
	 * 5 : 행사
	 * 6 : 축제
	 */
	@RequestMapping("/cultureExp.do")
	public String cultureExp(HttpServletRequest request, ModelMap model) throws Exception {
		String rtn = "/popup/cultureExp";
		
		ParamMap paramMap = new ParamMap(request);

		String gbn = CommonUtil.nullStr(request.getParameter("gbn"), "1");  
		String type = CommonUtil.nullStr(request.getParameter("type"), "exp");  
		String type2 = CommonUtil.nullStr(request.getParameter("type2"), "noti");  
		String tab = CommonUtil.nullStr(request.getParameter("tab"), "inline-block;");  
		paramMap.put("gbn", gbn);
		paramMap.put("type", type);
		paramMap.put("tab", tab);

		//문화체험
		if("exp".equals(type)){
			if( "1".equals( gbn ) ){
				//공연
				model.addAttribute("count", (Integer) service.readForObject("rdfMetadataCommon.rdfPerformcount", paramMap));
				model.addAttribute("list", service.readForList("rdfMetadataCommon.rdfPerformlist2", paramMap));
			} else if ( "2".equals( gbn ) ){
				//전시
				model.addAttribute("count", (Integer) service.readForObject("rdfMetadataCommon.rdfDisplaycount", paramMap));
				model.addAttribute("list", service.readForList("rdfMetadataCommon.rdfDisplaylist", paramMap));
			} else if ( "3".equals( gbn ) ){
				//릴레이티켓
				
//				/*초기조회시 오늘 날짜 전후 2개월 조*/
//				System.out.println("::::request.getParameter(search_date):::" + request.getParameter("search_date"));
//				
//				if(request.getParameter("search_date") == null ){
//					Calendar calendar = Calendar.getInstance();
//					SimpleDateFormat formatter = new SimpleDateFormat("YYYYMMdd");
//					paramMap.put("search_date", formatter.format(calendar.getTime()));
//				}
				
				model.addAttribute("list", service.readForList("relay_discount.list", paramMap));
				model.addAttribute("count", service.readForObject("relay_discount.listCnt", paramMap));
			} else if ( "4".equals( gbn ) ){
				//할인티켓
				model.addAttribute("list", service.readForList("content.popup.ticketList", paramMap));
				model.addAttribute("count", service.readForObject("content.popup.ticketListCnt", paramMap));
			} else if ( "5".equals( gbn ) ){
				//행사
				model.addAttribute("count", (Integer) service.readForObject("rdfMetadataCommon.rdfEventcount", paramMap));
				model.addAttribute("list", service.readForList("rdfMetadataCommon.rdfEventlist", paramMap));
			} else if ( "6".equals( gbn ) ){
				//축제
				model.addAttribute("count", (Integer) service.readForObject("rdfMetadataCommon.rdfFestivalcount", paramMap));
				model.addAttribute("list", service.readForList("rdfMetadataCommon.rdfFestivallist", paramMap));
			}

			rtn = "/popup/cultureExp";
		}
		//문화영상
		else if("ucc".equals(type)){
			//setUccParamMap(paramMap);
			setPagingNum(paramMap);
			paramMap.put("culture100", "");
			//!@# 2019.02.06  PDWORKER로 SQL NAMESPACE 변경
			model.addAttribute("list", ckDatabaseService.readForList("pdworker.content.popup.uccList2", paramMap));
			model.addAttribute("count", ckDatabaseService.readForObject("pdworker.content.popup.uccListCnt2", paramMap));
			
			rtn = "/popup/cultureUcc";
		}
		//문화포털콘텐츠
		else if("con".equals(type)){
			String subType = paramMap.getString("subType");
			
			if ("3".equals(subType)) {
				paramMap.put("del_yn", "N");
				paramMap.put("approval_yn", "Y");
				paramMap.put("keyword", paramMap.getString("search_word"));
				paramMap.put("search_word", paramMap.getString("search_word"));
				
				model.addAttribute("count", service.readForObject("culture.issue.listCnt", paramMap));
				model.addAttribute("list", service.readForList("culture.issue.list", paramMap));
			} else if ("4".equals(subType)) {
				paramMap.put("cont_type", "S");
				paramMap.put("approval", "Y");
				paramMap.put("keyword", paramMap.getString("search_word"));
				paramMap.put("search_word", paramMap.getString("search_word"));

				model.addAttribute("count", (Integer) service.readForObject("culture.agree.listCnt", paramMap));
				model.addAttribute("list", service.readForList("culture.agree.list", paramMap));
			} else if("5".equals(subType)){ //문화직업
				paramMap.put("job30", "Y");
				setPagingNum(paramMap);
				//!@# 2019.02.06 PDWORKER로 SQL NAMESPACE 변경
				model.addAttribute("list", ckDatabaseService.readForList("pdworker.content.popup.uccList2", paramMap));
				model.addAttribute("count", ckDatabaseService.readForObject("pdworker.content.popup.uccListCnt2", paramMap));
				
			}
			else if("0".equals(subType)){ //문화TV
				paramMap.put("tvReveiw", "Y");
				setPagingNum(paramMap);
				//!@# 2019.02.06 PDWORKER로 SQL NAMESPACE 변경
				model.addAttribute("list", ckDatabaseService.readForList("pdworker.content.popup.cultureReviewList", paramMap));
				model.addAttribute("count", ckDatabaseService.readForObject("pdworker.content.popup.cultureReviewListCnt", paramMap));
			
			}
			else if("1".equals(subType)){ //문화예보
				paramMap.put("forecast", "Y");
				setPagingNum(paramMap);
				//!@# 2019.02.06 PDWORKER로 SQL NAMESPACE 변경
				model.addAttribute("list", ckDatabaseService.readForList("pdworker.content.popup.forecastList", paramMap));
				model.addAttribute("count", ckDatabaseService.readForObject("pdworker.content.popup.forecastListCnt", paramMap));
			
			}
			else if("2".equals(subType)){ //인문학강연
				paramMap.put("humanlecture", "Y");
				setPagingNum(paramMap);
				//!@# 2019.02.06 PDWORKER로 SQL NAMESPACE 변경
				model.addAttribute("list", ckDatabaseService.readForList("pdworker.content.popup.humanLectureList", paramMap));
				model.addAttribute("count", ckDatabaseService.readForObject("pdworker.content.popup.humanLectureListCnt", paramMap));
			
			} 
			else{
				//setUccParamMap(paramMap);
				setPagingNum(paramMap);
				paramMap.put("culture100", "");
				//!@# 2019.02.06 PDWORKER로 SQL NAMESPACE 변경
				model.addAttribute("list", ckDatabaseService.readForList("pdworker.content.popup.uccList2", paramMap));
				model.addAttribute("count", ckDatabaseService.readForObject("pdworker.content.popup.uccListCnt2", paramMap));
			}
			
			rtn = "/popup/cultureCont";
		}
		//전통문양활용
		else if("pattern".equals(type)){
			if( "1".equals( gbn ) ){
				//제품디자인
				model.addAttribute("list", service.readForList("content.popup.patternDesignList", paramMap));
				model.addAttribute("count", service.readForObject("content.popup.patternDesignListCnt", paramMap));
			} else if ( "2".equals( gbn ) ){
				//활용갤러리
				model.addAttribute("list", service.readForList("content.popup.patternGalleryList", paramMap));
				model.addAttribute("count", service.readForObject("content.popup.patternGalleryListCnt", paramMap));
			}
			rtn = "/popup/culturePattern";
		}
		
		//인문학강연
		else if("humanLecture".equals(type)){
			setPagingNum(paramMap);
			//!@# 2019.02.06 PDWORKER로 SQL NAMESPACE 변경
			model.addAttribute("list", ckDatabaseService.readForList("pdworkercontent.popup.humanLectureList", paramMap));
			model.addAttribute("count", ckDatabaseService.readForObject("pdworkercontent.popup.humanLectureListCnt", paramMap));
			rtn = "/popup/cultureHumanLecture";
		}
		
		//문화예보
		else if("forecast".equals(type)){
			setPagingNum(paramMap);
			//!@# 2019.02.06 PDWORKER로 SQL NAMESPACE 변경
			model.addAttribute("list", ckDatabaseService.readForList("pdworker.content.popup.forecastList", paramMap));
			model.addAttribute("count", ckDatabaseService.readForObject("pdworker.content.popup.forecastListCnt", paramMap));
			rtn = "/popup/cultureForecast";
		}
		
		//한국문화100
		else if("culture100".equals(type)){
			setPagingNum(paramMap);
			//!@# 2019.02.06 PDWORKER로 SQL NAMESPACE 변경
			model.addAttribute("list", ckDatabaseService.readForList("pdworker.content.popup.culture100List", paramMap));
			model.addAttribute("count", ckDatabaseService.readForObject("pdworker.content.popup.culture100ListCnt", paramMap));
			rtn = "/popup/culture100";
		}
		
		//교육활용자료
		else if("ict".equals(type)){
			setPagingNum(paramMap);
			
			paramMap.put("approval", "Y");
			model.addAttribute("count", (Integer) service.readForObject("ict.count", paramMap));
			model.addAttribute("list", service.readForList("ict.list", paramMap));
			rtn = "/popup/cultureIct";
		}
		
		//문화사업
		else if("enterprise".equals(type)){

			paramMap.put("searchAproval", "Y");
			paramMap.put("gubun", "E");
			model.addAttribute("count", (Integer) service.readForObject("culture_welfare.cultureWelfareListCnt", paramMap));
			model.addAttribute("list", service.readForList("culture_welfare.cultureWelfareList", paramMap));
			rtn = "/popup/cultureEnt";
		}
		
		else {
			//문화포털콘텐츠
			if("noti".equals(type2)){
				/*
				 * 0:소식
				 * 1:교육
				 * 2:채용
				 * 3:지원사업
				 */
				
				String subType = paramMap.getString("subType");
				
				if ("0".equals(subType)) {
					model.addAttribute("paramMap", paramMap);
					paramMap.put("type", "46");
					
					//정책뉴스 수집DB로 이전
					model.addAttribute("list", culdataService.readForList("content.popup.newsList", paramMap));
					model.addAttribute("count", culdataService.readForObject("content.popup.newsListCnt", paramMap));
				} else if ("1".equals(subType)) {
					model.addAttribute("paramMap", paramMap);
					paramMap.put("delete_yn", "N");
					paramMap.put("approval", "Y");
	
					model.addAttribute("list", service.readForList("education.class.list", paramMap));
					model.addAttribute("count", service.readForObject("education.class.listCnt", paramMap));
				} else if ("2".equals(subType)){
					model.addAttribute("paramMap", paramMap);
					paramMap.put("type", new String[] { "52" });
					setPagingNum(paramMap);
					
					model.addAttribute("list", service.readForList("content.popup.hiringList", paramMap));
					model.addAttribute("count", service.readForObject("content.popup.hiringListCnt", paramMap));
				} else {
					model.addAttribute("paramMap", paramMap);
					setPagingNum(paramMap);
					
					model.addAttribute("list", service.readForList("content.popup.cultureSupportList", paramMap));
					model.addAttribute("count", service.readForObject("content.popup.cultureSupportListCnt", paramMap));
				}
				
				rtn = "/popup/cultureNoti";
			}
		}
		model.addAttribute("paramMap", paramMap);
			
		return rtn;
	}
	
	private void setUccParamMap(ParamMap paramMap ) throws Exception { 
		String area_group = null;
		String culture100 = null;
		String searchEtc = "";
			
		String subType = paramMap.getString("subType");
		
		//문화영상 세부분류 - 0:국내영상, 1-국외영상, Y-한국대표100, 2-기타영상(문화직업30, 한국문화100, 문화tv)
		if ("0".equals(subType)) {
			area_group = "0";
			culture100 = "N";
		}
		else if ("1".equals(subType)) {
			area_group = "1";
		}
		else if ("Y".equals(subType)) {
			area_group = "0";
			culture100 = "Y";
		}
		else if ("2".equals(subType)) {
			searchEtc = "( JOB30 = 'Y'"
						+ " OR CULTURE100 = 'Y'"
						+ " OR CULTURE_REVIEW = 'Y' )";
		}
		paramMap.put("searchEtc", searchEtc);
		paramMap.put("area_group", area_group);
		paramMap.put("culture100", culture100);
	}
	
	private void setPagingNum(ParamMap paramMap) { 
		int pageNo = paramMap.getInt("page_no");
		int listUnit = paramMap.getInt("list_unit");
		
		paramMap.put("snum", (pageNo - 1) * listUnit + 1);
		paramMap.put("enum", pageNo * listUnit);
	}
	

	//태그관리 매뉴 추가로 인한 신규 태그 팝업 추가
	@RequestMapping("/menuTree.do")
	public String menuTree(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		model.addAttribute("paramMap", paramMap);
		return "/popup/menuTree";
	}

	@RequestMapping("/jusoPopup.do")
	public String jusoPopup(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		model.addAttribute("paramMap", paramMap);
		return "popup/jusoPopup";
	}
	
	
	/**
	 * 앱내부 페이지 리스트 조회
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/pushLinkPage.do")
	public String allList(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) ckDatabaseService.readForObject("culturePush.allListCnt", paramMap));
		model.addAttribute("list", ckDatabaseService.readForList("culturePush.allList", paramMap));
		return "/culturepro/common/popup/pushLinkpage";
	}
	
		
	// file upload
	/**
	 * 시설/단체 > 서점 CvsFile Load Popup
	 * @param menu_type
	 * @param file_type
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/cvsFileLoadPopup.do", method = RequestMethod.GET)
	public String cvsFileLoadPopup(String menu_type, String file_type, ModelMap model) throws Exception {

		logger.debug(">>>>> file_type : "+file_type);
		
		if (StringUtils.isBlank(menu_type)) {
			model.addAttribute("valid", "0");
			return "/facility/bookStore/fileupload";
		}

		model.addAttribute("valid", "1");
		model.addAttribute("menu_type", menu_type);
		model.addAttribute("full_file_path", "");
		model.addAttribute("file_path", "");
		model.addAttribute("file_type", file_type);

		return "/facility/bookStore/fileupload";
	}

	// file upload regist
	@RequestMapping(value = "/cvsFileLoad.do", method = RequestMethod.POST)
	public String cvsFileLoadRegist(String menu_type, String file_type, ModelMap model, @RequestParam("file") MultipartFile multi) throws Exception {

		try {
			if (StringUtils.isBlank(menu_type) || multi == null || multi.isEmpty() || StringUtils.isBlank(file_type)) {
				model.addAttribute("valid", "0");
				return "/popup/fileupload";
			}
						
			if(file_type != null){
				
				if("csv_deleteUpdate".equals(file_type)){
					ckDatabaseService.delete("bookStore.deleteAll", null);
					this.cvsLoad(multi);
				}else if("csv".equals(file_type)){
					this.cvsLoad(multi);
				}else{
					this.excelLoad_HSS(multi);
				}
			}
			
			ParamMap hisParamMap = new ParamMap();
			
			hisParamMap.put("fileName", multi.getOriginalFilename());
			//hisParamMap.put("userId", splitToken[2]);
			
			ckDatabaseService.insert("bookStore.insertCvsHistory", hisParamMap);
						      
			model.addAttribute("valid", "2");
			model.addAttribute("message", "첨부파일이 등록되었습니다.");
					
		} catch (Exception e) {
			e.printStackTrace();
		} 
		
		return "/facility/bookStore/fileupload";
	}
	
	private void cvsLoad( MultipartFile multi) throws Exception {

		try {
			
			File convFile = new File( multi.getOriginalFilename());
			multi.transferTo(convFile);
			
			BufferedReader br = new BufferedReader(new FileReader(multi.getOriginalFilename()));
			
			String line = "";
			  
			ParamMap paramMap = new ParamMap();
				  
			while ((line = br.readLine()) != null) {
				// -1 옵션은 마지막 "," 이후 빈 공백도 읽기 위한 옵션
				String[] splitToken = line.split(",", -1);
				  
				paramMap.put("title", splitToken[1]);
				paramMap.put("address", splitToken[2]);
				paramMap.put("sido", splitToken[3]);
				paramMap.put("gugun", splitToken[4]);
				paramMap.put("dong", splitToken[5]);
				paramMap.put("li", splitToken[6]);
				paramMap.put("gpsy", splitToken[7]);
				paramMap.put("gpsx", splitToken[8]);
				paramMap.put("ownerNm", splitToken[9]);
				paramMap.put("tel", splitToken[10]);
				paramMap.put("businessTime", splitToken[11]);
				paramMap.put("rest", splitToken[12]);
				paramMap.put("homepage", splitToken[13]);
				   
				ckDatabaseService.insert("bookStore.insert", paramMap);
			}
			br.close();
			
		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
	}
	
	private void excelLoad_HSS( MultipartFile multi) throws Exception {
		
		File convFile = new File( multi.getOriginalFilename());
		multi.transferTo(convFile);
		
		FileInputStream fis = null;
		HSSFWorkbook wb = null;
		
		try {
			fis = new FileInputStream(multi.getOriginalFilename());
			wb = new HSSFWorkbook(fis);
			
			int rowindex=0;
			int columnindex=0;
			//시트 수 (첫번째에만 존재하므로 0을 준다)
			//만약 각 시트를 읽기위해서는 FOR문을 한번더 돌려준다
			HSSFSheet sheet = wb.getSheetAt(0);
			//행의 수
			int rows=sheet.getPhysicalNumberOfRows();
			for(rowindex=1;rowindex<rows;rowindex++){
				//행을 읽는다
				HSSFRow row=sheet.getRow(rowindex);
				if(row !=null){
					//셀의 수
					int cells=row.getPhysicalNumberOfCells();
					
					String strVal = "";
					for(columnindex=0;columnindex<=cells-1;columnindex++){
						//셀값을 읽는다
						HSSFCell cell=row.getCell(columnindex);
						String value="";
						
						ParamMap paramMap = new ParamMap();
						
						//셀이 빈값일경우를 위한 널체크
						if(cell==null){
							continue;
						}else{
							//타입별로 내용 읽기
							switch (cell.getCellType()){
							case HSSFCell.CELL_TYPE_FORMULA:
								value=cell.getCellFormula();
								break;
							case HSSFCell.CELL_TYPE_NUMERIC:
								value=cell.getNumericCellValue()+"";
								break;
							case HSSFCell.CELL_TYPE_STRING:
								value=cell.getStringCellValue()+"";
								break;
							case HSSFCell.CELL_TYPE_BLANK:
								//value=cell.getBooleanCellValue()+"";
								value="";
								break;
							case HSSFCell.CELL_TYPE_ERROR:
								value=cell.getErrorCellValue()+"";
								break;
							}
						}
						
						strVal += value + "|";
					}
					
					ParamMap paramMap = new ParamMap();
					  
					if (strVal != null) {
						// -1 옵션은 마지막 "," 이후 빈 공백도 읽기 위한 옵션
						String[] splitToken = strVal.split("\\|", -1);
						  
						/*paramMap.put("title", splitToken[1]);
						paramMap.put("address", splitToken[2]);
						paramMap.put("sido", splitToken[3]);
						paramMap.put("gugun", splitToken[4]);
						paramMap.put("dong", splitToken[5]);
						paramMap.put("li", splitToken[6]);
						paramMap.put("gpsy", splitToken[7]);
						paramMap.put("gpsx", splitToken[8]);
						paramMap.put("ownerNm", splitToken[9]);
						paramMap.put("tel", splitToken[10]);
						paramMap.put("businessTime", splitToken[11]);
						paramMap.put("rest", splitToken[12]);
						paramMap.put("homepage", splitToken[13]);
						//paramMap.put("userId", splitToken[16]);
*/						
						
						paramMap.put("sido", splitToken[1]);	//	시도
						paramMap.put("gugun", splitToken[2]);	//	구군
						paramMap.put("title", splitToken[3]);	//	서점명
						paramMap.put("tel", splitToken[6]);		//	전화번호	
						paramMap.put("address", splitToken[8]);	//	주소
						paramMap.put("bookStoreCert", splitToken[9]);	//	지역서점인증
						paramMap.put("gpsx", splitToken[10]);
						paramMap.put("gpsy", splitToken[11]);
						   
						ckDatabaseService.insert("bookStore.insert", paramMap);
						
					}
				}
			}

		} catch (Exception e) {
			logger.error(e.getMessage());
			throw e;
		}
		
	}
	
	
	
}