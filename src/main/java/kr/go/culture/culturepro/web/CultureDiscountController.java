package kr.go.culture.culturepro.web;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.service.FileService;
import kr.go.culture.common.util.CommonUtil;
import kr.go.culture.common.util.SessionMessage;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;


@RequestMapping("/culturepro/cultureDiscount")
@Controller("CultureDiscountController")
public class CultureDiscountController extends CultureCommonController{
	
	@RequestMapping("list.do")
	public String allList(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		String field = (String) paramMap.get("field");
		// default
		if(StringUtils.isEmpty(field)){
			field = "D";
		}
		
		List<HashMap<String, Object>> list = null;
		int listCnt = 0;
		if("D".equals(field)){
			//할인이벤트
			list = ckDatabaseService.readForListMap("culture_discount.dlist", paramMap);
			listCnt = (Integer)ckDatabaseService.readForObject("culture_discount.dlistCnt", paramMap);
		}
		else if("R".equals(field)){
			//문화릴레이
			list = ckDatabaseService.readForListMap("culture_discount.rlist", paramMap);
			listCnt = (Integer)ckDatabaseService.readForObject("culture_discount.rlistCnt", paramMap);
		}
		else if("N".equals(field)){
			//문화소식
			list = ckDatabaseService.readForListMap("culture_discount.nlist", paramMap);
			listCnt = (Integer)ckDatabaseService.readForObject("culture_discount.nlistCnt", paramMap);
		}
		else if("F".equals(field)){
			//참여시설
			list = ckDatabaseService.readForListMap("culture_discount.flist", paramMap);
			listCnt = (Integer)ckDatabaseService.readForObject("culture_discount.flistCnt", paramMap);
		}
		else if("C".equals(field)){
			//공연/전시
			list = ckDatabaseService.readForListMap("culture_discount.dlist", paramMap);
			listCnt = (Integer)ckDatabaseService.readForObject("culture_discount.dlistCnt", paramMap);
		}
		
		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", listCnt);
		model.addAttribute("list", list);
		
		return "/culturepro/cultureDiscount/list";
	}

	
	
	@RequestMapping("save.do")
	public String save(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		String field = (String) paramMap.get("field");
		// default
		if(StringUtils.isEmpty(field)){
			field = "D";
		}
				
		// 파라미터 확인
		System.out.println(paramMap.getArray("discount_percent"));
		System.out.println(paramMap.getArray("seq"));
		String[] discountArr = paramMap.getArray("discount_percent");
		String[] seqArr = paramMap.getArray("seq");
		
		if("D".equals(field)){
			//할인이벤트
			ParamMap param = new ParamMap();
			for (int i = 0; i < discountArr.length; i++) {
				String discount = discountArr[i];
				if(StringUtils.isEmpty(discount)) continue;
				String seq = seqArr[i];
				param.put("seq", seq);
				param.put("viewDiscount", discount);
				ckDatabaseService.insert("culture_discount.updateDViewDiscount", param);
			}
		}
		else if("R".equals(field)){
			//문화릴레이
			ParamMap param = new ParamMap();
			for (int i = 0; i < discountArr.length; i++) {
				String discount = discountArr[i];
				if(StringUtils.isEmpty(discount)) continue;
				String seq = seqArr[i];
				param.put("seq", seq);
				param.put("viewDiscount", discount);
				ckDatabaseService.insert("culture_discount.updateRViewDiscount", param);
			}
		}
		else if("N".equals(field)){
			//문화소식
			ParamMap param = new ParamMap();
				for (int i = 0; i < discountArr.length; i++) {
					String discount = discountArr[i];
					if(StringUtils.isEmpty(discount)) continue;
					String seq = seqArr[i];
					param.put("seq", seq);
					param.put("viewDiscount", discount);
					ckDatabaseService.insert("culture_discount.updateNViewDiscount", param);
				}
			
		}
		else if("F".equals(field)){
			//참여시설
			ParamMap param = new ParamMap();
			for (int i = 0; i < discountArr.length; i++) {
				String discount = discountArr[i];
				if(StringUtils.isEmpty(discount)) continue;
				String seq = seqArr[i];
				param.put("seq", seq);
				param.put("viewDiscount", discount);
				ckDatabaseService.insert("culture_discount.updateRViewDiscount", param);
			}
		}
		else if("C".equals(field)){
			//공연/전시
		}
		
		modelMap.addAttribute("paramMap", paramMap);
		SessionMessage.update(request);
		
		return "redirect:/culturepro/cultureDiscount/list.do";
	}
	
	
}
