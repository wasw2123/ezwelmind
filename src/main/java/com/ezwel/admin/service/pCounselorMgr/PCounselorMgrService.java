package com.ezwel.admin.service.pCounselorMgr;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.Period;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Optional;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.ezwel.admin.domain.entity.employ.EmployData;
import com.ezwel.admin.domain.entity.pCounselorMgr.MindCounselCounselDetail;
import com.ezwel.admin.domain.entity.pCounselorMgr.MindCounselIntake;
import com.ezwel.admin.domain.entity.pCounselorMgr.MindSchedule;
import com.ezwel.admin.domain.entity.user.User;
import com.ezwel.admin.persist.pCounselorMgr.PCounselorMgrMapper;
import com.ezwel.admin.service.message.queue.SmsService;
import com.ezwel.admin.service.mgr.MgrService;
import com.ezwel.admin.service.pCounselorMgr.dto.MindCounselIntakeDto;
import com.ezwel.admin.service.pCounselorMgr.dto.MindCounselRecordTxtDto;
import com.ezwel.admin.service.pCounselorMgr.dto.MindScheduleDto;
import com.ezwel.admin.service.sms.OrderSmsPoliceService;
import com.ezwel.admin.service.sms.OrderSmsService;
import com.ezwel.admin.service.user.UserService;
import com.ezwel.common.service.acl.MailService;
import com.ezwel.core.framework.web.vo.Paging;
import com.ezwel.core.support.util.DateUtils;
import com.ezwel.core.support.util.EzwelCode.BRANCH;
import com.ezwel.core.support.util.EzwelCode.TEAM;
import com.ezwel.core.support.util.FileUploadUtils;
import com.ezwel.core.support.util.FileUtils;
import com.ezwel.core.support.util.StringUtils;

@Service
public class PCounselorMgrService {

	private static final int SANGDAM_SCHEDULE_TYPE_COMM_CD = 100562;
	private static final int GUMSA_SCHEDULE_TYPE_COMM_CD = 100564;
	private static final int COUNSEL_FEEDBACK_TYPE_COMM_CD = 101024;

	@Resource
	private PCounselorMgrMapper pCounselorMgrMapper;
	
	@Resource
	private SmsService smsService;
	
	@Resource
	private OrderSmsService orderSmsService;
	
	@Resource
	private OrderSmsPoliceService orderSmsPoliceService;
	
	@Resource
	private MailService mailService;
	
	@Resource
	private UserService userService;
	
	@Resource
	private MgrService mgrService;
	
	@Value("#{global['phone.admin.number']}")
	private String phoneAdminNumber;
	
	@Value("#{global['mail.sangdam4u']}")
	private String mailSangdam4u;

	private Logger logger = LoggerFactory.getLogger(this.getClass().getName());

	public Paging<MindCounselIntake> pCounselorDateList(MindCounselIntakeDto mindCounselIntakeDto) {
		if( logger.isDebugEnabled()){
			logger.debug("===서비스 디버깅===" + mindCounselIntakeDto);
		}
		Paging<MindCounselIntake> paging = new Paging<MindCounselIntake>();
		paging.setPaging(mindCounselIntakeDto);
		paging.setList(pCounselorMgrMapper.pCounselorDateList(mindCounselIntakeDto));
		mindCounselIntakeDto.setPageCommonFlag(true);
		paging.setTotalCount(pCounselorMgrMapper.pCounselorDateList(mindCounselIntakeDto).get(0).getPageCommonCount());

		return paging;
	}

//	public void insertPlanDate(MindCounselPlanDto mindCounselPlanDto) {
//		if( logger.isDebugEnabled()){
//			logger.debug("===서비스 상담목표 및 계획===" + mindCounselPlanDto);
//		}
//		pCounselorMgrMapper.insertPlanDate(mindCounselPlanDto);
//
//	}

