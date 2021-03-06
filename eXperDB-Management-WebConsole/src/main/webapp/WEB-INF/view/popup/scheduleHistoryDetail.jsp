<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@include file="../cmmn/commonLocale.jsp"%>
<%
	/**
	* @Class Name : scheduleHistoryDetail.jsp
	* @Description : scheduleHistoryDetail 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.10.24     최초 생성
	*
	* author 김주영 사원
	* since 2017.10.24
	*
	*/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>스케줄수행이력 상세보기</title>
<link rel="stylesheet" type="text/css" href="/css/jquery-ui.css">
<link rel="stylesheet" type="text/css" href="/css/common.css">
<link rel = "stylesheet" type = "text/css" media = "screen" href = "<c:url value='/css/dt/jquery.dataTables.min.css'/>"/>
<link rel = "stylesheet" type = "text/css" media = "screen" href = "<c:url value='/css/dt/dataTables.jqueryui.min.css'/>"/> 
<link rel="stylesheet" type="text/css" href="<c:url value='/css/dt/dataTables.colVis.css'/>"/>
<link rel="stylesheet" type="text/css" href="<c:url value='/css/dt/dataTables.checkboxes.css'/>"/>

<script src ="/js/jquery/jquery-1.7.2.min.js" type="text/javascript"></script>
<script src ="/js/jquery/jquery-ui.js" type="text/javascript"></script>
<script src="/js/jquery/jquery.dataTables.min.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.jqueryui.min.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.colResize.js" type="text/javascript"></script>
<script src="/js/dt/dataTables.checkboxes.min.js" type="text/javascript"></script>	
<script src="/js/dt/dataTables.colVis.js" type="text/javascript"></script>	
<script type="text/javascript" src="/js/common.js"></script>
</head>
<script>
var workTable = null;

function fn_init() {

    workTable = $('#workTable').DataTable({
		scrollY : "130px",
		searching : false,
		paging: false,
		scrollX: true,
		bSort: false,
		columns : [
		{ data : "rownum", className : "dt-center",  defaultContent : ""}, 
		{data : "wrk_nm", className : "dt-left", defaultContent : ""
			,"render": function (data, type, full) {
				  return '<span onClick=javascript:fn_workLayer("'+full.wrk_id+'"); class="bold" title="'+full.wrk_nm+'">' + full.wrk_nm + '</span>';
			}
		},
		{ data : "wrk_exp",
			render : function(data, type, full, meta) {	 	
				var html = '';					
				html += '<span title="'+full.wrk_exp+'">' + full.wrk_exp + '</span>';
				return html;
			},
			defaultContent : ""
		},
		{ data : "wrk_strt_dtm",  defaultContent : ""},  
		{ data : "wrk_end_dtm",  defaultContent : ""},
		{ data : "wrk_dtm",  defaultContent : ""},
		{data : "exe_rslt_cd",  defaultContent : "",className : "dt-center"
			,"render": function (data, type, full) {
				if(full.exe_rslt_cd=="TC001701"){
					var html = '<span class="btn btnC_01 btnF_02"><img src="../images/ico_state_02.png" style="margin-right:3px;"/>Success</span>';
						return html;
				}else if(full.exe_rslt_cd == 'TC001702'){
					var html = '<span class="btn btnC_01 btnF_02"><button onclick="fn_failLog('+full.exe_sn+')"><img src="../images/ico_state_01.png" style="margin-right:3px;"/>Fail</button></span>';
					return html;
				}else{
					var html = '<span class="btn btnC_01 btnF_02"><img src="../images/ico_state_03.png" style="margin-right:3px;"/><spring:message code="etc.etc28"/></span>';
					return html;
				}
			}
		},
			{
				data : "fix_rsltcd",
				render : function(data, type, full, meta) {	 						
					var html = '';
					if (full.fix_rsltcd == 'TC002001') {
						html += '<span class="btn btnC_01 btnF_02" onClick=javascript:fn_fixLog('+full.exe_sn+');><input type="button" value="<spring:message code="etc.etc29"/>"></span>';
					} else if(full.fix_rsltcd == 'TC002002'){
						html += '<span class="btn btnC_01 btnF_02" onClick=javascript:fn_fixLog('+full.exe_sn+');><input type="button" value="<spring:message code="etc.etc30"/>"></span>';
					} else {
						if(full.exe_rslt_cd == 'TC001701'){
							html += ' - ';
						}else{
							html +='<span class="btn btnC_01 btnF_02" onClick=javascript:fn_fix_rslt_reg('+full.exe_sn+');><input type="button" value="<spring:message code="backup_management.Enter_Action"/>"></span>';
						}
					}
					return html;
				},
				className : "dt-center",
				defaultContent : ""
			},
		{data : "scd_id",  defaultContent : "", visible: false }
		]
	});
    
    workTable.tables().header().to$().find('th:eq(0)').css('min-width', '40px');
    workTable.tables().header().to$().find('th:eq(1)').css('min-width', '200px');
    workTable.tables().header().to$().find('th:eq(2)').css('min-width', '300px');
    workTable.tables().header().to$().find('th:eq(3)').css('min-width', '150px');
    workTable.tables().header().to$().find('th:eq(4)').css('min-width', '150px');
	workTable.tables().header().to$().find('th:eq(5)').css('min-width', '100px');
	workTable.tables().header().to$().find('th:eq(6)').css('min-width', '100px');
	workTable.tables().header().to$().find('th:eq(7)').css('min-width', '100px');
	workTable.tables().header().to$().find('th:eq(8)').css('min-width', '0px');
    $(window).trigger('resize');
    
}

