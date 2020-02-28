<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/layout/inc/tags.jspf"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%
	Date ct = new Date();
	String pattern = "yyyy/MM/dd";
	SimpleDateFormat fmt = new SimpleDateFormat(pattern);
	
	//today
	String today = fmt.format(ct);
	
	//today-7
	ct.setDate(ct.getDate()-7);
	String owa = fmt.format(ct);
	
	//today -15
	ct.setDate(ct.getDate()-8);
	String hma = fmt.format(ct);
	
	//today -30
	ct.setDate(ct.getDate()-15);
	String oma = fmt.format(ct);

	//today -60
	ct.setDate(ct.getDate()-30);
	String tma = fmt.format(ct);
	
%>
<html>
<head>
<title>프로모션목록</title>
<script type="text/javascript">
j$(document).ready(function(){
	j$('.date_timepicker_from').datetimepicker({
		format:'Y/m/d',
		onShow:function( ct ){
			this.setOptions({
				maxDate:j$('.date_timepicker_to').val()?j$('.date_timepicker_to').val():false
			})
		},
		timepicker:false
	});

	j$("#fromDt").click(function(){
		j$('.date_timepicker_from').datetimepicker('show');
	});

	j$('.date_timepicker_to').datetimepicker({
		format:'Y/m/d',
		onShow:function( ct ){
			this.setOptions({
				minDate:j$('.date_timepicker_from').val()?j$('.date_timepicker_from').val():false
			})
		},
		timepicker:false
	});

	j$("#toDt").click(function(){
		j$('.date_timepicker_to').datetimepicker('show');
	});
	
	
	//등록
	j$('#insertbtn').click(function() {
		 j$("#promotionForm").attr("action","/madm/service/exposure/addpromotion");
		 j$("#promotionForm").submit();
	});

	//조회
	j$('.searchbtn').click(function() {
		var fromDt = j$('.date_timepicker_from').val()
		var toDt = j$('.date_timepicker_to').val()
		
		if(fromDt == "" && toDt != "" ){
			alert("판매기간 시작기간 조건을 확인해 주세요.");
			return;
		}
		
		if(fromDt != "" && toDt == "" ){
			alert("판매기간 종료기간 조건을 확인해 주세요.");
			return;
		}
		
		j$("#promotionForm").submit();
	});
	
	//상태변경
	j$('#modifybtn').click(function() {
		var key = j$(this).attr("value");
		j$("#modifytype").val(key);
		
		if( j$("input[id=check]:checked").length == 0 ) {
			 j$.alert("선택된 값이 없습니다.");
			 return;
		}

		j$.alert("변경 하시겠습니까?", function() {
			j$('input:checkbox[name="goodsCdArr"]:unchecked').each(function(){
				j$(this).parent().parent().remove();
			});

		
			 j$("#promotionForm").attr("action","/madm/service/exposure/modifystatus");
			 j$("#promotionForm").submit();
		}, function() {
		}); // end alert
	});
	
	//수정화면
	j$('.detail').click(function() {
		var key = j$(this).attr("value");
		j$("#promotionForm").attr("action","/madm/service/exposure/modifypromotion?prmCd="+key);
		j$("#promotionForm").submit();
		
	});
	
	//판매 정보 관리
	j$('#notZero').click(function() {
		var key = j$(this).attr("value");
		j$("#promotionForm").attr("action","/madm/service/exposure/price?prmCd="+key);
		j$("#promotionForm").submit();
		
	});
	
	//판매상품 등록
	j$('#zero').click(function() {
		var key = j$(this).attr("value");
		j$("#promotionForm").attr("action","/madm/service/exposure/addpgoods?prmCd="+key);
		j$("#promotionForm").submit();
		
	});
	
	
});

function jsSearchDate(arg) {
	
	var fr = document.promotionForm;
	var startDt = "reqFromDt";
	var endDt	= "reqToDt";
	
     if (arg == "today") { //오늘
    	fr.elements[startDt].value  = "<%=today %>";
    	fr.elements[endDt].value  = "<%=today %>";
    }
    if (arg == "week") {  //일주일
    	fr.elements[startDt].value  = "<%=owa %>";
    	fr.elements[endDt].value  = "<%=today %>";
    }
    if (arg == "halfMonth") {  //보름
    	fr.elements[startDt].value  = "<%=hma %>";
    	fr.elements[endDt].value  = "<%=today %>";
    }
    if (arg == "month") {  //한달
    	fr.elements[startDt].value  = "<%=oma %>";
    	fr.elements[endDt].value  = "<%=today %>";
    }
    if (arg == "twoMonths") {  //두달
    	fr.elements[startDt].value  = "<%=tma %>";
    	fr.elements[endDt].value  = "<%=today %>";
    } 
}

function jsSearchDateClear() {
	var startDt = "reqFromDt";
	var endDt	= "reqToDt";
	var fr = document.promotionForm;

	fr.elements[startDt].value = "";
	fr.elements[endDt].value = "";
}





</script>
</head>
<body>


<form id="promotionForm" name="promotionForm" action="/madm/service/exposure/promotion" method="POST">
<input type="hidden" id="modifytype" name="modifytype"  value=""  />

