package kr.go.culture.addservice.service;

import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import kr.go.culture.common.domain.CommonModel;
import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.service.FileService;

@Service("PollEventService")
public class PollEventService {
	
	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckService;
	
	@Resource(name = "FileService")
	private FileService fileService;
	
	@SuppressWarnings("unchecked")
	public CommonModel getPoll(ParamMap paramMap) throws Exception{

		CommonModel poll = (CommonModel) ckService.readForObject("pollEvent.getPoll", paramMap);
		if(poll != null){
			
			List<Object> workList = ckService.readForList("pollEvent.getPollWork", paramMap);
			HashMap<String, Object> tmp = null;
			
			for (int i = 1; 4 >= i ; i++) {
				Object item = workList.get(i-1);
				tmp = (HashMap<String, Object>) item;
			
				poll.put("work"+i+"_seq", tmp.get("work_seq"));
				poll.put("work"+i+"_file_name", tmp.get("file_name"));
				poll.put("work"+i+"_url", tmp.get("url"));
				poll.put("work"+i+"_title", tmp.get("title"));
				poll.put("work"+i+"_gift", tmp.get("gift"));
				poll.put("work"+i+"_keyword1", tmp.get("keyword1"));
				poll.put("work"+i+"_keyword1_url", tmp.get("keyword1_url"));
				poll.put("work"+i+"_keyword2", tmp.get("keyword2"));
				poll.put("work"+i+"_keyword2_url", tmp.get("keyword2_url"));
				poll.put("work"+i+"_keyword3", tmp.get("keyword3"));
				poll.put("work"+i+"_keyword3_url", tmp.get("keyword3_url"));
			}
		}
		
		return poll;
	}
	
