<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/layout/inc/tags.jspf"%>
<html>
<head>
<title>상담비 정산</title>
<script type="text/javascript">
$(document).ready(function(){	
	
	$('.checkboxAll').click(function() {
		if($('.checkboxAll').is(':checked') == true){
			$('.selectPayCheck').prop("checked", true);
		}else{
			$('.selectPayCheck').prop("checked", false);
		}
		
	});
	
	$("#searchBtn").click(function(){
		j$("#searchWaitList").submit();
		return false;
	});
	
	$("#updatePaycheckConfirmBtn").click(function(){
		if(confirm("수정하시겠습니까?")){
			var params = {};
			var writeMonth 			= $("input[name='writeMonth']").val();
			var writeDay 			= $("input[name='writeDay']").val();
			var issueMonth 			= $("input[name='issueMonth']").val();
			var issueDay 			= $("input[name='issueDay']").val();
			var issueHour 			= $("input[name='issueHour']").val();
			var email 				= $("input[name='email']").val();

			params.writeMonth 		= writeMonth;
			params.writeDay 		= writeDay;
			params.issueMonth 		= issueMonth;
			params.issueDay 		= issueDay;
			params.issueHour 		= issueHour;
			params.email 			= email;
			
			$.ajax({
				url: "/partner/payCheckMgr/updatePaycheckConfirm",
				data: params,
				dataType: 'json',
				success: function (response) {
					var resultCnt = response.resultCnt;
					if(resultCnt > 0){
						alert("계산서 정보가 수정되었습니다.");
						location.reload();
					}else{
						alert("계산서 정보 수정에 실패하였습니다.");
					}
				}
			});
		}
		return false;
	});
	
	$(".showPayCheckPop").click(function(){
		var counselCd = $(this).attr("counselCd");
		var startDt = $(this).attr("startDt");
		var endDt = $(this).attr("endDt");
		var searchClientCd = $(this).attr("searchClientCd");
		var searchStaffNm = $(this).attr("searchStaffNm");
		var searchMgrNm = $(this).attr("searchMgrNm");
		var searchCounselorNm = $(this).attr("searchCounselorNm");
		var searchCenterSeq = $(this).attr("searchCenterSeq");
		var insertType = $(this).attr("insertType");
		$.divPop("payCheckPop", "상담비정산 상세정보", "/partner/payCheckMgr/showPayCheckPop?counselCd="+counselCd+"&startDt="+startDt+"&endDt="+endDt
				+"&searchClientCd="+searchClientCd+"&searchStaffNm="+searchStaffNm+"&searchMgrNm="+searchMgrNm+"&searchCounselorNm="+searchCounselorNm
				+"&searchCenterSeq="+searchCenterSeq+"&insertType="+insertType);
		return false;
	});
	
	$('.date_timepicker_start').datetimepicker({
		format:'Y/m/d',
		onShow:function( ct ){
			this.setOptions({
				maxDate:$('.date_timepicker_end').val()?j$('.date_timepicker_end').val():false
			})
		},
		timepicker:false
	});

	$("#btstartDt").click(function(){
		$('.date_timepicker_start').datetimepicker('show');
	});

	$('.date_timepicker_end').datetimepicker({
		format:'Y/m/d',
		onShow:function( ct ){
			this.setOptions({
				minDate:$('.date_timepicker_start').val()?j$('.date_timepicker_start').val():false
			})
		},
		timepicker:false
	});

	$("#btendDt").click(function(){
		$('.date_timepicker_end').datetimepicker('show');
	});
	
	
});

