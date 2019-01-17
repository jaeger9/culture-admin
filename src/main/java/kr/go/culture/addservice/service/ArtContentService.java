package kr.go.culture.addservice.service;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.List;

import javax.annotation.Resource;

import kr.go.culture.common.domain.CommonModel;
import kr.go.culture.common.domain.ParamMap;
import kr.go.culture.common.service.CkDatabaseService;

import org.springframework.stereotype.Service;

@Service
public class ArtContentService {

	private static List<Object> categoryList;

	@Resource(name = "CkDatabaseService")
	private CkDatabaseService service;

	public List<Object> getCategoryList() throws Exception {
		if (categoryList == null) {
			categoryList = service.readForList("artContent.listByCode", null);
		}
		return categoryList;
	}

	public CommonModel getViewDetail(ParamMap paramMap) throws Exception {
		if (paramMap.isBlank("vvm_seq")) {
			return null;
		}
		return (CommonModel) service.readForObject("artContent.view", paramMap);
	}

	public void insertDetailContents(ParamMap paramMap) throws Exception {
		// 본문 삭제 후 재입력
		service.delete("artContent.deleteByDetailContents", paramMap);

		String[] values = getCutValue(paramMap.getString("vac_contents"));
		ParamMap contentMap = null;

		if (values != null) {
			for (String value : values) {
				contentMap = new ParamMap();
				contentMap.put("vvi_seq", paramMap.getInt("vvi_seq"));
				contentMap.put("vvm_seq", paramMap.getInt("vvm_seq"));
				contentMap.put("vac_contents", value);

				service.insert("artContent.insertByDetailContents", contentMap);
			}
		}
	}

	public byte[] getFileToByte(File file) {
		if (file == null || !file.exists()) {
			return null;
		}

		int length = 0;
		byte[] temp = new byte[2048];
		byte[] result = null;

		InputStream is = null;
		ByteArrayOutputStream baos = null;

		try {
			is = new FileInputStream(file);
			baos = new ByteArrayOutputStream();

			while ((length = is.read(temp)) >= 0) {
				baos.write(temp, 0, length);
			}

			result = baos.toByteArray();

			baos.close();
			is.close();

			baos = null;
			is = null;

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (baos != null) {
				try {
					baos.close();
				} catch (Exception e2) {
				}
				;
			}
			if (is != null) {
				try {
					is.close();
				} catch (Exception e3) {
				}
			}
		}

		return result;
	}

	private String[] getCutValue(String value) {
		int length = value.length();
		int max = 2000;
		int size = Math.max((length + (max - 1)) / max, 1);

		String[] arr = new String[size];

		for (int i = 0; i < size; i++) {
			if (i == size - 1) {
				arr[i] = value.substring(i * max);
			} else {
				arr[i] = value.substring(i * max, (i + 1) * max);
			}
		}

		return arr;
	}

}