	//상담 일지 등록/수정
	public void pCounselorDateInsert(MindCounselCounselDetail mindCounselCounselDetail) throws Exception{

		List<MindCounselCounselDetail> pCounselorRecordCnt = null;
		List<MindCounselCounselDetail> pCounselorRecordChkCnt = null;
		List<MindCounselRecordTxtDto> mindCounselRecordTxtList =  new ArrayList<MindCounselRecordTxtDto>();
//			int resultCnt=0;

//		만족도조사 & 법률상담 문자/이메일 발송을 위한 체크 
//		기존 종결상태일 경우 재발송하지 않는다.
		String recordStatus = pCounselorMgrMapper.getRecordStatus(mindCounselCounselDetail);
		
		//상담일지,목표 세팅 등록/수정 start
		pCounselorRecordCnt = pCounselorMgrMapper.pCounselorRecordCnt(mindCounselCounselDetail);

		//파일업로드
		if("Y".equals(mindCounselCounselDetail.getFileUpYn())){
			FileUtils.fileAddUpload(mindCounselCounselDetail, FileUploadUtils.UPLOAD_DIR_PROP);
		}

		for(int i=0; i<pCounselorRecordCnt.size(); i++){
			String CntTitle = pCounselorRecordCnt.get(i).getCntTitle();
			int cnt = pCounselorRecordCnt.get(i).getCnt();

			//상담일지
			if("record".equals(CntTitle) && cnt == 0){  //등록
				int recordCnt = pCounselorMgrMapper.insertRecordDate(mindCounselCounselDetail);

				if(recordCnt > 0){
//						resultCnt++;
					pCounselorRecordChkCnt = pCounselorMgrMapper.pCounselorRecordCnt(mindCounselCounselDetail);

					String CntTitle2 = pCounselorRecordChkCnt.get(0).getCntTitle();
					int cnt2 = pCounselorRecordChkCnt.get(0).getCnt();

					if("record".equals(CntTitle2) && cnt2 > 0){
						mindCounselCounselDetail.setRecordCd(pCounselorRecordChkCnt.get(0).getRecordCd());
					}
				}
			}else{										//수정
				pCounselorMgrMapper.updateRecordDate(mindCounselCounselDetail);
//					resultCnt++;
			}

			//상담목표
			if("plan".equals(CntTitle) && cnt == 0){  //등록
				pCounselorMgrMapper.insertPlanDate(mindCounselCounselDetail);
//					resultCnt++;
			}else{										//수정
				pCounselorMgrMapper.updatePlanDate(mindCounselCounselDetail);
//					resultCnt++;
			}
		}
		//상담일지,목표 세팅 등록/수정 end
		
		if(!StringUtils.isEmpty(mindCounselCounselDetail.getRecordCd()) && !StringUtils.isEmpty(mindCounselCounselDetail.getFileNm())){
			pCounselorMgrMapper.insertCounselRecordHis(mindCounselCounselDetail);
		}

		//소견 세팅 등록/수정 start
		if(!StringUtils.isEmpty(mindCounselCounselDetail.getRecordCd())){

			MindCounselRecordTxtDto mindCounselRecordTxtDto1 = new MindCounselRecordTxtDto();

			mindCounselRecordTxtDto1.setRecordCd(mindCounselCounselDetail.getRecordCd());
			mindCounselRecordTxtDto1.setRecordType(mindCounselCounselDetail.getRecordType1());
			mindCounselRecordTxtDto1.setContent(mindCounselCounselDetail.getContent1());
			mindCounselRecordTxtList.add(mindCounselRecordTxtDto1);

			MindCounselRecordTxtDto mindCounselRecordTxtDto2 = new MindCounselRecordTxtDto();

			mindCounselRecordTxtDto2.setRecordCd(mindCounselCounselDetail.getRecordCd());
			mindCounselRecordTxtDto2.setRecordType(mindCounselCounselDetail.getRecordType2());
			mindCounselRecordTxtDto2.setContent(mindCounselCounselDetail.getContent2());
			mindCounselRecordTxtList.add(mindCounselRecordTxtDto2);

			MindCounselRecordTxtDto mindCounselRecordTxtDto3 = new MindCounselRecordTxtDto();

			mindCounselRecordTxtDto3.setRecordCd(mindCounselCounselDetail.getRecordCd());
			mindCounselRecordTxtDto3.setRecordType(mindCounselCounselDetail.getRecordType3());
			mindCounselRecordTxtDto3.setContent(mindCounselCounselDetail.getContent3());
			mindCounselRecordTxtList.add(mindCounselRecordTxtDto3);

			MindCounselRecordTxtDto mindCounselRecordTxtDto4 = new MindCounselRecordTxtDto();

			mindCounselRecordTxtDto4.setRecordCd(mindCounselCounselDetail.getRecordCd());
			mindCounselRecordTxtDto4.setRecordType(mindCounselCounselDetail.getRecordType4());
			mindCounselRecordTxtDto4.setContent(mindCounselCounselDetail.getContent4());
			mindCounselRecordTxtList.add(mindCounselRecordTxtDto4);

			MindCounselRecordTxtDto mindCounselRecordTxtDto5 = new MindCounselRecordTxtDto();

			mindCounselRecordTxtDto5.setRecordCd(mindCounselCounselDetail.getRecordCd());
			mindCounselRecordTxtDto5.setRecordType(mindCounselCounselDetail.getRecordType5());
			mindCounselRecordTxtDto5.setContent(mindCounselCounselDetail.getContent5());
			mindCounselRecordTxtList.add(mindCounselRecordTxtDto5);

			MindCounselRecordTxtDto mindCounselRecordTxtDto6 = new MindCounselRecordTxtDto();

			mindCounselRecordTxtDto6.setRecordCd(mindCounselCounselDetail.getRecordCd());
			mindCounselRecordTxtDto6.setRecordType(mindCounselCounselDetail.getRecordType6());
			mindCounselRecordTxtDto6.setContent(mindCounselCounselDetail.getContent6());
			mindCounselRecordTxtList.add(mindCounselRecordTxtDto6);

			if(mindCounselRecordTxtList.size() > 0){
				MindCounselRecordTxtDto mindCounselRecordTxt = null;

				for(int i=0; i<mindCounselRecordTxtList.size(); i++){
					mindCounselRecordTxt = mindCounselRecordTxtList.get(i);

					//소견 등록 여부 체크
					int contYn = pCounselorMgrMapper.pCounselorRecordTxtChkCnt(mindCounselRecordTxt);

					if(contYn == 0){ //등록
						if(!StringUtils.isEmpty(mindCounselRecordTxt.getContent())){
							pCounselorMgrMapper.insertRecordTextDate(mindCounselRecordTxt);
						}
//							resultCnt++;
					}else{			 //수정
						pCounselorMgrMapper.updateRecordTextDate(mindCounselRecordTxt);
//							resultCnt++;
					}
				}
			}
		}
		//소견 세팅 등록/수정 end

//		상담사가 내담자에게 전하는 메시지 시작
		if( !StringUtils.isEmpty(mindCounselCounselDetail.getCounselFeedBack()) ) {
			mindCounselCounselDetail.setCounselFeedBackType(COUNSEL_FEEDBACK_TYPE_COMM_CD);
			pCounselorMgrMapper.updateCounselFeedBack(mindCounselCounselDetail);
		}
//		상담사가 내담자에게 전하는 메시지 종료
		
		
		//상담 일지상태 변경
		if(StringUtils.isEmpty(mindCounselCounselDetail.getRecordStatus())){
//				resultCnt = 0;
			throw new Exception("상담 일지를 등록할 수 없습니다.");
		}else{
			pCounselorMgrMapper.updateCounsel(mindCounselCounselDetail);
			
			try{
//				상담일지 상태가 종결이 아닐때
//				상담일지 정보를 종결로 수정할 때
//				두 가지 조건이 모두 충족되야 발송. 1회만 발송하기 위함
//				고객사가 상담포유서비스 제공 기간인지 체크 (제도운영기간 mind_client_jedo_period)
//				임직원 메일수신 동의 체크 & 메일에 필요한 정보 select 
				User user = userService.getUserSurveyInfo(mindCounselCounselDetail.getCounselCd());
				
				if("100884".equals(mindCounselCounselDetail.getCounselStatus()) && !"100884".equals(recordStatus) ){
					
					if("Y".equals(user.getJedoYn())){
						// 만족도조사 시작
						String title = "";
						String content = endCounselMailForm(user);
						
						if("police".equals(user.getClientCd())){
							title += "[마음안에] 만족도조사 안내입니다.";
						}else{
							title += "[상담포유] 만족도조사 안내입니다.";
						}
							
						if(StringUtils.isNotNull(user.getCounselMobile())){
							if("police".equals(user.getClientCd())){
								smsService.send(user.getCounselMobile(), "02-6909-4400", orderSmsPoliceService.getClientCounselEndTxtMsg(user) );
							}else if(user.getClientCd().equals("kcg") || user.getClientCd().equals("ap_global")){
								// ap_global은 해외주재원들 대상이라 SMS를 보내지 않음 
							}else if (isOptumDomain(user.getClientCd())) {
								// OPTUM 번호로 전송되도록
								smsService.send(user.getCounselMobile(), "02-6909-4414", orderSmsService.getClientCounselEndTxtMsg(user));
							}else if (isWpoDomain(user.getClientCd())) {
								// OPTUM 번호로 전송되도록
								smsService.send(user.getCounselMobile(), "02-6909-4409", orderSmsService.getClientCounselEndTxtMsg(user));
							}else if("nps".equals(user.getClientCd())){
								Calendar today = Calendar.getInstance();
								Date sendDate = null;
								int time = today.get(Calendar.HOUR_OF_DAY);
								//0시~8시59분 사이에는 그날의 아침 9시에 전송되도록 함 
								if(time>=0 && time<9) {
									today.clear();
									today.set(Calendar.HOUR, 9);
									sendDate = new Date(today.getTimeInMillis()); 
								//저녁8시에서 밤 11시59분 사이에는 다음날 아침 9시에 전송되도록 함 
								}else if(time>=20 && time<=23) {
									today.clear();
									today.add(Calendar.DATE, 1);
									today.set(Calendar.HOUR, 9);
									sendDate = new Date(today.getTimeInMillis()); 
								}
								
								smsService.send(user.getCounselMobile(), phoneAdminNumber, orderSmsService.getClientCounselEndTxtMsg4NPS(user),sendDate);
							}else{
								smsService.send(user.getCounselMobile(), phoneAdminNumber, orderSmsService.getClientCounselEndTxtMsg(user));
							}
						}
						
						if(StringUtils.isNotNull(user.getEmail()) && isOptumDomain(user.getClientCd()) == false 
								&& isWpoDomain(user.getClientCd()) == false && !user.getClientCd().equals("kcg")&& !user.getClientCd().equals("scourt")){
							// SKIP (optum 계열 고객사는 상담포유 사이트가 없으므로 사이트의 설문조사 안내 메일은 발송안함)
							mailService.send(user.getEmail(), mailSangdam4u, title, content);
						}
						// 만족도조사 종료
						
						// 법률상담 피드백 시작
						user.setCounselFeedBack(mindCounselCounselDetail.getCounselFeedBack());
						
//						피드백 내용 있을경우에만 발송
						if(!StringUtils.isEmpty(user.getCounselFeedBack())){
							if("police".equals(user.getClientCd())){
								title = "[마음안에] 상담 후 상담사가 전하는 메시지";
							}else{
								if(isOptumDomain(user.getClientCd())){
									title = "[이지웰니스] 상담 후 상담사가 전하는 메시지";
								}else {
									title = "[상담포유] 상담 후 상담사가 전하는 메시지";
								}
							}
							
							if(StringUtils.isNotNull(user.getCounselEmail()) && "Y".equals(mindCounselCounselDetail.getCheckEmail()) ){
								content =  endCounselFeedBackMailForm(user);
								mailService.send(user.getCounselEmail(), mailSangdam4u, title, content);
							}
							
							if(StringUtils.isNotNull(user.getCounselMobile()) && "Y".equals(mindCounselCounselDetail.getCheckSms()) ){
								String convertMsg = revertXSS(user.getCounselFeedBack()).replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
								user.setCounselFeedBack(convertMsg);
								
								if("police".equals(user.getClientCd())){
									smsService.send(user.getCounselMobile(), "02-6909-4400", orderSmsPoliceService.getCounselFeedBackMsg(user) );
								}else{
									if(isOptumDomain(user.getClientCd())) {
										smsService.send(user.getCounselMobile(), "02-6909-4414", orderSmsService.getCounselFeedBackMsg(user) );
									} else if(user.getClientCd().equals("ap_global")){
										// ap_global은 해외주재원들 대상이라 SMS를 보내지 않음 
									} else {
										smsService.send(user.getCounselMobile(), phoneAdminNumber, orderSmsService.getCounselFeedBackMsg(user) );
									}
								}
							}
							
						}
						// 법률상담 피드백 종료
						
					}
				}
				
				try{
					// 위험도 4, 5단계 알림 시작
					boolean isSend = false;
					if(!isSend){
						//수신 대상자 메일링 리스트
						List<String> recvMailList = mgrService.getMgrMailList(BRANCH.Ezwellness.code,
																		  	  Arrays.asList( TEAM.EAPManagement.GeneralManager.code, 
																			  		         TEAM.EAPManagement.EAPMarketingTeam.code,
																					         TEAM.EAPManagement.ContentManagementTeam.code) );
						
						List<String> recvSmsList = mgrService.getMgrSmsList(BRANCH.Ezwellness.code,
																		  	Arrays.asList( TEAM.EAPManagement.GeneralManager.code, 
																			    		   TEAM.EAPManagement.EAPMarketingTeam.code,
																					       TEAM.EAPManagement.ContentManagementTeam.code) );
						
						List<String> contentTeamMailList = mgrService.getMgrMailList(BRANCH.Ezwellness.code,
																		  	  Arrays.asList( TEAM.EAPManagement.ContentManagementTeam.code) );
						if("5".equals(mindCounselCounselDetail.getRisks())){
							String riskSmsSendYn = pCounselorMgrMapper.getRiskSmsSend(mindCounselCounselDetail);
							
							if(!"Y".equals(riskSmsSendYn)) {
								String title = "[공지-위험도 알림] 위험도 알림 lv "+ mindCounselCounselDetail.getRisks() +", 고객사 : " + user.getClientNm();
								String content = counselRecordMailForm(user, mindCounselCounselDetail.getRisks(), mindCounselCounselDetail.getRiskReason());
								
								Optional.ofNullable(recvMailList).ifPresent(l -> l.forEach(item -> {
									mailService.send(item, mailSangdam4u, title, content);
								}));
								
								Optional.ofNullable(recvSmsList).ifPresent(l -> l.forEach(item -> {
									smsService.send(item, phoneAdminNumber, "[위험도 알림] LV " + mindCounselCounselDetail.getRisks() +"\n 고객사 : "+ user.getClientNm() + "\n 상담센터 : "+ user.getCenterNm() );
								}));
								
								isSend = true;
								
								pCounselorMgrMapper.updateRiskSmsSend(mindCounselCounselDetail);
							}
						}else if( "4".equals(mindCounselCounselDetail.getRisks()) ){
							String riskSmsSendYn = pCounselorMgrMapper.getRiskSmsSend(mindCounselCounselDetail);
							
							if(!"Y".equals(riskSmsSendYn)) {
								String title = "[공지-위험도 알림] 위험도 알림 lv "+ mindCounselCounselDetail.getRisks() +", 고객사 : " + user.getClientNm();
								String content = counselRecordMailForm(user, mindCounselCounselDetail.getRisks(), mindCounselCounselDetail.getRiskReason());
	
								Optional.ofNullable(recvMailList).ifPresent(l -> l.forEach(item -> {
									mailService.send(item, mailSangdam4u, title, content);
								}));
								
								isSend = true;
								
								pCounselorMgrMapper.updateRiskSmsSend(mindCounselCounselDetail);
							}
						}else if( "3".equals(mindCounselCounselDetail.getRisks()) ){
							
							String riskReason = mindCounselCounselDetail.getRiskReason();	// 위험도사유
							String mainIssue = mindCounselCounselDetail.getMainIssue();		// 주호소문제
							String content6 = mindCounselCounselDetail.getContent6();		// 상담내용
							String content4 = mindCounselCounselDetail.getContent4();		// 상담사소견
							
							String keyWord = "";
							String location = "";
							boolean locaYn = false;
							
							// 특정 키워드가 포함되면 문자를 전송
							if (StringUtils.isNotNull(riskReason)) {
								if ( riskReason.contains("퇴직") ) 	{ locaYn = true; if(!keyWord.contains("퇴직"))	{ keyWord = keyWord + " 퇴직";} }
								if ( riskReason.contains("퇴사") ) 	{ locaYn = true; if(!keyWord.contains("퇴사"))	{ keyWord = keyWord + " 퇴사";} }
								if ( riskReason.contains("이직") ) 	{ locaYn = true; if(!keyWord.contains("이직"))	{ keyWord = keyWord + " 이직";} }
								if ( riskReason.contains("휴직") ) 	{ locaYn = true; if(!keyWord.contains("휴직"))	{ keyWord = keyWord + " 휴직";} }
								if ( riskReason.contains("자살") ) 	{ locaYn = true; if(!keyWord.contains("자살"))	{ keyWord = keyWord + " 자살";} }
								if ( riskReason.contains("자해") ) 	{ locaYn = true; if(!keyWord.contains("자해"))	{ keyWord = keyWord + " 자해";} }
								if ( riskReason.contains("타해") ) 	{ locaYn = true; if(!keyWord.contains("타해")) 	{ keyWord = keyWord + " 타해";} }
								if ( riskReason.contains("성추행") ) 	{ locaYn = true; if(!keyWord.contains("성추행"))	{ keyWord = keyWord + " 성추행";} }
								if ( riskReason.contains("성희롱") ) 	{ locaYn = true; if(!keyWord.contains("성희롱"))	{ keyWord = keyWord + " 성희롱";} }
								if ( riskReason.contains("폭행") ) 	{ locaYn = true; if(!keyWord.contains("폭행")) 	{ keyWord = keyWord + " 폭행";} }
								if ( riskReason.contains("폭력") ) 	{ locaYn = true; if(!keyWord.contains("폭력")) 	{ keyWord = keyWord + " 폭력";} }
								if ( riskReason.contains("학대") ) 	{ locaYn = true; if(!keyWord.contains("학대")) 	{ keyWord = keyWord + " 학대";} }
								if ( riskReason.contains("죽") ) 	{ locaYn = true; if(!keyWord.contains("죽")) 	{ keyWord = keyWord + " 죽이 포함된 단어";} }
								if ( locaYn ) { location = location + " 위험도사유"; locaYn = false; }
							}
							if (StringUtils.isNotNull(mainIssue)) {
								if ( mainIssue.contains("퇴직") ) 	{ locaYn = true; if(!keyWord.contains("퇴직"))	{ keyWord = keyWord + " 퇴직";} }
								if ( mainIssue.contains("퇴사") ) 	{ locaYn = true; if(!keyWord.contains("퇴사"))	{ keyWord = keyWord + " 퇴사";} }
								if ( mainIssue.contains("이직") ) 	{ locaYn = true; if(!keyWord.contains("이직"))	{ keyWord = keyWord + " 이직";} }
								if ( mainIssue.contains("휴직") ) 	{ locaYn = true; if(!keyWord.contains("휴직"))	{ keyWord = keyWord + " 휴직";} }
								if ( mainIssue.contains("자살") ) 	{ locaYn = true; if(!keyWord.contains("자살"))	{ keyWord = keyWord + " 자살";} }
								if ( mainIssue.contains("자해") ) 	{ locaYn = true; if(!keyWord.contains("자해"))	{ keyWord = keyWord + " 자해";} }
								if ( mainIssue.contains("타해") ) 	{ locaYn = true; if(!keyWord.contains("타해")) 	{ keyWord = keyWord + " 타해";} }
								if ( mainIssue.contains("성추행") ) 	{ locaYn = true; if(!keyWord.contains("성추행"))	{ keyWord = keyWord + " 성추행";} }
								if ( mainIssue.contains("성희롱") ) 	{ locaYn = true; if(!keyWord.contains("성희롱"))	{ keyWord = keyWord + " 성희롱";} }
								if ( mainIssue.contains("폭행") ) 	{ locaYn = true; if(!keyWord.contains("폭행")) 	{ keyWord = keyWord + " 폭행";} }
								if ( mainIssue.contains("폭력") ) 	{ locaYn = true; if(!keyWord.contains("폭력")) 	{ keyWord = keyWord + " 폭력";} }
								if ( mainIssue.contains("학대") ) 	{ locaYn = true; if(!keyWord.contains("학대")) 	{ keyWord = keyWord + " 학대";} }
								if ( mainIssue.contains("죽") ) 		{ locaYn = true; if(!keyWord.contains("죽")) 	{ keyWord = keyWord + " 죽이 포함된 단어";} }
								if ( locaYn ) { location = location + " 주호소문제"; locaYn = false; }
							}
							if (StringUtils.isNotNull(content6)) {
								if ( content6.contains("퇴직") ) 		{ locaYn = true; if(!keyWord.contains("퇴직"))	{ keyWord = keyWord + " 퇴직";} }
								if ( content6.contains("퇴사") ) 		{ locaYn = true; if(!keyWord.contains("퇴사"))	{ keyWord = keyWord + " 퇴사";} }
								if ( content6.contains("이직") ) 		{ locaYn = true; if(!keyWord.contains("이직"))	{ keyWord = keyWord + " 이직";} }
								if ( content6.contains("휴직") ) 		{ locaYn = true; if(!keyWord.contains("휴직"))	{ keyWord = keyWord + " 휴직";} }
								if ( content6.contains("자살") ) 		{ locaYn = true; if(!keyWord.contains("자살"))	{ keyWord = keyWord + " 자살";} }
								if ( content6.contains("자해") ) 		{ locaYn = true; if(!keyWord.contains("자해"))	{ keyWord = keyWord + " 자해";} }
								if ( content6.contains("타해") ) 		{ locaYn = true; if(!keyWord.contains("타해")) 	{ keyWord = keyWord + " 타해";} }
								if ( content6.contains("성추행") ) 	{ locaYn = true; if(!keyWord.contains("성추행"))	{ keyWord = keyWord + " 성추행";} }
								if ( content6.contains("성희롱") ) 	{ locaYn = true; if(!keyWord.contains("성희롱"))	{ keyWord = keyWord + " 성희롱";} }
								if ( content6.contains("폭행") ) 		{ locaYn = true; if(!keyWord.contains("폭행")) 	{ keyWord = keyWord + " 폭행";} }
								if ( content6.contains("폭력") ) 		{ locaYn = true; if(!keyWord.contains("폭력")) 	{ keyWord = keyWord + " 폭력";} }
								if ( content6.contains("학대") ) 		{ locaYn = true; if(!keyWord.contains("학대")) 	{ keyWord = keyWord + " 학대";} }
								if ( content6.contains("죽") ) 		{ locaYn = true; if(!keyWord.contains("죽")) 	{ keyWord = keyWord + " 죽이 포함된 단어";} }
								if ( locaYn ) { location = location + " 상담내용"; locaYn = false; }
							}
							if (StringUtils.isNotNull(content4)) {
								if ( content4.contains("퇴직") ) 		{ locaYn = true; if(!keyWord.contains("퇴직"))	{ keyWord = keyWord + " 퇴직";} }
								if ( content4.contains("퇴사") ) 		{ locaYn = true; if(!keyWord.contains("퇴사"))	{ keyWord = keyWord + " 퇴사";} }
								if ( content4.contains("이직") ) 		{ locaYn = true; if(!keyWord.contains("이직"))	{ keyWord = keyWord + " 이직";} }
								if ( content4.contains("휴직") ) 		{ locaYn = true; if(!keyWord.contains("휴직"))	{ keyWord = keyWord + " 휴직";} }
								if ( content4.contains("자살") ) 		{ locaYn = true; if(!keyWord.contains("자살"))	{ keyWord = keyWord + " 자살";} }
								if ( content4.contains("자해") ) 		{ locaYn = true; if(!keyWord.contains("자해"))	{ keyWord = keyWord + " 자해";} }
								if ( content4.contains("타해") ) 		{ locaYn = true; if(!keyWord.contains("타해")) 	{ keyWord = keyWord + " 타해";} }
								if ( content4.contains("성추행") ) 	{ locaYn = true; if(!keyWord.contains("성추행"))	{ keyWord = keyWord + " 성추행";} }
								if ( content4.contains("성희롱") ) 	{ locaYn = true; if(!keyWord.contains("성희롱"))	{ keyWord = keyWord + " 성희롱";} }
								if ( content4.contains("폭행") ) 		{ locaYn = true; if(!keyWord.contains("폭행")) 	{ keyWord = keyWord + " 폭행";} }
								if ( content4.contains("폭력") ) 		{ locaYn = true; if(!keyWord.contains("폭력")) 	{ keyWord = keyWord + " 폭력";} }
								if ( content4.contains("학대") ) 		{ locaYn = true; if(!keyWord.contains("학대")) 	{ keyWord = keyWord + " 학대";} }
								if ( content4.contains("죽") ) 		{ locaYn = true; if(!keyWord.contains("죽")) 	{ keyWord = keyWord + " 죽이 포함된 단어";} }
								if ( locaYn ) { location = location + " 상담사소견"; locaYn = false; }
							}
							
							if( !keyWord.equals("") ) {
								
								// 메시지 발송 여부 조회
								String msgReadYn = pCounselorMgrMapper.getMsgRead(mindCounselCounselDetail);
								
								if(!"Y".equals(msgReadYn)) { // 미발송시에만 발송로직
									String title = "[공지] 고위험군 스크리닝, 고객사 : " + user.getClientNm() + " 상담코드 : " + mindCounselCounselDetail.getCounselCd();
									String content = counselRecordMailForm2(user, keyWord, location);
		
									Optional.ofNullable(contentTeamMailList).ifPresent(l -> l.forEach(item -> {
										mailService.send(item, mailSangdam4u, title, content);
									}));
									
									// 발송 후 발송여부 Y값으로 변경
									pCounselorMgrMapper.updateMsgRead(mindCounselCounselDetail);
								}
								
	
							}
							isSend = true;
						}
					}
					// 위험도 4,5단계 알림 종료
				}catch (Exception e) {
					logger.error("위험도 알림 발송실패!!", e);
				}
				
			}catch(Exception e) {
				logger.error("END COUNSEL SEND SMS,EMAIL ERROR", e);
			}
			
//				resultCnt++;
		}

	}
	