$(window.document).ready(function() {
	fn_init();
	
	$.ajax({
		url : "/selectScheduleHistoryWorkDetail.do",
		data : {
			exe_sn : "${exe_sn}"
		},
		dataType : "json",
		type : "post",
		beforeSend: function(xhr) {
	        xhr.setRequestHeader("AJAX", true);
	     },
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				alert('<spring:message code="message.msg02" />');
				top.location.href = "/";
			} else if(xhr.status == 403) {
				alert('<spring:message code="message.msg03" />');
				top.location.href = "/";
			} else {
				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
			}
		},
		success : function(result) {
			workTable.clear().draw();
			workTable.rows.add(result).draw();
		}
	});
});

function fn_fix_rslt_reg(exe_sn){
	document.getElementById("exe_sn_r").value = exe_sn;
	$('#fix_rslt_msg_r').val('');
	$("#rdo_r_1").attr('checked', true);
	toggleLayer($('#pop_layer_fix_rslt_reg'), 'on')
}

function fn_fix_rslt_msg_reg(){
	var fix_rsltcd = $(":input:radio[name=rdo_r]:checked").val();
	
	$.ajax({
			url : "/updateFixRslt.do",
			data : {
				exe_sn : $('#exe_sn_r').val(),
				fix_rsltcd : fix_rsltcd,
				fix_rslt_msg : $('#fix_rslt_msg_r').val()
			},
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					alert('<spring:message code="message.msg02" />');
					top.location.href = "/";
				} else if(xhr.status == 403) {
					alert('<spring:message code="message.msg03" />');
					top.location.href = "/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			},
			success : function(result) {
				toggleLayer($('#pop_layer_fix_rslt_reg'), 'off');
				location.reload();
			}
		}); 
}


function fn_fix_rslt_msg_modify(){
	var fix_rsltcd = $(":input:radio[name=rdo]:checked").val();

	$.ajax({
			url : "/updateFixRslt.do",
			data : {
				exe_sn : $('#exe_sn').val(),
				fix_rsltcd : fix_rsltcd,
				fix_rslt_msg : $('#fix_rslt_msg').val()
			},
			dataType : "json",
			type : "post",
			beforeSend: function(xhr) {
		        xhr.setRequestHeader("AJAX", true);
		     },
			error : function(xhr, status, error) {
				if(xhr.status == 401) {
					alert('<spring:message code="message.msg02" />');
					top.location.href = "/";
				} else if(xhr.status == 403) {
					alert('<spring:message code="message.msg03" />');
					top.location.href = "/";
				} else {
					alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
				}
			},
			success : function(result) {
				toggleLayer($('#pop_layer_fix_rslt_msg'), 'off');
				location.reload();
			}
		}); 
}
</script>
<body>
<style>
#scdinfo{
	width: 35% !important;
	margin-top: 0px !important;
}

#workinfo{
	width: 60% !important;
	height: 610px !important;
	margin-top: 0px !important;
}

