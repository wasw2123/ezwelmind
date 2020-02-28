<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/layout/inc/tags.jspf"%>
<%@ include file="/WEB-INF/jsp/layout/inc/staticBefore.jspf"%>
<script>
var clientCd="${info.clientCd}";
$(document).ready(function(){
	$("#highcategory").focus();
	$('#highcategory').change(function() {
		highCategoryChange();
	});
	$(".searchFee").click(function () {
		var highcategory = $("#highcategory").val();
		var counselDiv = $("#counselDiv").val();
		var counselType = $("#counselType").val();
		if(highcategory=="" || highcategory==null){
			alert('상담유형을 선택해주세요');
			 $("#highcategory").focus();
			 return;
		}
		if(counselDiv=="" || highcategory==null){
			alert('상담분야를 선택해주세요');
			 $("#counselDiv").focus();
			 return;
		}
		if(counselType=="" || counselType==null){
			alert('상담타입을 선택해주세요');
			 $("#counselType").focus();
			 return;
		}
		$("#price").val("");
		$("#point").val("");
		setPrice(counselDiv,counselType);
		
	});
	
	$(".givePoint").click(function () {
		pointValidation();
		
	});
	
	
	$('#count').focus(function(){
		var price = $("#price").val();
		if(price=="" || price==null){
			$("#highcategory").focus();
			return false;
		} 
		
	});
	
	$('#count').blur(function(){
		var price = $("#price").val();
		if(price=="" || price==null){
			//alert('비용이 조회되지 않았습니다. 비용을 조회해주세요.');
			$("#highcategory").focus();
			return;
		}
		var count = $('#count').val();
		if(count=="" || count==null){
			//alert('회기가 입력되지 않았습니다. 회기를 입력해주세요.');
			$('#point').val(0);
			$("#count").focus();
			return;
		}
		$('#point').val(getPoint(price,count));
		
	});
	
	
});
//숫자에 콤마찍기
function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}
//1회기당 금액 가져오기
function setPrice(counselDiv,counselType){
	var clientCd="${info.clientCd}";
	$.ajax({
		url: "/madm/operations/getPrice?clientCd="+clientCd+"&counselDiv="+counselDiv+"&counselType="+counselType,
		dataType: 'json',
		success: function (response) {
			var value = response.price;
			if(value!=null && value!=""){
				$("#price").val(value);
				var count = $('#count').val();
				if(count!="" && count!=null){
					$('#point').val(getPoint(value,count));
				}
				$(".givePoint").prop("disabled", false);
				$(".givePoint").removeAttr("disabled");
			}else{
				alert('1회기당 금액이 설정되지 않았습니다. 확인해주세요.')
			}
			
		}
	});
}

// 상담유형 변경시 
function highCategoryChange(){
	$("select[name='counselDiv'] option").remove();   
	$("[name='counselDiv']").append("<option value=''>---- 선택 ----</option>");
	var name 	= "highcategory";
	var setName = "counselDiv";
	getCategoryList(name, setName);
}
//상담분야 가져오기
function getCategoryList(name, setName) {
	var value= $("[name='"+name+"']").val();
	if ($("[name='"+name+"']").val() != "" && $("[name='"+name+"']").val() != null) {
		$.ajax({
			url: "/madm/common/getCategoryList?highCommCd=" + $("[name='"+name+"']").val()+"&clientCd="+clientCd,
			dataType: 'json',
			success: function (response) {
				var iter = response.list;
				var element = "";
				for (var i = 0; i < iter.length; i++) {
					element += "<option value='" + iter[i].categoryCd + "'>" + iter[i].categoryNm + "</option>";
				}
				if (element != "") {
					$("[name='"+setName+"']").append(element);
				}
			}
		});
	}
}
//포인트계산
function getPoint(price,count){
	var point = parseInt(price.replace(/,/gi,"")) * parseInt(count);
	return numberWithCommas(point);
}
//포인트부여하기전 유효성체크
function pointValidation(){
	//1. 부여할 포인트가 재대로 입력됐는지 확인
	var count = $("#count").val();
	var price = $("#price").val();
	if(count==null || count==""){
		alert('회기가 입력되지 않았습니다.')
		$("#count").focus();
		return;;
	}
	if(price==null || price==""){
		alert('비용이 조회되지 않았습니다. 비용을 조회해주세요.');
		$("#highcategory").focus();
		return;;
	}
	
	var point = $("#point").val();
	if(point!=null && point!=""){
		//2. 부여할 포인트가 고객사 잔여한도를 넘지 않는지 확인한다.
		var clientRemainPoint = $("#clientRemainPoint").val();
		clientRemainPoint = parseInt(clientRemainPoint.replace(/,/gi,"")) 
		point = parseInt(point.replace(/,/gi,"")) 
		if(point>0){
			if(clientRemainPoint-point>=0){
				var clientCd = $('#clientCd').val();
				var userKey = $('#userKey').val();
				var periodSeq = $('#periodSeq').val();
				givePoint(clientCd,userKey,point,periodSeq);
			}else{
				alert('부여할 포인트가 고객사 잔여한도를 초과하였습니다.')
				$("#point").val("");
				$("#count").val("");
				$("#count").focus();
			}
		}else{
			alert('부여할 포인트는 0포인트를 초과하여야 합니다.')
			$("#count").focus();
			return;;
		}
		
	}else{
		alert('부여할 포인트가 계산되지 않았습니다.비용 조회 후 회기를 입력해주세요.')
	}
	
	
	
	
	
	
}
//포인트부여하기
function givePoint(clientCd,userKey,point,periodSeq){
	$.ajax({
		url: "/madm/operations/givePointToUser?clientCd="+clientCd+"&userKey="+userKey+"&point="+point+"&periodSeq="+periodSeq+"&pointType=C",
		dataType: 'json',
		success: function (response) {
			var resultMap = response.resultMap;
			if(resultMap.resultValue=='success'){
				alert('포인트가 부여되었습니다.')
				location.reload(true);
			}else{
				alert('포인트가 부여가 실패되었습니다. 관리자에게 문의하세요.')
			}
		}
	});
	
}



