package com.ezwel.admin.domain.entity.counselor;

import lombok.Getter;
import lombok.Setter;

import com.ezwel.core.framework.web.vo.PagingVo;
import com.ezwel.core.support.util.StringUtils;

@Getter @Setter
public class ReqCounselor extends PagingVo {
	
	private String reqSeq;
	
	// 요청타입 
	private String reqType;
	private String reqNm;
	private String manager;
	private String telNum;
	private String mobile;
	private String age;
	private String gender;
	private String area1;
	private String area2;
	private String post;
	private String addr1;
	private String addr2;
	private String email;
	private String homepage;
	private String consultTarget;
	private String consultDiv;
	private String consultDivEtc;
	private String consultType;
	private String consultTypeEtc;
	private String consultExpYn;
	private String consultExp;
	private String infraPersonalCnt;
	private String infraWaitRoomYn;
	private String infraPlayRoomCnt;
	private String infraEduRoomYn;
	private String infraEtc;
	private String totMember;
	private String fileNm;
	private String filePath;
	private String regId;
	private String regNm;
	private String regDt;
	private String modiId;
	private String modiNm;
	private String modiDt;
	private String mgrStatus;
	
	
	public void setConsultTarget(String consultTarget) {
		this.consultTarget = StringUtils.lastCommaRemove(consultTarget);
	}
	
	public void setConsultDiv(String consultDiv) {
		this.consultDiv = StringUtils.lastCommaRemove(consultDiv);
	}
	
	public void setConsultType(String consultType) {
		this.consultType = StringUtils.lastCommaRemove(consultType);
	}
}
