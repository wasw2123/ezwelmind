package com.ezwel.admin.service.security;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;

import com.ezwel.admin.domain.entity.common.Manager;
import com.ezwel.core.security.EzUserDetails;

public class SessionMapping implements RowMapper {

	/**
	 *
	 * @param rs
	 * @param rownum
	 * @return
	 * @auther ddakker 2014. 6. 12.
	 */
	@Override
	public Object mapRow(ResultSet rs, int rownum) throws SQLException {
		String	userId					= rs.getString("USER_ID");
		String	userType				= rs.getString("USER_TYPE");
		String	userTypeNm				= rs.getString("userTypeNm");
		String	authCd					= rs.getString("AUTH_CD");
		String	userNm					= rs.getString("USER_NM");
		String	userPwd					= rs.getString("USER_PWD");
		boolean enabled  				= rs.getBoolean("ENABLED");
		String 	useYn					= rs.getString("USE_YN");
		String 	email					= rs.getString("EMAIL");
		String 	mobile					= rs.getString("MOBILE");
		String 	branchCd					= rs.getString("BRANCH_CD");
		String 	deptCd					= rs.getString("DEPT_CD");
		String 	teamCd					= rs.getString("TEAM_CD");
		String 	regDt					= rs.getString("REG_DT");
		String 	modiDt					= rs.getString("MODI_DT");

		String 	mgrStatus				= rs.getString("MGR_STATUS");
		int 	centerSeq				= rs.getInt("CENTER_SEQ");
		String 	centerOwnerYn			= rs.getString("CENTER_OWNER_YN");
		String 	imsiPwdYn			 	= rs.getString("IMSI_PWD_YN");
		String	cspCd					= rs.getString("CSP_CD");
		
        boolean accountNonExpired		= true;
        boolean credentialsNonExpired	= true;
        boolean accountNonLocked		= true;



        Manager manger = new Manager();
        manger.setUserId(userId);
        manger.setUserType(userType);
        manger.setUserNm(userNm);
        manger.setUseYn(useYn);
        manger.setMgrStatus(mgrStatus);
        manger.setEmail(email);
        manger.setMobile(mobile);
        manger.setBranchCd(branchCd);
        manger.setDeptCd(deptCd);
        manger.setTeamCd(teamCd);
        manger.setRegDt(regDt);
        manger.setModiDt(modiDt);
        manger.setCenterSeq(centerSeq);
        manger.setCenterOwnerYn(centerOwnerYn);
        manger.setImsiPwdYn(imsiPwdYn);
        manger.setCspCd(cspCd);
        manger.setUserTypeNm(userTypeNm);
        manger.setAuthCd(authCd);
        
        return new EzUserDetails(userId, userPwd, enabled, accountNonExpired, credentialsNonExpired, accountNonLocked, manger);
    }
}