	private String counselRecordMailForm(User user, String lv, String riskReason) {
		StringBuffer sb = new StringBuffer();
		
		try {
			sb.append("<br><br><br>&nbsp;상담포유 상담일지 위험도 lv").append(lv).append(" 안내입니다. <br><br> ");
			sb.append("고객사 : ").append(user.getClientNm()).append("(").append(user.getClientCd()).append(") <br>");
			sb.append("임직원명 : ").append(user.getUserNm()).append("<br>");
			sb.append("내담자명 : ").append(user.getCounselNm()).append("<br>");
			sb.append("센터명 : ").append(user.getCenterNm()).append("<br>");
			sb.append("상담일시 : ").append(user.getScheduleDt()).append("<br>");
			sb.append("상담사명 : ").append(user.getCounselorNm()).append("<br><br>");
			sb.append("위험도사유 : ").append(riskReason).append("<br><br>");
			sb.append("즐거운 하루되세요.");
			
		}catch(Exception e) {
			logger.error("FIND PWD MAIL FORM ERROR" + e.toString());
			return "";
		}
		
		return sb.toString();
	}
	
	private String counselRecordMailForm(User user, String lv){
		return counselRecordMailForm(user, lv, "");
	}
	
	private String counselRecordMailForm2(User user, String keyWord, String location){
		StringBuffer sb = new StringBuffer();
	
		try {
			sb.append("<br><br><br>&nbsp;상담포유 상담일지 고위험군 스크리닝 안내입니다. <br><br> ");
			sb.append("고객사 : ").append(user.getClientNm()).append("(").append(user.getClientCd()).append(") <br>");
			sb.append("임직원명 : ").append(user.getUserNm()).append("<br>");
			sb.append("내담자명 : ").append(user.getCounselNm()).append("<br>");
			sb.append("센터명 : ").append(user.getCenterNm()).append("<br>");
			sb.append("상담일시 : ").append(user.getScheduleDt()).append("<br>");
			sb.append("상담사명 : ").append(user.getCounselorNm()).append("<br>");
			sb.append("키워드 :").append(keyWord).append("<br>");
			sb.append("위치 :").append(location).append("<br><br>");
			sb.append("즐거운 하루되세요.");
			
		}catch(Exception e) {
			logger.error("FIND PWD MAIL FORM ERROR" + e.toString());
			return "";
		}
		
		return sb.toString();
	}

