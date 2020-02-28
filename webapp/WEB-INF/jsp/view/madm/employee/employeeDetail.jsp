<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/layout/inc/tags.jspf"%>
<html>
<head>
<title>임직원관리</title>
<script type="text/javascript">
var clientCd = "${vo.clientCd }";

j$(document).ready(function(){
		var code1 = $("[name='inter1']").attr('value');
		var element1 = "";
		$.ajax({
			url: "/madm/employeeManagement/getCategory?userKey="+${vo.userKey }+"&highCode=" + code1,
			dataType: 'json',
			success: function (response) {
	
				var iter = response.inter;
				element1 += "<td>";
				if(iter.length==0){
					element1 += " - ";
				}
				
				for (var i=0; i<iter.length; i++) {
					if(i!=0){
						element1 += ", ";	
					}
					element1 += iter[i].interestNm ;
				}
				element1 += "</td>";
				
				if (element1 != "") {
					$("[name='inter1']").append(element1);
				}
			}
		});
		
		var code2 = $("[name='inter2']").attr('value');
		var element2 = "";
		$.ajax({
			url: "/madm/employeeManagement/getCategory?userKey="+${vo.userKey }+"&highCode=" + code2,
			dataType: 'json',
			success: function (response) {
	
				var iter = response.inter;
				element2 += "<td>";
				if(iter.length==0){
					element2 += " - ";
				}
				for (var i=0; i<iter.length; i++) {
					if(i!=0){
						element2 += ", ";
					}
					element2 += iter[i].interestNm ;
				}
				element2 += "</td>";
				
				if (element2 != "") {
					$("[name='inter2']").append(element2);
				}
			}
		});
		
		var code3 = $("[name='inter3']").attr('value');
		var element3 = "";
		$.ajax({
			url: "/madm/employeeManagement/getCategory?userKey="+${vo.userKey }+"&highCode=" + code3,
			dataType: 'json',
			success: function (response) {
	
				var iter = response.inter;
				element3 += "<td>";
				if(iter.length==0){
					element3 += " - ";
				}
				for (var i = 0; i < iter.length; i++) {
					if(i!=0){
						element3 += ", ";	
					}
					element3 += iter[i].interestNm ;
				}
				element3 += "</td>";
				
				if (element3 != "") {
					$("[name='inter3']").append(element3);
				}
			}
		});
		
		var code4 = $("[name='inter4']").attr('value');
		var element4 = "";
		$.ajax({
			url: "/madm/employeeManagement/getCategory?userKey="+${vo.userKey }+"&highCode=" + code4,
			dataType: 'json',
			success: function (response) {
	
				var iter = response.inter;
				element4 += "<td>";
				if(iter.length==0){
					element4 += " - ";
				}
				for (var i = 0; i < iter.length; i++) {
					if(i!=0){
						element4 += ", ";	
					}
					element4 += iter[i].interestNm ;
				}
				element4 += "</td>";
				
				if (element4 != "") {
					$("[name='inter4']").append(element4);
				}
			}
		});
		
		
		j$(".listBtn").click(function(){
			j$("#employeeDetailForm").submit();
		});
		
		
		/**
		 * 임직원 정보 수정
		 */
		$("#btnUpdateUser").click(function () {
			var params = {};
			
			var gender 		= $("#gender").val();
			var rrn 			= $("#rrn").val();
			var userKey 		= $("#userKey").val();
			var branchCd 	= $("#branchCd").val();
			var deptCd		= $("#deptCd").val();
			var teamCd 		= $("#teamCd").val();
			var partCd 		= $("#partCd").val();
			var gradeCd 	= $("#gradeCd").val();
			var homeTel1 	= $("#homeTel1").val();
			var homeTel2 	= $("#homeTel2").val();
			var homeTel3 	= $("#homeTel3").val();
			var mobile1 		= $("#mobile1").val();
			var mobile2		= $("#mobile2").val();
			var mobile3 		= $("#mobile3").val();
			var userStatus 	= $("#userStatus").val();
			var email1 		= $("#email1").val();
			var email2 		= $("#email2").val();
			var clientMgrYn 		= $("#clientMgrYn").val();
			
			if (gender == "") {
				alert("성별을 선택해주세요."); 
				return;
			}
			
			if (rrn == "") {
				alert("주민번호 앞 6자리를 입력해주세요."); 
				return;
			}

			// 전화번호
			if(homeTel1 != "" || homeTel2 != "" || homeTel3 != "") {
				$("#homeTel").val(homeTel1+"-"+homeTel2+"-"+homeTel3);
				 
				var regex =  /^0([0-9])-?([0-9]{3,4})-?([0-9]{4})$/;
				if ( !regex.test($("#homeTel").val()) ) {
					alert("연락처를 확인해주세요.");
					$("#homeTel1").focus();
					return false;
				}
			}
			
			// 휴대폰 번호
			if(mobile1 != "" || mobile2 != "" || mobile3 != "") {
				$("#mobile").val(mobile1+"-"+mobile2+"-"+mobile3);
				 
				var regex = /^01([0|1|6|7|8|9]?)-?([0-9]{3,4})-?([0-9]{4})$/;
				if ( !regex.test($("#mobile").val()) ) {
					alert("휴대폰번호를 확인해주세요.");
					$("#mobile1").focus();
					return false;
				}
			}

			// 이메일
			if(email1 != "" || email2 != "") {
				$("#email").val(email1+"@"+email2);
			}
			 

			var homeTel = $("#homeTel").val();
			var mobile 	= $("#mobile").val();
			var email 	= $("#email").val();
			
			params.gender 		= gender;
			params.rrn 			= rrn;
			params.userKey 		= userKey;
			params.branchCd 	= branchCd;
			params.deptCd 		= deptCd;
			params.teamCd 		= teamCd;
			params.partCd 		= partCd;
			params.gradeCd 	= gradeCd;
			params.homeTel 	= homeTel;
			params.mobile 		= mobile;
			params.userStatus	= userStatus;
			params.email			= email;
			params.clientMgrYn	= clientMgrYn;
			
			if( confirm("입력하신 임직원 정보는 고객사관리자 통계에 연동됩니다. \n입력된 정보가 잘 입력되었는지 확인하세요. \n\n확인버튼을 누르면 정보가 수정됩니다.") ){
				$.ajax({
					url: '/madm/counsel/updateEmpInfo',
					data: params,
					dataType: 'json',
					type: 'post',
					success: function(data) {
						if (data.resultValue == "1") {
							alert("임직원 정보를 수정하였습니다.\n페이지가 새로고침 됩니다.");
							window.location.reload(true); // 페이지 새로고침
						} else {
							alert("실패하였습니다.")
						}
					}
				});
			}
		});
		
		
		
		/**
		 * 임직원 정보 수정
		 */
		$("#btnUpdateIntake").click(function () {
			var params = {};

			var intakeCd		= $("#intakeCd").val();
			var relation 		= $("#intakeRelation").val();
			var rrn 			= $("#intakeRrn").val();
			var gender 		= $("#intakeGender").val();
			var counselNm 	= $("#intakeCounselNm").val();
			var education	= $("#intakeEducation").val();
			var session 		= $("#intakeSession").val();
			var job	 		= $("#intakeJob").val();
			var counselDiv 	= $("#intakeCounselDiv").val();
			var counselType	= $("#intakeCounselType").val();
			var cause 		= $("#intakeCause").val();
			var mobile1 		= $("#intakeMobile1").val();
			var mobile2		= $("#intakeMobile2").val();
			var mobile3 		= $("#intakeMobile3").val();
			var email1 		= $("#intakeEmail1").val();
			var email2 		= $("#intakeEmail2").val();
			var memo 		= $("#intakeMemo").val().replace(/\n/g, "<br>");
			
			// 휴대폰 번호
			if(mobile1 == "" || mobile2 == "" || mobile3 == "") {
				alert("휴대폰번호를 입력해주세요");
				$("#intakeMobile1").focus();
				return false;
			}else{
				$("#intakeMobile").val(mobile1+"-"+mobile2+"-"+mobile3);
				 
				var regex = /^01([0|1|6|7|8|9]?)-?([0-9]{3,4})-?([0-9]{4})$/;
				if ( !regex.test($("#intakeMobile").val()) ) {
					alert("휴대폰번호를 확인해주세요.");
					$("#intakeMobile1").focus();
					return false;
				}
			}

			// 이메일
			if(email1 == "" || email2 == "") {
				 alert("이메일을 입력해주세요");
				 return false;
			}else{
				$("#intakeEmail").val(email1+"@"+email2);
			}
			 

			var mobile 	= $("#intakeMobile").val();
			var email 	= $("#intakeEmail").val();
			
			params.intakeCd 	= intakeCd;
			params.relation 		= relation;
			params.rrn 			= rrn;
			params.gender 		= gender;
			params.counselNm 	= counselNm;
			params.education 	= education;
			params.session 		= session;
			params.job 			= job;
			params.counselDiv 	= counselDiv;
			params.counselType= counselType;
			params.cause		= cause;
			params.mobile		= mobile;
			params.email			= email;
			params.memo		= memo;
			
			if( confirm("입력된 정보로 수정하시겠습니까? \n\n확인버튼을 누르면 인테이크정보가 수정됩니다.") ){
				$.ajax({
					url: '/madm/counsel/updateIntakeInfo',
					data: params,
					dataType: 'json',
					type: 'post',
					success: function(data) {
						if (data.resultValue == "1") {
							alert("인테이크정보를 수정하였습니다.\n페이지가 새로고침 됩니다.");
							window.location.reload(true); // 페이지 새로고침
						} else {
							alert("실패하였습니다.")
						}
					}
				});
			}
		});
		
		
	// 인테이크 상담방법 수정 불가능하도록 변경처리 #20190417	
	<c:if test="${not empty intake_detail }">
	$("#intakeCounselType").prop("disabled", true);
	$("#intakeCounselType").css("background-color", "#ccc");
	</c:if>
}); // END READY

