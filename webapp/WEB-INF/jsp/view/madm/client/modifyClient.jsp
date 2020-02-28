<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/layout/inc/tags.jspf"%>
<html>
<head>
<title>고객사 정보</title>
<script type="text/javascript" src="//ezutil.ezwel.com/resources/js/address/ez-addr.js"></script>
<script type="text/javascript">
j$(document).ready(function(){

	j$(".addrPopUp").click(function(){
		var siteUrl = '<spring:eval expression="@global['site.url']" />' + '/resources/jsp/addrSubmit.jsp';
		NEW2015_pZip(siteUrl);
		return false;
	});

	j$('.date_timepicker_openDd').datetimepicker({
		format:'Ymd',
		timepicker:false
	});

	j$("#openDdImg").click(function(){
		j$('.date_timepicker_openDd').datetimepicker('show');
	});

	j$(".onlyNumber").keyup(function() {
		j$(this).val(j$(this).val().replace(/[^0-9]/g,""));
	});

	j$("#modifyClient").validate({
		onkeyup:false,
		onclick:false,
		onfocusout:false,
		showErrors:function(errorMap, errorList){
			if (this.numberOfInvalids()) {
				alert(errorList[0].message);
			}
		},
		rules : {
			clientNm				: {required:true},
			divCd				: {required:true},
			bitem				: {required:true},
			areaCd				: {required:true},
			totEmploy				: {required:true},
			pointBringYn				: {required:true},
			contractType				: {required:true},
			joinType				: {required:true},
			loginType				: {required:true},
			useYn				: {required:true},
			openYn				: {required:true},
			menuGroup			: {required:true},
			useType				: {required:true},
			useService				: {required:true},
			useChannel				: {required:true},
			calcType				: {required:true},
			calcDd				: {required:true},
			dutyYn				: {required:true},
			taxYn				: {required:true},
			zip1				: {required:true},
			ceoNm				: {required:true},
			bsnsNum				: {required:true}
			
		},
		messages: {
			clientNm			: "고객사명을 입력하세요",
			divCd				: "고객사분류를 선택하세요",
			bitem			: "업종구분을 선택하세요",
			areaCd			: "지역구분을 선택하세요",
			totEmploy			: "인원수를 입력하세요",
			pointBringYn		: "포인트 이월 정보를 선택하세요",
			contractType		: "계약방식을 선택하세요",
			joinType			: "가입방식을 선택하세요",
			loginType			: "로그인방식을 선택하세요",
			useYn				: "사용여부를 선택하세요",
			openYn			: "오픈여부를 선택하세요",
			menuGroup		: "메뉴그룹을 선택하세요",
			useType			: "이용대상을 선택하세요",
			useService			: "이용서비스를 선택하세요",
			useChannel			: "상담채널을 선택하세요",
			calcType				: "정산주기를 선택하세요",
			calcDd					: "정산일을 입력하세요",
			dutyYn				: "과세여부를 선택하세요",
			taxYn				: "세금계산서 발행여부를 선택하세요",
			zip1				: "주소를 입력하세요",
			ceoNm				: "대표자명을 임력하세요",
			bsnsNum				: "사업자번호를 입력하세요"
		},
		submitHandler: function(form) {

			//사업자등록번호
			var regex = /[0-9]{3}\-[0-9]{2}\-[0-9]{5}/g;
			if (j$("[name='bsnsNum']").val() != "") {
				if ( !regex.test(j$("[name='bsnsNum']").val()) ) {
					alert("사업자번호는 xxx-xx-xxxxx의 형태로 작성하셔야합니다.");
					j$("[name='bsnsNum']").focus();
					return false;
				}
			}

			//전화번호
			regex =  /^(([0-9]{2,3}))-?([0-9]{3,4})-?([0-9]{4})$/;
			if (j$("[name='telNum']").val() != "") {
				if ( !regex.test(j$("[name='telNum']").val()) ) {
					alert("전호번호를 확인해주세요.");
					j$("[name='telNum']").focus();
					return false;
				}
			}
			if (j$("[name='faxNum']").val() != "") {
				if ( !regex.test(j$("[name='faxNum']").val()) ) {
					alert("팩스번호를 확인해주세요.");
					j$("[name='faxNum']").focus();
					return false;
				}
			}

			if (j$("#oldFileNm").val() == "" && j$("#file01").val() == "") {
				alert("사업자등록증을 입력해주세요.");
				j$("#file01").focus();
				return false;
			}

			form.submit();
		}
	});

	j$('#insertBtn').click(function(){
		j$.alert('등록하시겠습니까?',function(){
				j$("#modifyClient").submit();
			 },function(){
			 	return false;
			 }
	 	);
		return false;
	});

	j$('#updateBtn').click(function() {
		j$("#modifyClient").attr("action","/madm/client/modify");
		j$.alert('수정하시겠습니까?',function(){
			j$("#modifyClient").submit();
		 },function(){
		 	return false;
		 }
 	);
	return false;
	});

	j$("#cancleBtn").click(function(){
		location.href = "/madm/client/clientList";
		return false;
	});

<%--
	j$('#deleteBtn').click(function() {
		j$("#modifyClient").attr("action","/madm/client/delete");
		j$.alert('삭제하시겠습니까?',function(){
			location.href = "/madm/client/delete?clientCd=" + j$('#clientCd').val();
		 },function(){
		 	return false;
		 }
 	);
	return false;
	});
--%>
});

