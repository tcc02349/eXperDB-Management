<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<%@include file="cmmn/cs.jsp"%>

<script type="text/javascript">
var today = "";

$(window.document).ready(function() {

	today = new Date();
	
	var html ="";
	html += "<img src='../images/ico_state_09.png' style='margin-right:5px;'>"+today.toJSON().slice(0,10).replace(/-/g,'-');
	$( "#today" ).append(html);
	
	today.toJSON().slice(0,10).replace(/-/g,'');
	
	var encryptDashbaordServer = document.getElementById("encryptDashbaordServer");
	var encryptDashbaordAgent = document.getElementById("encryptDashbaordAgent");
	if("${sessionScope.session.encp_use_yn}" == "Y"){
		encryptDashbaordServer.style.display = '';
		encryptDashbaordAgent.style.display = '';
		fn_serverStatus();
	}else{
		encryptDashbaordServer.style.display = 'none';
		encryptDashbaordAgent.style.display = 'none';
	} 

});




function fn_serverStatus(){
	$.ajax({
		url : "/serverStatus.do",
		data : {},
		dataType : "json",
		type : "post",
		beforeSend: function(xhr) {
	        xhr.setRequestHeader("AJAX", true);
	     },
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				alert("<spring:message code='message.msg02' />");
				top.location.href = "/";
			} else if(xhr.status == 403) {
				alert("<spring:message code='message.msg03' />");
				top.location.href = "/";
			} else {
				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
			}
		},
		success : function(data) {
			if(data.resultCode == "0000000000"){
				var html ='<img src="../images/ico_state_03.png" alt="Running Transfer" /><span> Running</span>';				
				$("#encryptServer").html(html);
				fn_selectSecurityStatistics(today);
			}else if(data.resultCode == "8000000002"){
				var html ='<img src="../images/ico_state_07.png" alt="Stop" /> STOP';
				//var html ='<img src="../images/ico_agent_2.png" alt="" />';
				$("#encryptServer").html(html);
			}
		}
	});			
}


function fn_selectSecurityStatistics(today){
	$.ajax({
		url : "/selectDashSecurityStatistics.do",
		data : {
			from : today+"00",
			to : 	today+"24",
			categoryColumn : "SITE_ACCESS_ADDRESS"
		},
		dataType : "json",
		type : "post",
		beforeSend: function(xhr) {
	        xhr.setRequestHeader("AJAX", true);
	     },
		error : function(xhr, status, error) {
			if(xhr.status == 401) {
				alert("<spring:message code='message.msg02' />");
				top.location.href = "/";
			} else if(xhr.status == 403) {
				alert("<spring:message code='message.msg03' />");
				top.location.href = "/";
			} else {
				alert("ERROR CODE : "+ xhr.status+ "\n\n"+ "ERROR Message : "+ error+ "\n\n"+ "Error Detail : "+ xhr.responseText.replace(/(<([^>]+)>)/gi, ""));
			}
		},
		success : function(data) {
				if(data.resultCode == "0000000000"){
				 	var html ="";
					for(var i=0; i<data.list.length; i++){
						html += '<tr>';
						html += '<td>'+data.list[i].monitoredName+'</td>';
						html += '<td>'+data.list[i].encryptSuccessCount+'</td>';
						html += '<td>'+data.list[i].encryptFailCount+'</td>';
						html += '<td>'+data.list[i].decryptSuccessCount+'</td>';
						html += '<td>'+data.list[i].decryptFailCount+'</td>';
						html += '<td>'+data.list[i].sumCount+'</td>';
						if(data.list[i].status == "start"){
							html += '<td><img src="../images/ico_agent_1.png" alt="" /></td>';
						}else{
							html += '<td><img src="../images/ico_agent_2.png" alt="" /></td>';
						}
						html += '</tr>';

						$( "#col" ).html(html);
					} 
				}else if(data.resultCode == "8000000002"){
					alert("<spring:message code='message.msg05' />");
					location.href="/";
				}else if(data.resultCode == "8000000003"){
					alert(data.resultMessage);
					location.href="/securityKeySet.do";
				}else{
					if(data.list.length != 0){
						alert(data.resultMessage +"("+data.resultCode+")");
					}
				}
		}
	});		
}


