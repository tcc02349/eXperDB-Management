package com.k4m.dx.tcontrol.functions.transfer.web;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.k4m.dx.tcontrol.admin.accesshistory.service.AccessHistoryService;
import com.k4m.dx.tcontrol.admin.menuauthority.service.MenuAuthorityService;
import com.k4m.dx.tcontrol.cmmn.CmmnUtils;
import com.k4m.dx.tcontrol.common.service.HistoryVO;
import com.k4m.dx.tcontrol.functions.transfer.service.ConnectorVO;
import com.k4m.dx.tcontrol.functions.transfer.service.TransferService;
import com.k4m.dx.tcontrol.functions.transfer.service.TransferVO;
import com.k4m.dx.tcontrol.login.service.LoginVO;
import com.k4m.dx.tcontrol.tree.transfer.service.TransferMappingVO;

/**
 * Transfer 컨트롤러 클래스를 정의한다.
 *
 * @author 김주영
 * @see
 * 
 *      <pre>
 * == 개정이력(Modification Information) ==
 *
 *   수정일       수정자           수정내용
 *  -------     --------    ---------------------------
 *  2017.06.08   김주영 최초 생성
 *      </pre>
 */
@Controller
public class TransferController {

	@Autowired
	private TransferService transferService;

	@Autowired
	private AccessHistoryService accessHistoryService;

	@Autowired
	private MenuAuthorityService menuAuthorityService;

	private List<Map<String, Object>> menuAut;

	/**
	 * 전송설정 화면을 보여준다.
	 * 
	 * @param
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/transferSetting.do")
	public ModelAndView transferSetting(@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN000201");
			if (menuAut.get(0).get("read_aut_yn").equals("N")) {
				mv.setViewName("error/autError");
			} else {
				mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
				mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));

				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0011");
				historyVO.setMnu_id(6);
				accessHistoryService.insertHistory(historyVO);

				mv.setViewName("functions/transfer/transferSetting");
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}

	/**
	 * 전송설정 조회한다.
	 * 
	 * @param request
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectTransferSetting.do")
	public @ResponseBody TransferVO selectTransferSetting(HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession();
		TransferVO resultSet = null;
		try {
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN000201");

			// 읽기권한이 있을경우
			if (menuAut.get(0).get("read_aut_yn").equals("N")) {
				response.sendRedirect("/autError.do");
				return resultSet;
			}
			
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String usr_id = loginVo.getUsr_id();
			resultSet = (TransferVO) transferService.selectTransferSetting(usr_id);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
	}

	/**
	 * 전송설정 등록한다.
	 * 
	 * @param transferVO
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/insertTransferSetting.do")
	public @ResponseBody void insertTransferSetting(@ModelAttribute("transferVO") TransferVO transferVO,
			@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request,
			HttpServletResponse response) {
		try {
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN000201");

			// 쓰기권한이 있을경우
			if (menuAut.get(0).get("wrt_aut_yn").equals("N")) {
				response.sendRedirect("/autError.do");
			}
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String usr_id = loginVo.getUsr_id();
			transferVO.setFrst_regr_id(usr_id);
			transferVO.setLst_mdfr_id(usr_id);

			transferService.insertTransferSetting(transferVO);

			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0011_01");
			historyVO.setMnu_id(6);
			accessHistoryService.insertHistory(historyVO);

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 전송설정 수정한다.
	 * 
	 * @param transferVO
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateTransferSetting.do")
	public @ResponseBody boolean updateTransferSetting(@ModelAttribute("transferVO") TransferVO transferVO,
			@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request,
			HttpServletResponse response) {
		try {
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN000201");
			// 쓰기권한이 있을경우
			if (menuAut.get(0).get("wrt_aut_yn").equals("N")) {
				response.sendRedirect("/autError.do");
				return false;
			}
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String usr_id = loginVo.getUsr_id();
			transferVO.setLst_mdfr_id(usr_id);

			transferService.updateTransferSetting(transferVO);

			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0011_01");
			historyVO.setMnu_id(6);
			accessHistoryService.insertHistory(historyVO);

			return true;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return true;
	}

	/**
	 * Connector 등록 화면을 보여준다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/connectorRegister.do")
	public ModelAndView connectorRegister(@ModelAttribute("historyVO") HistoryVO historyVO,
			HttpServletRequest request) {
		ModelAndView mv = new ModelAndView();
		try {
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN000202");
			if (menuAut.get(0).get("read_aut_yn").equals("N")) {
				mv.setViewName("error/autError");
			} else {
				mv.addObject("read_aut_yn", menuAut.get(0).get("read_aut_yn"));
				mv.addObject("wrt_aut_yn", menuAut.get(0).get("wrt_aut_yn"));

				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0012");
				historyVO.setMnu_id(7);
				accessHistoryService.insertHistory(historyVO);

				mv.setViewName("functions/transfer/connectorRegister");
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}

	/**
	 * Connector 리스트를 조회한다.
	 * 
	 * @param request
	 * @return resultSet
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectConnectorRegister.do")
	public @ResponseBody List<ConnectorVO> selectConnectorRegister(@ModelAttribute("historyVO") HistoryVO historyVO,
			HttpServletRequest request, HttpServletResponse response) {
		List<ConnectorVO> resultSet = null;
		try {
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN000202");

			// 읽기권한이 있을경우
			if (menuAut.get(0).get("read_aut_yn").equals("N")) {
				response.sendRedirect("/autError.do");
				return resultSet;
			}

			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0012_01");
			historyVO.setMnu_id(7);
			accessHistoryService.insertHistory(historyVO);

			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String usr_id = loginVo.getUsr_id();

			Map<String, Object> param = new HashMap<String, Object>();

			String cnr_nm = request.getParameter("cnr_nm");
			String cnr_ipadr = request.getParameter("cnr_ipadr");

			param.put("cnr_nm", cnr_nm);
			param.put("cnr_ipadr", cnr_ipadr);
			param.put("usr_id", usr_id);

			resultSet = transferService.selectConnectorRegister(param);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultSet;
	}

	/**
	 * Connector 등록 팝업을 보여준다.
	 * 
	 * @param request
	 * @return ModelAndView mv
	 * @throws Exception
	 */
	@RequestMapping(value = "/popup/connectorRegForm.do")
	public ModelAndView connectorReg(HttpServletRequest request, @ModelAttribute("historyVO") HistoryVO historyVO) {
		ModelAndView mv = new ModelAndView();
		try {
			CmmnUtils cu = new CmmnUtils();
			menuAut = cu.selectMenuAut(menuAuthorityService, "MN000202");
			if (menuAut.get(0).get("read_aut_yn").equals("Y")) {
				mv.setViewName("error/autError");
			}

			String act = request.getParameter("act");

			if (act.equals("i")) {
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0013");
				historyVO.setMnu_id(7);
				accessHistoryService.insertHistory(historyVO);
			}

			if (act.equals("u")) {
				// 화면접근이력 이력 남기기
				CmmnUtils.saveHistory(request, historyVO);
				historyVO.setExe_dtl_cd("DX-T0014");
				historyVO.setMnu_id(7);
				accessHistoryService.insertHistory(historyVO);

				int cnr_id = Integer.parseInt(request.getParameter("cnr_id"));
				ConnectorVO connectInfo = (ConnectorVO) transferService.selectDetailConnectorRegister(cnr_id);
				mv.addObject("cnr_id", connectInfo.getCnr_id());
				mv.addObject("cnr_nm", connectInfo.getCnr_nm());
				mv.addObject("cnr_ipadr", connectInfo.getCnr_ipadr());
				mv.addObject("cnr_portno", connectInfo.getCnr_portno());
				mv.addObject("cnr_cnn_tp_cd", connectInfo.getCnr_cnn_tp_cd());
			}

			mv.addObject("act", act);
			mv.setViewName("popup/connectorRegForm");

		} catch (Exception e) {
			e.printStackTrace();
		}
		return mv;
	}

