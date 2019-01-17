package kr.go.culture.common.service;

import java.awt.Image;
import java.awt.image.BufferedImage;
import java.awt.image.PixelGrabber;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.text.SimpleDateFormat;
import java.util.Calendar;

import javax.imageio.ImageIO;

import kr.go.culture.common.util.DateUtil;

import org.apache.commons.lang.RandomStringUtils;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service("FileService")
public class FileService {

	private static final Logger logger = LoggerFactory.getLogger(FileService.class);
	
	@Value("#{contextConfig['file.upload.base.location.dir']}")
	private String fileUploadBaseLocaionDir;

	public enum MenuUploadFilePath {
		webzine("/upload/webzine/")								// 웹진
		,agency("/info/agency/")								// 관련 기관
		,banner("/upload/banner/")								// 배너
		,author("/main/")										// 필진
		,site("/upload/manage/")								// microsite
		,report("/info/report/")								//
		,show("/upload/rdf/")									// 공연 /전시  RDF META 용인가??
		,place("/upload/culSpace/")								// 공연장
		,relay("/upload/relay/")								// 릴레이 티켓 쪽인데 기존에 파일 업로드 안하는듯 보임 디렉토리 경로 X 서버엔 있네 ㅋㅋ
		,leaflet("/upload/leaflet/")							// 문화릴레이 리플렛
		,theme("/upload/theme/")								// 추천공연
		,culture_group("/upload/group/")						// 문화시설/단체0
		,issue("/upload/issue/")								// 매거진/문화영상 > 문화 이슈 컨텐츠
		,cardnews("/upload/cardnews/")							// 매거진/문화영상 > 카드뉴스
		,cardnewsThumb("/upload/cardnews/thumbnail")			// 매거진/문화영상 > 카드뉴스 > 썸네일
		,recom("/upload/recom/recom/")							// 문화공감							(??? * ??? / file name 사용 / PCN_RECOM_CULTURE.IMG_URL, PCN_RECOM_CULTURE.THUMB_URL)
		,magazine_agency_image("/upload/publicMov/")			// 매거진 기관 영상
		,pattern_content("/upload/patternEx/")					// 전통디자인 컨텐츠
		,use_design("/upload/patternUse/")						// 전통디자인 활용 디자인
		,use_design_80("/upload/patternUse/80/")				// 전통디자인 활용 디자인
		,apply_design("/upload/patternDesign/")					// 전통문양 활용 - 제품디자인
		,apply_gallery("/upload/patternDesign/")				// 전통문양 활용 - 활용갤러리

		// [프론트에서 이미지 사용 안함] 문화지식/정책 - 리포트
		// [프론트에서 이미지 사용 안함] 이벤트/소식 - 채용
		,knowledge_relic("/upload/knowledge/relic/")			// 문화지식/정책 - 국가유물 							(125 *  95 / full url  사용 / MV_RDF_METADATA_RELIC.REFERENCE_IDENTIFIER)
		,knowledge_ict("/upload/knowledge/ict/")				// 문화지식/정책 - 교육활용자료							(110 *  85 / full url  사용 / MV_RDF_METADATA_ICT.REFERENCE_IDENTIFIER)
		,knowledge_artContent("/upload/vvm_tmp/")				// 문화지식/정책 - 예술지식백과 - 활용콘텐츠관리			(??? * ??? / file name 사용 / VLI_VLI_MST.VVM_FILE_NAME, VLI_VLI_MST.VVM_FILE_NAME_SUB)
		,knowledge_artContentDetail("/upload/vmi/")				// 문화지식/정책 - 예술지식백과 - 활용콘텐츠관리 상세		(no iamge  / file name 사용 / VLI_VLI_INF.VVI_OLE_FILE)
		,knowledge_artContentDetailFile("/upload/vmi_temp/")	// 문화지식/정책 - 예술지식백과 - 활용콘텐츠관리 상세 파일	(no iamge  / file name 사용 / VLI_MED_INF.VMI_FILE, VLI_MED_INF.VMI_FILE_SUB)
		,knowledge_cardinst("/upload/cardinst/")				// 문화지식/정책 - 카드대표참여기관
		,knowledge_welfare("/upload/welfare/")					// 문화지식/정책 - 문화복지혜택, 문화사업
		,event_event("/upload/event/")							// 이벤트/소식 - 문화포털이벤트							(180 * 117 / file name 사용 / PCN_EVENT.FILE_ORG)
		,event_news("/upload/news/")							// 이벤트/소식 - 뉴스 RDF, CUL						(125 *  95 / full url  사용 / MV_RDF_METADATA_INFO.REFERENCE_IDENTIFIER / type = 46)
		,customer_openapi("/upload/customer/openapi/")			// 이용안내 - 공공문화정보API - 오퍼레이션				(no image  / file name 사용 / RDF_OPERATION.FILENAME)
		,customer_sns("/upload/recom/sns/")						// 이용안내 - 문화SNS지도								( 40 *  40 / file name 사용 / PCN_RECOM_SNS.IMG_URL)
		,addservice_contestMcst("/upload/contestMCST/")			// 부가서비스 - 공모전관리 - 문체부공모전관리			(??? * ??? / file name 사용 / PCN_CONTEST_MCST.IMAGE)
		,addservice_contestGallery("/upload/contestGallery/")	// 부가서비스 - 공모전관리 - 시상식갤러리				(202 * 146 / file name 사용 / PCN_CONTEST_GALLERY.IMAGE)
		,addservice_archive("/upload/arc_tmp/")					// 부가서비스 - 아카이브 - 아카이브관리					(no image  / file name 사용 / ARC_CLS_MST.ARC_FILE_NAME, ARC_CLS_MST.ARC_FILE_SUB_NAME)
		,microsite_site("/upload/microsite/site/")				// 부가서비스 - 마이크로사이트 - 사이트관리				( 12 *  12 / full url  사용 / MICROSITE.SITE_IMG)
		,microsite_board("/upload/microsite/board/")			// 부가서비스 - 마이크로사이트 - 게시판관리				(174 * 114 / full url  사용 / MICROSITE_BOARD.THUMBNAIL
		