</script>



<!-- contents -->
<div id="contents" class="main">
	<div class="contents_wrap">
		<div class="contents_tit">
			<h4><spring:message code="menu.dashboard" /> <a href="#n"><img src="../images/ico_tit.png" alt="" class="btn_info"/></a></h4>
			<div class="infobox"> 
				<ul>
					<li><spring:message code="help.dashboard" /> </li>				
				</ul>
			</div>
		</div>
		
		<div class="contents">
			<div class="main_grp">
				<div class="main_info">
					<div class="m_info_lt">
						<p class="m_tit"><spring:message code="menu.schedule_information" /></p>
						<ul>
							<li>
								<p class="state">
									<img src="../images/ico_state_09.png" alt="Backup" /><span>Schedule
									</span>
								</p>
								<a href="/selectScheduleListView.do">
								<c:choose>
						           <c:when test="${fn:length(fn:escapeXml(backupInfo.schedule_cnt))>2}">
						           <p class="state_num c1" style="font-size: 40px;">
						            <c:out value="${backupInfo.schedule_cnt}"/>
						            </p>
						           </c:when>
						           <c:otherwise>
						           <p class="state_num c1">
						            <c:out value="${backupInfo.schedule_cnt}"/>
						            </p>
						           </c:otherwise> 
						         </c:choose>
								</a>
								<p class="state_txt"><spring:message code="dashboard.Register_schedule" /></p>
							</li>							
							<%-- <li>
								<p class="state">
									<img src="../images/ico_state_03.png" alt="Running" /><span>Running</span>
								</p>
								<p class="state_num c1">${scheduleInfo.run_cnt}</p>
								<p class="state_txt">실행</p>
							</li> --%>
							<li>
								<p class="state">
									<img src="../images/ico_state_06.png" alt="Start" /><span>Start</span>
								</p>
								<a href="/selectScheduleListView.do?scd_cndt=TC001801">
								 <c:choose>
						           <c:when test="${fn:length(fn:escapeXml(scheduleInfo.start_cnt))>2}">
						           <p class="state_num c1" style="font-size: 40px;">
						            <c:out value="${scheduleInfo.start_cnt}"/>
						            </p>
						           </c:when>
						           <c:otherwise>
						           <p class="state_num c1">
						            <c:out value="${scheduleInfo.start_cnt}"/>
						            </p>
						           </c:otherwise> 
						         </c:choose>
								</a>
								<p class="state_txt"><spring:message code="etc.etc37"/></p>
							</li>
							<li>
								<p class="state">
									<img src="../images/ico_state_04.png" alt="Stop" /><span>Stop</span>
								</p>
								<a href="/selectScheduleListView.do?scd_cndt=TC001803">
								 <c:choose>
						           <c:when test="${fn:length(fn:escapeXml(scheduleInfo.stop_cnt))>2}">
						           <p class="state_num c1" style="font-size: 40px;">
						            <c:out value="${scheduleInfo.stop_cnt}"/>
						            </p>
						           </c:when>
						           <c:otherwise>
						           <p class="state_num c1">
						            <c:out value="${scheduleInfo.stop_cnt}"/>
						            </p>
						           </c:otherwise> 
						         </c:choose>
								</a>
								<p class="state_txt"><spring:message code="schedule.stop" /></p>
							</li>
							<li>
								<p class="state">
									<img src="../images/ico_state_03.png" alt="Running Schedule" /><span>Running</span>
								</p>
								<a href="/selectScheduleListView.do?scd_cndt=TC001802">
								 <c:choose>
						           <c:when test="${fn:length(fn:escapeXml(scheduleInfo.run_cnt))>2}">
						           <p class="state_num c3" style="font-size: 40px;">
						            <c:out value="${scheduleInfo.run_cnt}"/>
						            </p>
						           </c:when>
						           <c:otherwise>
						           <p class="state_num c3">
						            <c:out value="${scheduleInfo.run_cnt}"/>
						            </p>
						           </c:otherwise> 
						         </c:choose>
								</a>
								<p class="state_txt"><spring:message code="dashboard.running" /></p>
							</li>
							<li>
								<p class="state">
									<img src="../images/ico_state_09.png" alt="Scheduled for today" /><span>Today</span>
								</p>
								
								<c:choose>
						           <c:when test="${fn:length(fn:escapeXml(scheduleInfo.today_cnt))>2}">
						           <p class="state_num c1" style="font-size: 40px;">
						            <c:out value="${scheduleInfo.today_cnt}"/>
						            </p>
						           </c:when>
						           <c:otherwise>
						           <p class="state_num c1">
						            <c:out value="${scheduleInfo.today_cnt}"/>
						            </p>
						           </c:otherwise> 
						         </c:choose>
						         
								<p class="state_txt"><spring:message code="dashboard.scheduled_today" /></p>
							</li>
							<li>
								<p class="state">
									<img src="../images/ico_state_01.png" alt="Fail" /><span>Fail</span>
								</p>
								<a href="/selectScheduleHistoryFail.do">
								<c:choose>
						           <c:when test="${fn:length(fn:escapeXml(scheduleInfo.fail_cnt))>2}">
						           <p class="state_num c3" style="font-size: 40px;">
						            <c:out value="${scheduleInfo.fail_cnt}"/>
						            </p>
						           </c:when>
						           <c:otherwise>
						           <p class="state_num c3">
						            <c:out value="${scheduleInfo.fail_cnt}"/>
						            </p>
						           </c:otherwise> 
						         </c:choose>
								</a>
								<p class="state_txt"><spring:message code="dashboard.failed" /></p>
							</li>
						</ul>
					</div>
					<div class="m_info_ct">
						<p class="m_tit"><spring:message code="common.backInfo"/></p>
						<ul>
							<li>
								<p class="state">
									<img src="../images/ico_state_10.png" alt="Server" /><span>Server</span>
								</p>
								<a href="/dbServer.do">
								 <c:choose>
						           <c:when test="${fn:length(fn:escapeXml(backupInfo.server_cnt))>2}">
						           <p class="state_num c1" style="font-size: 40px;">
						            <c:out value="${backupInfo.stop_cnt}"/>
						            </p>
						           </c:when>
						           <c:otherwise>
						           <p class="state_num c1">
						            <c:out value="${backupInfo.server_cnt}"/>
						            </p>
						           </c:otherwise> 
						         </c:choose>
								</a>
								<p class="state_txt"><spring:message code="dashboard.server" /></p>
							</li>
							<li>
								<p class="state">
									<img src="../images/ico_state_11.png" alt="Backup" /><span>Backup</span>
								</p>
								 <c:choose>
						           <c:when test="${fn:length(fn:escapeXml(backupInfo.backup_cnt))>2}">
						           <p class="state_num c1" style="font-size: 40px;">
						            <c:out value="${backupInfo.backup_cnt}"/>
						            </p>
						           </c:when>
						           <c:otherwise>
						           <p class="state_num c1">
						            <c:out value="${backupInfo.backup_cnt}"/>
						            </p>
						           </c:otherwise> 
						         </c:choose>
								<p class="state_txt"><spring:message code="dashboard.Register_backup" /></p>
							</li>
							<%-- <li>
								<p class="state">
									<img src="../images/ico_state_09.png" alt="Backup" /><span>Schedule
									</span>
								</p>
								<a href="/selectScheduleListView.do"><p class="state_num c1">${backupInfo.schedule_cnt}</p></a>
								<p class="state_txt">스캐줄등록</p>
							</li>
							<li>
								<p class="state">
									<img src="../images/ico_state_03.png" alt="Running Schedule" /><span>Running Schedule</span>
								</p>
								<p class="state_num c3">${backupInfo.schedule_run_cnt}</p>
								<p class="state_txt">스케줄실행중</p>
							</li> --%>
						</ul>
					</div>
					<div class="m_info_rt">
						<p class="m_tit"><spring:message code="menu.data_transfer_information" /></p>
						<ul>
							<li>
								<p class="state">
									<img src="../images/ico_state_10.png" alt="connet" /><span>Channel</span>
								</p>
								<c:choose>
						           <c:when test="${fn:length(fn:escapeXml(transferInfo.connect_cnt))>2}">
						           <p class="state_num c1" style="font-size: 40px;">
						            <c:out value="${transferInfo.connect_cnt}"/>
						            </p>
						           </c:when>
						           <c:otherwise>
						           <p class="state_num c1">
						            <c:out value="${transferInfo.connect_cnt}"/>
						            </p>
						           </c:otherwise> 
						         </c:choose>
								<p class="state_txt"><spring:message code="dashboard.connect_count" /></p>
							</li>
							<li>
								<p class="state">
									<img src="../images/ico_state_03.png" alt="Running Transfer" /><span>Running</span>
								</p>
								<c:choose>
						           <c:when test="${fn:length(fn:escapeXml(transferInfo.execute_cnt))>2}">
						           <p class="state_num c3" style="font-size: 40px;">
						            <c:out value="${transferInfo.execute_cnt}"/>
						            </p>
						           </c:when>
						           <c:otherwise>
						           <p class="state_num c3">
						            <c:out value="${transferInfo.execute_cnt}"/>
						            </p>
						           </c:otherwise> 
						         </c:choose>
								<p class="state_txt"><spring:message code="dashboard.running" /></p>
							</li>
						</ul>
					</div>				
				</div>

				<div class="main_server_info">
					<p class="tit"><spring:message code="menu.dbms_information" /></p>
					<div class="inner">
					<!--
						<div class="sch_form">
							<table class="write">
								<caption>검색 조회</caption>
								<colgroup>
									<col style="width: 104px;" />
									<col />
								</colgroup>
								<tbody>
									<tr>
										<th scope="row" class="t2">서버명</th>
										<td><input type="text" class="txt t2" /></td>
									</tr>
									<tr>
										<th scope="row" class="t10">백업 실행일자</th>
										<td>
											<div class="calendar_area">
												<a href="#n" class="calendar_btn">달력열기</a> <input
													type="text" class="calendar" id="datepicker1"
													title="백업 실행 시작날짜" readonly /> <span class="wave">~</span>
												<a href="#n" class="calendar_btn">달력열기</a> <input
													type="text" class="calendar" id="datepicker2"
													title="백업 실행 종료날짜" readonly />
											</div> <span class="btn btnF_03 btnBd_01"><button>조회</button></span>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
						
					-->
						<table class="list" border="1">
							<caption><spring:message code="dashboard.dbms_info" /></caption>
							<colgroup>
								<col style="width: 10%;" />
								<col style="width: 10%;" />
								<col style="width: 6%;" />
								<col style="width: 6%;" />
								<col style="width: 6%;" />
								<col style="width: 6%;" />
								<col style="width: 14%;" />

								<col style="width: 14%;" />
								<col style="width: 9%;" />
								<col style="width: 9%;" />
							</colgroup>
							<thead>
								<tr>
									<th scope="col" rowspan="2"><spring:message code="common.dbms_name" /> </th>
									<th scope="col" rowspan="2"><spring:message code="dashboard.management_db" />  </th>
									<th scope="col" colspan="4"><spring:message code="menu.backup_management" /></th>
									<th scope="col"><spring:message code="menu.access_control" /></th>

									<th scope="col" colspan="2"><spring:message code="menu.data_transfer" /></th>
									<th scope="col" rowspan="2">Agent <spring:message code="properties.status" /></th>								
								</tr>
								<tr>
									<th scope="col"><spring:message code="common.registory" /></th>
									<th scope="col"><spring:message code="menu.schedule" /></th>
									<th scope="col"><spring:message code="common.success" /></th>
									<th scope="col"><spring:message code="common.failed" /> </th>
									<th scope="col"><spring:message code="dashboard.regist_count" /></th>
									<th scope="col"><spring:message code="dashboard.connect_count" /></th>
									<th scope="col"><spring:message code="schedule.run" /></th>
								</tr>
							</thead>
							<tbody>
								<c:if test="${fn:length(serverInfo) == 0}">
										<tr>
											<td colspan="11"><spring:message code="message.msg01" /></td>
										</tr>
								</c:if>
								<c:forEach var="data" items="${serverInfo}" varStatus="status">
								<tr>
									<td>${data.db_svr_nm}</td>
									<td>${data.db_cnt}</td>
									<td>${data.wrk_cnt}</td>
									<td>${data.schedule_cnt}</td>
									<td>${data.success_cnt}</td>
									<td>${data.fail_cnt}</td>
									<td>${data.access_cnt}</td>
									<td>${data.connect_cnt}</td>
									<td>${data.execute_cnt}</td>
									<td>
									<c:if test="${data.agt_cndt_cd == null}">
										<span class="work_state"><img src="../images/ico_state_08.png" alt="Not Install" /></span>Not Install
									</c:if>
									<c:if test="${data.agt_cndt_cd == 'TC001101'}">
										<!-- <span class="work_state"> -->
										<img src="../images/ico_agent_1.png" alt="" />
										<!-- <img src="../images/ico_state_03.png" alt="Running" /></span>Running -->
									</c:if>									
									<c:if test="${data.agt_cndt_cd == 'TC001102'}">
										<img src="../images/ico_agent_2.png" alt="" />
										<!-- <span class="work_state"><img src="../images/ico_state_07.png" alt="Stop" /></span>Stop -->
									</c:if>											
									</td>							
								</tr>
								</c:forEach>
							</tbody>
						</table>
					</div>
				</div>
				
				<!-- eXperDB Encrypt 상태 -->
				<div class="main_server_info" >
					<p class="tit">eXperDB Encrypt <%-- <spring:message code="properties.status" /> --%> <span id="today" style="float: right; padding-right: 1%;"></span></p>
					
					<div class="inner">
						<table class="list" style="width: 320px;" id="encryptDashbaordServer">
							<caption>eXperDB Encrypt Server </caption>
							<colgroup>
							</colgroup>
							<tr>
								<th>Server <spring:message code="properties.status" /></th>						
								<th id="encryptServer"></th>
							</tr>		
						</table>			
					
							
						<table class="list" border="1" id="encryptDashbaordAgent">
							<caption><spring:message code="dashboard.dbms_info" /></caption>
							<colgroup>
								<col style="width: 13.5%;" />

								<col style="width: 6%;" />
								<col style="width: 6%;" />
								<col style="width: 6%;" />								
								<col style="width: 6%;" />
								
								<col style="width: 10%;" />
								<col style="width: 10%;" />
							</colgroup>
							<thead>
								<tr>
									<th scope="col" rowspan="2">Encrypt Agent IP </th>						
									<th scope="col" colspan="2"><spring:message code="encrypt_log_decode.Encryption"/></th>
									<th scope="col" colspan="2"><spring:message code="encrypt_log_decode.Decryption"/></th>
									<th scope="col" rowspan="2"><spring:message code="encrypt_Statistics.Sum"/>  </th>
									<th scope="col" rowspan="2">Agent <spring:message code="properties.status" /></th>								
								</tr>
								<tr>
									<th scope="col"><spring:message code="common.success" /></th>
									<th scope="col"><spring:message code="common.failed" /></th>
									<th scope="col"><spring:message code="common.success" /></th>
									<th scope="col"><spring:message code="common.failed" /></th>
								</tr>
							</thead>
							<tbody id="col">
						
							</tbody>
						</table>
					</div>
				</div>
				
			</div>
		</div>
	</div>
</div>
<!-- // contents -->