	public void insertPollEvent(ParamMap paramMap) throws Exception {
		
		ParamMap pollParam = new ParamMap();
		ParamMap workParam = new ParamMap();
		
		//-------------- 작품1-1 insert start ----------------//
		workParam.clear();
		workParam.put("file_name", paramMap.get("work1_file_name"));
		workParam.put("url", paramMap.get("work1_url"));
		workParam.put("title", paramMap.get("work1_title"));
		workParam.put("gift", paramMap.get("work1_gift"));
		
		if(paramMap.get("work1_keyword1") != null){
			workParam.put("keyword1", paramMap.get("work1_keyword1"));
			workParam.put("keyword1_url", paramMap.get("work1_keyword1_url"));
		}
		if(paramMap.get("work1_keyword2") != null){
			workParam.put("keyword2", paramMap.get("work1_keyword2"));
			workParam.put("keyword2_url", paramMap.get("work1_keyword2_url"));
		}
		if(paramMap.get("work1_keyword3") != null){
			workParam.put("keyword3", paramMap.get("work1_keyword3"));
			workParam.put("keyword3_url", paramMap.get("work1_keyword3_url"));
		}

		Integer work1_seq = (Integer) ckService.insert("pollEvent.insertPollWork", workParam);		
		
		//-------------- 작품1-2 insert start ----------------//
		workParam.clear();
		workParam.put("file_name", paramMap.get("work2_file_name"));
		workParam.put("url", paramMap.get("work2_url"));
		workParam.put("title", paramMap.get("work2_title"));
		workParam.put("gift", paramMap.get("work2_gift"));
		
		if(paramMap.get("work2_keyword1") != null){
			workParam.put("keyword1", paramMap.get("work2_keyword1"));
			workParam.put("keyword1_url", paramMap.get("work2_keyword1_url"));
		}
		if(paramMap.get("work2_keyword2") != null){
			workParam.put("keyword2", paramMap.get("work2_keyword2"));
			workParam.put("keyword2_url", paramMap.get("work2_keyword2_url"));
		}
		if(paramMap.get("work2_keyword3") != null){
			workParam.put("keyword3", paramMap.get("work2_keyword3"));
			workParam.put("keyword3_url", paramMap.get("work2_keyword3_url"));
		}
		
		Integer work2_seq = (Integer) ckService.insert("pollEvent.insertPollWork", workParam);
		
		///// 첫번째 투표 insert /////
		workParam.clear();
		workParam.put("poll_title", paramMap.get("poll1_title"));
		workParam.put("work1_seq", work1_seq);
		workParam.put("work2_seq", work2_seq);
		
		Integer poll1_seq = (Integer) ckService.insert("pollEvent.insertPoll", workParam);
		paramMap.put("poll1_seq", poll1_seq);
		///// 첫번째 투표 insert /////
		
		
		//-------------- 작품2-1 insert start ----------------//
		workParam.clear();
		workParam.put("file_name", paramMap.get("work3_file_name"));
		workParam.put("url", paramMap.get("work3_url"));
		workParam.put("title", paramMap.get("work3_title"));
		workParam.put("gift", paramMap.get("work3_gift"));
		
		if(paramMap.get("work3_keyword1") != null){
			workParam.put("keyword1", paramMap.get("work3_keyword1"));
			workParam.put("keyword1_url", paramMap.get("work3_keyword1_url"));
		}
		if(paramMap.get("work3_keyword2") != null){
			workParam.put("keyword2", paramMap.get("work3_keyword2"));
			workParam.put("keyword2_url", paramMap.get("work3_keyword2_url"));
		}
		if(paramMap.get("work3_keyword3") != null){
			workParam.put("keyword3", paramMap.get("work3_keyword3"));
			workParam.put("keyword3_url", paramMap.get("work3_keyword3_url"));
		}
		
		Integer work3_seq = (Integer) ckService.insert("pollEvent.insertPollWork", workParam);
		
		//-------------- 작품2-2 insert start ----------------//
		workParam.clear();
		workParam.put("file_name", paramMap.get("work4_file_name"));
		workParam.put("url", paramMap.get("work4_url"));
		workParam.put("title", paramMap.get("work4_title"));
		workParam.put("gift", paramMap.get("work4_gift"));
		
		if(paramMap.get("work4_keyword1") != null){
			workParam.put("keyword1", paramMap.get("work4_keyword1"));
			workParam.put("keyword1_url", paramMap.get("work4_keyword1_url"));
		}
		if(paramMap.get("work4_keyword2") != null){
			workParam.put("keyword2", paramMap.get("work4_keyword2"));
			workParam.put("keyword2_url", paramMap.get("work4_keyword2_url"));
		}
		if(paramMap.get("work4_keyword3") != null){
			workParam.put("keyword3", paramMap.get("work4_keyword3"));
			workParam.put("keyword3_url", paramMap.get("work4_keyword3_url"));
		}
		
		Integer work4_seq = (Integer) ckService.insert("pollEvent.insertPollWork", workParam);

		///// 두번째 투표 insert /////
		workParam.clear();
		workParam.put("poll_title", paramMap.get("poll2_title"));
		workParam.put("work1_seq", work3_seq);
		workParam.put("work2_seq", work4_seq);
		
		Integer poll2_seq = (Integer) ckService.insert("pollEvent.insertPoll", workParam);
		paramMap.put("poll2_seq", poll2_seq);
		///// 두번째 투표 insert /////
		
		pollParam.clear();
		pollParam.putAll(paramMap);

		ckService.insert("pollEvent.insertPollEvent", pollParam);
		
	}
	
	
	public void updatePollEvent(ParamMap paramMap) throws Exception {
		
		ParamMap pollParam = new ParamMap();
		ParamMap workParam = new ParamMap();
		
		//-------------- 작품1-1 update start ----------------//
		workParam.clear();
		
		if(paramMap.get("work1_seq") != null){
			workParam.put("work_seq", paramMap.get("work1_seq"));
						
			//기존 이미지파일과 다른 이미지업로드 할 경우 기존이미지 삭제
			String old_file_name = (String) ckService.readForObject("pollEvent.getWorkFileName", workParam);
			if(!old_file_name.equals(paramMap.get("work1_file_name"))){
				fileService.deleteFile("addservice_pollEvent", old_file_name);
			}
		}
		
		workParam.put("file_name", paramMap.get("work1_file_name"));
		workParam.put("url", paramMap.get("work1_url"));
		workParam.put("title", paramMap.get("work1_title"));
		workParam.put("gift", paramMap.get("work1_gift"));
		
		if(paramMap.get("work1_keyword1") != null){
			workParam.put("keyword1", paramMap.get("work1_keyword1"));
			workParam.put("keyword1_url", paramMap.get("work1_keyword1_url"));
		}
		if(paramMap.get("work1_keyword2") != null){
			workParam.put("keyword2", paramMap.get("work1_keyword2"));
			workParam.put("keyword2_url", paramMap.get("work1_keyword2_url"));
		}
		if(paramMap.get("work1_keyword3") != null){
			workParam.put("keyword3", paramMap.get("work1_keyword3"));
			workParam.put("keyword3_url", paramMap.get("work1_keyword3_url"));
		}

		ckService.save("pollEvent.updatePollWork", workParam);
		
		//-------------- 작품1-2 update start ----------------//
		workParam.clear();
		
		if(paramMap.get("work2_seq") != null){
			workParam.put("work_seq", paramMap.get("work2_seq"));
			//기존 이미지파일과 다른 이미지업로드 할 경우 기존이미지 삭제
			String old_file_name = (String) ckService.readForObject("pollEvent.getWorkFileName", workParam);
			if(!old_file_name.equals(paramMap.get("work2_file_name"))){
				fileService.deleteFile("addservice_pollEvent", old_file_name);
			}
		}
		
		workParam.put("file_name", paramMap.get("work2_file_name"));
		workParam.put("url", paramMap.get("work2_url"));
		workParam.put("title", paramMap.get("work2_title"));
		workParam.put("gift", paramMap.get("work2_gift"));
		
		if(paramMap.get("work2_keyword1") != null){
			workParam.put("keyword1", paramMap.get("work2_keyword1"));
			workParam.put("keyword1_url", paramMap.get("work2_keyword1_url"));
		}
		if(paramMap.get("work2_keyword2") != null){
			workParam.put("keyword2", paramMap.get("work2_keyword2"));
			workParam.put("keyword2_url", paramMap.get("work2_keyword2_url"));
		}
		if(paramMap.get("work2_keyword3") != null){
			workParam.put("keyword3", paramMap.get("work2_keyword3"));
			workParam.put("keyword3_url", paramMap.get("work2_keyword3_url"));
		}
		
		ckService.save("pollEvent.updatePollWork", workParam);
		
		
		///// 첫번째 투표 update /////
		workParam.clear();
		workParam.put("poll_seq", paramMap.get("poll1_seq"));
		workParam.put("poll_title", paramMap.get("poll1_title"));

		ckService.save("pollEvent.updatePoll", workParam);
		///// 첫번째 투표 update /////
				
		
		//-------------- 작품2-1 update start ----------------//
		workParam.clear();
		
		if(paramMap.get("work3_seq") != null){
			workParam.put("work_seq", paramMap.get("work3_seq"));
			//기존 이미지파일과 다른 이미지업로드 할 경우 기존이미지 삭제
			String old_file_name = (String) ckService.readForObject("pollEvent.getWorkFileName", workParam);
			if(!old_file_name.equals(paramMap.get("work3_file_name"))){
				fileService.deleteFile("addservice_pollEvent", old_file_name);
			}
		}
		
		workParam.put("file_name", paramMap.get("work3_file_name"));
		workParam.put("url", paramMap.get("work3_url"));
		workParam.put("title", paramMap.get("work3_title"));
		workParam.put("gift", paramMap.get("work3_gift"));
		
		if(paramMap.get("work3_keyword1") != null){
			workParam.put("keyword1", paramMap.get("work3_keyword1"));
			workParam.put("keyword1_url", paramMap.get("work3_keyword1_url"));
		}
		if(paramMap.get("work3_keyword2") != null){
			workParam.put("keyword2", paramMap.get("work3_keyword2"));
			workParam.put("keyword2_url", paramMap.get("work3_keyword2_url"));
		}
		if(paramMap.get("work3_keyword3") != null){
			workParam.put("keyword3", paramMap.get("work3_keyword3"));
			workParam.put("keyword3_url", paramMap.get("work3_keyword3_url"));
		}
			
		ckService.save("pollEvent.updatePollWork", workParam);
		
		
		//-------------- 작품2-2 update start ----------------//
		workParam.clear();

		if(paramMap.get("work4_seq") != null){
			workParam.put("work_seq", paramMap.get("work4_seq"));
			//기존 이미지파일과 다른 이미지업로드 할 경우 기존이미지 삭제
			String old_file_name = (String) ckService.readForObject("pollEvent.getWorkFileName", workParam);
			if(!old_file_name.equals(paramMap.get("work4_file_name"))){
				fileService.deleteFile("addservice_pollEvent", old_file_name);
			}
		}
		
		workParam.put("file_name", paramMap.get("work4_file_name"));
		workParam.put("url", paramMap.get("work4_url"));
		workParam.put("title", paramMap.get("work4_title"));
		workParam.put("gift", paramMap.get("work4_gift"));
		
		if(paramMap.get("work4_keyword1") != null){
			workParam.put("keyword1", paramMap.get("work4_keyword1"));
			workParam.put("keyword1_url", paramMap.get("work4_keyword1_url"));
		}
		if(paramMap.get("work4_keyword2") != null){
			workParam.put("keyword2", paramMap.get("work4_keyword2"));
			workParam.put("keyword2_url", paramMap.get("work4_keyword2_url"));
		}
		if(paramMap.get("work4_keyword3") != null){
			workParam.put("keyword3", paramMap.get("work4_keyword3"));
			workParam.put("keyword3_url", paramMap.get("work4_keyword3_url"));
		}
	
		ckService.save("pollEvent.updatePollWork", workParam);
		
		///// 두번째 투표 update /////
		workParam.clear();
		workParam.put("poll_seq", paramMap.get("poll2_seq"));
		workParam.put("poll_title", paramMap.get("poll2_title"));

		ckService.save("pollEvent.updatePoll", workParam);;
		///// 두번째 투표 update /////
		
		
		pollParam.clear();
		pollParam.putAll(paramMap);
		
		ckService.save("pollEvent.updatePollEvent", paramMap);
		
	}
	
	
	@SuppressWarnings("unchecked")
	public boolean deletePollEvent(ParamMap paramMap) throws Exception {
		
		int voterCount = (Integer) ckService.readForObject("pollEvent.getVoterCount", paramMap); //투표자수
		if(voterCount > 0 ){
			return false; //투표자가 있으면 투표 삭제 x
		}
		
		List<Object> delWorkList = ckService.readForList("pollEvent.getDeleteWorkList", paramMap); //삭제할 작품목록
		HashMap<String, Object> delWork = null;
		if (delWorkList != null && delWorkList.size() > 0) {
			for (Object o : delWorkList) {
				delWork = (HashMap<String, Object>) o;
				fileService.deleteFile("addservice_pollEvent", delWork.get("file_name").toString()); //작품이미지 삭제
				ParamMap workParam = new ParamMap();
				workParam.put("work_seq", delWork.get("work_seq").toString());
				ckService.delete("pollEvent.pollWorkDelete", workParam);	//작품정보 삭제
			}
		}
		
		List<Object> delPollList = ckService.readForList("pollEvent.getDeletePollList", paramMap); //삭제할 투표목록
		HashMap<String, Object> delPoll = null;
		if (delPollList != null && delPollList.size() > 0) {
			for (Object o : delPollList) {
				delPoll = (HashMap<String, Object>) o;
				ParamMap workParam = new ParamMap();
				workParam.put("poll_seq", delPoll.get("poll_seq").toString());
				ckService.delete("pollEvent.pollDelete", workParam);	//투표정보 삭제
			}
		}
		
		ckService.delete("pollEvent.pollEventDelete", paramMap); //투표이벤트 삭제
		
		return true;
	}

}
