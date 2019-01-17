package kr.go.culture.common.util;

import java.io.File;


/**
 * 파일 확장자 구하기
 * @author hjs4827
 * @param File 파일 객체
 * @return 파일 확장자 ex)exe, jpg, png, 등등
 * ex String ext = FileUtil.getExt(file); 
 */
public class FileUtil {
	public static String getExt(File file){
		String fileStr = file.getName();
		return fileStr.substring(fileStr.lastIndexOf(".")+1,fileStr.length());
	}
	/**
	 * 파일 확장자 구하기
	 * @author hjs4827
	 * @param File 파일 객체
	 * @return 성공시 true
	 * ex if(!FileUtil.rename(file, "text123.txt")) return false;  
	 */
	public static File rename(File file, String rename){
		File tempFile = new File(file.getParent()+File.separator+rename);
		if(!file.renameTo(tempFile))
			return null;
		else
			return tempFile;
					
			
	}
}
