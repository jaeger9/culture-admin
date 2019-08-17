package kr.go.culture.common.util;

import org.apache.commons.lang.StringUtils;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.SimpleTimeZone;
import java.util.TimeZone;

//import org.parboiled.common.StringUtils;

public class DateUtil {

	public static int getLastDayOfMonth() {
		Calendar cal = Calendar.getInstance(TimeZone.getTimeZone("JST"),
				Locale.KOREA);
		return getLastDayOfMonth(cal);
	}

	public static int getLastDayOfMonth(Date date) {
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);
		return getLastDayOfMonth(cal);
	}

	public static int getLastDayOfMonth(Calendar cal) {
		int lastDayOfMonth = cal.getActualMaximum(5);
		return lastDayOfMonth;
	}

	public static int getDayOfWeek() {
		Calendar cal = Calendar.getInstance(TimeZone.getTimeZone("JST"),
				Locale.KOREA);
		return getDayOfWeek(cal);
	}

	public static int getDayOfWeek(Date date) {
		Calendar cal = Calendar.getInstance();
		cal.setTime(date);
		return getDayOfWeek(cal);
	}

	public static int getDayOfWeek(Calendar cal) {
		int dayOfWeek = cal.get(7);
		return dayOfWeek;
	}

	public static boolean isWeekDay(Date date) {
		int dayOfWeek = getDayOfWeek(date);
		boolean isWeekDay = (dayOfWeek >= 2) && (dayOfWeek <= 6);
		return isWeekDay;
	}

	public static boolean isWeekDay() {
		int dayOfWeek = getDayOfWeek();
		boolean isWeekDay = (dayOfWeek >= 2) && (dayOfWeek <= 6);
		return isWeekDay;
	}

	public static boolean isWeekEnd(Date date) {
		int dayOfWeek = getDayOfWeek(date);
		boolean isWeekEnd = (dayOfWeek == 7) || (dayOfWeek == 1);
		return isWeekEnd;
	}

	public static boolean isWeekEnd() {
		int dayOfWeek = getDayOfWeek();
		boolean isWeekEnd = (dayOfWeek == 7) || (dayOfWeek == 1);
		return isWeekEnd;
	}

	public static Date getDaysAgo(Date date, int days) {
		return new Date(date.getTime() - (days * 86400000L));
	}

	public static String getDateTime() throws Exception {
		return getDateTime("Y-M-D h:m:s");
	}

	public static String getDateTime(String dFormat) throws Exception {
		Calendar cal = Calendar.getInstance(TimeZone.getTimeZone("JST"),
				Locale.KOREA);

		int year = cal.get(1);
		int mon = cal.get(2) + 1;
		int day = cal.get(5);
		int hour = cal.get(11);
		int min = cal.get(12);
		int sec = cal.get(13);
		int msec = cal.get(14);

		String sYear = Integer.toString(year);
		String sMon = Integer.toString(mon);
		if(sMon.length() < 2) {
			sMon = "0"+sMon;
		}
		String sDay = Integer.toString(day);
		String sHour = Integer.toString(hour);
		String sMin = Integer.toString(min);
		String sSec = Integer.toString(sec);
		String sMsec;
		if (msec == 0) {
			sMsec = "000";
		} else {
			if (msec < 10) {
				sMsec = "00" + msec;
			} else {
				if (msec < 100)
					sMsec = "0" + msec;
				else
					sMsec = Integer.toString(msec);
			}
		}
		String rValue = dFormat;
		rValue = CommonUtil.replaceStr(rValue, "Y", sYear);
		rValue = CommonUtil.replaceStr(rValue, "M", sMon);
		rValue = CommonUtil.replaceStr(rValue, "D", sDay);
		rValue = CommonUtil.replaceStr(rValue, "h", sHour);
		rValue = CommonUtil.replaceStr(rValue, "m", sMin);
		rValue = CommonUtil.replaceStr(rValue, "s", sSec);
		rValue = CommonUtil.replaceStr(rValue, "i", sMsec);

		return rValue;
	}

	public static String getDateTime(String dFormat, String dt)
			throws Exception {
		if ((dt == null)
				|| ((dt.length() != 8) && (dt.length() != 14) && (dt.length() != 12))) {
			return dt;
		}
		String y = dt.substring(0, 4);
		String m = dt.substring(4, 6);
		String d = dt.substring(6, 8);
		String h = "";
		String mm = "";
		String s = "";

		if (dt.length() == 14) {
			h = dt.substring(8, 10);
			mm = dt.substring(10, 12);
			s = dt.substring(12);
		}

		if (dt.length() == 12) {
			h = dt.substring(8, 10);
			mm = dt.substring(10, 12);
		}

		String rValue = "";
		for (int i = 0; i < dFormat.length(); ++i) {
			switch (dFormat.charAt(i)) {
			case 'Y':
				rValue = rValue + y;
				break;
			case 'M':
				rValue = rValue + m;
				break;
			case 'D':
				rValue = rValue + d;
				break;
			case 'h':
				rValue = rValue + h;
				break;
			case 'm':
				rValue = rValue + mm;
				break;
			case 's':
				rValue = rValue + s;
				break;
			default:
				rValue = rValue + dFormat.charAt(i);
			}
		}
		return rValue;
	}

	public static int diffOfDate(String begin, String end) throws Exception {
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd");

		Date beginDate = formatter.parse(begin);
		Date endDate = formatter.parse(end);

		long diff = endDate.getTime() - beginDate.getTime();
		long diffDays = diff / 86400000L;

		return (int) diffDays;
	}

	public static int diffOfDate(int begin, int end) throws Exception {
		String beginStr = String.valueOf(begin);
		String endStr = String.valueOf(end);

		return diffOfDate(beginStr, endStr);
	}

	public static String calcDate(String year, String month, String day,
			String fields, int diff) {
		String[] ids = TimeZone.getAvailableIDs(32400000);
		SimpleTimeZone pdt = new SimpleTimeZone(32400000, ids[0]);
		Calendar date = new GregorianCalendar(pdt);

		int y = 0;
		int m = 0;
		int d = 0;

		if ((year != null) && (month != null) && (day != null)) {
			y = Integer.parseInt(year);
			m = Integer.parseInt(month);
			d = Integer.parseInt(day);
			date.set(y, m - 1, d);
		}

		if ((fields.equals("y")) || (fields.equals("Y")))
			date.set(1, date.get(1) + diff);
		else if ((fields.equals("m")) || (fields.equals("M")))
			date.set(2, date.get(2) + diff);
		else if ((fields.equals("w")) || (fields.equals("W")))
			date.set(5, date.get(5) + diff * 7);
		else if ((fields.equals("d")) || (fields.equals("D"))) {
			date.set(5, date.get(5) + diff);
		}

		String rValue = "";
		rValue = rValue + date.get(1);

		m = date.get(2) + 1;
		if (m >= 10)
			rValue = rValue + m;
		else {
			rValue = rValue + "0" + m;
		}

		d = date.get(5);
		if (d >= 10)
			rValue = rValue + d;
		else {
			rValue = rValue + "0" + d;
		}
		return rValue;
	}
	
	
	public static Map getSplitDate(String dateTime){
		
		Map<String,String> map = new HashMap<String, String>();
		
		if(StringUtils.isEmpty(dateTime)){
			return null;
		}
		
		String[] datetime = dateTime.split(" ");
		if(datetime.length > 0){
			map.put("send_date", datetime[0]);
			if(datetime.length > 1){
				String[] times = datetime[1].split(":");
				map.put("send_hour", times[0]);
				map.put("send_minute", times[1]);
			}
		}else{
			map = null;
		}
		return map;
	}
	
	/**
	 * 현재날짜 구하기
	 * @author wbae
	 * @return the escaped string ex)20130322
	 */
	public static String getToday(){
		return getToday("");
	}
	
	/**
	 * 현재날짜 구하기
	 * @author wbae
	 * @param string 구분자
	 * @return string ex)2013-03-22
	 */
	public static String getToday(String sep){
		Calendar cal = Calendar.getInstance();
		String yyyy = Integer.toString(cal.get(Calendar.YEAR));
		String mm = Integer.toString(cal.get(Calendar.MONTH)+1);
		String dd = Integer.toString(cal.get(Calendar.DATE));
		if (mm.length() == 1) {
			mm = "0"+mm;
		}
		if (dd.length() == 1) {
			dd = "0"+dd;
		}
		
		String date = yyyy + sep + mm + sep + dd; 
		return date;
	}
}
