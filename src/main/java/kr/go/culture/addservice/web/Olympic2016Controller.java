package kr.go.culture.addservice.web;

import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.ui.ModelMap;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import kr.go.culture.common.domain.CommonModel;
import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.service.KiissDataBaseService;
import kr.go.culture.common.util.DateUtil;
import net.sf.json.JSONObject;

//@Controller
//@RequestMapping(value="/addservice/2016Olympic")
@Deprecated
public class Olympic2016Controller {
	
	//@Resource(name = "KiissDataBaseService")
	private KiissDataBaseService kiissDataBaseService;
	
	//@Autowired
	private CkDatabaseService ckService;
	
	/** 
	 * 2016올림픽영상 > 영상 관리 - 목록
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	//@RequestMapping("/vodList.do")
	public String pollList(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		setPagingNum(paramMap);
		
		//대표영상
		modelMap.addAttribute("representVod", kiissDataBaseService.readForObject("culture.olympic.representVod", paramMap));
		
		//국내외문화영상
		paramMap.put("gubun", "all");
		modelMap.addAttribute("count", kiissDataBaseService.readForObject("culture.olympic.vodListCount", paramMap));
		modelMap.addAttribute("list", kiissDataBaseService.readForList("culture.olympic.vodList", paramMap));
		modelMap.addAttribute("olympicVodCount", kiissDataBaseService.readForObject("culture.olympic.olympicVodCount", paramMap));
		modelMap.addAttribute("paramMap", paramMap);
		
		return "addservice/2016Olympic/vodList";
	}
	
	//@RequestMapping("olympicPopup.do")
	public String olympicPopup(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		setPagingNum(paramMap);
		
		//올림픽영상
		paramMap.put("gubun", "olympic");
		modelMap.addAttribute("count", kiissDataBaseService.readForObject("culture.olympic.vodListCount", paramMap));
		modelMap.addAttribute("list", kiissDataBaseService.readForList("culture.olympic.vodList", paramMap));
		modelMap.addAttribute("paramMap", paramMap);
		
		return "addservice/2016Olympic/olympicPopup";
	}
	
	
	/**
	 * 2016올림픽영상 > 영상 관리 - 대표영상 선택
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	//@RequestMapping("/representVodUpdate.do")
	public String representVodUpdate(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		CommonModel representVod = (CommonModel) kiissDataBaseService.readForObject("culture.olympic.representVod", null);//기존 대표영상
		if(representVod != null){
			ParamMap inputParam = new ParamMap();
			inputParam.put("seq", representVod.get("idx"));
			inputParam.put("represent_yn", "N");
			kiissDataBaseService.save("culture.olympic.representVodUpdate", inputParam);//기존 대표영상 삭제
		}

		kiissDataBaseService.save("culture.olympic.representVodUpdate", paramMap);//새로운 대표영상 등록
		modelMap.addAttribute("paramMap", paramMap);
		
		return "redirect:/addservice/2016Olympic/vodList.do";
	}
	
	/**
	 * 2016올림픽영상 > 영상 관리 - 올림픽영상 선택, 미선택 처리
	 * @param seqs
	 * @param approval
	 * @param model
	 * @return
	 * @throws Exception
	 */
	//@RequestMapping(value = "/approval.do", method = RequestMethod.POST)
	//@ResponseBody
	public JSONObject approval(String[] seqs, String[] data_yn, String approval, ModelMap model) throws Exception {
		JSONObject jo = new JSONObject();

		if (seqs == null || seqs.length == 0) {
			jo.put("success", false);
			return jo;
		}

		if(approval.equals("Y")){//선택
			for(int i=0; i < seqs.length; i++){
				if(data_yn[i].equals("N")){ //기존올림픽영상이 아닐경우 등록
					ParamMap paramMap = new ParamMap();
					paramMap.put("seq", seqs[i]);
					kiissDataBaseService.save("culture.olympic.insertOlympicVod", paramMap);
				}
			}
			
		}else if(approval.equals("N")){//미선택
			for(int i=0; i < seqs.length; i++){
				if(data_yn[i].equals("Y")){ //기존올림픽영상인 경우 삭제
					ParamMap paramMap = new ParamMap();
					paramMap.put("seq", seqs[i]);
					kiissDataBaseService.save("culture.olympic.deleteOlympicVod", paramMap);
				}
			}
		}

		jo.put("success", true);
		return jo;
	}
	
