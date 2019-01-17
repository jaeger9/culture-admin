<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<head>
<script type="text/javascript" src="/editor/js/HuskyEZCreator.js" charset="utf-8"></script>
<script type="text/javascript">

var subListYN = false;

$(function () {

	var frm = $('form[name=frm]');
	
	if('${subList[0].seq}') subListYN = true;
	
	//radio check
	if('${view.approval}')$('input:radio[name="approval"][value="${view.approval}"]').prop('checked', 'checked');
	
	$('input[name=uploadFile]').on('change', function(){
		$('.inputText').val($(this).val().substr(12));
	})

	//수정 , 삭제 , 등록 
	$('span > button').each(function() {
    	$(this).click(function() { 
        	if($(this).html() == '수정') { 
        		frm.attr('action' ,'/education/humanLecture/update.do');
        		frm.submit();
        	} else if($(this).html() == '삭제') {
        		console.log('삭제');
        		frm.attr('action' ,'/education/humanLecture/delete.do');
        		frm.submit();
        	} else if($(this).html() == '등록') {
        		frm.attr('action' ,'/education/humanLecture/insert.do');
        		frm.submit();
        	} else if($(this).html() == '목록') {
        		console.log('목록');
        		location.href='/education/humanLecture/list.do';
        	}   		
    	});
	});
	
});
</script>
</head>
<body>
	<!-- 검색 필드 -->
	<div class="tableWrite">
		<form name="frm" method="post" action="/education/humanLecture/insert.do" enctype="multipart/form-data">
			<c:if test='${not empty view.seq}'>
				<input type="hidden" name="seq" value="${view.seq}"/>
			</c:if>
			<input type="hidden" name="menuType" value="${paramMap.menuType}"/>
			<table summary="인문학강연 배너 등록/수정">
				<caption>인문학강연 배너 등록/수정</caption>
				<colgroup>
					<col style="width:17%" /><col style="width:33%" /><col style="width:15%" /><col style="width:35%" /></colgroup>
				<tbody>
					<tr>
						<th scope="row">배너 제목</th>
						<td colspan="3">
							<input type="text" name="title" style="width:670px" value="${view.title}" />
						</td>
					</tr>
					<tr>
						<th scope="row">배너 URL</th>
						<td colspan="3">
							<input type="text" name="url" style="width:670px" value="${subList[0].url}" />
						</td>
					</tr>
					<tr>
						<th scope="row">이미지</th>
						<td colspan="3">
							<div class="fileInputs">
								<input type="file" name="uploadFile" class="file hidden" title="첨부파일 선택" />
								<div class="fakefile">
									<input type="text" title="" class="inputText" value="${subList[0].img_name1}"/>
									<span class="btn whiteS"><button>찾아보기</button></span>
								</div>
							</div>
							<div style="margin-top:4px;">
								* 725 X 182px 사이즈로 등록해주시기 바랍니다.
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row">승인여부</th>
						<td colspan="3">
							<div class="inputBox">
								<label><input type="radio" name="approval" value="W"/> 대기</label>
								<label><input type="radio" name="approval" value="Y"/> 승인</label>
								<label><input type="radio" name="approval" value="N" checked="checked"/> 미승인</label>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
		</form>
	</div>
	<div class="btnBox textRight">
		<c:if test='${not empty view}'>
			<span class="btn white"><button type="button">수정</button></span>
			<span class="btn white"><button type="button">삭제</button></span>
		</c:if>
		<c:if test='${empty view }'>
			<span class="btn white"><button type="button">등록</button></span>
		</c:if>
		<span class="btn gray"><button type="button">목록</button></span>
	</div>
</body>
</html>