		,main_content("/upload/mainContent/")					// 메인콘텐츠				(92 * 92 / full url  사용 / PORTAL_MAIN_CONTENT_SUB.IMAGE_NAME
		,resource_page("/upload/resource/page/")				// 문화정보	- 페이지 관리		(? * ? / full url  사용 / PCN_INFO_RESOURCE_MENU.IMAGE
		,resource_board("/upload/resource/board/")				// 문화정보	- 게시판 관리		(174 * 114 / full url  사용 / PCN_INFO_RESOURCE_BOARD.THUMBNAIL
		,resource_banner("/upload/resource/banner/")			// 문화정보	- 배너 관리			(125 * 155/ full url  사용 / PCN_INFO_RESOURCE_BANNER.IMAGE
		,addservice_pollEvent("/upload/pollEvent/")				// 부가서비스 - 2016문화초대이벤트 - 이벤트내용관리			(??? * ??? / file name 사용 / CULTURE_EVENT_POLL_WORK.FILE_NAME)
		,cultureVideoThumb("/upload/video/thumbnail")			//
		,cultureVideo("/upload/cultureVideo")
		,cultureAppPop("/upload/app/pop")						// 문화 융성앱 팝업 관리
		;

		private String uploadFilePath;

		private MenuUploadFilePath(String uploadFilePath) {
			this.uploadFilePath = uploadFilePath;
		}

		public String getMenuUploadPath() {
			return uploadFilePath;
		}
	}

	public String[] fileList(String menuType) throws Exception {
		File file = new File(getUploadPath(menuType));

		return file.list();
	}

	public void deleteFile(String menuType, String fileName) throws Exception {
		String deleteFilePath = getUploadPath(menuType);
		File deleteFile = new File(deleteFilePath + File.separator + fileName);
		deleteFile.delete();
		logger.info("fileDel"+deleteFile);
	}

	public String writeFile(MultipartFile file, String menuType) throws Exception {
		if (file == null || file.isEmpty() || StringUtils.isBlank(menuType)) {
			return "";
		}

		String uploadPath = getUploadPath(menuType);
		
		if("show".equals(menuType)){
			uploadPath=uploadPath+MkFileDir();
		}
		checkDir(uploadPath);

		return write(file, uploadPath, menuType);
	}

	private String getUploadPath(String menuType) {
		return fileUploadBaseLocaionDir + MenuUploadFilePath.valueOf(menuType).getMenuUploadPath();
	}

	private void checkDir(String uploadPath) throws Exception {
		File dir = new File(uploadPath);

		if (!dir.exists()) {
			dir.mkdirs();
		}
	}

