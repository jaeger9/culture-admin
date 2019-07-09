package kr.go.culture.common.service;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;
import java.util.HashMap;

import javax.net.ssl.HttpsURLConnection;

import org.springframework.stereotype.Service;

@Service("UrlConnectionService")
public class UrlConnectionService {

	public String readData(String url, HashMap<String, String> param) throws Exception {

		URLConnection connection = getConnection(url);

		return read(connection);
	}

	private URLConnection getConnection(String url) throws IOException {
		URL httpUrl = null;

		httpUrl = new URL(url);

		return httpUrl.openConnection();
	}

	/**
	 * 
	 * @param connection
	 * @param connectionOption
	 * @throws Exception
	 */
	private void setConnection(URLConnection connection, HashMap<String, String> connectionOption) throws Exception {

		/*
		 * connection.setRequestMethod("POST"); connection.setReadTimeout(10 * 1000);
		 * 
		 * connection.setRequestProperty("Content-Type",
		 * "application/json; charset=UTF-8"); connection.setRequestProperty("Accept",
		 * "application/json"); connection.setRequestProperty("AP_CODE", "OK_AP01");
		 * 
		 * connection.setDoOutput(true); connection.setDoInput(true);
		 */
	}

	private void write(URLConnection connection, HashMap<String, Object> param) throws Exception {
		/*
		 * OutputStreamWriter writer = null;
		 * 
		 * writer = new OutputStreamWriter(connection.getOutputStream(),"UTF-8");
		 * 
		 * writer.write(d); writer.flush();
		 */
	}

	private String read(URLConnection connection) throws Exception {
		BufferedReader br = null;
		StringBuffer sb = new StringBuffer();
		String str = null;

		try {
			br = new BufferedReader(new InputStreamReader(connection.getInputStream(), "UTF-8"));

			while ((str = br.readLine()) != null)
				sb.append(str);

			return sb.toString();
		} catch (Exception e) {
			throw e;
		} finally {
			if (connection instanceof HttpURLConnection) {
				try {
					if (connection != null) {
						((HttpURLConnection)connection).disconnect();
					}
				} catch (Exception e2) {
				}
			}
			if (connection instanceof HttpsURLConnection) {
				try {
					if (connection != null) {
						((HttpsURLConnection)connection).disconnect();
					}
				} catch (Exception e2) {
				}
			}
			try {
				if (br != null)
					br.close();
			} catch (Exception e2) {
			}
		}

	}
}