</script>
</head>
<body>
<form id="modifyClient" name="modifyClient"  action="/madm/client/modify" method="POST" enctype="multipart/form-data">
<input type="hidden" name="clientType" value="E">
<input type="hidden" name="oldFileNm" id="oldFileNm" value="${vo.fileNm}"/>
<input type="hidden" name="oldFilePath" id="oldFilePath" value="${vo.filePath}"/>

<!-- 버튼 영역 시작 -->
<table cellpadding="5" cellspacing="0" border="0" width="95%" style="border-bottom: 1px solid silver;">
	<tr>
		<td height="10px"></td>
	</tr>
	<tr>
		<td align="left" class="subtitle">고객사 정보</td>
	</tr>
</table>
<br/>
<!-- 버튼 영역 종료 -->

<table cellpadding="0" cellspacing="0" border="0" width="95%" height="100%">
<tr>
	<td valign="top" align="left">
		<strong>* 기본정보</strong>
		<table cellpadding="5" cellspacing="0" border="1" width="100%" style="border-collapse:collapse;">
			<tr>
				<td class="line" width="20%" height="25" align="center" bgcolor="#F5F5F5"> <span style="color:RED">* </span>고객사코드</td>
				<td width="30%" ><input type="hidden" name="clientCd" value="${vo.clientCd}" />${vo.clientCd}</td>
				<td class="line" width="20%" align="center" bgcolor="#F5F5F5"> <span style="color:RED">* </span>도메인코드</td>
				<td width="30%" ><input type="hidden" name="domainCd" value="${vo.domainCd}" />${vo.domainCd}</td>
			</tr>
			<tr>
				<td class="line" width="20%" height="25" align="center" bgcolor="#F5F5F5"> <span style="color:RED">* </span>고객사명</td>
				<td width="80%" colspan="3"><input type="text" name="clientNm" value="${vo.clientNm}" minlength="2" maxlength="50" size="50" /></td>
			</tr>
			<tr>
				<td class="line" width="20%" height="60" align="center" bgcolor="#F5F5F5"> <span style="color:RED">* </span>주소</td>
				<td width="80%" colspan="3">
					<div>
						<input type="text" name="zip1" id="zip1" value="${vo.zip1}" class="addrPopUp" id="b_zipcode01" title="우편번호 앞자리 입력" style="width:50px;" readonly > -
						<input type="text" name="zip2" id="zip2" value="${vo.zip2}" class="addrPopUp" title="우편번호 뒷자리 입력" style="width:50px;" readonly >
						<a href="#"  class="addrPopUp">우편번호 찾기</a>
					</div>
					<div class="mt" style="padding-top:10px">
						<input type="text" name="addr1" id="addr1" value="${vo.addr1}" class="addrPopUp" title="주소입력" style="width:35%;" readonly >
						<input type="text" name="addr2" id="addr2" value="${vo.addr2}" title="주소입력" style="width:55%;">
					</div>
				</td>
			</tr>
			<tr>
				<td class="line" height="25" align="center" bgcolor="#F5F5F5"> <span style="color:RED">* </span>대표자명</td>
				<td ><input type="text" name="ceoNm" value="${vo.ceoNm}" minlength="2" maxlength="50" /></td>
				<td class="line" align="center" bgcolor="#F5F5F5"> <span style="color:RED">* </span>사업자번호</td>
				<td ><input type="text" name="bsnsNum" value="${vo.bsnsNum}" minlength="4" maxlength="12" /> <span style="color:RED"> "-" 포함 </span></td>
			</tr>
			<tr>
				<td class="line" height="25" align="center" bgcolor="#F5F5F5">전화번호</td>
				<td ><input type="text" name="telNum" value="${vo.telNum}" minlength="4" maxlength="20" /> <span style="color:RED"> "-" 포함 </span></td>
				<td class="line" align="center" bgcolor="#F5F5F5">팩스번호</td>
				<td ><input type="text" name="faxNum" value="${vo.faxNum}" minlength="4" maxlength="20" /> <span style="color:RED"> "-" 포함 </span></td>
			</tr>
			<tr>
				<td class="line" height="25" align="center" bgcolor="#F5F5F5"> <span style="color:RED">* </span>고객사분류</td>
				<td >
					<select name="divCd">
						<option value="">---- 선택 ----</option>
						<c:forEach var="list" items="${divCdList}" varStatus="status">
							<option value="${list.commCd}" ${list.commCd == vo.divCd? 'selected':''}>${list.commNm}</option>
						</c:forEach>
					</select>
				</td>
				<td class="line" align="center" bgcolor="#F5F5F5"> <span style="color:RED">* </span>업종구분</td>
				<td >
					<select name="bitem">
						<option value="">---- 선택 ----</option>
						<c:forEach var="list" items="${bitemList}" varStatus="status">
							<option value="${list.commCd}" ${list.commCd == vo.bitem ? 'selected':''}>${list.commNm}</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<td class="line" height="25" align="center" bgcolor="#F5F5F5"> <span style="color:RED">* </span>지역구분</td>
				<td >
					<select name="areaCd">
						<option value="">---- 선택 ----</option>
						<c:forEach var="list" items="${areaCdList}" varStatus="status">
							<option value="${list.commCd}" ${list.commCd == vo.areaCd ? 'selected':''}>${list.commNm}</option>
						</c:forEach>
					</select>
				</td>
				<td class="line" align="center" bgcolor="#F5F5F5"> <span style="color:RED">* </span>인원수</td>
				<td ><input type="text" name="totEmploy" value="${vo.totEmploy}" minlength="1" maxlength="7" /> <span style="color:RED"> 숫자만 입력</span></td>
			</tr>
			<tr>
				<td class="line" width="20%" height="25" align="center" bgcolor="#F5F5F5"> <span style="color:RED">* </span>사업자등록증</td>
				<td width="80%" colspan="3">
					<input type="file" name="file" id="file01" size="50" /><br>
					<c:if test="${vo.filePath ne null}">
						<%-- <img alt="미리보기" src="<spring:eval expression="@global['upload.http.img']" />${vo.filePath}" style="width: 100; height: 100;"> --%>
						<a href="<spring:eval expression="@global['upload.http.img']" />${vo.filePath}" >${vo.fileNm}</a>
					</c:if>
				</td>
			</tr>
		</table>
	</td>
