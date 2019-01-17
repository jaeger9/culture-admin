package kr.go.culture.magazine.web;

import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.util.CommonUtil;
import kr.go.culture.magazine.service.MagazineTagsProcService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/magazine/magazineTags")
public class MagazineTagsController {

	@Autowired
	private CkDatabaseService ckService;
	
	@Autowired
	private MagazineTagsProcService mtmService;
	
	/**
	 * 태그 목록
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("list.do")
	public String list(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		String sortType = CommonUtil.nullStr(request.getParameter("sort_type"), "name");
		String type = CommonUtil.nullStr(request.getParameter("type"), "1");
		
		paramMap.put("sort_type", sortType);
		paramMap.put("list_unit", 30);
		paramMap.put("type", type);
		
		modelMap.addAttribute("paramMap", paramMap);
		
		setPagingNum(paramMap);
		
		//총갯수
		modelMap.addAttribute("count", ckService.readForObject("magazine.tags.listCnt", paramMap));
		//태그 리스트
		modelMap.addAttribute("list", ckService.readForList("magazine.tags.list", paramMap));
		//인기태그 리스트
		modelMap.addAttribute("popularList", ckService.readForList("magazine.tags.popularList", paramMap));
		
		
		return "/magazine/magazineTags/list";
	}

	/**
	 * 페이징정보 생성
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	private void setPagingNum(ParamMap paramMap) { 
		int pageNo = paramMap.getInt("page_no");
		int listUnit = paramMap.getInt("list_unit");
		
		paramMap.put("snum", (pageNo - 1) * listUnit + 1);
		paramMap.put("enum", pageNo * listUnit);
	}

	/**
	 * 태그명 등록/수정
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("merge.do")
	public @ResponseBody HashMap<String , String> updateTagName(HttpServletRequest request) throws Exception  {
		
		ParamMap paramMap = new ParamMap(request);
		HashMap<String , String> rData = new HashMap<String , String>();
		int chkNameCnt = 0;
		
		//해당 태그가 이미 사용중인지 여부 체크
		chkNameCnt = mtmService.chkName(paramMap);
		if(chkNameCnt > 0){
			rData.put("success", "V");
		}else{
			mtmService.merge(paramMap);
			rData.put("success", "Y");
		}
		
		return rData;
	}
	
	/**
	 * 사용중인 태그인지 여부 체크
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("using.do")
	public @ResponseBody HashMap<String , String> using(HttpServletRequest request) throws Exception  {
		
		ParamMap paramMap = new ParamMap(request);
		HashMap<String , String> rData = new HashMap<String , String>();
		String rtnVal = "";
		
		String seqs[] = request.getParameterValues("seqs");
		paramMap.put("seqs", seqs);
		rtnVal = CommonUtil.nullStr(mtmService.using(paramMap),"");
		
		if( !"".equals(rtnVal) ){
			rData.put("use_yn", "Y");
			rData.put("targetTags", rtnVal);
		}
		
		return rData;
	}
	
	/**
	 * 선택한 태그 삭제
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("delete.do")
	public @ResponseBody HashMap<String , String> delete(HttpServletRequest request) throws Exception  {
		
		ParamMap paramMap = new ParamMap(request);
		HashMap<String , String> rData = new HashMap<String , String>();
		
		String seqs[] = request.getParameterValues("seqs");
		
		paramMap.put("seqs", seqs);
		mtmService.delete(paramMap);
		
		rData.put("success", "Y");
		
		return rData;
	}
	
	/**
	 * 선택된 태그를 인기태그로 등록
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("updatePopular.do")
	public @ResponseBody HashMap<String , String> updatePopular(HttpServletRequest request) throws Exception  {
		
		ParamMap paramMap = new ParamMap(request);
		HashMap<String , String> rData = new HashMap<String , String>();
		
		String seqs[] = request.getParameterValues("seqs");
		
		paramMap.putArray("seqs", seqs);
		mtmService.updatePopular(paramMap);
		
		rData.put("success", "Y");
		
		return rData;
	}
}
