package kr.go.culture.common.service;

import javax.annotation.Resource;
import javax.mail.internet.MimeMessage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

@Service("MailService")
public class MailService {

//	@Autowired
    @Resource(name = "mailsender")
	private JavaMailSender mailSender;

//	@Autowired
//	private SimpleMailMessage simpleMailMessage;

	public void sendMail(final String from,  final String to, final String subject, final String body) throws Exception {

        MimeMessage message = mailSender.createMimeMessage();  
        MimeMessageHelper helper = new MimeMessageHelper(message, true , "UTF-8");  // 마지막 encoding 값 안주면 default encoding 으로 바뀐다ㅏ.

        helper.setFrom(from);
        helper.setTo(to);
        helper.setSubject(subject);
        helper.setText(body , true); // html 로 보낼려면 true 줘야함....
        
        System.out.println("body:" + body);
		mailSender.send(message);
	}
	
//	public void sendAlertMail(String alert) {
//	    SimpleMailMessage mailMessage = new SimpleMailMessage(simpleMailMessage);
//	    mailMessage.setText(alert);
//	    mailSender.send(mailMessage);
//	}
}