</tr>
<tr>
	<td height="20px"></td>
</tr>
<tr>
	<td valign="top" align="left">
		<strong>* 제도정보</strong>
		<table cellpadding="5" cellspacing="0" border="1" width="100%" style="border-collapse:collapse;">
			<tr>
				<td class="line" width="15%" height="25" align="center" bgcolor="#F5F5F5">상담포유 명칭</td>
				<td width="18%" ><input type="text" name="siteNm" value="${vo.siteNm}" minlength="2" maxlength="50" /></td>
				<td class="line" width="15%" align="center" bgcolor="#F5F5F5">포인트 명칭</td>
				<td width="19%" ><input type="text" name="pointNm" value="${vo.pointNm}" minlength="2" maxlength="30" /></td>
				<td class="line" width="15%" align="center" bgcolor="#F5F5F5"> <span style="color:RED">* </span>포인트 이월</td>
				<td width="18%" >
					<input type="radio" name="pointBringYn" value="Y" ${vo.pointBringYn == 'Y'  ? 'checked':''}> 허용
					<input type="radio" name="pointBringYn" value="N" ${vo.pointBringYn == 'N'  ? 'checked':''}> 비허용
				</td>
			</tr>
			<tr>
				<td class="line" height="25" align="center" bgcolor="#F5F5F5"> <span style="color:RED">* </span>계약방식</td>
				<td >
					<select name="contractType">
						<option value="">---- 선택 ----</option>
						<c:forEach var="list" items="${contractTypeList}" varStatus="status">
							<option value="${list.commCd}" ${list.commCd == vo.contractType ? 'selected':''}>${list.commNm}</option>
						</c:forEach>
					</select>
				</td>
				<td class="line" align="center" bgcolor="#F5F5F5"> <span style="color:RED">* </span>가입방식</td>
				<td >
					<input type="radio" name="joinType" value="I" ${vo.joinType == 'I'  ? 'checked':''}> 관리자등록
					<input type="radio" name="joinType" value="J" ${vo.joinType == 'J'  ? 'checked':''}> 회원가입
				</td>
				<td class="line" align="center" bgcolor="#F5F5F5"> <span style="color:RED">* </span>로그인방식</td>
				<td >
					<input type="radio" name="loginType" value="I" ${vo.loginType == 'I'  ? 'checked':''}> 아이디
					<input type="radio" name="loginType" value="E" ${vo.loginType == 'E'  ? 'checked':''}> 사번
				</td>
			</tr>
			<tr>
				<td class="line" height="25" align="center" bgcolor="#F5F5F5"> <span style="color:RED">* </span>사용유무</td>
				<td >
					<input type="radio" name="useYn" value="Y" ${vo.useYn == 'Y'  ? 'checked':''}> Y
					<input type="radio" name="useYn" value="N" ${vo.useYn == 'N'  ? 'checked':''}> N
				</td>
				<td class="line" align="center" bgcolor="#F5F5F5"> <span style="color:RED">* </span>오픈여부</td>
				<td >
					<input type="radio" name="openYn" value="Y" ${vo.openYn == 'Y'  ? 'checked':''}> Y
					<input type="radio" name="openYn" value="N" ${vo.openYn == 'N'  ? 'checked':''}> N
				</td>
				<td class="line" align="center" bgcolor="#F5F5F5">고객사오픈일</td>
				<td >
					<input type="text" name="openDd" id="openDd" size="10" value="${vo.openDd}" class="date_timepicker_openDd"/>
					<img id="openDdImg" src="http://img.ezwel.com/welfare_pms/images/common/icon02.jpg" border="0" />
				</td>
			</tr>
			<tr>
				<td class="line" height="25" align="center" bgcolor="#F5F5F5"> <span style="color:RED">* </span>메뉴그룹</td>
				<td >
					<select name="menuGroup">
						<option value="">---- 선택 ----</option>
						<c:forEach var="list" items="${menuGroupList}" varStatus="status">
							<option value="${list.commNm}" ${list.commNm == vo.menuGroup ? 'selected':''}>${list.commNm}</option>
						</c:forEach>
					</select>
				</td>
				<td class="line" align="center" bgcolor="#F5F5F5"> <span style="color:RED">* </span>EMS 발송여부</td>
				<td >
					<input type="radio" name="emsRecvYn" value="Y" ${vo.emsRecvYn == 'Y'  ? 'checked':''}> Y
					<input type="radio" name="emsRecvYn" value="N" ${vo.emsRecvYn == 'N'  ? 'checked':''}> N
				</td>
				<td class="line" align="center" bgcolor="#F5F5F5"> <span style="color:RED">* </span>SMS 발송여부</td>
				<td >
					<input type="radio" name="smsRecvYn" value="Y" ${vo.smsRecvYn == 'Y'  ? 'checked':''}> Y
					<input type="radio" name="smsRecvYn" value="N" ${vo.smsRecvYn == 'N'  ? 'checked':''}> N
				</td>
			</tr>
			<tr>
				<td class="line" height="25" align="center" bgcolor="#F5F5F5"> <span style="color:RED">* </span>현금영수증 포인트 발급여부</td>
				<td >
					<input type="radio" name="receiptPointYn" value="Y" ${vo.receiptPointYn == 'Y'  ? 'checked':''}> Y
					<input type="radio" name="receiptPointYn" value="N" ${vo.receiptPointYn == 'N'  ? 'checked':''}> N
				</td>
				<td class="line" align="center" bgcolor="#F5F5F5"> <span style="color:RED">* </span>현금영수증 계좌이체 발급여부</td>
				<td >
					<input type="radio" name="receiptAccountYn" value="Y" ${vo.receiptAccountYn == 'Y'  ? 'checked':''}> Y
					<input type="radio" name="receiptAccountYn" value="N" ${vo.receiptAccountYn == 'N'  ? 'checked':''}> N
				</td>
				<td class="line" align="center" bgcolor="#F5F5F5"><span style="color:RED">* </span>모바일 고객사 여부</td>
				<td >
					<input type="radio" name="mobileYn" value="Y" ${vo.mobileYn == 'Y'  ? 'checked':''}> Y
					<input type="radio" name="mobileYn" value="N" ${vo.mobileYn == 'N'  ? 'checked':''}> N
				</td>
			</tr>
			<tr>
				<td class="line" height="25" align="center" bgcolor="#F5F5F5"> 결제수단 명칭</td>
				<td colspan="5">
					<input type="text" name="payNm" value="${vo.payNm}" maxlength="30" />
					<span style="color:RED">상담포유 결제단위 명칭에 사용됩니다. 입력하지 않을 경우 '원'으로 표시됩니다.</span>
				</td>
			</tr>
		</table>
	</td>