function branchCdChange(){
	$("select[name='deptCd'] option").remove();   
	$("select[name='teamCd'] option").remove();
	$("select[name='partCd'] option").remove();
	$("[name='deptCd']").append("<option value=''>선택해주세요.</option>");
	$("[name='teamCd']").append("<option value=''>선택해주세요.</option>");
	$("[name='partCd']").append("<option value=''>선택해주세요.</option>");
	var name 	= "branchCd";
	var setName = "deptCd";
	var cnt = getCommClientCdList(name, setName, clientCd);
}

function deptCdChange(){
	j$("select[name='teamCd'] option").remove();
	j$("select[name='partCd'] option").remove();
	j$("[name='teamCd']").append("<option value=''>선택해주세요.</option>");
	j$("[name='partCd']").append("<option value=''>선택해주세요.</option>");
	var name 	= "deptCd";
	var setName = "teamCd";
	var cnt = getCommClientCdList(name, setName, clientCd);
}

function teamCdChange(){
	j$("select[name='partCd'] option").remove();
	j$("[name='partCd']").append("<option value=''>선택해주세요.</option>");
	var name 	= "teamCd";
	var setName = "partCd";
	var cnt = getCommClientCdList(name, setName, clientCd);
}

function getCommClientCdList(name, setName) {
	var result = 0;
	if ($("[name='"+name+"']").val() != "" && $("[name='"+name+"']").val() != null) {
		$.ajax({
			url: "/madm/common/getCommClientList?highCommCd=" + $("[name='"+name+"']").val() + "&clientCd=${vo.clientCd }",
			dataType: 'json',
			async: false,
			success: function (response) {
				var iter = response.list;
				var element = "";
				result = iter.length;
				for (var i = 0; i < iter.length; i++) {
					element += "<option value='" + iter[i].commCd + "'>" + iter[i].commNm + "</option>";
				}
				if (element != "") {
					$("[name='"+setName+"']").append(element);
				}
			}
		});
	}
	
	return result;
}
</script>
</head>
<body>