<table cellpadding="0" align="left" cellspacing="0" border="0" width="95%">
	<tr>
		<td>
			<table cellpadding="0" cellspacing="0" border="0" width="100%">
				<tr>
					<td height="20px"></td>
				</tr>
				<tr>
					<td align="left" class="subtitle">프로모션목록</td>
					<td align="right">
						<input type="button" id="insertbtn" value="신규등록">
					</td>
				</tr>
			</table>
			<tr>
				<td height="10px"></td>
			</tr>
				<tr>
					<td>
						<!-- 검색 영역 시작 -->
						<table cellpadding="5" cellspacing="0" border="1" width="100%" style="border-collapse:collapse;" bordercolor="#DDDDDD">
							<tr align="left" height="30px">
								<td bgcolor="#F5F5F5" align="center"><strong>프로모션제목</strong></td>
								<td>
									<input type="text" id="searchPromotionNm" name="searchPromotionNm" value="${param.searchPromotionNm }" />
								</td>
								<td bgcolor="#F5F5F5" align="center"><strong>프로모션코드</strong></td>
						    	<td align="left">
						    		<input type="text" id="searchPromotionCd" name="searchPromotionCd" value="${param.searchPromotionCd }" />
						    	</td>
							</tr>
							<tr align="left" height="30px">
								<td bgcolor="#F5F5F5" align="center"><strong>진행상태</strong></td>
						    	<td align="left" >
						    		<comm:select name="selectStatus" code="100805"  basicValue="전체" selectValue="${param.selectStatus}" />
						    	</td>
						    	<td bgcolor="#F5F5F5" align="center"><strong></strong></td>
						    	<td align="left" >
						    	</td>
							</tr>
							<tr>
								<th scope="col">판매기간</th>
								<td colspan="3">
										<input type="text" name="reqFromDt" size="10" class="date_timepicker_from" value="${param.reqFromDt}"/>
									<img id="fromDt" src="http://img.ezwelmind.co.kr/images/icon02.jpg"border="0" />
										&nbsp;~&nbsp;
										<input type="text" name="reqToDt" size="10" class="date_timepicker_to" value="${param.reqToDt}"/>
										<img id="toDt" src="http://img.ezwelmind.co.kr/images/icon02.jpg"border="0" />
										<input type="button" value="오늘" onclick="javascript:jsSearchDate('today');" >
										<input type="button" value="일주일" onclick="javascript:jsSearchDate('week');" >
										<input type="button" value="15일" onclick="javascript:jsSearchDate('halfMonth');" >
										<input type="button" value="한달" onclick="javascript:jsSearchDate('month');" >
										<input type="button" value="두달" onclick="javascript:jsSearchDate('twoMonths');" >
										<input type="button" value="전체" onclick="javascript:jsSearchDateClear();" >
								</td>
							</tr>
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
								    		<td id="btn01"><a href="#"><span class="searchbtn">검 색</span></a></td>
						    			</tr>
						    		</table>
						    	</td>
							</tr>
						</table>
						<!-- 버튼 영역 종료 -->
					</td>
				</tr>

				<tr>
					<td>
						<table cellpadding="0" cellspacing="0" border="0" width="100%" align="left">
							<tr>
								<td>
									<table cellpadding="0" cellspacing="0" border="0" width="100%">
										<tr>
											<td align="left">
												<strong>총 ${paging.totalCount} 건 |</strong> 
												<strong>페이지 : ${paging.currentPage}/${paging.getPageCount()} </strong>
											</td>
											<td align="right">
												<input type="button" id="modifybtn" value="상태수정">
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td>
									<table cellpadding="5" align="" id="chRow" cellspacing="0" border="1" width="100%" style="border-collapse:collapse;">
										<tr align="center" height="50px">
											<th >선택</th>
											<th >순번</th>
											<th >메뉴코드 </br>메뉴명</th>
											<th >프로모션코드</th>
											<th >프로모션제목</th>
											<th >판매기간</th>
											<th >상품수</th>
											<th >진행상태</th>
											<th >등록일</th>
											
										</tr>
										</tr>
										<c:forEach var="list" items="${paging.list}" varStatus="status">
										<tr align="center" height="30px">
											<td ><input type="checkbox" id="check" name="goodsCdArr" value="${list.prmCd}" /></td>
											<td >${(paging.totalCount - ((paging.currentPage-1) * paging.pageSize)) - status.index}</td>
											<td >${list.menuCd }</br>${list.menuNm }</td>
											<td ><a href="javascript:void(0)" class="detail" value="${list.prmCd }" >${list.prmCd }</a></td>
											<td ><a href="#" class="detail" value="${list.prmCd }" >${list.prmNm}</a></td>
											<td >${list.stdt }</br>${list.eddt }</td>
											<td >
												<c:choose>
													<c:when test="${list.goodsCount != 0 }">
														<a href="#" id="notZero" value="${list.prmCd }">${list.goodsCount}</a>
													</c:when>
													<c:otherwise>
														<a href="#" id="zero" value="${list.prmCd }">${list.goodsCount}</a>
													</c:otherwise>
												</c:choose>
											</td>
											<td >
												<comm:select name="authCdArr" code="100805"  selectValue="${list.statusCd}" />
											</td>
											<td >${list.regDt }</td>
										</tr>
										</c:forEach>
									</table>
									<br>
								</td>
							</tr>
						</table>
					</td>
				</tr>

				<tr>
					<td height="10px"></td>
				</tr>
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
</form>
<div id="viewlayout" onmouseOver="this.style.display='block'" onMouseOut="this.style.display='none'" style="display:none; position:fixed;"></div>
</body>
</html>