</tr>
<tr>
	<td height="60px">
		&nbsp;&nbsp;<b>* 사용유무 설정 : </b>사용유무를 N으로 설정하면 상담포유 안내 페이지가 노출 됩니다.<br>
		&nbsp;&nbsp;<b>* 오픈여부 설정 : </b>오픈여부를 N으로 설정하면 테스트 아이디만 로그인이 가능합니다.
	</td>
</tr>
<tr>
	<td valign="top" align="left">
		<strong>* 이용정보</strong>
		<table cellpadding="5" cellspacing="0" border="1" width="100%" style="border-collapse:collapse;">
			<tr>
				<td class="line" width="20%" height="25" align="center" bgcolor="#F5F5F5"> <span style="color:RED">* </span>이용대상</td>
				<td width="80%" >
					<c:forEach var="list" items="${useTypeList}" varStatus="status">
						<input type="checkbox" name="useType" value="${list.commCd}" ${fn:indexOf(vo.useType,list.commCd) > -1 ? 'checked' : ''} />${list.commNm}
					</c:forEach>
				</td>
			</tr>
			<tr>
				<td class="line" height="25" align="center" bgcolor="#F5F5F5"> <span style="color:RED">* </span>이용서비스</td>
				<td >
					<c:forEach var="list" items="${useServiceList}" varStatus="status">
						<input type="checkbox" name="useService" value="${list.commCd}" ${fn:indexOf(vo.useService,list.commCd) > -1 ? 'checked' : ''} />${list.commNm}
					</c:forEach>
				</td>
			</tr>
			<tr>
				<td class="line" height="25" align="center" bgcolor="#F5F5F5"> <span style="color:RED">* </span>상담채널</td>
				<td >
					<c:forEach var="list" items="${useChannelList}" varStatus="status">
						<input type="checkbox" name="useChannel" value="${list.commCd}" ${fn:indexOf(vo.useChannel,list.commCd) > -1 ? 'checked' : ''} />${list.commNm}
					</c:forEach>
				</td>
			</tr>
		</table>
	</td>
