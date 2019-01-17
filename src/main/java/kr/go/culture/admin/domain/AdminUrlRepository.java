package kr.go.culture.admin.domain;

import java.util.Date;

public class AdminUrlRepository {

	private String url_id;
	private String url_string;
	private String url_desc;
	private String url_link_yn;
	private String approval;
	private String user_id;
	private Date reg_date;
	private Date upt_date;

	//

	private String url_strings;

	//

	public AdminUrlRepository() {
	}

	public AdminUrlRepository(AdminUrlRepository u) {
		url_id = u.getUrl_id();
		url_string = u.getUrl_string();
		url_desc = u.getUrl_desc();
		url_link_yn = u.getUrl_link_yn();
		approval = u.getApproval();
		user_id = u.getUser_id();
		reg_date = u.getReg_date();
		upt_date = u.getUpt_date();
		url_strings = u.getUrl_strings();
	}

	//

	public String getUrl_id() {
		return url_id;
	}

	public void setUrl_id(String url_id) {
		this.url_id = url_id;
	}

	public String getUrl_string() {
		return url_string;
	}

	public void setUrl_string(String url_string) {
		this.url_string = url_string;
	}

	public String getUrl_desc() {
		return url_desc;
	}

	public void setUrl_desc(String url_desc) {
		this.url_desc = url_desc;
	}

	public String getUrl_link_yn() {
		return url_link_yn;
	}

	public void setUrl_link_yn(String url_link_yn) {
		this.url_link_yn = url_link_yn;
	}

	public String getApproval() {
		return approval;
	}

	public void setApproval(String approval) {
		this.approval = approval;
	}

	public String getUser_id() {
		return user_id;
	}

	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}

	public Date getReg_date() {
		return reg_date;
	}

	public void setReg_date(Date reg_date) {
		this.reg_date = reg_date;
	}

	public Date getUpt_date() {
		return upt_date;
	}

	public void setUpt_date(Date upt_date) {
		this.upt_date = upt_date;
	}

	public String getUrl_strings() {
		return url_strings;
	}

	public void setUrl_strings(String url_strings) {
		this.url_strings = url_strings;
	}

}