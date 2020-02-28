package com.ezwel.admin.domain.entity.evaluation;

import com.ezwel.core.framework.web.vo.PagingVo;

import lombok.Getter;
import lombok.Setter;

@Getter @Setter
public class Evaluation extends PagingVo {

//	mind_evaluation
	private String evalSeq;
	private String evalType;
	private String evalTitle;
	private String evalStatus;
	private String evalDisNum;

//	mind_evaluation_item
	private String itemSeq;
	private String itemNo;
	private String itemTitle;
	private String itemType;
	private String itemLimit;
	private String itemYn;

//	mind_evaluation_user
	private String evalUserSeq;
	private String targeySeq;
	private String userKey;
	private String itemAns;
	private String regDt;
	
	private String userNm;
	private String email;
	private String smsRecvYn;
	private String counselNm;
	private String counselCd;
	private String counselEmail;
	private String jedoYn;
	private String scheduleDt;
	private String scheduleDtMonth;
	private String centerTelNum;
	private String centerNm;
	private String centerAddr1;
	private String centerAddr2;
	private String counselorNm;
	private String counselorMobile;
	private String counselType;	
	private String emailRecvYn;
	private String mobile;
	private String cMobile;
	
	private String clientCd;
	private String clientNm;
	private String relation;
	private String counselDt;
	private String ansArr;
	private String item01Ans;
	private String item02Ans;
	private String item03Ans;
	private String item04Ans;
	private String item05Ans;
	private String item06Ans;
	private String item07Ans;
	private String item08Ans;
	private String item09Ans;
	private String item10Ans;
	
	private String itemYcnt;
	private String itemNcnt;
	
	private String itemAvg;
	private String itemMin;
	private String itemMax;
	
	private String showYn;
	private String showDt;
	private String showId; 
	
	private String targetSeq;
	

}