</tr>
<tr>
	<td height="20px"></td>
</tr>

<tr>
	<td valign="top" align="left">
		<strong>* 계약정보</strong>
		<table cellpadding="5" cellspacing="0" border="1" width="100%" style="border-collapse:collapse;">
			<tr>
				<td class="line" width="15%" height="25" align="center" bgcolor="#F5F5F5">제도운영 담당자 A</td>
				<td width="18%" >
					<select name="mgrId">
						<option value="">---- 선택 ----</option>
						<c:forEach var="list" items="${mgrList}" varStatus="status">
							<option value="${list.userId}" ${list.userId == vo.mgrId ? 'selected':''}>${list.userNm}</option>
						</c:forEach>
					</select>
				</td>
				<td class="line" width="15%" height="25" align="center" bgcolor="#F5F5F5">제도운영 담당자 B</td>
				<td width="18%" >
					<select name="counselMgrId">
						<option value="">---- 선택 ----</option>
						<c:forEach var="list" items="${mgrList}" varStatus="status">
							<option value="${list.userId}" ${list.userId == vo.counselMgrId ? 'selected':''}>${list.userNm}</option>
						</c:forEach>
					</select>
				</td>
				<td class="line" width="15%" align="center" bgcolor="#F5F5F5">계약금</td>
				<td width="19%" >
					<input type="text" name="budget" class="onlyNumber" maxlength="10" value="${vo.budget}"/>
				</td>
			</tr>
			<tr>
				<td class="line" width="15%" align="center" bgcolor="#F5F5F5">계약사항</td>
				<td colspan="5">
					<textarea rows="5" cols="10" id="ir1" name="memo" style="width:100%; height:100px;">${vo.memo} </textarea>
					
				</td>
			</tr>
		</table>
	</td>