</script>

<div style="overflow-x: hidden; overflow-y: scroll; ">
<input name="clientCd" id="clientCd" type="hidden" value="${info.clientCd}" />
<input name="periodSeq" id="periodSeq" type="hidden" value="${info.periodSeq}" />
<input name="userKey" id="userKey" type="hidden" value="${userKey}" />
<input name="clientRemainPoint" id="clientRemainPoint" type="hidden" value="${clientRemainPoint}" />
<table cellpadding="5" cellspacing="0" border="1px solid silver" style="border-collapse:collapse; width:1000px;" >
	<tr align="left" height="30px">
		<td bgcolor="#F5F5F5" align="center" width="11%"><strong>고객사명</strong></td>
    	<td align="left" width="23%">${info.clientNm }</td>
    	<td bgcolor="#F5F5F5" align="center" width="11%"><strong>이름</strong></td>
    	<td align="left" width="auto;" colspan="3">${info.userNm }</td>
	</tr>
	<tr align="left" height="30px">
		<td bgcolor="#F5F5F5" align="center"><strong>고객사 제도기간</strong></td>
    	<td align="left">${info.startDd } ~ ${info.endDd}</td>
    	<td bgcolor="#F5F5F5" align="center"><strong>고객사잔여한도</strong></td>
    	<td align="left" width="auto;" colspan="3">${clientRemainPoint}</td>
	</tr>
	<tr align="left" height="30px">
		    	<td bgcolor="#F5F5F5" align="center"><strong>개인사용한도</strong></td>
    	<td align="left">${info.ceilingPoint} </td>
    	<td bgcolor="#F5F5F5" align="center"><strong>개인 잔여한도</strong></td>
    	<td align="left" width="auto;" colspan="3">${privateRemainPoint}</td>
	</tr>

	<tr align="left" height="30px">
		<td bgcolor="#F5F5F5" align="center"><strong>고객사 비용조회</strong></td>
    	<td colspan="5" align="left">
    		<comm:categorySelect name="highcategory" id="highcategory" code="0" basicValue="--  선택  --"/>
    		<comm:categorySelect name="counselDiv" id="counselDiv" basicValue="--  선택  --" code="1025468" />
			<select name="counselType" id="counselType" style="height: 20px;">
				<option value="" >---- 선택 ----</option>
				<option value="100433" >대면</option>
				<option value="100434" >전화</option>
				<option value="100435" >게시판</option>
			</select>	
    		<button class="searchFee" type="button"> 비용조회</button>
    	</td>
	</tr>
	<tr align="left" height="30px">
		<td bgcolor="#F5F5F5" align="center"><strong>1회기당비용</strong></td>
    	<td align="left" width="23%">
    		<input type="text" class="price" id="price" name="price" readonly="readonly"/>
    	</td>
		<td bgcolor="#F5F5F5" align="center" width="11%"><strong>부여할회기</strong></td>
    	<td align="left"><input type="text" class="count" id="count" name="count"/></td>
    	<td bgcolor="#F5F5F5" align="center"><strong>총 부여 포인트</strong></td>
    	<td align="left">
    		<input type="text" class="point" id="point" name="point" readonly="readonly"/>
    		<button class="givePoint" type="button" disabled="disabled"> 포인트부여하기</button>
    	</td>
	</tr>
</table>

</div>