	public Paging<MindCounselIntake> pCounselorDateDetail(MindCounselIntakeDto mindCounselIntakeDto) {
		if( logger.isDebugEnabled()){
			logger.debug("===서비스 디버깅 pCounselorDateDetail ===" + mindCounselIntakeDto);
		}
		Paging<MindCounselIntake> paging = new Paging<MindCounselIntake>();
		paging.setPaging(mindCounselIntakeDto);
		paging.setList(pCounselorMgrMapper.pCounselorDateDetail(mindCounselIntakeDto));
		mindCounselIntakeDto.setPageCommonFlag(true);
		paging.setTotalCount(pCounselorMgrMapper.pCounselorDateDetail(mindCounselIntakeDto).get(0).getPageCommonCount());

		return paging;
	}

	public MindCounselIntake intakeDetail(MindCounselIntakeDto mindCounselIntakeDto) {
		return pCounselorMgrMapper.intakeDetail(mindCounselIntakeDto);
	}

	public MindCounselIntake baseInfoDetail(MindCounselIntakeDto mindCounselIntakeDto) {
		MindCounselIntake mindCounselIntake = pCounselorMgrMapper.baseInfoDetail(mindCounselIntakeDto);
		setScheduleDtOverdue(mindCounselIntake);
		return mindCounselIntake;
	}

	private void setScheduleDtOverdue(MindCounselIntake mindCounselIntake) {
		String scheduleDt = mindCounselIntake.getScheduleDt();
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
		try {
			Date scheduleDtDate = simpleDateFormat.parse(scheduleDt);
			
			LocalDate schedulDtLocalDate = scheduleDtDate.toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
			LocalDate today = LocalDate.now();
			Period period = Period.between(schedulDtLocalDate, today);
			int months = period.getMonths();
			if(months < 2) {
				mindCounselIntake.setScheduleDtOverdue("N");
			} else {
				mindCounselIntake.setScheduleDtOverdue("Y");
			}
		} catch (ParseException e) {
			logger.error("scheduleDt's value is wrong ["+scheduleDt+"]" + e.toString());
		}
	}

