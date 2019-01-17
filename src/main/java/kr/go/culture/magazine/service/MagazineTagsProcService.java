package kr.go.culture.magazine.service;

import javax.annotation.Resource;

import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service("MagazineTagsProcService")
public class MagazineTagsProcService {

	@Resource(name = "CkDatabaseService")
	CkDatabaseService ckDatabaseService;

	@Transactional(value = "ckTransactionManager", rollbackFor = Exception.class)
	public void merge(ParamMap paramMap) throws Exception {
		ckDatabaseService.save("magazine.tags.merge", paramMap);
	}
	
	@Transactional(value = "ckTransactionManager", rollbackFor = Exception.class)
	public int chkName(ParamMap paramMap) throws Exception {
		return (Integer) ckDatabaseService.readForObject("magazine.tags.chkName", paramMap);
	}
	
	@Transactional(value = "ckTransactionManager", rollbackFor = Exception.class)
	public String using(ParamMap paramMap) throws Exception {
		return (String) ckDatabaseService.readForObject("magazine.tags.using", paramMap);
	}
	
	@Transactional(value = "ckTransactionManager", rollbackFor = Exception.class)
	public void delete(ParamMap paramMap) throws Exception {
		//맵핑테이블 데이터 삭제
		ckDatabaseService.delete("magazine.tags.deleteMapping", paramMap);
		//태그 데이터 삭제컬럼 변경
		ckDatabaseService.save("magazine.tags.updateDeleteColumn", paramMap);
	}
	
	@Transactional(value = "ckTransactionManager", rollbackFor = Exception.class)
	public void updatePopular(ParamMap paramMap) throws Exception {
		String seqs[] = paramMap.getArray("seqs");
		
		for( int i=0; i < seqs.length; i++ ){
			paramMap.put("seq", seqs[i]);
			ckDatabaseService.save("magazine.tags.updatePopular", paramMap);
		}
	}
	

	@Transactional(value = "ckTransactionManager", rollbackFor = Exception.class)
	public void insertTagMap(ParamMap paramMap) throws Exception {
		//태그가 등록되었을때 태그테이블에 입력되도록 수정
		//입력 전 기존 데이터를 지워준다. 단, 입력인 경우는 삭제할게 없다..
		if( !"".equals(paramMap.get("tagSeqs")) && paramMap.get("tagSeqs") != null ){
			ckDatabaseService.delete("magazine.tags.deleteMapping", paramMap);
		}
		
		//신규 등록된 태그가 존재하면 태그를 저장한다.
		if( paramMap.get("tagSeqs") != null && !"".equals(paramMap.get("tagSeqs")) ){
			
			//신규작성된 태그를 입력한다.
			String tagSeqs = (String) paramMap.get("tagSeqs");
			String arrTagSeqs[] = tagSeqs.split(",");
			paramMap.put("tagSeq", arrTagSeqs);
			ckDatabaseService.insert("magazine.tags.insertTagMap", paramMap);
		}
	}
	
	@Transactional(value = "ckTransactionManager", rollbackFor = Exception.class)
	public String selectTagMap(ParamMap paramMap) throws Exception {
		return (String) ckDatabaseService.readForObject("magazine.tags.selectTagMap", paramMap);
	}
	
	@Transactional(value = "ckTransactionManager", rollbackFor = Exception.class)
	public void deleteTagMap(ParamMap paramMap) throws Exception {
		ckDatabaseService.delete("magazine.tags.deleteMapping", paramMap);
	}
}
