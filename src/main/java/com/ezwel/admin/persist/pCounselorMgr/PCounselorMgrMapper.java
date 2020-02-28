package com.ezwel.admin.persist.pCounselorMgr;

import java.util.List;
import java.util.Map;

import com.ezwel.admin.domain.entity.employ.EmployData;
import com.ezwel.admin.domain.entity.pCounselorMgr.MindCounselCounselDetail;
import com.ezwel.admin.domain.entity.pCounselorMgr.MindCounselIntake;
import com.ezwel.admin.domain.entity.pCounselorMgr.MindSchedule;
import com.ezwel.admin.service.pCounselorMgr.dto.MindCounselIntakeDto;
import com.ezwel.admin.service.pCounselorMgr.dto.MindCounselRecordTxtDto;
import com.ezwel.admin.service.pCounselorMgr.dto.MindScheduleDto;

@SuppressWarnings("PMD.UnusedModifier")
public interface PCounselorMgrMapper {

	public List<MindCounselIntake> pCounselorDateList(MindCounselIntakeDto mindCounselIntakeDto);

//	public void insertPlanDate(MindCounselPlanDto mindCounselPlanDto);
//	public void insertRecordDate(MindCounselRecordDto mindCounselRecordDto);
	public void insertPlanDate(MindCounselCounselDetail mindCounselCounselDetail);
	public int insertRecordDate(MindCounselCounselDetail mindCounselCounselDetail);
	public void insertRecordTextDate(MindCounselRecordTxtDto mindCounselRecordTxtDto);
	public void insertCounselRecordHis(MindCounselCounselDetail mindCounselCounselDetail);
	
//	public void updatePlanDate(MindCounselPlanDto mindCounselPlanDto);
//	public void updateRecordDate(MindCounselRecordDto mindCounselRecordDto);
	public void updateCounsel(MindCounselCounselDetail mindCounselCounselDetail);
	public void updatePlanDate(MindCounselCounselDetail mindCounselCounselDetail);
	public void updateRecordDate(MindCounselCounselDetail mindCounselCounselDetail);
	public void updateRecordTextDate(MindCounselRecordTxtDto mindCounselRecordTxtDto);

//	public MindCounselIntake pCounselorDateDetail(MindCounselIntakeDto mindCounselIntakeDto);
	public List<MindCounselIntake> pCounselorDateDetail(MindCounselIntakeDto mindCounselIntakeDto);
	public MindCounselIntake intakeDetail(MindCounselIntakeDto mindCounselIntakeDto);
	public MindCounselIntake baseInfoDetail(MindCounselIntakeDto mindCounselIntakeDto);

	public List<MindSchedule> getMonthScheduleList(MindScheduleDto mindScheduleDto);
	public int getScheduleCnt(MindScheduleDto mindScheduleDto);
	public void insertSchedule(MindScheduleDto mindScheduleDto);
	public void deleteSchedule(MindScheduleDto mindScheduleDto);
	
	public void insertSchedule2(Map<String, Object> itemMap);
	public void deleteSchedule2(MindScheduleDto dto);

	public int getHolidayScheduleCnt(MindScheduleDto mindScheduleDto);
	public void deleteHolidaySchedule(MindScheduleDto mindScheduleDto);
	public void deleteHoliday(MindScheduleDto mindScheduleDto);
	
	public void deleteHolidaySchedule2(Map<String, Object> itemMap);
	public void deleteHoliday2(Map<String, Object> itemMap);

	public int selectPCounselorDateInput(MindCounselIntakeDto mindCounselIntakeDto);
	public int updatePCounselorDateInput(MindCounselIntakeDto mindCounselIntakeDto);

	public MindCounselCounselDetail pCounselorRecordDtl(MindCounselCounselDetail mindCounselCounselDetail);
	public MindCounselCounselDetail pCounselFirstRecordDetail(MindCounselCounselDetail mindCounselCounselDetail);
	public List<MindCounselCounselDetail> pCounselorRecordTxtList(MindCounselCounselDetail mindCounselCounselDetail);
	public List<MindCounselCounselDetail> pCounselorRecordCnt(MindCounselCounselDetail mindCounselCounselDetail);
	public int pCounselorRecordTxtChkCnt(MindCounselRecordTxtDto mindCounselRecordTxtDto);
	
	/**
	 * 오늘의 노쇼 데이터 조회
	 * 
	 * @return
	 */
	public List<MindCounselCounselDetail> getTodayNoShowCounselData();
	public void updatePCounselSchedule();
	public List<MindCounselCounselDetail> getCounselInfo(MindCounselIntakeDto mindCounselIntakeDto);
	public MindCounselCounselDetail getReplyInfo(MindCounselIntakeDto mindCounselIntakeDto);
	public int addCounselBbsAdd(MindCounselIntakeDto mindCounselIntakeDto);
	public EmployData getUserInfo(MindCounselIntakeDto mindCounselIntakeDto);
	
	public void adminUpdatePCounselSchedule(MindScheduleDto mindScheduleDto);
	public MindCounselCounselDetail pCounselorRecordFeedBack(MindCounselCounselDetail mindCounselCounselDetail);
	public void updateCounselFeedBack(MindCounselCounselDetail mindCounselCounselDetail);
	
	public String getRecordStatus(MindCounselCounselDetail mindCounselCounselDetail);
	public List<MindCounselIntake> getCounselDiagnosis(String intakeCd);
	
	/**
	 * 스크리닝 메시지 발송여부 조회
	 * 
	 * @param mindCounselCounselDetail
	 * @return
	 */
	public String getMsgRead(MindCounselCounselDetail mindCounselCounselDetail);
	
	/**
	 * 스크리닝 메시지 발송여부 수정
	 * 
	 * @param mindCounselCounselDetail
	 * @return
	 */
	public int updateMsgRead(MindCounselCounselDetail mindCounselCounselDetail);
	
	/**
	 * 위험도 메시지 발송여부 조회
	 * 
	 * @param mindCounselCounselDetail
	 * @return
	 */
	public String getRiskSmsSend(MindCounselCounselDetail mindCounselCounselDetail);
	
	/**
	 * 스크리닝 메시지 발송여부 수정
	 * 
	 * @param mindCounselCounselDetail
	 * @return
	 */
	public int updateRiskSmsSend(MindCounselCounselDetail mindCounselCounselDetail);
}