function getToDay() {
	var time = new Date();
	var year = time.getFullYear();
	var month = time.getMonth()+1;
	if(month < 10){
		month = '0'+month;
	}
	var day = time.getDate();
	if(day < 10){
		day = '0'+day;
	}
	var start = year+"/"+month+"/"+day;
	
	return start;
}
function todayBtn() {
	var time = new Date();
	var year = time.getFullYear();
	var month = time.getMonth()+1;
	if(month < 10){
		month = '0'+month;
	}
	var day = time.getDate();
	if(day < 10){
		day = '0'+day;
	}
	var start = year+"/"+month+"/"+day;

	
	$(".date_timepicker_start").val(start);
	$(".date_timepicker_end").val(start);
}
function weekBtn() {
	var time = new Date();
	
	var yearStart = time.getFullYear();
	var monthStart = time.getMonth()+1;
	if(monthStart < 10){
		monthStart = '0'+monthStart;
	}
	var dayStart = time.getDate();
	if(dayStart < 10){
		dayStart = '0'+dayStart;
	}
	 
	time.setDate (time.getDate() - 7); 
	var yearEnd = time.getFullYear();
	var monthEnd = time.getMonth()+1;
	if(monthEnd < 10){
		monthEnd = '0'+monthEnd;
	}
	var dayEnd = time.getDate();
	if(dayEnd < 10){
		dayEnd = '0'+dayEnd;
	}
	var start = yearStart+"/"+monthStart+"/"+dayStart;
	var end = yearEnd+"/"+monthEnd+"/"+dayEnd;
	
	
	$(".date_timepicker_start").val(end);
	$(".date_timepicker_end").val(start);
}
function fifteenBtn() {
	var time = new Date();
	
	var yearStart = time.getFullYear();
	var monthStart = time.getMonth()+1;
	if(monthStart < 10){
		monthStart = '0'+monthStart;
	}
	var dayStart = time.getDate();
	if(dayStart < 10){
		dayStart = '0'+dayStart;
	}
	 
	time.setDate (time.getDate() - 15); 
	var yearEnd = time.getFullYear();
	var monthEnd = time.getMonth()+1;
	if(monthEnd < 10){
		monthEnd = '0'+monthEnd;
	}
	var dayEnd = time.getDate();
	if(dayEnd < 10){
		dayEnd = '0'+dayEnd;
	}
	var start = yearStart+"/"+monthStart+"/"+dayStart;
	var end = yearEnd+"/"+monthEnd+"/"+dayEnd;
	
	
	$(".date_timepicker_start").val(end);
	$(".date_timepicker_end").val(start);
}
function monthBtn() {
	var time = new Date();
	var yearStart = time.getFullYear();
	time
	var monthStart = time.getMonth()+1;
	if(monthStart < 10){
		monthStart = '0'+monthStart;
	}
	var dayStart = time.getDate();
	if(dayStart < 10){
		dayStart = '0'+dayStart;
	}
	time.setDate (time.getDate() - 30); 

	var yearEnd = time.getFullYear();
	var monthEnd = time.getMonth()+1;
	if(monthEnd < 10){
		monthEnd = '0'+monthEnd;
	}
	var dayEnd = time.getDate();
	if(dayEnd < 10){
		dayEnd = '0'+dayEnd;
	}
	var start = yearStart+"/"+monthStart+"/"+dayStart;
	var end = yearEnd+"/"+monthEnd+"/"+dayEnd;
	
	
	$(".date_timepicker_start").val(end);
	$(".date_timepicker_end").val(start);

}

function showPayCheckPopInsert(){
	var insertType = "I";
	$.divPop("payCheckPop", "상담비정산 상세정보", "/partner/payCheckMgr/showPayCheckPop?insertType="+insertType);
	return false;
}

function deletePayCheckAll(){
	if(confirm("모든 정산 데이터가 삭제됩니다. 그래도 진행하시겠습니까?")){
		$.ajax({
			url: "/partner/payCheckMgr/deletePayCheck",
			dataType: 'json',
			success: function (response) {
				var resultCnt = response.resultCnt;
				if(resultCnt > 0){
					alert("모든 정산 데이터가 삭제되었습니다.");
					location.reload();
				}else{
					alert("정산 데이터 삭제에 실패하였습니다.");
				}
			}
		});
	}
}