	private String write(MultipartFile file, String uploadPath, String menuType) throws Exception {
		BufferedOutputStream outputStream = null;
		File uploadFile = null;
		byte[] bytes = null;
		
		String oriFileName = null;
		String sysFileName = null;

		try {
			if (file != null && !file.isEmpty()) {
				bytes = file.getBytes();

				// 파일경로 생성
				File fileDir = new File(uploadPath);
				if(!fileDir.exists()) {
					fileDir.mkdirs();
				}
				
				oriFileName = file.getOriginalFilename();
				String fileExt = oriFileName.substring(oriFileName.lastIndexOf("."), oriFileName.length());
				//fileName = System.currentTimeMillis() + fileName;
				
				// 파일 중복 체크
				boolean fileExists = true;
				do {
					String randomNum = RandomStringUtils.random(5, false, true);
					sysFileName = menuType+"_"+DateUtil.getDateTime("YMDhms")+randomNum+fileExt;
					File checkFile = new File(uploadPath, sysFileName);
					fileExists = checkFile.exists();
				} while (fileExists);
				
				uploadFile = new File(uploadPath + File.separator + sysFileName);
				
				outputStream = new BufferedOutputStream(new FileOutputStream(uploadFile));
				outputStream.write(bytes);
				outputStream.close();
				outputStream = null;
				
				//카드뉴스일경우 썸네일 생성
				if(menuType.equals("cardnews")){
					//이미지 리사이즈
					//이밎 리사이즈 2번하기 사이즈 별로
					BufferedImage inputImage = ImageIO.read(uploadFile);
		            BufferedImage buffer_thumbnail_image = resizeImageHighQuality(inputImage, BufferedImage.TYPE_3BYTE_BGR, 238, 238);
		            String thumbPath = uploadPath + "thumbnail/" + sysFileName;
					uploadPath = uploadPath + "thumbnail/";
					uploadFile = new File(thumbPath);
					ImageIO.write(buffer_thumbnail_image, "jpg", uploadFile);
				 /**************************************************************/	
		           /*** 280 * 280 ***/
					
					//String etc_fileExt = sysFileName.substring(sysFileName.lastIndexOf("."), sysFileName.length());
					//String fileNm=sysFileName.replaceAll(etc_fileExt, "");
				    String reName="M_"+sysFileName;
				    BufferedImage buffer_thumbnail_image_m = resizeImageHighQuality(inputImage, BufferedImage.TYPE_3BYTE_BGR, 280, 280);
				    String thumbPath1 = uploadPath + reName;
				    
					uploadFile = new File(thumbPath1);
		            ImageIO.write(buffer_thumbnail_image_m, "jpg", uploadFile);
		            
		            /***********/
				}else if(menuType.equals("place")){
					
					//이미지 리사이즈
					BufferedImage inputImage = ImageIO.read(uploadFile);
		            BufferedImage buffer_thumbnail_image = resizeImageHighQuality(inputImage, BufferedImage.TYPE_3BYTE_BGR, 300, 200);
		            
		            String thumbPath = uploadPath + "thumbnail/" + sysFileName;
					uploadPath = uploadPath + "thumbnail/";
					
					File fileDir1 = new File(uploadPath);
					if(!fileDir1.exists()) {
						fileDir1.mkdirs();
					}
					
					uploadFile = new File(thumbPath);
		            ImageIO.write(buffer_thumbnail_image, "jpg", uploadFile);
				}
				/*else if(menuType.equals("issue")){
					
					//이미지 리사이즈
					BufferedImage inputImage = ImageIO.read(uploadFile);
		            BufferedImage buffer_thumbnail_image = resizeImageHighQuality(inputImage, BufferedImage.TYPE_3BYTE_BGR, 238, 238);
		            
		            String thumbPath = uploadPath + "thumbnail/" + sysFileName;
					uploadPath = uploadPath + "thumbnail/";
					
					File fileDir1 = new File(uploadPath);
					if(!fileDir1.exists()) {
						fileDir1.mkdirs();
					}
					
					uploadFile = new File(thumbPath);
		            ImageIO.write(buffer_thumbnail_image, "jpg", uploadFile);
		            
				}*/


			} else {
				throw new Exception("Upload File is Empty");
			}
		} catch (Exception e) {
			throw e;
		} finally {
			if (outputStream != null) {
				try { outputStream.close(); } catch (Exception e2) {}
			}
		}
		
		if("show".equals(menuType)){
			sysFileName=MkFileDir()+sysFileName;
		}

		return sysFileName == null ? "" : sysFileName;
	}
	
	private BufferedImage resizeImageHighQuality(BufferedImage originalImage, int type, int width, int height) throws Exception { 
		Image image = originalImage.getScaledInstance(width, height, Image.SCALE_SMOOTH); 
		int pixels[] = new int[width * height]; 
		PixelGrabber pixelGrabber = new PixelGrabber(image, 0, 0, width, height, pixels, 0, width); 
		pixelGrabber.grabPixels();

		// image 객체로부터 픽셀 정보를 읽어온 후, BufferedImage에 채워 넣어주면 이미지 크기 변환이 된다. 
		BufferedImage destImg = new BufferedImage(width, height, type); 
		destImg.setRGB(0, 0, width, height, pixels, 0, width); 

		return destImg; 
	}
	
	public String MkFileDir(){
	    
	      SimpleDateFormat sdf = new SimpleDateFormat("yyMM");
	      Calendar c1 = Calendar.getInstance();
		  String strToday = sdf.format(c1.getTime());
		  
		  String year=strToday.substring(0,2);
		  String month=strToday.substring(2,4);
		  
		  String upDir=year+"/"+month+"/";
		      
		 return upDir;
	}


}