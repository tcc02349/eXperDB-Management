package com.k4m.dx.tcontrol.admin.menuauthority.service;

import java.util.List;
import java.util.Map;

import com.k4m.dx.tcontrol.login.service.UserVO;

public interface MenuAuthorityService {

	/**
	 * 사용자 메뉴권한 조회
	 * @param 
	 * @throws Exception
	 */
	List<MenuAuthorityVO> selectUsrmnuautList(MenuAuthorityVO menuAuthorityVO) throws Exception;

	
	/**
	 * 메뉴ID 조회
	 * @param 
	 * @throws Exception
	 */
	List<UserVO> selectMnuIdList() throws Exception;
	
	
	/**
	 * 사용자 등록시 메뉴권한 등록
	 * @param 
	 * @throws Exception
	 */
	void insertUsrmnuaut(UserVO userVo) throws Exception;


	/**
	 * 사용자 메뉴권한 수정
	 * @param 
	 * @throws Exception
	 */
	void updateUsrMnuAut(Object object) throws Exception;


	/**
	 * 사용자 화면권한 조회
	 * @param 
	 * @throws Exception
	 */
	List<Map<String, Object>> selectMenuAut(Map<String, Object> param) throws Exception;




}