function excelDownPayCheck(){
	var counselCd = $("#excelBtn").attr("counselCd");
	var startDt = $("#excelBtn").attr("startDt");
	var endDt = $("#excelBtn").attr("endDt");
	var searchClientCd = $("#excelBtn").attr("searchClientCd");
	var searchStaffNm = $("#excelBtn").attr("searchStaffNm");
	var searchMgrNm = $("#excelBtn").attr("searchMgrNm");
	var searchCounselorNm = $("#excelBtn").attr("searchCounselorNm");
	var searchCenterSeq = $("#excelBtn").attr("searchCenterSeq");
	location.href = "/partner/payCheck/excelDownPayCheck?counselCd="+counselCd+"&startDt="+startDt+"&endDt="+endDt
		+"&searchClientCd="+searchClientCd+"&searchStaffNm="+searchStaffNm+"&searchMgrNm="+searchMgrNm
		+"&searchCounselorNm="+searchCounselorNm+"&searchCenterSeq="+searchCenterSeq;
}


function updateCheckYn(){
	if( j$("input[class=selectPayCheck]:checked").length == 0 ) {
		 j$.alert("선택된 값이 없습니다.");
		 return;
	}
	
	var chk = document.getElementsByName("selectPayCheck");
	var counselCdAll = document.getElementsByName("counselCd");
	var centerSeqAll = document.getElementsByName("centerSeq");
	var clientCdAll = document.getElementsByName("clientCd");

	 
	for(var i=0; i<chk.length;i++){
		if(chk[i].checked == true){  //체크가 되어있는 값 구분
			
			var counselCd = counselCdAll[i].value;
			var centerSeq = centerSeqAll[i].value;
			var clientCd = clientCdAll[i].value;	
			var params = {};
			params.counselCd = counselCd;
			params.centerSeq  = centerSeq;
			params.clientCd  = clientCd;
			console.log(params);
			j$.ajax({
				url: '/partner/payCheck/updateCheckYn',
				data: params,
				dataType: 'json',
				type: 'GET',
				cache:true,
				success: function(data, textStatus){
					//window.location.reload();
				}
			});   
			
		}
	} 
	
	window.location.reload();
	return false;
	
	
}
function updateCheckYnOwner(){
	if( j$("input[class=selectPayCheck]:checked").length == 0 ) {
		 j$.alert("선택된 값이 없습니다.");
		 return;
	}
	
	var chk = document.getElementsByName("selectPayCheck");
	var counselCdAll = document.getElementsByName("counselCd");
	var centerSeqAll = document.getElementsByName("centerSeq");
	var clientCdAll = document.getElementsByName("clientCd");

	 
	for(var i=0; i<chk.length;i++){
		if(chk[i].checked == true){  //체크가 되어있는 값 구분
			
			var counselCd = counselCdAll[i].value;
			var centerSeq = centerSeqAll[i].value;
			var clientCd = clientCdAll[i].value;	
			var params = {};
			params.counselCd = counselCd;
			params.centerSeq  = centerSeq;
			params.clientCd  = clientCd;
			console.log(params);
			j$.ajax({
				url: '/partner/payCheck/updateCheckYnOwner',
				data: params,
				dataType: 'json',
				type: 'GET',
				cache:true,
				success: function(data, textStatus){
					//window.location.reload();
				}
			});   
			
		}
	} 
	
	window.location.reload();
	return false;
	
	
}

