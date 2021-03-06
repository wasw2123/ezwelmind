package com.ezwel.admin.service.mgr.dto;

import com.ezwel.core.framework.web.vo.PagingVo;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
@SuppressWarnings("serial")
public class CounselorInfoMgrDto extends PagingVo{
	
	/**
	 * 관리자 세부정보
	 */
	
	//아이디(PK)
	private String userId;
	
	//성별
	private String gender;
	
	//학력
	private String education;
	
	//대학교
	private String university;
	
	//학과
	private String department;
	
	//경력
	private String career;
	
	//소개
	private String memo;
	
	//파일명
	private String fileNm;
	
	//파일경로
	private String filePath;

	//센터구분
	private String centerType;
	
	//근무형태(S:상주 P:파트)
	private String workType;
	
	//상담유형
	private String channelType;
	
	//심리상담대상
	private String mentalAges;
	
	//심리상담분야
	private String mentalDiv;
	
	//심리상담기타분야
	private String mentalDivEtc;
	
	//심리상담방법
	private String mentalType;
	
	//법률상담분야
	private String lawDiv;
	
	//법률상담방법
	private String lawType;
	
	//재무상담분야
	private String financeDiv;
	
	//재무상담방법
	private String financeType;
	
	//심리검사상담대상
	private String diagnosisAges;
	
	//심리검사상담분야
	private String diagnosisDiv;
	
	//심리검사기타상담분야
	private String diagnosisDivEtc;
	
	//심리검사상담방법
	private String diagnosisType;
	
	//상태
	private String mgrStatus;
	
	//수정일시
	private String modiDt;
	
	//유저이름
	private String userNm;

	//비밀번호
	private String userPwd;
	
	//연락처
	private String mobile;
	
	//이메일
	private String email;
	
	//생년월일
	private String rrn;
	
	//등록일
	private String regDt;
	
	//사용여부
	private String useYn;
	
	//상담센터일련번호
	private int centerSeq;
	
	//검색시작일
	private String startDt;	
	
	//검색종료일
	private String endDt;	
	
	//센터명
	private String centerNm;
	
	private String sMStatus;
	
	private String sWType;
	
	private String memo1;
	
	private String price;
	
	private String[] sMgrStatue;
	
	private String userRrn;
	private String userMobile;
	private String userMnm;
	private String userGender;
	private String suserGender;
	
	//접속권한
	private String authCd;
	private String[] sAuthCd;
	
	//상담센터일련번호
	private String searchCenterSeq;

	
	//지역검색
	private String area1;	
	//지역검색
	private String area2;	
	
	// 연령대
	private String ages;
	
	// 노출여부
	private String dispYn;
	
	//외국어 상담
	private String languageType;
	//특수 주제
	private String specialType; 
	
	private String highCommCd;
	
	private String carefulInfo;
	private int extraIdx;
	private String extraNm;
	private String extraTarget;
	private String extraCost;  
	
	private String qualify;
}