	/**
	 * 2016올림픽영상 > 공유참여자 조회 - 목록
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	//@RequestMapping("/commentEntry.do")
	public String commentEntry(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		modelMap.addAttribute("paramMap", paramMap);
		
		modelMap.addAttribute("count", ckService.readForObject("olympic.commentListCount", paramMap));
		modelMap.addAttribute("list", ckService.readForList("olympic.commentList", paramMap));
		
		return "addservice/2016Olympic/commentList";
	}
	
	/**
	 * 2016올림픽영상 > 공유참여자 조회 - 엑셀다운로드
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	//@RequestMapping("/commentExcelDown.do")
	public String commentExcelDown(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);		
		String[] headerArr = {"순번", "성명", "휴대폰번호", "공유 URL", "응원메시지", "등록일"};
		
		List<LinkedHashMap<String, Object>> list = ckService.readForLinkedList("olympic.commentExcelList", paramMap);
				
		modelMap.addAttribute("fileNm", "commentEvent_"+DateUtil.getDateTime("YMD"));
		modelMap.addAttribute("headerArr", headerArr);
		modelMap.addAttribute("excelList", list);		
		return "excelView";
	}
	
	/**
	 * 2016올림픽영상 > 공유참여자 조회 - 당첨자 팝업
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	//@RequestMapping(value="/commentWinnerPopup.do", method=RequestMethod.GET)
	public String commentWinnerPopup(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		List<Object> winnerList = ckService.readForList("olympic.commentWinnerList", paramMap);
		modelMap.addAttribute("winnerList", winnerList);
		modelMap.addAttribute("paramMap", paramMap);
		
		return "addservice/2016Olympic/commentWinnerPopup";
	}
	
	/**
	 * 2016올림픽영상 > 공유참여자 조회 - 당첨자 팝업 - 엑셀다운로드
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	//@RequestMapping("/commentWinnerExcelDown.do")
	public String commentWinnerExcelDown(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);		
		String[] headerArr = {"순번", "성명", "휴대폰번호", "공유 URL", "응원메시지", "등록일"};
		
		List<LinkedHashMap<String, Object>> list = ckService.readForLinkedList("olympic.commentWinnerExcelList", paramMap);
				
		modelMap.addAttribute("fileNm", "commentWinnerEvent_"+DateUtil.getDateTime("YMD"));
		modelMap.addAttribute("headerArr", headerArr);
		modelMap.addAttribute("excelList", list);		
		return "excelView";
	}
	
	/**
	 * 2016올림픽영상 > 공유참여자 조회 - 당첨자 추첨
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	//@RequestMapping(value="/commentWinnerPopup.do", method=RequestMethod.POST)
	public String commentWinnerPopupPost(HttpServletRequest request, RedirectAttributes redirectAttributes) throws Exception {
		ParamMap paramMap = new ParamMap(request);	
		
		int max =  Integer.parseInt((String)paramMap.get("lottery_number"));				
		for(int i=0; i<max ; i++){//당첨자 max명(추첨건수)까지
			List<Object> list = ckService.readForList("olympic.commentWinnerPotentialList", paramMap); // 당청 가능한 사람 목록
			if (!list.isEmpty()) {				
				Collections.shuffle(list);
				int lotNum = (int) (Math.random() * list.size());
				Map<String, Object> winner = (Map<String, Object>) list.get(lotNum);

				ckService.insert("olympic.commentWinnerInsert", winner); //당첨자 당첨테이블에 insert
			}else{
				redirectAttributes.addFlashAttribute("msg", "당첨가능한 사람이 없습니다.");
			}
		}		
		return "redirect:/addservice/2016Olympic/commentWinnerPopup.do";
	}
	
	/**
	 * 2016올림픽영상 > 공유참여자 조회 - 당첨자 삭제
	 * @param request
	 * @return
	 * @throws Exception
	 */
	//@RequestMapping(value="/commentWinnerDelete.do", method=RequestMethod.POST)
	public String commentWinnerDelete(HttpServletRequest request) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		ckService.delete("olympic.commentWinnerDelete", paramMap);
		return "redirect:/addservice/2016Olympic/commentWinnerPopup.do";
	}
		
	
	private void setPagingNum(ParamMap paramMap) { 
		int pageNo = paramMap.getInt("page_no");
		int listUnit = paramMap.getInt("list_unit");
		
		paramMap.put("snum", (pageNo - 1) * listUnit + 1);
		paramMap.put("enum", pageNo * listUnit);
	}

}
