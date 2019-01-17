package kr.go.culture.culturepro.web;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.collections.CollectionUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.util.SessionMessage;


@RequestMapping("/culturepro/cultureSale")
@Controller("CultureSaleController")
public class CultureSaleController extends CultureCommonController{
	
	@RequestMapping("list.do")
	public String allList(HttpServletRequest request, ModelMap model) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		paramMap.put("view_discount", 50);
		paramMap.put("list_unit", 10000);
		List<HashMap<String, Object>> list = new ArrayList<HashMap<String,Object>>();
		List<HashMap<String, Object>> dlist = ckDatabaseService.readForListMap("culture_discount.dlist", paramMap);
		List<HashMap<String, Object>> rlist = ckDatabaseService.readForListMap("culture_discount.rlist", paramMap);
		List<HashMap<String, Object>> nlist = ckDatabaseService.readForListMap("culture_discount.nlist", paramMap);
		List<HashMap<String, Object>> flist = ckDatabaseService.readForListMap("culture_discount.flist", paramMap);
		if(CollectionUtils.isNotEmpty(dlist)) list.addAll(dlist);
		if(CollectionUtils.isNotEmpty(rlist)) list.addAll(rlist);
		if(CollectionUtils.isNotEmpty(nlist)) list.addAll(nlist);
		if(CollectionUtils.isNotEmpty(flist)) list.addAll(flist);
		
		
		model.addAttribute("paramMap", paramMap);
		model.addAttribute("count", list.size());
		model.addAttribute("list", list);
		
		return "/culturepro/cultureSale/list";
	}

	@RequestMapping("view.do")
	public String view(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		modelMap.addAttribute("paramMap", paramMap);
		if (paramMap.containsKey("seq")) {
//			ckDatabaseService.insert("culture_sale.viewCnt", paramMap);
			modelMap.addAttribute("view", ckDatabaseService.readForObject("culture_sale.view", paramMap));
		}
		
		return "/culturepro/cultureSale/view";
	}
	
	@RequestMapping("insert.do")
	public String insert(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		paramMap.put("reg_id", request.getSession().getAttribute("admin_id"));
		ckDatabaseService.insert("culture_sale.insert", paramMap);		
		
		SessionMessage.insert(request);
		
		return "redirect:/culturepro/cultureSale/list.do";
	}
	
	@RequestMapping("update.do")
	public String update(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		paramMap.put("upd_id", request.getSession().getAttribute("admin_id"));
		
		ckDatabaseService.insert("culture_sale.update", paramMap);
		modelMap.addAttribute("paramMap", paramMap);
		SessionMessage.update(request);
		
		return "redirect:/culturepro/cultureSale/view.do?seq=" + request.getParameter("seq") +"&type=" + request.getParameter("type");
	}
	
	
	@RequestMapping("delete.do")
	public String delete(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);

		paramMap.put("reg_id", request.getSession().getAttribute("admin_id"));
		ckDatabaseService.insert("culture_sale.insert", paramMap);		
		
		SessionMessage.insert(request);
		
		return "redirect:/culturepro/cultureSale/list.do";
	}
	
	@RequestMapping("statusUpdate.do")
	public String statusUpdate(HttpServletRequest request, ModelMap modelMap) throws Exception {
		ParamMap paramMap = new ParamMap(request);
		
		paramMap.put("upd_id", request.getSession().getAttribute("admin_id"));
		
		String[] seqArr = paramMap.getArray("seq");
		String type = "";
		String seq = "";
		if(seqArr.length > 0){
			for(int i=0; i<seqArr.length; i++){
				type = seqArr[i].split("-")[0];
				seq = seqArr[i].split("-")[1];
				paramMap.put("seq", seq);
				if("D".equals(type)){
					ckDatabaseService.insert("culture_discount.DstatusUpdate", paramMap);
				}
				else if("R".equals(type)){
					ckDatabaseService.insert("culture_discount.RstatusUpdate", paramMap);
				}
				else if("N".equals(type)){
					ckDatabaseService.insert("culture_discount.NstatusUpdate", paramMap);
				}
				else if("F".equals(type)){
					ckDatabaseService.insert("culture_discount.FstatusUpdate", paramMap);
				}
			}
		}
		
//		ckDatabaseService.insert("culture_sale.statusUpdate", paramMap);
		modelMap.addAttribute("paramMap", paramMap);
		SessionMessage.update(request);
		
		return "forward:/culturepro/cultureSale/list.do";
	}
}