	public HashMap<String, MindSchedule> getMonthScheduleMap(MindScheduleDto mindScheduleDto) {
		HashMap<String, MindSchedule> scheduleMap = new HashMap<String, MindSchedule>();
		List<MindSchedule> scheduleList = new ArrayList<MindSchedule>();
		scheduleList =  pCounselorMgrMapper.getMonthScheduleList(mindScheduleDto);
		if(scheduleList != null) {
			for(MindSchedule scheduleTmp : scheduleList) {
				String keyString = "";

				if(StringUtils.isEquals(scheduleTmp.getHolidayYn(),"Y")) {
					keyString = "humu_" + StringUtils.substring(scheduleTmp.getYmd(), 6, 9);
				} else if( SANGDAM_SCHEDULE_TYPE_COMM_CD == scheduleTmp.getScheduleType()) {
					keyString = "sangdam_" + StringUtils.substring(scheduleTmp.getYmd(), 6, 9) + "_" + StringUtils.substring(scheduleTmp.getStTime(), 0, 2);
				} else if( GUMSA_SCHEDULE_TYPE_COMM_CD == scheduleTmp.getScheduleType()) {
					keyString = "gumsa_" + StringUtils.substring(scheduleTmp.getYmd(), 6, 9) + "_" + StringUtils.substring(scheduleTmp.getStTime(), 0, 2);
				}
				logger.debug(">>>> scheduleMap : "+keyString);
				scheduleMap.put(keyString, scheduleTmp);
			}
		}
		return scheduleMap;
	}

	public void updateSchedule(MindScheduleDto mindScheduleDto, HttpServletRequest req) {

		String toDate = DateUtils.toDateStringYMD();
		String toHour = DateUtils.toDateStringYMDHMS().substring(8, 10);
		String thisYm = req.getParameter("thisYm");
		String ymd = "";
		String day = "";
		String time = "";
		
		ArrayList<MindScheduleDto> delHumuArr = new ArrayList<MindScheduleDto>();
		ArrayList<MindScheduleDto> delUnCheckArr = new ArrayList<MindScheduleDto>();
		ArrayList<MindScheduleDto> delHolidayArr = new ArrayList<MindScheduleDto>();
		ArrayList<MindScheduleDto> delSangDam = new ArrayList<MindScheduleDto>();
		ArrayList<MindScheduleDto> delGumSa = new ArrayList<MindScheduleDto>();
		
		ArrayList<MindScheduleDto> insertList = new ArrayList<MindScheduleDto>();

		MindScheduleDto tmpSchedule = new MindScheduleDto();
		tmpSchedule.setCenterSeq(mindScheduleDto.getCenterSeq());
		tmpSchedule.setUserId(mindScheduleDto.getUserId());
		tmpSchedule.setMgrId(mindScheduleDto.getMgrId());
		tmpSchedule.setCounselCd("0");

		for (int seq = 1; seq < 32; seq++) {
			if(seq < 10) {
				day = "0" + Integer.toString(seq);
			} else {
				day = Integer.toString(seq);
			}

			ymd = thisYm + day;

			//오늘 이전 데이터는 수정 안함.
			if( Integer.parseInt(ymd) < Integer.parseInt(toDate)) continue;

			tmpSchedule.setYmd(ymd);

			//휴무일 처리
			String humu_xx = req.getParameter("humu_" + day);
			if (humu_xx != null && humu_xx.length() == 8 ) {
				//processHolidaySchedule(tmpSchedule, humu_xx);
				
				MindScheduleDto m = new MindScheduleDto();
				m.setCenterSeq(tmpSchedule.getCenterSeq());
				m.setUserId(tmpSchedule.getUserId());
				m.setMgrId(tmpSchedule.getMgrId());
				m.setHolidayYn("Y");
				m.setYmd(humu_xx);
				insertList.add(m);
				
				//delHumuArr += humu_xx + ", ";
				delHumuArr.add(m);
			} else {
				//일정 수정
				String iIndex_xx = req.getParameter("idx_" + day);

				//선택 안한 일정 삭제
				if (iIndex_xx == null || iIndex_xx == "") {
					//pCounselorMgrMapper.deleteHolidaySchedule(tmpSchedule);
					MindScheduleDto m = new MindScheduleDto();
					m.setCenterSeq(tmpSchedule.getCenterSeq());
					m.setUserId(tmpSchedule.getUserId());
					m.setMgrId(tmpSchedule.getMgrId());
					m.setYmd(ymd);
					//delUnCheckArr += ymd + ", ";
					delUnCheckArr.add(m);
					continue;
				} else {
					//pCounselorMgrMapper.deleteHoliday(tmpSchedule);
					//delHolidayArr += ymd + ", ";
					MindScheduleDto m = new MindScheduleDto();
					m.setCenterSeq(tmpSchedule.getCenterSeq());
					m.setUserId(tmpSchedule.getUserId());
					m.setMgrId(tmpSchedule.getMgrId());
					m.setYmd(ymd);
					delHolidayArr.add(m);
				}

				for(int t = 7; t <= 22; t++ ) {
					if(t < 10) {
						time = "0" + Integer.toString(t);
					} else {
						time= Integer.toString(t);
					}

					//금일이고 현재시간 이전 데이터는 수정 안함.
					if( ymd.equals(toDate) && Integer.parseInt(time) < Integer.parseInt(toHour)) continue;

					String sangdam_xx = req.getParameter("sangdam_" + day + "_" + time);
					String gumsa_xx = req.getParameter("gumsa_" + day + "_" + time);

					//상담 스케줄 등록
					tmpSchedule.setScheduleType(SANGDAM_SCHEDULE_TYPE_COMM_CD);
					if (sangdam_xx == null || sangdam_xx == "") {
						tmpSchedule.setYmd(ymd);
						tmpSchedule.setStTime(time+"00");

						//선택안한 상담 스케줄 삭제
						//if( pCounselorMgrMapper.getScheduleCnt(tmpSchedule) > 0) {
							//pCounselorMgrMapper.deleteSchedule(tmpSchedule);
							//delSangDamStdtArr += time + "00, ";
							//delSangDamYmdArr += ymd + ", ";
							
							MindScheduleDto m = new MindScheduleDto();
							m.setScheduleType(SANGDAM_SCHEDULE_TYPE_COMM_CD);
							m.setCenterSeq(tmpSchedule.getCenterSeq());
							m.setUserId(tmpSchedule.getUserId());
							m.setMgrId(tmpSchedule.getMgrId());
							m.setStTime(time + "00");
							m.setYmd(ymd);
							
							delSangDam.add(m);
						//}
					} else {
						String[] sangdam = StringUtils.split(sangdam_xx, "-");
						tmpSchedule.setHolidayYn("N");
						tmpSchedule.setYmd(sangdam[0]);
						tmpSchedule.setStTime(sangdam[1]);
						tmpSchedule.setEdTime(sangdam[2]);

						//상담 스케줄 등록
						//if( pCounselorMgrMapper.getScheduleCnt(tmpSchedule) == 0) {
							MindScheduleDto m = new MindScheduleDto();
							
							m.setScheduleType(SANGDAM_SCHEDULE_TYPE_COMM_CD);
							m.setCenterSeq(tmpSchedule.getCenterSeq());
							m.setUserId(tmpSchedule.getUserId());
							m.setMgrId(tmpSchedule.getMgrId());
							m.setCounselCd("0");
							m.setHolidayYn("N");
							m.setYmd(sangdam[0]);
							m.setStTime(sangdam[1]);
							m.setEdTime(sangdam[2]);
							insertList.add(m);
							//pCounselorMgrMapper.insertSchedule(tmpSchedule);
						//}
					}

					//검사 스케줄 등록
					tmpSchedule.setScheduleType(GUMSA_SCHEDULE_TYPE_COMM_CD);
					if (gumsa_xx == null || gumsa_xx == "") {
						tmpSchedule.setYmd(ymd);
						tmpSchedule.setStTime(time+"00");

						//선택안한 검사 스케줄 삭제
						//if( pCounselorMgrMapper.getScheduleCnt(tmpSchedule) > 0) {
							//pCounselorMgrMapper.deleteSchedule(tmpSchedule);
							//delGumSaStdtArr += time + "00, ";
							//delGumSaYmdArr += ymd + ", ";
							
							MindScheduleDto m = new MindScheduleDto();
							m.setScheduleType(GUMSA_SCHEDULE_TYPE_COMM_CD);
							m.setCenterSeq(tmpSchedule.getCenterSeq());
							m.setUserId(tmpSchedule.getUserId());
							m.setMgrId(tmpSchedule.getMgrId());
							m.setStTime(time + "00");
							m.setYmd(ymd);
							
							delGumSa.add(m);
						//}
					} else {
						String[] gumsa = StringUtils.split(gumsa_xx, "-");
						tmpSchedule.setHolidayYn("N");
						tmpSchedule.setYmd(gumsa[0]);
						tmpSchedule.setStTime(gumsa[1]);
						tmpSchedule.setEdTime(gumsa[2]);

						//검사 스케줄 등록
						//if( pCounselorMgrMapper.getScheduleCnt(tmpSchedule) == 0) {
							//pCounselorMgrMapper.insertSchedule(tmpSchedule);
							MindScheduleDto m = new MindScheduleDto();
							
							m.setScheduleType(GUMSA_SCHEDULE_TYPE_COMM_CD);
							m.setCenterSeq(tmpSchedule.getCenterSeq());
							m.setUserId(tmpSchedule.getUserId());
							m.setMgrId(tmpSchedule.getMgrId());
							m.setCounselCd("0");
							m.setHolidayYn("N");
							m.setYmd(gumsa[0]);
							m.setStTime(gumsa[1]);
							m.setEdTime(gumsa[2]);
							insertList.add(m);
						//}
					}
				}
			}
		}	
		
		if (delHumuArr.size() > 0) {
			HashMap<String, Object> itemMap = new HashMap<String, Object>();
			itemMap.put("itemMap", delHumuArr);
			pCounselorMgrMapper.deleteHolidaySchedule2(itemMap);
		}
		
		if (delUnCheckArr.size() > 0) {
			HashMap<String, Object> itemMap = new HashMap<String, Object>();
			itemMap.put("itemMap", delUnCheckArr);
			pCounselorMgrMapper.deleteHolidaySchedule2(itemMap);
		}
		
		if (delHolidayArr.size() > 0) {
			HashMap<String, Object> itemMap = new HashMap<String, Object>();
			itemMap.put("itemMap", delHolidayArr);
			pCounselorMgrMapper.deleteHoliday2(itemMap);
		}
		
		if (delSangDam.size() > 0) {
			for (MindScheduleDto dto : delSangDam) {
				pCounselorMgrMapper.deleteSchedule2(dto);
			}
		}
		
		if (delGumSa.size() > 0) {
			for (MindScheduleDto dto : delGumSa) {
				pCounselorMgrMapper.deleteSchedule2(dto);
			}
		}
		
		if (insertList.size() > 0) {
			for(MindScheduleDto dto : insertList){
				if( pCounselorMgrMapper.getScheduleCnt(dto) == 0) {
					pCounselorMgrMapper.insertSchedule(dto);
				}
			}
			
			/*
			HashMap<String, Object> itemMap = new HashMap<String, Object>();
			itemMap.put("itemMap", insertList);
			
			pCounselorMgrMapper.insertSchedule2(itemMap);
			*/
		}
	}