function updateCheckYnManager(){
	if( j$("input[class=selectPayCheck]:checked").length == 0 ) {
		 j$.alert("선택된 값이 없습니다.");
		 return;
	}
	
	var chk = document.getElementsByName("selectPayCheck");
	var counselCdAll = document.getElementsByName("counselCd");
	var centerSeqAll = document.getElementsByName("centerSeq");
	var clientCdAll = document.getElementsByName("clientCd");

	 
	for(var i=0; i<chk.length;i++){
		if(chk[i].checked == true){  //체크가 되어있는 값 구분
			
			var counselCd = counselCdAll[i].value;
			var centerSeq = centerSeqAll[i].value;
			var clientCd = clientCdAll[i].value;	
			var params = {};
			params.counselCd = counselCd;
			params.centerSeq  = centerSeq;
			params.clientCd  = clientCd;
			console.log(params);
			j$.ajax({
				url: '/partner/payCheck/updateCheckYnManager',
				data: params,
				dataType: 'json',
				type: 'GET',
				cache:true,
				success: function(data, textStatus){
					//window.location.reload();
				}
			});   
			
		}
	} 
	
	window.location.reload();
	return false;
	
	
}
</script>
</head>
<body>
<div class="web">
	<form:form id="searchWaitList" modelAttribute="payCheckAddDto" action="/partner/payCheck/payCheckList" method="GET">
	<table cellpadding="0" align="center" cellspacing="0" border="0" width="95%">
		<tr>
			<td>
				<table cellpadding="0" cellspacing="0" border="0" width="100%">
					<tr>
						<td height="20px"></td>
					</tr>
					<tr>
						<td align="left" class="subtitle">상담비 정산</td>
					</tr>
					<tr>
						<td height="10px"></td>
					</tr>
					<tr>
						<td>
							<!-- 검색 영역 시작 -->
							<table cellpadding="6" cellspacing="0" border="1" width="100%" style="border-collapse:collapse;" bordercolor="#DDDDDD">
								<tr>
									<th width="10%" bgcolor="#F5F5F5" align="center">정산기간</th>
							    	<td  width="35%" align="left">
							    		<input type="text" name="startDt" size="10" class="date_timepicker_start" value="${payCheckAddDto.startDt}"/>
										<img id="btstartDt" src="${url:img('/images/icon02.jpg')}"border="0" />
										&nbsp;~&nbsp;
										<input type="text" name="endDt" size="10" class="date_timepicker_end" value="${payCheckAddDto.endDt}"/>
										<img id="btendDt" src="${url:img('/images/icon02.jpg')}"border="0" />
										<input type="button" onclick="todayBtn();"  value="오늘"/>
										<input type="button" onclick="weekBtn();"  value="1주일"/>
										<input type="button" onclick="fifteenBtn();"  value="15일"/>
										<input type="button" onclick="monthBtn();"  value="1개월"/>
							    	</td>
							    	<th width="15%" bgcolor="#F5F5F5" align="center">담당자명</th>
								   	<td width="35%" align="left">
								   		<input name="searchStaffNm" value="${payCheckAddDto.searchStaffNm}" type="text" style="width:100px;"/>
								   	</td>
								</tr>
								<%--<tr align="left" height="30px">
									<th bgcolor="#F5F5F5" align="center"><strong>고객사 선택</strong></th>
									 <td>
										<select id="selClientCd" name="searchClientCd">
											<option value=""> 고객사를 선택 하세요  </option>
											<c:forEach var="list" items="${clientList }">
												<option value="${list.clientCd }" <c:if test="${list.clientCd eq payCheckAddDto.searchClientCd }"> selected </c:if> >${list.clientNm } </option>
											</c:forEach>
										</select>
									</td> 
									
								</tr>--%>
								<tr>
								   	<th width="15%" bgcolor="#F5F5F5" align="center">내담자명</th>
								   	<td width="35%" align="left">
								   		<input name="searchMgrNm" value="${payCheckAddDto.searchMgrNm}" type="text" style="width:100px;"/>
								   	</td>
								   	<sec:authorize access="hasAnyRole('ROLE_PARTNER_CENTER')">
									   	<th width="15%" bgcolor="#F5F5F5" align="center">상담자명</th>
									   	<td width="35%">
									   		<input name="searchCounselorNm" value="${payCheckAddDto.searchCounselorNm}" type="text" style="width:100px;"/>
									   	</td>
									</sec:authorize>
								</tr>
								<sec:authorize access="hasAnyRole('ROLE_PARTNER_ADMIN')">
									<tr>
										<th bgcolor="#F5F5F5" align="center">상담센터</th>
								    	<td width="35%" >
								    		<select name="searchCenterSeq" id="centerList">
								    			<option value="">전체</option>
								    			<c:forEach var="item" items="${centerList}">
								    				<option value="${item.centerSeq}" <c:if test="${item.centerSeq eq payCheckAddDto.searchCenterSeq }"> selected </c:if> >
								    				${item.centerNm}</option>
								    			</c:forEach>
								    		</select>
										</td>
									</tr>
								</sec:authorize>
							</table>
							<!-- 검색 영역 종료 -->
						</td>
					</tr>
	
					<tr>
						<td height="10px"></td>
					</tr>
	
					<tr>
						<td>
							<!-- 버튼 영역 시작 -->
							<table cellpadding="5" cellspacing="0" border="0" width="100%" style="border-collapse:collapse;" bordercolor="#DDDDDD">
								<tr>
									<td align="center" colspan="4">
										<table cellpadding="0" cellspacing="0" border="0">
											<tr>
									    		<td id="btn01"><a href="#"><span id="searchBtn">검 색</span></a></td>
							    			</tr>
							    		</table>
							    	</td>
								</tr>
							</table>
							<!-- 버튼 영역 종료 -->
						</td>
					</tr>
						<table cellpadding="2" cellspacing="0" border="0" width="100%" style="border-collapse:collapse;">
											<tr>
												<sec:authorize access="hasAnyRole('ROLE_PARTNER_ADMIN')">
													<td align="left">
														<input type="button" onclick="showPayCheckPopInsert();" value="신규등록"/>
														<input type="button" onclick="deletePayCheckAll();" value="전체삭제"/>
													</td>
												</sec:authorize>
												<td align="right">
												<sec:authorize access="hasAnyRole('ROLE_PARTNER_CENTER')">
												
													<input type="button" id="excelBtn" onclick="excelDownPayCheck();" 
														startDt="${param.startDt }" endDt="${param.endDt }"
														searchClientCd="${payCheckAddDto.searchClientCd }" 	
														searchStaffNm="${payCheckAddDto.searchStaffNm}"
														searchMgrNm="${payCheckAddDto.searchMgrNm}" 
														searchCounselorNm="${payCheckAddDto.searchCounselorNm}"
														searchCenterSeq="${payCheckAddDto.searchCenterSeq }"
														value="엑셀 다운로드"/>
															<input type="button"  onclick="javascript:updateCheckYn();" value="정산 확인">
														
															<input type="button"  onclick="javascript:updateCheckYnOwner();" value="센터장 확인">
														</sec:authorize>
														<sec:authorize access="hasAnyRole('ROLE_PARTNER_ADMIN')">
															<input type="button"  onclick="javascript:updateCheckYnManager();" value="담당자 확인">
														</sec:authorize>
												</td>
											</tr>
										</table>
					<tr>
						<td>
							<!-- 채널 영역 시작 -->
							<table cellpadding="0" cellspacing="0" border="0" width="100%" align="left">
								<tr>
									<td>
										<table cellpadding="0" cellspacing="0" border="0" width="100%">
											<sec:authorize access="hasAnyRole('ROLE_PARTNER_CENTER')">
												<tr>
													<td align="left">
														<strong>계산서의 작성일자 : 
															<input type="text" name="writeMonth" style="width:20px;" value="${payCheckConfirm.writeMonth }" 
																<c:if test="${auth == 'center' }">disabled</c:if>/>월
															<input type="text" name="writeDay" style="width:20px;" value="${payCheckConfirm.writeDay }" 
																<c:if test="${auth == 'center' }">disabled</c:if>/>일 
														</strong>
														<span style="margin-left: 15px;"></span>
														<strong>계산서의 발행기한 : 
															<input type="text" name="issueMonth" style="width:20px;" value="${payCheckConfirm.issueMonth }" 
																<c:if test="${auth == 'center' }">disabled</c:if>/>월 
															<input type="text" name="issueDay" style="width:20px;" value="${payCheckConfirm.issueDay }" 
																<c:if test="${auth == 'center' }">disabled</c:if>/>일
															<input type="text" name="issueHour" style="width:20px;" value="${payCheckConfirm.issueHour }" 
																<c:if test="${auth == 'center' }">disabled</c:if>/>시 
														</strong>
														<span style="margin-left: 15px;"></span>
														<strong>계산서의 발신대상 이메일 : 
															<input type="text" name="email" style="width:150px;" 
																<c:if test="${auth == 'center' }">disabled</c:if> value="${payCheckConfirm.email }"/> 
														</strong>
														<sec:authorize access="hasAnyRole('ROLE_PARTNER_ADMIN')">
															<button id="updatePaycheckConfirmBtn" type="button" style="margin-left: 10px;"> 수정</button>
														</sec:authorize>
														
													</td>
													
												</tr>
											</sec:authorize>
											<tr>
												<td align="left">
													<strong>조회건 : ${paging.totalCount} </strong>
													<span style="margin-left: 20px;"></span>
													<strong>페이지 : ${paging.currentPage}/${paging.getPageCount()} </strong>
												</td>
												<td align="right">
													<sec:authorize access="hasAnyRole('ROLE_PARTNER_ADMIN')">
														<span style="font-size: 12px;"><strong>검색결과 비용합계 : ${priceSum} (부가세 포함)</strong></span>
													</sec:authorize>
												</td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td>
										<!-- 채널 정보 시작 -->
										<table cellpadding="5" align="" id="chRow" cellspacing="0" border="1" width="100%" style="border-collapse:collapse;">
											<tr align="center" height="50px">
												<th bgcolor="#F5F5F5" width="3%" ><strong>선택</strong><br><input type="checkbox" class="checkboxAll" /></th>
												<td bgcolor="#F5F5F5" width="5%"><strong>상담</br>코드</strong></td>
												<td bgcolor="#F5F5F5" width="10%"><strong>고객사</strong></td>
												<td bgcolor="#F5F5F5" width="7%"><strong>상담일자</strong></td>
												<td bgcolor="#F5F5F5" width="5%"><strong>임직원</strong></td>
												<td bgcolor="#F5F5F5" width="5%"><strong>내담자</strong></td>
												<td bgcolor="#F5F5F5" width="10%"><strong>상담기관</strong></td>
												<!-- <td bgcolor="#F5F5F5" width="5%"><strong>상담사ID</strong></td> -->
												<td bgcolor="#F5F5F5" width="5%"><strong>상담사</strong></td>
												<td bgcolor="#F5F5F5" width="5%"><strong>일지상태</strong></td>
												
												<td bgcolor="#F5F5F5" width="5%"><strong>상담사확인</strong></td>
												<td bgcolor="#F5F5F5" width="5%"><strong>확인일자</strong></td>
												<td bgcolor="#F5F5F5" width="5%"><strong>센터장확인</strong></td>
												<td bgcolor="#F5F5F5" width="5%"><strong>확인일자</strong></td>

		<!-- 										<td bgcolor="#F5F5F5" width="5%"><strong>상담</br>타입</strong></td>
												<td bgcolor="#F5F5F5" width="5%"><strong>상담</br>상태</strong></td>
												 -->
												<!-- <td bgcolor="#F5F5F5" width="5%"><strong>상담기관</br>코드</strong></td> -->
												
												
												<!-- <td bgcolor="#F5F5F5" width="5%"><strong>세금</br>구분</strong></td>
												<td bgcolor="#F5F5F5" width="8%"><strong>은행명</strong></td>
												<td bgcolor="#F5F5F5" width="5%"><strong>예금주</strong></td> -->
												
												<sec:authorize access="hasAnyRole('ROLE_PARTNER_ADMIN')">
													<td bgcolor="#F5F5F5" width="5%"><strong>담당자확인</strong></td>
													<td bgcolor="#F5F5F5" width="5%"><strong>확인일자</strong></td>
													<td bgcolor="#F5F5F5" width="5%"><strong>정보</br>관리</strong></td>
													<td bgcolor="#F5F5F5" width="5%"><strong>상담비</strong></td>
												</sec:authorize>
											</tr>
											<c:forEach var="list" items="${paging.list}" varStatus="status">
											<tr align="center" height="30px">
												<td>
													<input type="checkbox" name="selectPayCheck" class="selectPayCheck" />
													
													<input type="hidden" name="counselCd" value="${list.counselCd }" />
													<input type="hidden" name="centerSeq" value="${list.centerSeq}" />
													<input type="hidden" name="clientCd" value="${list.clientCd}" />
												</td>
												<th >${list.counselCd}</th>
												<td >${list.clientNm }</td>
												<td >${list.scheduleDt }</td>
												<td >${list.staffNm }</td>
												<td >${list.mgrNm }</td>
												<td >${list.centerNm }</td>
												<%-- <td >${list.counselorId }</td> --%>
												<td >${list.counselorNm }</td>

												<c:choose>
													<c:when test="${list.recordStatus == 100695}">
														<td><strong><comm:commNmOut option="commCd" code="${list.recordStatus}"/></strong></td>
													</c:when>
													<c:when test="${list.recordStatus == 100696}">
														<td><strong><comm:commNmOut option="commCd" code="${list.recordStatus}"/></strong></td>
													</c:when>
													<c:otherwise>
														<td><strong><comm:commNmOut option="commCd" code="${list.recordStatus}"/></strong></td>
													</c:otherwise>
												</c:choose>
												
												
												
												
												
												<td >${list.counselorCheck }</td>
												<td >${list.counselorDt }</td>
												<td >${list.ownerCheck }</td>
												<td >${list.ownerCheckDt }</td>
												
												<%-- <td >${list.counselType }</td>
												<td >${list.counselStatus }</td> --%>
												
												<%-- <td >${list.centerSeq }</td> --%>
												
												<%-- <td >${list.taxType }</td>
												<td >${list.bankNm }</td>
												<td >${list.accountOwner }</td> --%>

												
												<sec:authorize access="hasAnyRole('ROLE_PARTNER_ADMIN')">
													<td >${list.managerCheck }</td>
													<td >${list.managerDt }</td>
													<td class="showPayCheckPop" counselCd="${list.counselCd }" 
														startDt="${param.startDt }" endDt="${param.endDt }"
														searchClientCd="${payCheckAddDto.searchClientCd }" 	
														searchStaffNm="${payCheckAddDto.searchStaffNm}"
														searchMgrNm="${payCheckAddDto.searchMgrNm}" 
														searchCounselorNm="${payCheckAddDto.searchCounselorNm}"
														searchCenterSeq="${payCheckAddDto.searchCenterSeq }"
														insertType="U">
														<a href="javascript:void(0);"><span style="font-weight: bold; color: blue;">수정</span></a>
													</td>
													<td><fmt:formatNumber value="${list.price }" pattern="#,###"/>원</td>
												</sec:authorize>
												
											</tr>
											</c:forEach>
										</table>
										<table cellpadding="2" cellspacing="0" border="0" width="100%" style="border-collapse:collapse;">
											<p><!-- (※ 위 내역은 자동으로 어드민의 데이터와 연동되지 않기 때문에 실제와 다소 차이가 있을 수 있습니다.) --></p>
										</table>
										
										<table cellpadding="2" cellspacing="0" border="0" width="100%" style="border-collapse:collapse;">
											<tr>
												<td align="center">
				  								<ui:paging value="${paging}"
				  									btnFirst="${url:img('/images/btn_first.jpg')}"
				  									btnPrev="${url:img('/images/btn_prev.jpg')}"
				  									btnNext="${url:img('/images/btn_next.jpg')}"
				  									btnLast="${url:img('/images/btn_last.jpg')}" />
	  											</td>
											</tr>
										</table>
										<!-- 채널 정보 종료 -->
									</td>
								</tr>
							</table>
							<!-- 채널 영역 종료 -->
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
	</form:form>
</div>



</body>
</html>