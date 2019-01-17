package kr.go.culture.main;

import static org.junit.Assert.*;

import org.junit.After;
import org.junit.Test;

public class EnumTest {

	public enum MenuUploadFilePath {
		agency("/info/agency/");
		
		private String uploadFilePath;
		private MenuUploadFilePath(String uploadFilePath) {
			this.uploadFilePath = uploadFilePath;
		}
		
		public String getUploadPath() { 
			return uploadFilePath;
		}
	}
	@Test
	public void test() {
		String path = MenuUploadFilePath.valueOf("agency").getUploadPath();
		
		System.out.println("path:" + path);
	}

}
