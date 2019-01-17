package kr.go.culture.facility.service;

import java.util.List;

import javax.annotation.Resource;

import kr.go.culture.common.domain.CommonModel;
import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;
import kr.go.culture.common.service.MailService;
import kr.go.culture.common.service.UrlConnectionService;

import org.springframework.stereotype.Service;

@Service("RentalApplyStatusUpdateService")
public class RentalApplyStatusUpdateService {

	//설정 파일에 밖을까 하다가 말음 설정 및 프로 파일은 있으니 알아서 하시오
	private String from = "portal@kcisa.kr";
	private String subject = "문화 포털 시설예약 알림";
		
	@Resource(name = "CkDatabaseService")
	private CkDatabaseService ckDatabaseService;

	@Resource(name = "UrlConnectionService")
	private UrlConnectionService urlConnectionService;
	
	@Resource(name = "MailService")
	private MailService mailService;
	
	public void statusUpdate(ParamMap paramMap) throws Exception { 
		//PORTAL_RENTAL_APPLY STATUS UPDATE
		ckDatabaseService.save("place.rentalStatusUpdate", paramMap);
		
		//MAIL ADDR , NAME GET mailInfo
		senedMail(ckDatabaseService.readForList("place.mailInfo", paramMap));
	}
	
	private void senedMail(List<Object> userInfoList) throws Exception { 
		
		String mailForm = urlConnectionService.readData("http://localhost:8080/mail/templateA.jsp", null);
		String html = null;
		
		for(Object object : userInfoList) { 
			CommonModel data = (CommonModel)object;
			
			html = mailForm.replaceAll("<gubun>", data.get("title").toString());
			html = html.replaceAll("<approval>", data.get("approval").toString());
			html = html.replaceAll("<name>", data.get("name").toString());
			html = html.replaceAll("<subject>", data.get("subject").toString());
			
			mailService.sendMail(from, data.get("email").toString(), subject, html);
		}
	}
}
