<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : agentMonitoringModifyForm.jsp
	* @Description : 암호화 에이전트 모니터링 수정 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2018.01.04     최초 생성
	*
	* author 변승우 대리
	* since 2018.01.04
	*
	*/
%>
<!doctype html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>eXperDB</title>
<link rel="stylesheet" type="text/css" href="/css/common.css">
<script type="text/javascript" src="/js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="/js/common.js"></script>
</head>
<style>
.cmm_bd .sub_tit>p {
	padding: 0 8px 0 33px;
	line-height: 24px;
	background: url(../images/popup/ico_p_2.png) 8px 48% no-repeat;
}
</style>

<script>
var table = null;

//var key = "${resultKey}";
//var keyValue = "${resultValue}";
var extendedField = ${extendedField};

	$(window.document).ready(function() {	
		fn_buttonAut();
		var html = ""; 
	
		for(key in extendedField) {		
			html += ' <tr>';
			html += ' <td>';
			html +=	key;
			html += ' </td>';
			html += ' <td>';
			html +=	extendedField[key];
			html += ' </td>';
			html += ' </tr>';
		}
		$( "#extendedField" ).append(html);
	});
	
	function fn_buttonAut(){
		var btnSave = document.getElementById("btnSave"); 
		
		if("${wrt_aut_yn}" == "Y"){
			btnSave.style.display = '';
		}else{
			btnSave.style.display = 'none';
		}
	}
	
	function fn_agentStatusSave(){
		$.ajax({
			url : "/agentStatusSave.do", 
		  	data : {		  		
		  		entityName : $('#entityName').val(),
		  		entityUid : $('#entityUid').val(),
		  		entityStatusCode : $('#entityStatusCode').val(),
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
					alert('<spring:message code="encrypt_msg.msg21"/>');
					opener.location.reload();
					window.close();
				}else if(data.resultCode == "8000000002"){
					alert("<spring:message code='message.msg05' />");
					top.location.href = "/";
				}else if(data.resultCode == "8000000003"){
					alert(data.resultMessage);
					location.href = "/securityKeySet.do";
				}else{
					alert(data.resultMessage +"("+data.resultCode+")");		
				}
			}
		});
	}
</script>

<body>
	<div class="pop_container">
		<div class="pop_cts">
			<p class="tit"><spring:message code="encrypt_agent.Modify_Agent_Monitoring"/></p>
				<div class="btn_type_01">
					<span class="btn btnC_01" onClick="fn_agentStatusSave();"><button type="button" id="btnSave"><spring:message code="common.save"/></button></span> 
				</div>
			<div class="cmm_bd">
				<div class="sub_tit">
					<p><spring:message code="encrypt_agent.Default_Default"/></p>
				</div>
				<div class="overflows_areas">
					<table class="write">
						<colgroup>
							<col style="width: 100px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="ico_t2"><spring:message code="encrypt_agent.Agent_Name"/></th>
								<td><input type="text" class="txt" name="entityName" id="entityName" value="${entityName}"  readonly="readonly" >
										<input type="hidden" name="entityUid" id="entityUid" value="${entityUid}" >
								</td>
							</tr>
							<tr>
								<th scope="row" class="ico_t2">Agent <spring:message code="access_control_management.activation" /></th>
								<td>
									<select class="select t5" id="entityStatusCode" name="entityStatusCode" >
											<c:forEach var="result" items="${result}" varStatus="status">
												<option value="<c:out value="${result.sysCode}"/>" <c:if test="${result.sysCode == entityStatusCode}">selected="selected"</c:if>><c:out value="${result.sysCodeName}"/></option>
											</c:forEach> 
									</select>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>

			<br><br>
			
			<div class="cmm_bd">
				<div class="sub_tit">
					<p><spring:message code="encrypt_agent.Additional_Information"/></p>
				</div>
				<div class="overflows_areas">
					<table class="write">
						<colgroup>
							<col style="width: 170px;" />
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="ico_t2"><spring:message code="encrypt_agent.Recently_accessed_address"/></th>
								<td><input type="text" class="txt" name="latestAddress" id="latestAddress" value="${latestAddress}"  readonly="readonly" ></td>
							</tr>
							<tr>
								<th scope="row" class="ico_t2"><spring:message code="encrypt_agent.Recently_Accessed_Time"/></th>
								<td><input type="text" class="txt" name="latestDateTime" id="latestDateTime" value="${latestDateTime}"  readonly="readonly" ></td>

							</tr>
						</tbody>
					</table>
				</div>
			</div>
			
			<br><br>

			<div class="overflow_area">
				<table class="list">
					<caption>리스트</caption>
					<colgroup>
						<col style="width: 15%;" />
						<col style="width: 35%;" />
					</colgroup>
					<thead>
						<tr>
							<th scope="col"><spring:message code="encrypt_agent.System_Key"/></th>
							<th scope="col"><spring:message code="encrypt_agent.System_Value"/></th>
						</tr>
					</thead>
					<tbody id="extendedField">		

					</tbody>
				</table>
			</div>
		</div>
		<!-- //pop-container -->
	</div>
</body>
</html>