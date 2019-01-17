package kr.go.culture.common.view;

import java.net.URLEncoder;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.go.culture.common.util.CommonUtil;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.view.document.AbstractExcelView;

public class ExcelDocView extends AbstractExcelView {

	private static final Logger logger = LoggerFactory.getLogger(ExcelDocView.class);
	
	@SuppressWarnings("unchecked")
	@Override
	protected void buildExcelDocument(
			Map<String, Object> model, HSSFWorkbook workbook, HttpServletRequest request, 
			HttpServletResponse response) throws Exception {		
		String userAgent = request.getHeader("User-Agent");
		String fileNm = (String) model.get("fileNm");
		String[] headerArr = (String[]) model.get("headerArr");
		
		if(userAgent.indexOf("MSIE") > -1) {
			fileNm = URLEncoder.encode(fileNm, "UTF-8");
		} else {
			fileNm = new String(fileNm.getBytes("UTF-8"), "iso-8859-1");
		}
		
		Sheet sheet = null;
		Row row = null;
		Cell cell = null;
		//CellStyle style = null;
		
		sheet = workbook.createSheet(fileNm);
		
		row = sheet.createRow(0);
		//style = workbook.createCellStyle();
		
		// 엑셀 문서 헤더 설정
		int hNo = 0;
		for(String str : headerArr) {
			cell = row.createCell(hNo);
			cell.setCellValue(str);
			//style.setAlignment(CellStyle.ALIGN_CENTER);
			//style.setBorderTop(CellStyle.BORDER_THIN);
			
			if(hNo > 0) {
				//style.setBorderLeft(CellStyle.BORDER_HAIR);
			} else {
				//style.setBorderLeft(CellStyle.BORDER_THIN);
			}
			if((hNo+1) == headerArr.length) {
				//style.setBorderRight(CellStyle.BORDER_THIN);
			}
			//style.setBorderBottom(CellStyle.BORDER_THIN);
						
			//cell.setCellStyle(style);
			hNo++;
		}
		
		// 엑셀 문서 내용 설정
		List<Map<String, Object>> list = (List<Map<String, Object>>) model.get("excelList");
		int bNo = 0; 
		for(Map<String, Object> data : list) {
			row = sheet.createRow((bNo+1));
			
			int i=0;
			Iterator<String> itr = data.keySet().iterator();
			//style = workbook.createCellStyle();
			
			while (itr.hasNext()) {
				String key = itr.next();
				cell = row.createCell(i);
				cell.setCellValue(CommonUtil.nullStr(data.get(key).toString(), ""));
				
				if(bNo > 0) {
					//style.setBorderTop(CellStyle.BORDER_HAIR);
				}
				if(i > 0) {
					//style.setBorderLeft(CellStyle.BORDER_THIN);
				} else {
					//style.setBorderLeft(CellStyle.BORDER_HAIR);
				}
				if((i+1) == headerArr.length) {
					//style.setBorderRight(CellStyle.BORDER_THIN);
				}
				if((bNo+1) == list.size()) {
					//style.setBorderBottom(CellStyle.BORDER_THIN);
				}
				//cell.setCellStyle(style);
				i++;
			}
			bNo++;
		}
		
		response.setContentType("Application/Msexcel");
		response.setHeader("Content-Disposition", "Attachment; Filename="+fileNm+".xls");		
	}

}