#scriptInfo{
	width: 60% !important;
	height: 610px !important;
	margin-top: 0px !important;
}
</style>
<%@include file="../cmmn/commonLocale.jsp"%>  
<%@include file="../cmmn/workRmanInfo.jsp"%>
<%@include file="../cmmn/workDumpInfo.jsp"%>
<%@include file="../cmmn/workScriptInfo.jsp"%>
<%@include file="../cmmn/scheduleInfo.jsp"%>
<%@include file="../cmmn/wrkLog.jsp"%>
<%@include file="../cmmn/fixRsltMsg.jsp"%>

	<div id="pop_layer_fix_rslt_reg" class="pop-layer">
		<div class="pop-container">
			<div class="pop_cts" style="width: 60%; margin: 0 auto; min-height:0; min-width:0;">
				<p class="tit" style="margin-bottom: 15px;"><spring:message code="etc.etc33"/></p>
				<table class="write" border="0">
					<caption><spring:message code="etc.etc33"/></caption>
					<tbody>
						<tr>
							<td>
								<div class="inp_rdo">
									<input name="rdo_r" id="rdo_r_1" type="radio" checked="checked">
										<label for="rdo_r_1" style="margin-right: 2%;"><spring:message code="etc.etc29"/></label> 
									<input name="rdo_r" id="rdo_r_2" type="radio"> 
										<label for="rdo_r_2"><spring:message code="etc.etc30"/></label>
								</div>
							</td>
						</tr>						
						<tr>
							<td><textarea name="fix_rslt_msg_r" id="fix_rslt_msg_r" style="height: 250px;"> </textarea>
									<input type="hidden" name="exe_sn_r" id="exe_sn_r">
							</td>
						</tr>
					</tbody>
				</table>
				<div class="btn_type_02">
					<a href="#n" class="btn" onclick="fn_fix_rslt_msg_reg();"><span><spring:message code="common.save"/></span></a>
					<a href="#n" class="btn" onclick="toggleLayer($('#pop_layer_fix_rslt_reg'), 'off');"><span><spring:message code="common.close"/></span></a>
				</div>
			</div>
		</div><!-- //pop-container -->
	</div>
	
		
	<div class="pop_container">
		<div class="pop_cts">
			<p class="tit"><spring:message code="schedule.scheduleHistoryDetail"/></p>
			<div class="pop_cmm3">
				<p class="pop_s_tit"><spring:message code="menu.schedule_information" /></p>		
				<table class="list" style="border:1px solid #99abb0;">
					<colgroup>
							<col style="width:15%;" />
							<col style="width:85%;" />
					</colgroup>
					<tbody>
					<c:forEach var="result" items="${result}" varStatus="status">
						<tr>
							<td><spring:message code="schedule.schedule_name" /></td>
							<td style="text-align: left"><span onClick='javascript:fn_scdLayer("${result.scd_id}");' class="bold">${result.scd_nm}</span></td>
						</tr>		
						<tr>
							<td><spring:message code="schedule.work_start_datetime" /></td>
							<td style="text-align: left">${result.wrk_strt_dtm}</td>
						</tr>	
						<tr>
							<td><spring:message code="schedule.work_end_datetime" /></td>
							<td style="text-align: left">${result.wrk_end_dtm}</td>
						</tr>
						<tr>
							<td><spring:message code="schedule.jobTime"/></td>
							<td style="text-align: left">${result.wrk_dtm}</td>
						</tr>	
						<tr>
							<td><spring:message code="schedule.scheduleExp"/></td>
							<td style="text-align: left">${result.scd_exp}</td>
						</tr>
					</c:forEach>						
					</tbody>
				</table>
					
					
				<br><br>
				<p class="pop_s_tit"><spring:message code="backup_management.work_info"/></p>
				<div class="overflow_area" style="height: 230px;">
					<table id="workTable" class="display" cellspacing="0" width="100%">
						<thead>
							<tr>
								<th width="40"><spring:message code="common.no" /></th>
								<th width="200" class="dt-center"><spring:message code="common.work_name"/></th>
								<th width="300" class="dt-center"><spring:message code="common.work_description"/></th>
								<th width="150"><spring:message code="schedule.work_start_datetime"/></th>
								<th width="150"><spring:message code="schedule.work_end_datetime"/></th>
								<th width="100"><spring:message code="schedule.jobTime"/></th>
								<th width="100"><spring:message code="schedule.result"/></th>
								<th width="0"><spring:message code="etc.etc31"/></th>
							</tr>
						</thead>
					</table>
				</div>
			</div>
			<div class="btn_type_02">
				<a href="#n" class="btn" onclick="window.close();"><span><spring:message code="common.close"/></span></a>
			</div>
		</div>
	</div>
</body>
</html>