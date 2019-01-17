package kr.go.culture.addservice.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import kr.go.culture.common.domain.CommonModel;
import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;

import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Service;

@Service("ContestService")
public class ContestService {

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService service;

	@SuppressWarnings("unchecked")
	public Map<String, HashMap<String, Object>> getAgentMap() throws Exception {

		Map<String, HashMap<String, Object>> agentMap = new HashMap<String, HashMap<String, Object>>();
		HashMap<String, Object> tmp = null;

		List<Object> agentList = service.readForList("contest.listByAgent", null);

		for (Object item : agentList) {
			tmp = (HashMap<String, Object>) item;
			agentMap.put((String) tmp.get("seq"), tmp);
		}

		return agentMap;
	}

	@SuppressWarnings("unchecked")
	public List<Object> getExcelList(ParamMap paramMap) throws Exception {
		HashMap<String, Object> tmp = null;

		List<Object> list = service.readForList("contest.listByExcel", paramMap);
		Map<String, HashMap<String, Object>> agentMap = getAgentMap();

		String serviceseq = null;

		for (Object item : list) {
			tmp = (HashMap<String, Object>) item;
			serviceseq = (String) tmp.get("serviceseq");
			tmp.put("agents", getAgentName(agentMap, serviceseq));
		}

		return list;
	}

	public CommonModel getView(ParamMap paramMap) throws Exception {
		CommonModel result = (CommonModel) service.readForObject("contest.view", paramMap);
		Map<String, HashMap<String, Object>> agentMap = getAgentMap();

		result.put("agents", getAgentName(agentMap, (String) result.get("serviceseq")));

		return result;
	}

	private String getAgentName(Map<String, HashMap<String, Object>> agentMap, String serviceseq) {
		if (StringUtils.isBlank(serviceseq)) {
			return null;
		}

		serviceseq = serviceseq.replace("(", "");
		serviceseq = serviceseq.replace(")", "");

		String agents = null;
		String[] seqs = serviceseq.split(",");

		if (seqs != null && seqs.length > 0) {
			for (String s : seqs) {
				if (agentMap.containsKey(s)) {
					if (agents == null) {
						agents = "분야 : " + agentMap.get(s).get("category")
								+ ", 기관 : " + agentMap.get(s).get("agent")
								+ ", 서비스 : " + agentMap.get(s).get("service");
					} else {
						agents += "<br />분야 : " + agentMap.get(s).get("category")
								+ ", 기관 : " + agentMap.get(s).get("agent")
								+ ", 서비스 : " + agentMap.get(s).get("service");
					}
				}
			}
		}

		return agents;
	}

}