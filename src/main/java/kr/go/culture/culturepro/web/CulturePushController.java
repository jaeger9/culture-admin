package kr.go.culture.culturepro.web;

import java.text.SimpleDateFormat;
import java.util.Date;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.CommonModel;
import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.service.FileService;
import kr.go.culture.common.util.AlertException;
import kr.go.culture.common.util.CommonUtil;
import kr.go.culture.common.util.SessionMessage;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;


@RequestMapping("/culturepro/culturePush")
@Controller("CulturePushController")
public class CulturePushController {

	private static final Logger logger = LoggerFactory.getLogger(CulturePushController.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;
	
	@Resource(name = "FileService")
	private FileService fileService;

	/**
	 * Push관리 리스트
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("list.do")
	public String list(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) ckDatabaseService.readForObject("culturePush.listCnt", paramMap));
		model.addAttribute("list", ckDatabaseService.readForList("culturePush.list", paramMap));
		return "/culturepro/culturePush/list";
	}
	
	
	/**
	 * 앱내부 페이지 리스트 조회
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("allList.do")
	public String allList(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", (Integer) ckDatabaseService.readForObject("culturePush.allListCnt", paramMap));
		model.addAttribute("list", ckDatabaseService.readForList("culturePush.allList", paramMap));
		return "/culturepro/common/popup/pushLinkpage";
	}

	
	/**
	 * Push관리  컨텐츠 상세
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("view.do")
	public String view(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		modelMap.addAttribute("paramMap", paramMap);
		
		if (paramMap.containsKey("seq")) {
			CommonModel cModel = (CommonModel) ckDatabaseService.readForObject("culturePush.view", paramMap);
			if(logger.isDebugEnabled()) logger.debug(cModel.toString());
			String linkType = (String) cModel.get("link_type");
			if("I".equals(linkType)){
				String inLink = (String) cModel.get("in_link");
				String prefix = inLink.split("-")[0];
				String seq = inLink.split("-")[1];
				
				CommonModel relationModel = null;
				ParamMap param = new ParamMap();
				param.put("seq", seq);
				// 타이틀 가져와야뎀.
				if("noti".equals(prefix)){
					// 공지 사항
					relationModel = (CommonModel) ckDatabaseService.readForObject("cultureNotice.view", param);
					
				}
				else if("cal".equals(prefix)){
					// 칼랜더
					relationModel = (CommonModel) ckDatabaseService.readForObject("culture_cal.view", param);
				}
				else if("news".equals(prefix)){
					// 문화소식
					relationModel = (CommonModel) ckDatabaseService.readForObject("cardnews.view", param);
				}
				else if("video".equals(prefix)){
					// 문화 영상
					relationModel = (CommonModel) ckDatabaseService.readForObject("cultureVideo.view", param);
				}
				String title = "";
				if(relationModel != null) title = (String) relationModel.get("title");
				cModel.put("rTitle", title);	 

			}
			modelMap.addAttribute("view", cModel);
			
		}
		
		return "/culturepro/culturePush/view";
	}
	
	/**
	 * Push관리  컨텐츠 등록
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("insert.do")
	public String insert(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		paramMap.put("del_yn", CommonUtil.nullStr(request.getParameter("del_yn"), "N"));
		paramMap.put("reg_id", request.getSession().getAttribute("admin_id"));
		
		String send_type = request.getParameter("send_type");
		if(StringUtils.equals("D", send_type)){
			//바로 발송인 경우 send_yn = 'Y'처리함.
			paramMap.put("send_yn", "Y");
			SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
			paramMap.put("send_date", sf.format(new Date()));
			sf.applyPattern("HH");
			paramMap.put("send_hour", sf.format(new Date()));
			sf.applyPattern("mm");
			paramMap.put("send_minute", sf.format(new Date()));
		}else{
			paramMap.put("send_yn", "N");
		}
		
		ckDatabaseService.insert("culturePush.insert", paramMap);		
		
		SessionMessage.insert(request);
		
		return "redirect:/culturepro/culturePush/list.do";
	}
	
	
	/**
	 * Push관리 컨텐츠 수정
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("update.do")
	public String update(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		paramMap.put("upd_id", request.getSession().getAttribute("admin_id"));
		
		
		String send_type = request.getParameter("send_type");
		if(StringUtils.isNotEmpty(send_type)){
			if( StringUtils.equals("D", send_type)){
				//바로 발송인 경우 send_yn = 'Y'처리함.
				paramMap.put("send_yn", "Y");
				SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
				paramMap.put("send_date", sf.format(new Date()));
				sf.applyPattern("HH");
				paramMap.put("send_hour", sf.format(new Date()));
				sf.applyPattern("mm");
				paramMap.put("send_minute", sf.format(new Date()));
			}else{
				paramMap.put("send_yn", "N");
			}
		}
		
		ckDatabaseService.insert("culturePush.update", paramMap);
		modelMap.addAttribute("paramMap", paramMap);
		SessionMessage.update(request);
		
		return "redirect:/culturepro/culturePush/view.do?seq=" + request.getParameter("seq");
	}
	

	/**
	 * Push관리 컨텐츠 삭제
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("delete.do")
	public String delete(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		paramMap.put("upd_id", request.getSession().getAttribute("admin_id"));
		ckDatabaseService.delete("culturePush.delete", paramMap);

		SessionMessage.delete(request);

		return "redirect:/culturepro/culturePush/list.do";
	}
	
	
	/**
	 * Push관리 목록 > 바로발송 
	 * @param request
	 * @param modelMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("send.do")
	public String send(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		paramMap.put("upd_id", request.getSession().getAttribute("admin_id"));
		
		//바로 발송 처리 (현재시간으로 처리 ) 
		CommonModel pushMap = (CommonModel) ckDatabaseService.readForObject("culturePush.view", paramMap);
		if(StringUtils.equals((String)pushMap.get("send_yn"), "Y")){
			//이미 발송완료된 경우.
			throw new AlertException("이미 발송완료된 건입니다.");
		}
		
		paramMap.put("send_type", "D");
		SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
		paramMap.put("send_date", sf.format(new Date()));
		sf.applyPattern("HH");
		paramMap.put("send_hour", sf.format(new Date()));
		sf.applyPattern("mm");
		paramMap.put("send_minute", sf.format(new Date()));
		paramMap.put("send_yn", "Y");
		
		ckDatabaseService.insert("culturePush.updateSend", paramMap);		
		
		SessionMessage.update(request);
		
		//이전 경로에 따른 분기 처리( 상세페이지 / 리스트 페이지 ) 
		String from = request.getParameter("fromUrl");
		if(StringUtils.equals(from, "view")){
			return "redirect:/culturepro/culturePush/view.do?seq=" + request.getParameter("seq");
		}
		
		return "redirect:/culturepro/culturePush/list.do";
	}
	

}