	public String processHolidaySchedule(MindScheduleDto mindScheduleDto, String day) {

		String result = "";
		MindScheduleDto tmpSchedule = new MindScheduleDto();
		tmpSchedule.setCenterSeq(mindScheduleDto.getCenterSeq());
		tmpSchedule.setUserId(mindScheduleDto.getUserId());
		tmpSchedule.setMgrId(mindScheduleDto.getMgrId());
		tmpSchedule.setHolidayYn("Y");
		tmpSchedule.setYmd(day);

		// 휴무일 등록
		int cnt = pCounselorMgrMapper.getHolidayScheduleCnt(tmpSchedule);
		if(cnt > 0) {
			result = "error";
		} else {
			//기존 등록 내역 삭제
			pCounselorMgrMapper.deleteHolidaySchedule(tmpSchedule);
			//휴무일로 등록
			pCounselorMgrMapper.insertSchedule(tmpSchedule);
		}

		return result;
	}

	public int selectPCounselorDateInput(MindCounselIntakeDto mindCounselIntakeDto){

		return pCounselorMgrMapper.selectPCounselorDateInput(mindCounselIntakeDto);
	}

	public int updatePCounselorDateInput(MindCounselIntakeDto mindCounselIntakeDto){

		return pCounselorMgrMapper.updatePCounselorDateInput(mindCounselIntakeDto);
	}

	public MindCounselCounselDetail pCounselorRecordDtl(MindCounselCounselDetail mindCounselCounselDetail) {
		return pCounselorMgrMapper.pCounselorRecordDtl(mindCounselCounselDetail);
	}
	
	public MindCounselCounselDetail pCounselFirstRecordDetail(MindCounselCounselDetail mindCounselCounselDetail) {
		return pCounselorMgrMapper.pCounselFirstRecordDetail(mindCounselCounselDetail);
	}

	public List<MindCounselCounselDetail> pCounselorRecordTxtList(MindCounselCounselDetail mindCounselCounselDetail) {
		return pCounselorMgrMapper.pCounselorRecordTxtList(mindCounselCounselDetail);
	}

	public List<MindCounselCounselDetail> pCounselorRecordCnt(MindCounselCounselDetail mindCounselCounselDetail) {
		return pCounselorMgrMapper.pCounselorRecordCnt(mindCounselCounselDetail);
	}
	
	/**
	 * 오늘의 노쇼 데이터 조회
	 * 
	 * @return
	 */
	public List<MindCounselCounselDetail> getTodayNoShowCounselData() {
		return pCounselorMgrMapper.getTodayNoShowCounselData();
	}
	
	public void updatePCounselSchedule(){
		pCounselorMgrMapper.updatePCounselSchedule();
	}
	
	public List<MindCounselCounselDetail> getCounselInfo(MindCounselIntakeDto mindCounselIntakeDto){
		return pCounselorMgrMapper.getCounselInfo(mindCounselIntakeDto);
	}
	
	public MindCounselCounselDetail	getReplyInfo(MindCounselIntakeDto mindCounselIntakeDto){
		return pCounselorMgrMapper.getReplyInfo(mindCounselIntakeDto);
	}
	
	public int addCounselBbsAdd(MindCounselIntakeDto mindCounselIntakeDto){
		int result = pCounselorMgrMapper.addCounselBbsAdd(mindCounselIntakeDto);
		
		if(result > 0){
			if("Y".equals(mindCounselIntakeDto.getAnswerYn())){
				EmployData empData = pCounselorMgrMapper.getUserInfo(mindCounselIntakeDto);
				String content = empData.getUserNm();
				content += "님 안녕하세요? 상담포유입니다.\n 요청하신 1:1게시판상담에 대한 답변이 등록되었습니다.\n ★상담답변지 확인 방법\n - 마이페이지 > 나의상담이력 > 1:1상담게시판 클릭";
			
				smsService.send(empData.getMobile(), phoneAdminNumber, content);
			}
		}
		
		return result;
	}
	
