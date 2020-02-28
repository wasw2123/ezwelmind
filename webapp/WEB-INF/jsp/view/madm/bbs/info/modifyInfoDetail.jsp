<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/layout/inc/tags.jspf"%>
<html>
<head>
<title>게시판 상세정보</title>

<script type="text/javascript" src="/resources/se2/js/HuskyEZCreator.js" charset="utf-8"></script>
<script type="text/javascript">
var oEditors = [];

j$(document).ready(function(){
	j$("#deleteBtn").click(function(){
		alert("삭제는 Tech 담당자에게 문의해주세요.");
		return false;
	});

	j$("#modifyBtn").click(function(){
		oEditors[0].exec("UPDATE_CONTENTS_FIELD", []);   // 에디터의 내용이 textarea에 적용된다.

		if ( confirm('수정하시겠습니까?') ) {
			j$("#modifyInfoDetail").submit();
		}
		
		return false;
	});
	
	j$("#cancleBtn").click(function(){
		if(confirm("전단계로 돌아가시겠습니까?")){
			location.href = "/madm/bbsInfo/list";
		}
		return false;
	});
});

j$(function(){
	nhn.husky.EZCreator.createInIFrame({
	    oAppRef: oEditors,
	    elPlaceHolder: "ir1",
	    sSkinURI: "/resources/se2/SmartEditor2Skin.html",
	    htParams : {bUseToolbar : true,
            fOnBeforeUnload : function(){},
            fOnAppLoad : function(){}
            //oEditors.getById["ir1"].exec("PASTE_HTML", ["로딩이 완료된 후에 본문에 삽입되는 text입니다."]);
  		 },
	    fCreator: "createSEditor2"
	});
});
</script>
</head>
<body>

<form:form id="modifyInfoDetail" modelAttribute="bbsAddDto" action="/madm/bbsInfo/modifyInfoDetail" method="PUT">
<table cellpadding="0" cellspacing="0" border="0" width="95%" height="100%">
<tr><td height="20px"></td></tr>
<tr>
	<td valign="top" align="left">
		<table cellpadding="5" cellspacing="0" border="0" width="100%" align="center" style="border-bottom: 1px solid silver;">
			<tr>
		    	<td align="left" class="subtitle">게시판 상세정보</td>
			</tr>
		</table>
	</td>
</tr>

<tr><td height="20px"></td></tr>

<tr>
	<td>
		<table cellpadding="5" cellspacing="0" border="1" width="100%" style="border-collapse:collapse;">
	        <tr>
	            <th class="line" width="15%" align="center" bgcolor="#F5F5F5">서비스</th>
	            <td colspan="3" width="">
	            	${detail.serviceNm } (${detail.serviceType })
	            	<input type="hidden" name="serviceType" value="${detail.serviceType }">
	            </td>
	        </tr>
	        <tr>
	            <th class="line" align="center" bgcolor="#F5F5F5">게시판 유형</th>
	            <td colspan="3">
	            	${detail.bbsTypeNm }(${detail.bbsType })
	            	<input type="hidden" name="bbsType" value="${detail.bbsType }">
	            </td>
	        </tr>
	        <tr>
	        	<th class="line" width="15%" align="center" bgcolor="#F5F5F5">게시판코드</th>
	            <td colspan="3" width="">
	            	${detail.bbsCd }
	            	<input type="hidden" name="bbsCd" value="${detail.bbsCd }">
	            </td>
	        </tr>
	        <tr>
	        	<th class="line" align="center" bgcolor="#F5F5F5">게시판명</th>
	            <td colspan="3">
	            	<input type="text" name="bbsNm" value="${detail.bbsNm }" style="width: 300px; height: 25px;">
	            </td>
	        </tr>
	        <tr>
	            <th class="line" align="center" bgcolor="#F5F5F5">게시판 설명</th>
	            <td colspan="3" style="min-height: 200px;">
	            	<textarea rows="10" cols="30" id="ir1" name="comment" style="width:100%; height:400px;">${detail.comment }</textarea>
	            </td>
	        </tr>
		</table>
	</td>
</tr>

<tr><td height="20px"><td><tr>
<tr>
	<td>
		<table cellpadding="5" cellspacing="0" border="0" width="100%" style="border-collapse:collapse;">
			<tr align="center" height="50px">
				<td class="" colspan="2" align="center">
					<input type="button" id="modifyBtn" value="수정" style="height:30px; width:100px;">
					<span style="margin-left: 20px;"></span>
    				<input type="button" id="deleteBtn" value="삭제" style="height:30px; width:100px;">
		    		<span style="margin-left: 20px;"></span>
		    		<input type="button" id="cancleBtn" value="취소" style="height:30px; width:100px;">
		    	</td>
			</tr>
		</table>
	</td>
</tr>
</table>
</form:form>
</body>
</html>

