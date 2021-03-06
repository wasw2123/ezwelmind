<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/layout/inc/tags.jspf"%>
<html>
<head>
<title>상담예약요청 | 목록</title>
<link href="${url:resource('/resources/js/plugin/jquery-ui-1.8.9.custom-datepicker.css')}" rel="stylesheet" type="text/css" />
<link href="${url:resource('/resources/js/plugin/jquery.timepicker.min.css')}" rel="stylesheet" type="text/css" />
<script src="${url:resource('/resources/js/plugin/jquery.timepicker.min.js')}"></script>
<script src="${url:resource('/resources/js/jquery-ui-1.10.3.min.js')}"></script>
<script language="JavaScript" type="text/javascript" src="/resources/js/bcrypt.js"></script>

<script type="text/javascript">
j$(document).ready(function(){
	
});

var COUNSEL = {
		updateStatus : function(status, reservSeq) {
			
			if(status == "100005") {
				if(!confirm("한번 변경한 완료상태는 다시 변경할 수 없습니다.\n변경하시겠습니까?")) {
					return false;
				}
			}
			
			$.ajax({
				url: "/madm/counselReserv/updateStatus",
				method: "POST",
				dataType: 'json',
				data : {"status" : status, "reservSeq" : reservSeq},
				success: function (data) {
					
					if(data.success == "success") {
						alert("변경에 성공했습니다.");
						
						location.reload();
					} else {
						alert("변경에 실패했습니다.\n계속 해당 문구가 나오실 경우 이지웰니스로 문의주세요.");
						
						location.reload();
					}
				}
			});
			
		}
	}
</script>
</head>
<body>

<form:form id="searchForm" modelAttribute="dto" action="/madm/counselReserv/list" method="GET">
<table cellpadding="0" cellspacing="0" border="0" width="95%">
<tr>
	<td height="20px"></td>
</tr>

<tr>
	<td>
		<!-- 버튼 영역 시작 -->
		<table cellpadding="5" cellspacing="0" border="0" width="100%" align="center" style="border-bottom: 1px solid silver;">
			<tr>
				<td align="left" class="subtitle">상담예약요청 목록</td>
			</tr>
		</table>
		<!-- 버튼 영역 종료 -->

		<table cellpadding="0" cellspacing="0" border="0" width="100%" align="center">
			<tr>
				<td>
					<table cellpadding="5" cellspacing="0" border="0" width="100%" style="border-collapse:collapse; margin: 15px auto 5px auto;">
						<tr>
							<td align="left" width="30%">
								<strong>
									총 ${paging.totalCount}건
								</strong>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td>
					<table class="" cellpadding="5" align="" id="chRow" cellspacing="0" border="1" width="100%" style="text-align:center; border-collapse:collapse;">
						<thead>
							<tr>
								<th style="width: 8%">순번</th>
								<th style="width: 10%">성명</th>
								<th style="width: 7%">성별</th>
								<th style="width: 10%">근무지</th>
								<th style="width: 9%">생년월일</th>
								<th style="width: 10%">전화번호</th>
								<th style="width: 10%">이메일</th>
								<th style="width: 19%">상담정보</th>
								<th style="width: 10%">등록일시</th>
								<th style="width: 7%">상태</th>
							</tr>
						</thead>

						<tbody>
						<c:if test="${not empty paging.list }">
							<c:forEach var="list" items="${paging.list}" varStatus="status">
								<tr style="${list.status == '100003' ? 'background-color:#F5A9A9' : (list.status == '100004' ? 'background-color:#81DAF5' : (list.status == '100005' ? 'background-color:#81f5aa' : ''))}">
									<td rowspan="2">${(paging.totalCount - ((paging.currentPage-1) * paging.pageSize)) - status.index}</td>
									<td>${list.userNm}</td>
									<td>${list.gender == 'M' ? '남' : (list.gender == 'F' ? '여' : '정보미기입')}</td>
									<td>${list.workPlace }</td>
									<td>${list.rrn }</td>
									<td>${list.mobile }</td>
									<td>${list.email }</td>
									<td>
										${list.counselDiv } / ${list.counselWay } 
										<br>${list.counselArea }
										<c:if test="${list.counselArea == '기타센터' }">
										<br>(${list.area1 } ${list.area2 })
										</c:if>
									</td>
									<td>${fn:substring(list.regDt, 0, 4) }-${fn:substring(list.regDt, 4, 6) }-${fn:substring(list.regDt, 6, 8) }<br>
										${fn:substring(list.regDt, 8, 10) }:${fn:substring(list.regDt, 10, 12) }:${fn:substring(list.regDt, 12, 14) }
									</td>
									<td>
										<c:choose>
											<c:when test="${list.status == '100005' }">
												완료
											</c:when>
											<c:otherwise>
												<select name="status" onchange="COUNSEL.updateStatus(this.value, '${list.reservSeq }')">
													<option value="100001" ${list.status == '100001' ? 'selected' : '' }>대기</option>
													<option value="100002" ${list.status == '100002' ? 'selected' : '' }>보류</option>
													<option value="100003" ${list.status == '100003' ? 'selected' : '' }>거절</option>
													<option value="100004" ${list.status == '100004' ? 'selected' : '' }>승인</option>
													<c:if test="${list.status == '100004' }">
													<option value="100005" ${list.status == '100005' ? 'selected' : '' }>완료</option>
													</c:if>
												</select>
											</c:otherwise>
										</c:choose> 
									</td>
								</tr>
								<tr style="${list.status == '100003' ? 'background-color:#F5A9A9' : (list.status == '100004' ? 'background-color:#81DAF5' : (list.status == '100005' ? 'background-color:#81f5aa' : ''))}">
									<td colspan="9" style="text-align: left; padding-left: 3px;">${list.counselSchedule}</td>
								</tr>
							</c:forEach>
						</c:if>
						<c:if test="${empty paging.list }">
							<tr align="" height="50px">
								<td id="noResultTd" colspan="10">상담요청내역이 없습니다</td>
							</tr>
						</c:if>
						</tbody>
					</table>
					</div>
					<br>
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
				</td>
			</tr>
		</table>
	</td>
</tr>
</table>
</form:form>
</body>
</html>