	// 만족도 조사(종결) 메일
	public String endCounselMailForm(User user) {
		StringBuffer sb = new StringBuffer();
		String currentDate 	= new SimpleDateFormat("yyyy/MM/dd").format(new Date());
	
		try {

		sb.append("<table style='width:600px; margin:0 auto; padding:0; color:#666; font-size:12px; font-style:normal;' cellspacing='0' cellpadding='0'>");

//		상단 헤더(날짜표시) 시작
		sb.append("<thead><tr>");
		sb.append("<th style='width:50%; padding:37px 0 10px 0;' align='left'>");
		sb.append("<a href='#'><img src='//img.ezwelmind.co.kr/sangdam4u/images/mailform/img_logo.gif' border='0' alt='ezwel mind' /></a></th>");
//		날짜 표시 부분 ↓
		sb.append("<th style='width:50%; vertical-align:bottom; font-size:12px; padding:0 0 12px 0;' align='right'>"+ currentDate +"</th>");
		sb.append("</tr></thead>");
//		상단 헤더(날짜표시) 종료
		
//		내용 시작
		sb.append("<tbody>");
		sb.append("<tr><td colspan='2' style='height:1px; background:#727272;'></td></tr>");
		sb.append("<tr><td colspan='2' style='height:65px; background:#f9f9f9;'></td></tr>");
		sb.append("<tr><td colspan='2' style='background:#f9f9f9'>");
		sb.append("<table style='width:100%;' cellspacing='0' cellpadding='0'><tr><td style='width:50px;'></td><td style='width:85%;'>");
		sb.append("<table cellpadding='0' cellspacing='0' border='0' style='width:100%;'>");
		sb.append("<tr><td style='width:40px;'></td>");
		sb.append("<td align='center' style='font-size:24px; color:#3b3b3b; border-bottom:1px solid #000000; padding:0 0 20px 0;'><strong>만족도조사 안내</strong></td>");
		sb.append("<td style='width:40px;'></td></tr><tr><td style='width:40px;'></td>");
//		사용자이름 부분 ↓
		sb.append("<td align='center' style='font-size:18px; padding:30px 0 46px 0;'><span style='color:#3eb3c7;'>"+ user.getUserNm() +"</span>님 안녕하세요<br><br>"+ user.getScheduleDt() +"<br>"+ user.getCenterNm() +"("+ user.getCounselorNm() +")에서<br> 진행한 상담은 편안하셨는지요?<br><br> 다음 상담 이용 시 향상된 서비스를<br>제공하기 위해 만족도조사를 진행합니다. </td>");
		sb.append("<td style='width:40px;'></td></tr></table></td><td style='width:50px;'></td></tr>");
		sb.append("<tr>	<td style='width:50px;'></td>");
		sb.append("<td style='width:50px;'></td></tr><tr><td colspan='3' height='34'></td></tr>");
		if("police".equals(user.getClientCd())){
			sb.append("<tr><td colspan='3' align='center' style='font-size:15px; color:#999898;'><strong style='color:#3eb3c7; font-weight:normal;'>마음안에 홈페이지("+ user.getClientCd() +".sangdam4u.com)<br> > 마이페이지 > 상담내역조회 > 만족도조사</strong> <br> 를 통해 진행해주시기 바랍니다.</td></tr>");
		}else{
			sb.append("<tr><td colspan='3' align='center' style='font-size:15px; color:#999898;'><strong style='color:#3eb3c7; font-weight:normal;'>상담포유 홈페이지("+ user.getClientCd() +".sangdam4u.com)<br> > 나의상담포유 > 상담/검사조회 > 만족도조사</strong> <br> 를 통해 진행해주시기 바랍니다.</td></tr>");
		}
		sb.append("<tr><td colspan='3' height='40'></td></tr>");
		sb.append("<tr><td colspan='3' align='center'>");
//		상담포유 바로가기 링크 ↓
		if("police".equals(user.getClientCd())){
			sb.append("<a href='http://"+ user.getClientCd() +".sangdam4u.com/' target='_blank' style='display:block; padding:11px 0; width:262px; background:#3eb3c7; color:#fff; font-size:14px; text-decoration:none;'>마음안에 바로가기</a></td></tr>");
		}else{
			sb.append("<a href='http://"+ user.getClientCd() +".sangdam4u.com/' target='_blank' style='display:block; padding:11px 0; width:262px; background:#3eb3c7; color:#fff; font-size:14px; text-decoration:none;'>상담포유 바로가기</a></td></tr>");
		}
		sb.append("<tr><td colspan='3' height='70'></td></tr>");
		sb.append("<tr><td style='width:50px;'></td>");
		sb.append("<td style='font-size:11px; color:#a4a4a4;'>* 본메일은 발신전용으로 회답하지 않습니다. 문의사항은 고객센터로 문의바랍니다.</td>");
		sb.append("<td style='width:50px;'></td></tr>");
		sb.append("<tr><td colspan='3' height='28'></td></tr>");
		sb.append("<tr><td colspan='3' style='height:1px; background:#c4c4c4;'></td></tr>");
		sb.append("</table></td></tr>");
		sb.append("</tbody>");
//		내용 종료
		
//		Footer 시작
		sb.append("<tfoot><tr>");
		sb.append("<td colspan='2' style='background:#fff;'>");
		sb.append("<table cellpadding='0' cellspacing='0' border='0'>");
		sb.append("<tr><td height='10'></td></tr>");
		sb.append("<tr><td style='color:#b7b7b7; font-size:11px;'><span style='color:#8b8b8b;'>이지웰니스(주)</span> 서울시 구로구 디지털로 34길 43 (구로동)코오롱싸이언스밸리 1차 11층</td></tr>");
		sb.append("<tr><td style='color:#b7b7b7; font-size:11px;'><span style='color:#8b8b8b;'>사업자등록번호</span> 423-86-00129&nbsp;&nbsp;&nbsp;<span style='color:#8b8b8b;'>통신판매업신고</span>&nbsp;&nbsp;구로-0917호</td></tr>");
		
		if("police".equals(user.getClientCd())){
			sb.append("<tr><td style='color:#b7b7b7; font-size:11px;'><span style='color:#8b8b8b;'>대표</span>강민재&nbsp;&nbsp;&nbsp;<span style='color:#8b8b8b;'>개인정보보호최고관리책임자</span>&nbsp;강민재&nbsp;&nbsp;&nbsp;<span style='color:#8b8b8b;'>고객센터</span>&nbsp;&nbsp;TEL&nbsp;(02)&nbsp;6909&nbsp;&nbsp;4400&nbsp;&nbsp;&nbsp;&nbsp;FAX (070)&nbsp;7500&nbsp;&nbsp;1697</td></tr>");
		}else{
			sb.append("<tr><td style='color:#b7b7b7; font-size:11px;'><span style='color:#8b8b8b;'>대표</span>강민재&nbsp;&nbsp;&nbsp;<span style='color:#8b8b8b;'>개인정보보호최고관리책임자</span>&nbsp;강민재&nbsp;&nbsp;&nbsp;<span style='color:#8b8b8b;'>고객센터</span>&nbsp;&nbsp;TEL&nbsp;1644&nbsp;&nbsp;4474&nbsp;&nbsp;&nbsp;&nbsp;FAX (070)&nbsp;7500&nbsp;&nbsp;1697</td></tr>");
		}
		
		sb.append("<tr><td style='color:#b7b7b7; font-size:11px;'>copyright (c) 2001~2016 EZWELLFARE Corp. All rights Reserved.</td></tr>");
		sb.append("<tr><td height='10'></td></tr>");
		sb.append("</table></td></tr>");
		sb.append("</tfoot>");
		sb.append("</table>");
//		Footer 종료
		
		
		}catch(Exception e) {
			logger.error("FIND PWD MAIL FORM ERROR" + e.toString());
			return "";
		}
		
		return sb.toString();
	}
	
	public void adminUpdatePCounselSchedule(MindScheduleDto mindScheduleDto){
		pCounselorMgrMapper.adminUpdatePCounselSchedule(mindScheduleDto);
	}
	
	public MindCounselCounselDetail pCounselorRecordFeedBack(MindCounselCounselDetail mindCounselCounselDetail) {
		return pCounselorMgrMapper.pCounselorRecordFeedBack(mindCounselCounselDetail);
	}
	
	// 레코드 데이터 입력
	public int insertRecordDate(MindCounselCounselDetail mindCounselCounselDetail) {
		return pCounselorMgrMapper.insertRecordDate(mindCounselCounselDetail);
	}
	
