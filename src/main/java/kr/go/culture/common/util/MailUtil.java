package kr.go.culture.common.util;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.util.Date;
import java.util.Properties;

import javax.activation.DataHandler;
import javax.activation.FileDataSource;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class MailUtil{	
	
	private static final Logger logger = LoggerFactory.getLogger(MailUtil.class);
	
	private String mailDirectory = "/data/culture_portal_2015/mail/"; 
	//개발
	//private String mailDirectory = "/data/mail_send/";
	
	//local
	//private String mailDirectory = "F:\\workspace-sts\\culture_portal_2015\\src\\main\\webapp\\mail\\"; //local test
	
	
	public boolean sendMail(String senderemail,String email,String subject, String[][] mailtext,int mailType) {
		boolean sendMail = false;
		System.out.println("mailDirectory="+mailDirectory);
		String[] file_nm = {"bye.jsp","findPW.jsp","join.jsp","templateA.jsp","templateB.jsp", "grpCert.jsp", "culturecokReply.jsp"};
		
		
		String host	= "mail.kcisa.kr";//"mail.sac.ac.kr";
		
	    
	    try {
			Properties props = new Properties();			
					
			/*props.put("mail.transport.protocol", "smtp");
			props.put("mail.smtp.host", host);
	        props.put("mail.smtp.port", "25");*/
	        
			//gmail
			props.put("mail.smtp.host", "smtp.gmail.com"); 
			props.put("mail.smtp.port", "25"); 
			props.put("mail.debug", "true"); 
			props.put("mail.smtp.auth", "true"); 
			props.put("mail.smtp.starttls.enable","true");
			props.put("mail.smtp.EnableSSL.enable","true");
			props.setProperty("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");   
			props.setProperty("mail.smtp.socketFactory.fallback", "false");   
			props.setProperty("mail.smtp.port", "465");   
			props.setProperty("mail.smtp.socketFactory.port", "465");
	       
			Authenticator auth = new SMTPAuthenticator();
	
			Session session = Session.getInstance(props, auth);
			Multipart mp = new MimeMultipart();
	         
	             // create a message
			MimeMessage msg = new MimeMessage(session);
	         
			msg.setFrom(new InternetAddress("portal@kcisa.kr"));
			
			StringBuffer html = new StringBuffer();
			String html_str = "";
			try {
				char[] buffer = new char[1024];				
				
				BufferedReader in = new BufferedReader(new InputStreamReader(new FileInputStream(mailDirectory+file_nm[mailType]),"UTF8"));
				
				while((html_str =in.readLine() ) != null){
					
					html.append(html_str);
					
				}
				
				//System.out.println(html.toString());
				in.close();
			} catch (Exception e) {
				logger.error(e.getMessage());
			} 
			
			html_str = html.toString();
			
			
			for(int i = 0; i < mailtext.length; i++){
				
				html_str = html_str.replaceAll(mailtext[i][0], mailtext[i][1]);
			
				
			}
			//System.out.println(html_str);
	             // 받는사람
	        InternetAddress[] toAddress = InternetAddress.parse(senderemail);
	        msg.setRecipients(Message.RecipientType.TO, toAddress);
	 
	             // 제목
	        msg.setSubject(subject, "euc-kr");
	 
	             // 내용
			MimeBodyPart mbp1 = new MimeBodyPart();
			mbp1.setContent(html_str, "text/html; charset=utf-8");
			
			
			//mbp1.setContent(mailtext, "text/html; charset=euc-kr");
			mp.addBodyPart(mbp1);
			 // 파일첨부
			File attached = new File("");
			 
			if ( attached.isFile() ) {
			         
			     MimeBodyPart mbp2 = new MimeBodyPart();
			     FileDataSource fds = new FileDataSource(attached);
			     mbp2.setDataHandler(new DataHandler(fds));
			     mbp2.setFileName((fds.getName()));
			     mp.addBodyPart(mbp2);
			         
			}
			 // 메시지 add
			msg.setContent(mp);
			 // header 에 날짜 삽입
			msg.setSentDate(new Date());
			 // send the message
			Transport.send(msg);			
			sendMail = true;
		} catch (AddressException e) {
			logger.error(e.getMessage());
		} catch (MessagingException e) {
			logger.error(e.getMessage());
 		}
		
	    return sendMail;
	    
	}
	
	public class SMTPAuthenticator extends javax.mail.Authenticator {

		public PasswordAuthentication getPasswordAuthentication() {


			// real
			//String userId  = "culture";
			//String userPwd = "admin_000";
			
			String userId  = "k.cultureportal@gmail.com";
			String userPwd = "kcisa@2835";

	        return new PasswordAuthentication(userId, userPwd);
		}

	}

}