</tr>
<tr>
	<td height="20px"></td>
</tr>


<tr>
	<td valign="top" align="left">
		<strong>* 정산정보</strong>
		<table cellpadding="5" cellspacing="0" border="1" width="100%" style="border-collapse:collapse;">
			<tr>
				<td class="line" width="15%" height="25" align="center" bgcolor="#F5F5F5"> <span style="color:RED">* </span>정산주기</td>
				<td width="18%" >
					<select name="calcType">
						<option value="">---- 선택 ----</option>
						<c:forEach var="list" items="${calcTypeList}" varStatus="status">
							<option value="${list.commCd}" ${list.commCd == vo.calcType ? 'selected':''}>${list.commNm}</option>
						</c:forEach>
					</select>
					<input type="text" name="calcDd" value="${vo.calcDd}" minlength="1" maxlength="2" size="3" />일
				</td>
				<td class="line" width="15%" align="center" bgcolor="#F5F5F5"> <span style="color:RED">* </span>과세여부</td>
				<td width="19%" >
					<input type="radio" name="dutyYn" value="Y" ${vo.dutyYn == 'Y'  ? 'checked':''}> 과세
					<input type="radio" name="dutyYn" value="N" ${vo.dutyYn == 'N'  ? 'checked':''}> 면세
				</td>
				<td class="line" width="15%" align="center" bgcolor="#F5F5F5"> <span style="color:RED">* </span>세금계산서 발행</td>
				<td width="18%" >
					<input type="radio" name="taxYn" value="Y" ${vo.taxYn == 'Y'  ? 'checked':''}> 발행
					<input type="radio" name="taxYn" value="N" ${vo.taxYn == 'N'  ? 'checked':''}> 미발행
				</td>
			</tr>
		</table>
	</td>
</tr>
<tr>
	<td height="60px">
		&nbsp;&nbsp;<b>* 상담포유(사용자) : </b>(ID)32827980 / (PW)1230987<br>
		&nbsp;&nbsp;<b>* 상담포유(고객사관리자) : </b>(ID)고객사코드 / (PW)1230987
	</td>
</tr>
<tr>
	<td>
		<table cellpadding="5" cellspacing="0" border="0" width="100%" style="border-collapse:collapse;">
			<tr align="center" height="50px">
				<td class="" colspan="2" align="center">
					<input type="button" id="updateBtn" value="수정" style="height:30px; width:100px;">
					<span style="margin-left: 20px;"></span>
					<input type="button" id="cancleBtn" value="취소" style="height:30px; width:100px;">
				</td>
			</tr>
		</table>
	</td>
</tr>
</table>
</form>

</body>
</html>