	public String endCounselFeedBackMailForm(User user) {
		StringBuffer sb = new StringBuffer();
		String currentDate 	= new SimpleDateFormat("yyyy/MM/dd").format(new Date());
	
		try {

		sb.append("<table style='width:600px; margin:0 auto; padding:0; color:#666; font-size:12px; font-style:normal;' cellspacing='0' cellpadding='0'>");

//		상단 헤더(날짜표시) 시작
		sb.append("<thead><tr>");
		sb.append("<th style='width:50%; padding:37px 0 10px 0;' align='left'>");
		sb.append("<a href='#'><img src='//img.ezwelmind.co.kr/sangdam4u/images/mailform/img_logo.gif' border='0' alt='ezwel mind' /></a></th>");
//		날짜 표시 부분 ↓
		sb.append("<th style='width:50%; vertical-align:bottom; font-size:12px; padding:0 0 12px 0;' align='right'>"+ currentDate +"</th>");
		sb.append("</tr></thead>");
//		상단 헤더(날짜표시) 종료
		
//		내용 시작
		sb.append("<tbody>");
		sb.append("<tr><td colspan='2' style='height:1px; background:#727272;'></td></tr>");
		sb.append("<tr><td colspan='2' style='height:65px; background:#f9f9f9;'></td></tr>");
		sb.append("<tr><td colspan='2' style='background:#f9f9f9'>");
		sb.append("<table style='width:100%;' cellspacing='0' cellpadding='0'><tr><td style='width:50px;'></td><td style='width:85%;'>");
		sb.append("<table cellpadding='0' cellspacing='0' border='0' style='width:100%;'>");
		sb.append("<tr><td style='width:40px;'></td>");
		sb.append("<td align='center' style='font-size:24px; color:#3b3b3b; border-bottom:1px solid #000000; padding:0 0 20px 0;'><strong>상담사가 전하는 메시지</strong></td>");
		sb.append("<td style='width:40px;'></td></tr><tr><td style='width:40px;'></td>");
//		사용자이름 부분 ↓
		if(isOptumDomain(user.getClientCd())) {
			sb.append("<td align='center' style='font-size:18px; padding:30px 0 46px 0;'><span style='color:#3eb3c7;'>"+ user.getUserNm() +"</span>님 안녕하세요?<br>임직원을 위한 상담서비스를 제공하는 이지웰니스(주) 고객센터입니다.<br><br>"+ user.getScheduleDt() +"<br>"+ user.getCenterNm() +"("+ user.getCounselorNm() +")에서<br> 진행하신 상담은 만족스러우셨는지요?<br><br>도움받으셨던 상담에 대해<br>한번 더 요약하여 전달드립니다.<br>아래의 내용 확인해주시기 바랍니다.</td>");
		} else {
			sb.append("<td align='center' style='font-size:18px; padding:30px 0 46px 0;'><span style='color:#3eb3c7;'>"+ user.getUserNm() +"</span>님 안녕하세요?<br>상담포유 고객센터입니다.<br><br>"+ user.getScheduleDt() +"<br>"+ user.getCenterNm() +"("+ user.getCounselorNm() +")에서<br> 진행하신 법률상담은 만족스러우셨는지요?<br><br>도움받으셨던 상담에 대해<br>한번 더 요약하여 전달드립니다.<br>아래의 내용 확인해주시기 바랍니다.</td>");
		}
		sb.append("<td style='width:40px;'></td></tr></table></td><td style='width:50px;'></td></tr>");
		sb.append("<tr>	<td style='width:50px;'></td><td align='center' style='width:85%;'>"+ user.getCounselFeedBack() +"</td>");
		sb.append("<td style='width:50px;'></td></tr><tr><td colspan='3' height='34'></td></tr>");
		if(isOptumDomain(user.getClientCd()) == false) {
			if("police".equals(user.getClientCd())){
				sb.append("<tr><td colspan='3' align='center' style='font-size:15px; color:#999898;'><strong style='color:#3eb3c7; font-weight:normal;'>마음안에 홈페이지("+ user.getClientCd() +".sangdam4u.com)<br> > 마이페이지 > 상담내역조회 > 신청상세내역</strong> <br> 을 통해 확인 가능합니다.<br><br>상담포유는 더 행복한 내일을 위해 항상 최선을 다하겠습니다.</td></tr>");
			}else{
				sb.append("<tr><td colspan='3' align='center' style='font-size:15px; color:#999898;'><strong style='color:#3eb3c7; font-weight:normal;'>상담포유 홈페이지("+ user.getClientCd() +".sangdam4u.com)<br> > 나의상담포유 > 상담/검사조회 > 신청상세내역</strong> <br> 을 통해 확인 가능합니다.<br><br>상담포유는 더 행복한 내일을 위해 항상 최선을 다하겠습니다.</td></tr>");
			}
		} else {
			sb.append("<tr><td colspan='3' align='center' style='font-size:15px; color:#999898;'>감사합니다 <br/><br/>★문의사항은 고객센터(02-6909-4414)로 문의 주시기 바랍니다.</td></tr>");
		}
		sb.append("<tr><td colspan='3' height='40'></td></tr>");
		if(isOptumDomain(user.getClientCd()) == false) {
//		상담포유 바로가기 링크 ↓
			sb.append("<tr><td colspan='3' align='center'>");
			if("police".equals(user.getClientCd())){
				sb.append("<a href='http://"+ user.getClientCd() +".sangdam4u.com/' target='_blank' style='display:block; padding:11px 0; width:262px; background:#3eb3c7; color:#fff; font-size:14px; text-decoration:none;'>마음안에 바로가기</a></td></tr>");
			}else{
				sb.append("<a href='http://"+ user.getClientCd() +".sangdam4u.com/' target='_blank' style='display:block; padding:11px 0; width:262px; background:#3eb3c7; color:#fff; font-size:14px; text-decoration:none;'>상담포유 바로가기</a></td></tr>");
			}
			sb.append("<tr><td colspan='3' height='70'></td></tr>");
		}
		sb.append("<tr><td style='width:50px;'></td>");
		sb.append("<td style='font-size:11px; color:#a4a4a4;'>* 본메일은 발신전용으로 회답하지 않습니다. 문의사항은 고객센터로 문의바랍니다.</td>");
		sb.append("<td style='width:50px;'></td></tr>");
		sb.append("<tr><td colspan='3' height='28'></td></tr>");
		sb.append("<tr><td colspan='3' style='height:1px; background:#c4c4c4;'></td></tr>");
		sb.append("</table></td></tr>");
		sb.append("</tbody>");
//		내용 종료
		
//		Footer 시작
		sb.append("<tfoot><tr>");
		sb.append("<td colspan='2' style='background:#fff;'>");
		sb.append("<table cellpadding='0' cellspacing='0' border='0'>");
		sb.append("<tr><td height='10'></td></tr>");
		sb.append("<tr><td style='color:#b7b7b7; font-size:11px;'><span style='color:#8b8b8b;'>이지웰니스(주)</span> 서울시 구로구 디지털로 34길 43 (구로동)코오롱싸이언스밸리 1차 11층</td></tr>");
		sb.append("<tr><td style='color:#b7b7b7; font-size:11px;'><span style='color:#8b8b8b;'>사업자등록번호</span> 423-86-00129&nbsp;&nbsp;&nbsp;<span style='color:#8b8b8b;'>통신판매업신고</span>&nbsp;&nbsp;구로-0917호</td></tr>");
		
		if("police".equals(user.getClientCd())){
			sb.append("<tr><td style='color:#b7b7b7; font-size:11px;'><span style='color:#8b8b8b;'>대표</span>강민재&nbsp;&nbsp;&nbsp;<span style='color:#8b8b8b;'>개인정보보호최고관리책임자</span>&nbsp;강민재&nbsp;&nbsp;&nbsp;<span style='color:#8b8b8b;'>고객센터</span>&nbsp;&nbsp;TEL&nbsp;(02)&nbsp;6909&nbsp;&nbsp;4400&nbsp;&nbsp;&nbsp;&nbsp;FAX (070)&nbsp;7500&nbsp;&nbsp;1697</td></tr>");
		}else if(isOptumDomain(user.getClientCd()) == true) {
			sb.append("<tr><td style='color:#b7b7b7; font-size:11px;'><span style='color:#8b8b8b;'>대표</span>강민재&nbsp;&nbsp;&nbsp;<span style='color:#8b8b8b;'>개인정보보호최고관리책임자</span>&nbsp;강민재&nbsp;&nbsp;&nbsp;<span style='color:#8b8b8b;'>고객센터</span>&nbsp;&nbsp;TEL&nbsp;(02)&nbsp;6909&nbsp;&nbsp;4414&nbsp;&nbsp;&nbsp;&nbsp;FAX (070)&nbsp;7500&nbsp;&nbsp;1697</td></tr>");
		}else{
			sb.append("<tr><td style='color:#b7b7b7; font-size:11px;'><span style='color:#8b8b8b;'>대표</span>강민재&nbsp;&nbsp;&nbsp;<span style='color:#8b8b8b;'>개인정보보호최고관리책임자</span>&nbsp;강민재&nbsp;&nbsp;&nbsp;<span style='color:#8b8b8b;'>고객센터</span>&nbsp;&nbsp;TEL&nbsp;1644&nbsp;&nbsp;4474&nbsp;&nbsp;&nbsp;&nbsp;FAX (070)&nbsp;7500&nbsp;&nbsp;1697</td></tr>");
		}
		
		sb.append("<tr><td style='color:#b7b7b7; font-size:11px;'>copyright (c) 2001~2016 EZWELLFARE Corp. All rights Reserved.</td></tr>");
		sb.append("<tr><td height='10'></td></tr>");
		sb.append("</table></td></tr>");
		sb.append("</tfoot>");
		sb.append("</table>");
//		Footer 종료
		
		
		}catch(Exception e) {
			//logger.error("FIND PWD MAIL FORM ERROR" + e.toString());
			return "";
		}
		
		return sb.toString();
	}
	
	public static String revertXSS(String value) {
		if( value == null ) value = "";
		value = value.replaceAll("&lt;","<");
		value = value.replaceAll("&gt;", ">");
		value = value.replaceAll("&amp;","&");
		value = value.replaceAll("&quot;","\"");
		value = value.replaceAll("&nbsp;"," ");
		return value;
	}
	
	public List<MindCounselIntake>  getCounselDiagnosis(String intakeCd) {
		return pCounselorMgrMapper.getCounselDiagnosis(intakeCd);
	}
	
	protected static boolean isOptumDomain(String clientCd) {
		if(StringUtils.containsIgnoreCase(clientCd, "optum") || StringUtils.containsIgnoreCase(clientCd, "op_") ) {
			return true;
		}
		return false;
	}
	
	protected static boolean isWpoDomain(String clientCd) {
		if(StringUtils.containsIgnoreCase(clientCd, "wpo")) {
			return true;
		}
		return false;
	}
}
