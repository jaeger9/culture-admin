package kr.go.culture.customer.service;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.go.culture.common.domain.CommonModel;
import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.util.SessionMessage;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service("SiteService")
public class SiteService {

	private static final Logger logger = LoggerFactory.getLogger(SiteService.class);

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService service;

	@Transactional(value = "ckTransactionManager", rollbackFor = { Exception.class })
	public int regist(HttpServletRequest request, ParamMap paramMap) throws Exception {

		CommonModel resultMap = null;

		if (paramMap.isNotBlank("seq")) {
			resultMap = (CommonModel) service.readForObject("sitemain.view", paramMap);

			if (resultMap == null) {
				SessionMessage.empty(request);
				return -1; // 실패
			}

			// update
			service.save("sitemain.update", paramMap);
			SessionMessage.update(request);

		} else {
			// insert
			service.insert("sitemain.insert", paramMap);
			SessionMessage.insert(request);
		}

		// site 관리
		return registSite(paramMap);
	}

	@Transactional(value = "ckTransactionManager", rollbackFor = { Exception.class })
	private int registSite(ParamMap paramMap) throws Exception {

		int pseq = paramMap.getInt("seq");

		if (pseq < 1) {
			return -1; // 실패
		}

		ParamMap tmpMap = null;

		// 삭제
		String[] deleteIds = null;
		if (paramMap.isNotBlank("sub_delete_seqs")) {
			deleteIds = paramMap.getString("sub_delete_seqs").split(",");
		}
		if (deleteIds != null && deleteIds.length > 0) {
			tmpMap = new ParamMap();
			tmpMap.putArray("sub_seqs", deleteIds);
			service.delete("sitesub.delete", tmpMap);
		}

		// 등록,수정
		String[] sub_seq = null;
		String[] sub_site_name = null;
		String[] sub_site_url = null;

		if (pseq > 0 && paramMap.isNotBlank("sub_site_name")) {
			sub_seq = paramMap.getArray("sub_seq");
			sub_site_name = paramMap.getArray("sub_site_name");
			sub_site_url = paramMap.getArray("sub_site_url");

			if (sub_site_name != null && sub_site_name.length > 0) {
				for (int i = 0; i < sub_seq.length; i++) {
					tmpMap = new ParamMap();
					tmpMap.put("sub_pseq", pseq);

					tmpMap.put("sub_seq", sub_seq[i]);
					tmpMap.put("sub_site_name", sub_site_name[i]);
					tmpMap.put("sub_site_url", sub_site_url[i]);

					if (tmpMap.isNotBlank("sub_seq") && service.readForObject("sitesub.exist", tmpMap) != null) {
						service.insert("sitesub.update", tmpMap);
					} else {
						service.insert("sitesub.insert", tmpMap);
					}
				}
			}
		}

		return pseq;
	}

	@Transactional(value = "ckTransactionManager", rollbackFor = { Exception.class })
	public void delete(String[] seqs) throws Exception {

		ParamMap paramMap = new ParamMap();
		paramMap.putArray("sub_pseqs", seqs);
		service.delete("sitesub.deletePseq", paramMap);

		paramMap = new ParamMap();
		paramMap.putArray("seqs", seqs);
		service.delete("sitemain.delete", paramMap);

	}

}