	/**
	 * 커넥트명 중복 체크한다.
	 * 
	 * @param cnr_nm
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/connectorNameCheck.do")
	public @ResponseBody String connectorNameCheck(@RequestParam("cnr_nm") String cnr_nm) {
		try {
			int resultSet = transferService.connectorNameCheck(cnr_nm);
			if (resultSet > 0) {
				// 중복값이 존재함.
				return "false";
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "true";
	}

	
	/**
	 * Connector를 등록한다.
	 * 
	 * @param connectorVO
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/insertConnectorRegister.do")
	public @ResponseBody void insertConnectorRegister(@ModelAttribute("connectorVO") ConnectorVO connectorVO,
			@ModelAttribute("historyVO") HistoryVO historyVO, HttpServletRequest request) {
		try {
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String usr_id = loginVo.getUsr_id();
			connectorVO.setFrst_regr_id(usr_id);
			connectorVO.setLst_mdfr_id(usr_id);
			transferService.insertConnectorRegister(connectorVO);

			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0013_01");
			historyVO.setMnu_id(7);
			accessHistoryService.insertHistory(historyVO);

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * Connector를 수정한다.
	 * 
	 * @param connectorVO
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateConnectorRegister.do")
	public @ResponseBody void updateConnectorRegister(@ModelAttribute("historyVO") HistoryVO historyVO,
			@ModelAttribute("connectorVO") ConnectorVO connectorVO, HttpServletRequest request) {
		try {
			HttpSession session = request.getSession();
			LoginVO loginVo = (LoginVO) session.getAttribute("session");
			String usr_id = loginVo.getUsr_id();
			connectorVO.setLst_mdfr_id(usr_id);
			transferService.updateConnectorRegister(connectorVO);

			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0014_01");
			historyVO.setMnu_id(7);
			accessHistoryService.insertHistory(historyVO);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * Connector를 삭제한다.
	 * 
	 * @param historyVO
	 * @param request
	 * @return true
	 * @throws Exception
	 */
	@RequestMapping(value = "/deleteConnectorRegister.do")
	public @ResponseBody boolean deleteConnectorRegister(@ModelAttribute("historyVO") HistoryVO historyVO,
			HttpServletRequest request) {
		try {
			String[] param = request.getParameter("cnr_id").toString().split(",");
			for (int i = 0; i < param.length; i++) {
				/* 1. trf_trg_mpp_id조회 후 전송매핑테이블 확인 */
				List<TransferMappingVO> result = transferService.selectTrftrgmppid(Integer.parseInt(param[i]));
				/* 2. 전송매핑테이블 삭제 */
				if (result != null) {
					for (int j = 0; j < result.size(); j++) {
						transferService.deleteTransferMapping(result.get(j).getTrf_trg_mpp_id());
					}
				}
				/* 3. 전송대상매핑관계 삭제 */
				transferService.deleteTransferRelation(Integer.parseInt(param[i]));
				/* 4. 전송대상설정정보 삭제 */
				transferService.deleteTransferInfo(Integer.parseInt(param[i]));
				/* 5. 커넥터정보 삭제 */
				transferService.deleteConnectorRegister(Integer.parseInt(param[i]));
			}

			// 화면접근이력 이력 남기기
			CmmnUtils.saveHistory(request, historyVO);
			historyVO.setExe_dtl_cd("DX-T0012_02");
			historyVO.setMnu_id(7);
			accessHistoryService.insertHistory(historyVO);

			return true;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}
}
