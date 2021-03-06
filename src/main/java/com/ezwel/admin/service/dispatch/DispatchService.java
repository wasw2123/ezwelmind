package com.ezwel.admin.service.dispatch;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.ezwel.admin.domain.entity.dispatch.DispatchInfo;
import com.ezwel.admin.persist.dispatch.DispatchMapper;
import com.ezwel.admin.service.dispatch.dto.DispatchDto;
import com.ezwel.admin.service.security.UserDetailsHelper;
import com.ezwel.core.framework.web.vo.Paging;

/**
 * 마음왕진 서비스
 * 
 * @author starkaby12
 *
 */
@Service
public class DispatchService {

	@Resource
	private DispatchMapper dispatchMapper;
	
	
	/**
	 * 등록
	 * 
	 * @param dto
	 * @return
	 */
	public int regist(DispatchDto dto) {
		
		int isDuplicate = dispatchMapper.isDuplicate(dto);
		
		if(isDuplicate > 0) { // duplicate process
			return -1;
		}
		
		dto.setRegId(UserDetailsHelper.getAuthenticatedUser().getUserId()); // settings user id
		
		return dispatchMapper.regist(dto);
	}
	
	/**
	 * 고객사 아이디 중복 체크
	 * 
	 * @param dto
	 * @return
	 */
	public int isDuplicate(DispatchDto dto) {
		return dispatchMapper.isDuplicate(dto);
	}
	
	/**
	 * 목록 조회
	 * 
	 * @param dto
	 * @return
	 */
	public Paging<DispatchDto> getList(DispatchDto dto) {
		
		Paging<DispatchDto> paging = new Paging<DispatchDto>();
		
		paging.setPaging(dto);
		paging.setList(dispatchMapper.getList(dto));
		
		dto.setPageCommonFlag(true);
		paging.setTotalCount(dispatchMapper.getList(dto).get(0).getPageCommonCount());
		
		return paging;
	}
	
	/**
	 * 단건 조회
	 * 
	 * @param dto
	 * @return
	 */
	public DispatchDto getOne(DispatchDto dto) {
		return dispatchMapper.getOne(dto);
	}
	
	/**
	 * 수정
	 * 
	 * @param dto
	 * @return
	 */
	public int update(DispatchDto dto) {
		
		DispatchDto old = dispatchMapper.getOne(dto);
		
		// check same client cd
		if(!old.getClientCd().equals(dto.getClientCd())) {
			int isDuplicate = dispatchMapper.isDuplicate(dto);
			
			if(isDuplicate > 0) { // duplicate process
				return -1;
			}
		}
		
		return dispatchMapper.update(dto);
	}
	
	/**
	 * 참여자 목록 조회
	 * 
	 * @param dto
	 * @return
	 */
	public Paging<DispatchDto> getUserList(DispatchDto dto) {
		
		Paging<DispatchDto> paging = new Paging<DispatchDto>();
		
		paging.setPaging(dto);
		paging.setList(dispatchMapper.getUserList(dto));
		
		dto.setPageCommonFlag(true);
		paging.setTotalCount(dispatchMapper.getUserList(dto).get(0).getPageCommonCount());
		
		return paging;
	}
	
	/**
	 * 참여자 조회
	 * 
	 * @param dto
	 * @return
	 */
	public DispatchDto getUser(DispatchDto dto) {
		return dispatchMapper.getUser(dto);
	}
	
	/**
	 * 참여자 인테이크 조회
	 * 
	 * @param dto
	 * @return
	 */
	public List<DispatchDto> getUserIntake(DispatchDto dto) {
		return dispatchMapper.getUserIntake(dto);
	}
	
	/**
	 * 인테이크 메모 수정
	 * 
	 * @param dto
	 * @return
	 */
	public int updateIntakeMemo(DispatchDto dto) {
		return dispatchMapper.updateIntakeMemo(dto);
	}
	
	/**
	 * 엑셀 다운로드 사용자 목록 조회 
	 * 
	 * @param dto
	 * @return
	 */
	public List<DispatchDto> getUserExcelDownloadList(DispatchDto dto) {
		return dispatchMapper.getUserExcelDownloadList(dto);
	}
	
	/**
	 * 유저키 연결 목록 조회
	 * 
	 * @param dto
	 * @return
	 */
	public List<DispatchDto> getClientMindUserList(DispatchDto dto) {
		return dispatchMapper.getClientMindUserList(dto);
	}
	
	/**
	 * 유저 키 연결
	 * 
	 * @param dto
	 * @return
	 */
	public int updateUserKey(DispatchDto dto) {
		return dispatchMapper.updateUserKey(dto);
	}
}