<table cellpadding="0" align="left" cellspacing="0" border="0" width="95%">
	<tr>
		<td>
			<table cellpadding="0" cellspacing="0" border="0" width="100%">
				<tr>
					<td height="20px"></td>
				</tr>
				<tr>
					<td align="left" class="subtitle">임직원관리</td>
				</tr>
				<tr>
					<td height="10px"></td>
				</tr>
				<tr>
					<td align="left">
						<c:if test="${not empty user.ipinDi }">
		    				<span>※ 인증이 완료된 회원입니다.</span>
		    			</c:if>
		    			<c:if test="${empty user.ipinDi }">
		    				<span style="color:red;">※ 인증을 하지 않은 회원입니다.</span>
		    			</c:if> 
						<br><span  style="color:red;">
							※ 고객사, 유저키, 이름, 아이디/사번은 변경 할 수 없습니다.<br>
							※ 임직원 정보는 고객사관리자 통계에 반영됩니다. </span>
					</td>
				</tr>
				<tr>
					<td height="10px"></td>
				</tr>
				<tr>
					<td>
						<table cellpadding="5" cellspacing="0" border="1" width="100%" style="border-collapse:collapse;" bordercolor="#DDDDDD">
							<tr align="left" height="30px">
								<td bgcolor="#F5F5F5" align="center" width="11%"><strong>고객사명</strong></td>
						    	<td align="left" width="23%">${vo.clientNm }</td>
						    	<td bgcolor="#F5F5F5" align="center" width="11%"><strong>이름</strong></td>
						    	<td align="left" width="auto;" colspan="3">${vo.userNm }</td>
						    	<%-- <td bgcolor="#F5F5F5" align="center" width="11%"><strong>이름</strong></td>
						    	<td align="left" width="23%">${vo.userNm }</td> --%>
							</tr>
							<tr align="left" height="30px">
								<td bgcolor="#F5F5F5" align="center"><strong>유저키</strong></td>
						    	<td align="left">${vo.userKey }<input type="hidden" name="userKey" id="userKey" value="${vo.userKey }"></td>
						    	<td bgcolor="#F5F5F5" align="center"><strong>아이디/사번</strong></td>
						    	<td align="left" colspan="3">${vo.userId } (${vo.empNum })</td>
							</tr>
							<tr align="left" height="30px">
								<td bgcolor="#F5F5F5" align="center"><strong>주민번호 앞 7자리</strong></td>
						    	<td colspan="3" align="left">
						    		<input type="text" name="rrn" id="rrn" value="${vo.rrn }" maxlength="8" />
						    		ex) 81년 1월 1일생 남자의 경우 : <b>810101-1</b>  81년 1월 1일생 여자의 경우 : <b>810101-2</b>
						    	</td>
						    	<td bgcolor="#F5F5F5" align="center"><strong>고객사 담당자 여부</strong></td>
						    	<td align="left">
						    		<select name="clientMgrYn" id="clientMgrYn">
						    			<option value="">-- 선택 --</option>
						    			<option value="Y" <c:if test="${vo.clientMgrYn eq 'Y' }"> selected </c:if>>Y</option>
						    			<option value="N" <c:if test="${vo.clientMgrYn eq 'N' }"> selected </c:if>>N</option>
						    		</select>
						    	</td>
							</tr>
							
							<tr align="left" height="30px">
								<td bgcolor="#F5F5F5" align="center"><strong>전화번호</strong></td>
						    	<td align="left">
						    		<input type="hidden" name="homeTel" id="homeTel" value="${vo.homeTel }">
									<input type="text" id="homeTel1" size="5" value="${fn:split(vo.homeTel,'-')[0]}">
									<input type="text" id="homeTel2" maxlength="4" size="5" value="${fn:split(vo.homeTel,'-')[1]}">
									<input type="text" id="homeTel3" maxlength="4" size="5" value="${fn:split(vo.homeTel,'-')[2]}">
						    	</td>
						    	<td bgcolor="#F5F5F5" align="center"><strong>휴대폰</strong></td>
						    	<td align="left">
						    		<input type="hidden" name="mobile" id="mobile" value="${vo.mobile }">
									<input type="text" id="mobile1" maxlength="3" size="5" value="${fn:split(vo.mobile,'-')[0]}">
									<input type="text" id="mobile2" maxlength="4" size="5" value="${fn:split(vo.mobile,'-')[1]}">
									<input type="text" id="mobile3" maxlength="4" size="5" value="${fn:split(vo.mobile,'-')[2]}">
						    	</td>
						    	<td bgcolor="#F5F5F5" align="center"><strong>이메일</strong></td>
						    	<td align="left">
						    		<input type="hidden" name="email" id="email" value="${vo.email }">
									<input type="text" name="email1" id="email1" class="box" style="width:83px;" value="${fn:split(vo.email,'@')[0]}" > @ 
									<input type="text" name="email2" id="email2" class="box" style="width:83px; margin-left:10px;" value="${fn:split(vo.email,'@')[1]}" ><br>
						    	</td>
							</tr>
							<tr align="left" height="30px">
								<td bgcolor="#F5F5F5" align="center"><strong>성별</strong></td>
						    	<td align="left">
						    		<select name="gender" id="gender">
						    			<option value="">-- 선택 --</option>
						    			<option value="M" <c:if test="${vo.gender eq 'M' }"> selected </c:if> >남성</option>
						    			<option value="F"  <c:if test="${vo.gender eq 'F' }"> selected </c:if> >여성</option>
						    		</select>
						    	</td>
						    	<td bgcolor="#F5F5F5" align="center"><strong>직급/직책</strong></td>
						    	<td align="left">
						    		<commClient:select name="gradeCd" id="gradeCd" code="100006" clientCd="${vo.clientCd }" selectValue="${vo.gradeCd}" basicValue="선택" />
						    	</td>
						    	<td bgcolor="#F5F5F5" align="center"><strong>재직상태</strong></td>
						    	<td align="left">
						    		<commClient:select name="userStatus" id="userStatus" code="100001" clientCd="${vo.clientCd }" selectValue="${vo.userStatus}" basicValue="선택" />
						    	</td>
							</tr>
							<tr align="left" height="30px">
								<td bgcolor="#F5F5F5" align="center"><strong>소속</strong></td>
						    	<td align="left" colspan="5">
									<commClient:select name="branchCd" 	id="branchCd" 	clientCd="${vo.clientCd }" code="100002" onchange="branchCdChange();" selectValue="${vo.branchCd}" basicValue="선택해주세요." />
									<commClient:select name="deptCd" 		id="deptCd" 		clientCd="${vo.clientCd }" code="${vo.branchCd}" onchange="deptCdChange();" selectValue="${vo.deptCd}" basicValue="선택해주세요." />
									<commClient:select name="teamCd"		id="teamCd" 	clientCd="${vo.clientCd }" code="${vo.deptCd}" onchange="teamCdChange();" selectValue="${vo.teamCd}" basicValue="선택해주세요." />
									<commClient:select name="partCd" 		id="partCd" 		clientCd="${vo.clientCd }" code="${vo.teamCd}" selectValue="${user.partCd}" basicValue="선택해주세요." />
						    	</td>
							</tr>
							<tr align="left" height="30px">
								<td bgcolor="#F5F5F5" align="center"><strong>주소</strong></td>
						    	<td colspan="5" align="left">${vo.addr1 } ${vo.addr2 }</td>
							</tr>
							<tr align="left" height="30px">
								<td bgcolor="#F5F5F5" align="center"><strong>사용한도</strong></td>
						    	<td colspan="5" align="left">개인 한도 : ${ceiling}<br> 개인 잔여한도 : ${privateRemainPoint}<br> 고객사 잔여한도 : ${clientRemainPoint}</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td height="20px"></td>
				</tr>
				<tr>
					<td height="20px">
						<!-- 버튼 영역 시작 -->
						<table cellpadding="5" cellspacing="0" border="0" width="100%" style="border-collapse:collapse;" bordercolor="#DDDDDD">
							<tr>
								<td align="center" >
									<table cellpadding="0" cellspacing="0" border="0">
										<tr>
								    		<td id="btn01"><a href="#"><span id="btnUpdateUser">임직원 정보 수정</span></a></td>
						    			</tr>
						    		</table>
						    	</td>
							</tr>
						</table>
						<!-- 버튼 영역 종료 -->
					</td>
				</tr>
				<tr>
					<td height="20px"></td>
				</tr>
				
			<c:if test="${not empty intake_detail }">
				<tr>
					<td align="left" class="subtitle">인테이크</td>
				</tr>
				<tr>
					<td height="10px"></td>
				</tr>
				<tr>
					<table cellpadding="5" cellspacing="0" border="1" width="100%" style="border-collapse:collapse;" bordercolor="#DDDDDD">
						<tr align="left" height="30px" >
							<th class="line" align="center" width="10%">상담 받을 분</th>
							<td width="20%">
								<input type="hidden" name="intakeCd" id="intakeCd" value="${intakeCd }" />
								<comm:select name="intakeRelation" id="intakeRelation" code="100440" selectValue="${intake_detail.relation}" basicValue="--  선택  --" />
							</td>
							<th class="line" align="center" width="10%">생년월일</th>
							<td width="20%">
					    		<input type="text" name="intakeRrn" id="intakeRrn" value="${intake_detail.rrn }" />
					    		<br>ex) 81년 1월 1일생 남자의 경우 : <b>1981-01-01</b>
							</td>
							<th class="line" align="center" width="10%">성별</th>
							<td width="auto;">
					    		<select name="intakeGender" id="intakeGender">
					    			<option value="">-- 선택 --</option>
					    			<option value="M" <c:if test="${intake_detail.gender eq '남' }"> selected </c:if> >남성</option>
					    			<option value="F"  <c:if test="${intake_detail.gender eq '여' }"> selected </c:if> >여성</option>
					    		</select>
							</td>
						</tr>
						<tr align="left" height="30px" >
							<th class="line" align="center">성명</th>
							<td>
					    		<input type="text" name="intakeCounselNm" id="intakeCounselNm" value="${intake_detail.counselNm }" />
							</td>
							<th class="line" align="center">학력/학년</th>
							<td>
								<comm:select name="intakeEducation" id="intakeEducation" code="100597" selectValue="${intake_detail.education}" basicValue="--  선택  --" />
								&nbsp; <comm:select name="intakeSession" id="intakeSession" code="100614" selectValue="${intake_detail.session}" basicValue="--  선택  --" />
							</td>
							<th class="line" align="center">직업</th>
							<td>
								<comm:select name="intakeJob" id="intakeJob" code="100627" selectValue="${intake_detail.job}" basicValue="--  선택  --" />
							</td>
						</tr>
						<tr align="left" height="30px" >
							<th class="line" align="center">휴대전화</th>
							<td>
					    		<input type="hidden" name="intakeMobile" id="intakeMobile" value="${intake_detail.mobile }">
								<input type="text" id="intakeMobile1" maxlength="3" size="5" value="${fn:split(intake_detail.mobile,'-')[0]}">
								<input type="text" id="intakeMobile2" maxlength="4" size="5" value="${fn:split(intake_detail.mobile,'-')[1]}">
								<input type="text" id="intakeMobile3" maxlength="4" size="5" value="${fn:split(intake_detail.mobile,'-')[2]}">
							</td>
							<th class="line" align="center">이메일</th>
							<td>
					    		<input type="hidden" name="intakeEmail" id="intakeEmail" value="${intake_detail.email }">
								<input type="text" name="intakeEmail1" id="intakeEmail1" class="box" style="width:83px;" value="${fn:split(intake_detail.email,'@')[0]}" > @ 
								<input type="text" name="intakeEmail2" id="intakeEmail2" class="box" style="width:83px; margin-left:10px;" value="${fn:split(intake_detail.email,'@')[1]}" ><br>
							</td>
							<th class="line" align="center">상담분야</th>
							<td>
								<comm:categorySelect name="intakeCounselDiv" id="intakeCounselDiv" code="100001" selectValue="${intake_detail.counselDiv}" basicValue="--  선택  --" />
							</td>
						</tr>
						<tr align="left" height="30px" >
							<th class="line" align="center">상담방법</th>
							<td>
								<comm:select name="intakeCounselType" id="intakeCounselType" code="100432" selectValue="${intake_detail.counselType}" basicValue="--  선택  --" />
							</td>
							<th class="line" align="center">상담 세부주제</th>
							<td colspan="3">
								<input type="text" name="intakeCause" id="intakeCause" value="${intake_detail.cause }"  size="100"/>
							</td>
						</tr>
						<tr align="left" height="30px" >
							<th class="line" align="center">자유기술</th>
							<td colspan="5">	
								<textarea rows="5" cols="150" name="intakeMemo" id="intakeMemo"  >${intake_detail.memo }</textarea>
							</td>
						</tr>
					</table>
				</tr>
				<!-- 인테이크 테이블 끝-->
				<tr>
					<td height="20px"></td>
				</tr>
				<tr>
					<td height="20px">
						<!-- 버튼 영역 시작 -->
						<table cellpadding="5" cellspacing="0" border="0" width="100%" style="border-collapse:collapse;" bordercolor="#DDDDDD">
							<tr>
								<td align="center" >
									<table cellpadding="0" cellspacing="0" border="0">
										<tr>
								    		<td id="btn01"><a href="#"><span id="btnUpdateIntake">인테이크 정보 수정</span></a></td>
						    			</tr>
						    		</table>
						    	</td>
							</tr>
						</table>
						<!-- 버튼 영역 종료 -->
					</td>
				</tr>
				<tr>
					<td height="20px"></td>
				</tr>
			</c:if>
				
				
				
				
				<tr>
					<td align="left" class="subtitle">동의정보</td>
				</tr>
				<tr>
					<td height="10px"></td>
				</tr>
				<tr>
					<td>
						<table cellpadding="5" cellspacing="0" border="1" width="100%" style="border-collapse:collapse;" bordercolor="#DDDDDD">
							<tr align="left" height="30px">
								<td bgcolor="#F5F5F5" align="center" width="25%" style="width: 50px;" >
									<%-- <strong>${agree.agreeNm }</strong> --%>
									<strong>개인정보활용 동의</strong>
								</td>
								<td align="left" width="75%"><strong>${agree.agree==null ? "-": agree.agree} &nbsp; ${agree.agreeDt }</strong></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td height="20px"></td>
				</tr>
				<tr>
					<td align="left" class="subtitle">관심카테고리</td>
				</tr>
				<tr>
					<td height="10px"></td>
				</tr>
				<tr>
					<td>
						<table cellpadding="5" cellspacing="0" border="1" width="100%" style="border-collapse:collapse;" bordercolor="#DDDDDD">
							<tr align="left" height="30px">
								<td bgcolor="#F5F5F5" align="center" width="25%"><strong>힐링/스트레스관리/프로그램</strong></td>
								<td align="left" name="inter1" value="100527"  width="75%"></td>
							</tr>
							<tr align="left" height="30px">
								<td bgcolor="#F5F5F5" align="center"><strong>업무능력/직장</strong></td>
								<td align="left" name="inter2" value="100528" ></td>
							</tr>
							<tr align="left" height="30px">
								<td bgcolor="#F5F5F5" align="center"><strong>가족문제/양육문제/부부문제</strong></td>
								<td align="left" name="inter3" value="100529" ></td>
							</tr>
							<tr align="left" height="30px">
								<td bgcolor="#F5F5F5" align="center"><strong>신체건강/정신건강/생활습관</strong></td>
								<td align="left" name="inter4" value="100530" ></td>
							</tr>
						</table>
					</td>
				</tr>
				
				<tr>
				<td>
					<!-- 버튼 영역 시작 -->
						<table cellpadding="5" cellspacing="0" border="0" width="100%" style="border-collapse:collapse;" bordercolor="#DDDDDD">
							<tr>
								<td align="center" colspan="4">
									<table cellpadding="0" cellspacing="0" border="0">
										<tr>
							    		<td id="btn01"><a href="#"><span class="listBtn">목 록</span></a></td>
					    			</tr>
					    		</table>
					    	</td>
						</tr>
					</table>
					<!-- 버튼 영역 종료 -->
				</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</body>
</html>