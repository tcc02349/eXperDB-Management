<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%
	/**
	* @Class Name : accessControlRegForm.jsp
	* @Description : accessControlRegForm 화면
	* @Modification Information
	*
	*   수정일         수정자                   수정내용
	*  ------------    -----------    ---------------------------
	*  2017.06.26     최초 생성
	*
	* author 김주영 사원
	* since 2017.06.26
	*
	*/
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>접근제어 등록/수정 팝업</title>
<link rel="stylesheet" type="text/css" href="../css/common.css">
<script type="text/javascript" src="../js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="../js/common.js"></script>
</head>
<script>
	//숫자체크
	function valid_numeric(objValue) {
		if (objValue.match(/^[0-9]+$/) == null) {
			return false;
		} else {
			return true;
		}
	}

	/* Validation */
	function fn_accessControl() {
		/*Type=local -> ip입력 안함*/
		if ($("#ctf_tp_nm option:selected").val() != "local") {
			var ip = document.getElementById("ip");
			if (ip.value == "") {
				alert("IP를 입력하여 주십시오.");
				ip.focus();
				return false;
			}
			var prefix = document.getElementById("prefix");
			var prms_ipmaskadr = document.getElementById("prms_ipmaskadr");
			if(prefix.value == "" && prms_ipmaskadr.value == ""){
				alert("prefix,Ipmask 중 하나를 입력하여 주십시오.");
				return false;
			}
			if (prefix.value !="" &&!valid_numeric(prefix.value)) {
				alert("Prefix는 숫자만 입력가능합니다.");
				prefix.focus();
				return false;
			}
			if(prefix.value !="" && prefix.value>32){
				alert("Prefix는 0~32만 입력가능합니다.");
				prefix.focus();
				return false;
			}
		}
		return true;
	}

	/* 등록 버튼 클릭시*/
	function fn_insert() {
		if (!fn_accessControl())return false;
		var type = $("#ctf_tp_nm").val();
		var prms_ipadr = "";
		if(type!="local"){
			var ip = document.getElementById("ip").value;
			var prefix = document.getElementById("prefix").value;
			if(prefix!=""){
				prms_ipadr = ip + "/" + prefix;	
			}else{
				prms_ipadr = ip;
			}	
		}
			
		$.ajax({
			url : "/insertAccessControl.do",
			data : {
				db_svr_id : '${db_svr_id}',
				prms_ipadr : prms_ipadr,
				prms_ipmaskadr : $("#prms_ipmaskadr").val(),
				dtb : $("#dtb").val(),
				prms_usr_id : $("#prms_usr_id").val(),
				ctf_mth_nm : $("#ctf_mth_nm").val(),
				ctf_tp_nm : $("#ctf_tp_nm").val(),
				opt_nm : $("#opt_nm").val()				
			},
			type : "post",
			error : function(request, status, error) {
				alert("실패");
			},
			success : function(result) {
				alert("저장하였습니다.");
				window.close();
				opener.fn_select();
			}
		});
	}

	/* 수정 버튼 클릭시*/
	function fn_update() {
		if (!fn_accessControl())return false;
		var type = $("#ctf_tp_nm").val();
		var prms_ipadr = "";
		if(type!="local"){
			var ip = document.getElementById("ip").value;
			var prefix = document.getElementById("prefix").value;
			if(prefix!=""){
				prms_ipadr = ip + "/" + prefix;	
			}else{
				prms_ipadr = ip;
			}	
		}
		$.ajax({
			url : "/updateAccessControl.do",
			data : {
				prms_seq : '${prms_seq}',
				db_svr_id : '${db_svr_id}',
				prms_ipadr : prms_ipadr,
				prms_ipmaskadr : $("#prms_ipmaskadr").val(),
				dtb : $("#dtb").val(),
				prms_usr_id : $("#prms_usr_id").val(),
				ctf_mth_nm : $("#ctf_mth_nm").val(),
				ctf_tp_nm : $("#ctf_tp_nm").val(),
				opt_nm : $("#opt_nm").val()
			},
			type : "post",
			error : function(request, status, error) {
				alert("실패");
			},
			success : function(result) {
				alert("저장하였습니다.");
				window.close();
				opener.fn_select();
			}
		});
	}

	$(window.document).ready(function() {
		var ctf_tp_nm = $("#ctf_tp_nm option:selected").val();
		if (ctf_tp_nm == "local") {
			$('#ip').attr('disabled', 'true');
			$('#prefix').attr('disabled', 'true');
			$('#prms_ipmaskadr').attr('disabled', 'true');
		}
		if ("${act}" == "u") {
			var prms_ipadr = "${prms_ipadr}";
			var str = prms_ipadr.split("/");
			$('#ip').val(str[0]);
			$('#prefix').val(str[1]);
			if(str[1]==null){
				$('#prefix').attr('disabled', 'true');
			}else{
				$('#prms_ipmaskadr').attr('disabled', 'true');
			}
		}
	});

	function change(selectObj) {
		if (selectObj.value == "local") {
			$('#ip').attr('disabled', 'true');
			$('#prefix').attr('disabled', 'true');
			$('#prms_ipmaskadr').attr('disabled', 'true');
			$('#ip').val("");
			$('#prefix').val("");
			$('#prms_ipmaskadr').val("");
			
		} else {
			$('#ip').removeAttr('disabled');
			$('#prefix').removeAttr('disabled');
			$('#prms_ipmaskadr').removeAttr('disabled');
		}
	}
	
	function changePrefix() {
		var prefix = $("#prefix").val();
		if(prefix==""){
			$('#prms_ipmaskadr').removeAttr('disabled');
		}else{
			$('#prms_ipmaskadr').attr('disabled', 'true');
		}		
	}

	function changeIpmaskadr() {
		var ipmaskadr = $("#prms_ipmaskadr").val();
		if(ipmaskadr==""){
			$('#prefix').removeAttr('disabled');
		}else{
			$('#prefix').attr('disabled', 'true');
		}		
	}
</script>
<body>
<div class="pop_container">
	<div class="pop_cts">
		<p class="tit">
			<c:if test="${act == 'i'}">접근제어 등록하기</c:if>
			<c:if test="${act == 'u'}">접근제어 수정하기</c:if>
		</p>
		<div class="pop_cmm">
			<table class="write">
				<caption>
					<c:if test="${act == 'i'}">접근제어 등록하기</c:if>
					<c:if test="${act == 'u'}">접근제어 수정하기</c:if>
				</caption>
				<colgroup>
					<col style="width:85px;" />
					<col />
					<col style="width:85px;" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row" class="ico_t1">서버명</th>
						<td><input type="text" class="txt bg1" value="${db_svr_nm}" readonly="readonly"/></td>
						<th scope="row" class="ico_t1">Database</th>
						<td>
							<select id="dtb" name="dtb" class="select t4">
							<option value="all" ${dtb == 'all' ? 'selected="selected"' : ''}>all</option>
							<option value="replication" ${dtb == 'replication' ? 'selected="selected"' : ''}>replication</option>
								<c:forEach var="resultSet" items="${resultSet}">
									<option value="${resultSet.db_nm}" ${dtb eq resultSet.db_nm ? "selected='selected'" : ""}>${resultSet.db_nm}
									<c:if test="${!empty resultSet.db_exp}">(${resultSet.db_exp})</c:if>
									</option>
								</c:forEach>
							</select>
					</tr>
				</tbody>
			</table>
		</div>
		<div class="pop_cmm mt25">
			<table class="write">
				<caption>
					<c:if test="${act == 'i'}">접근제어 등록하기</c:if>
					<c:if test="${act == 'u'}">접근제어 수정하기</c:if>
				</caption>
				<colgroup>
					<col style="width:85px;" />
					<col />
					<col style="width:110px;" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row" class="ico_t1">Type</th>
						<td>					
							<select id="ctf_tp_nm" name="ctf_tp_nm" id="ctf_tp_nm" class="select t4" onChange="javascript:change(this)">
								<option value="local" ${ctf_tp_nm == 'local' ? 'selected="selected"' : ''}>local</option>
								<option value="host" ${ctf_tp_nm == 'host' ? 'selected="selected"' : ''}>host</option>
								<option value="hostssl" ${ctf_tp_nm == 'hostssl' ? 'selected="selected"' : ''}>hostssl</option>
								<option value="hostnossl" ${ctf_tp_nm == 'hostnossl' ? 'selected="selected"' : ''}>hostnossl</option>
							</select>
						</td>
						
						<th scope="row" class="ico_t1">IP<br>(127.0.0.1/32)</th>
						<td>
							<input type="text" class="txt" name="ip" id="ip" style="width: 130px;"/> /
							<input type="text" class="txt" name="prefix" id="prefix" style="width: 100px;" onchange="changePrefix()" />
						</td>
					</tr>
					<tr>
						<th scope="row" class="ico_t1">User</th>
						<td>									
							<select id="prms_usr_id" name="prms_usr_id" class="select t4">
								<option value="all" ${prms_usr_id == 'all' ? 'selected="selected"' : ''}>all</option>
								<c:forEach var="result" items="${result.data}">
									<option value="${result.rolname}" ${prms_usr_id eq result.rolname ? "selected='selected'" : ""}>${result.rolname}</option>
								</c:forEach>
							</select>
						</td>
						<th scope="row" class="ico_t1">Ipmask</th>
						<td><input type="text" class="txt" name="prms_ipmaskadr" id="prms_ipmaskadr" onchange="changeIpmaskadr()" value="${ipmask}"/></td>
					</tr>
					<tr>
						<th scope="row" class="ico_t1">Method</th>
						<td>
							<select id="ctf_mth_nm" name="ctf_mth_nm" id="ctf_mth_nm" class="select">
								<option value="trust"  ${ctf_mth_nm == 'trust' ? 'selected="selected"' : ''}>trust</option>
								<option value="reject" ${ctf_mth_nm == 'reject' ? 'selected="selected"' : ''}>reject</option>
								<option value="md5" ${ctf_mth_nm == 'md5' ? 'selected="selected"' : ''}>md5</option>
								<option value="password" ${ctf_mth_nm == 'password' ? 'selected="selected"' : ''}>password</option>
								<option value="krb4" ${ctf_mth_nm == 'Krb4' ? 'selected="selected"' : ''}>Krb4</option>
								<option value="krb5" ${ctf_mth_nm == 'krb5' ? 'selected="selected"' : ''}>krb5</option>
								<option value="ident" ${ctf_mth_nm == 'ident' ? 'selected="selected"' : ''}>ident</option>
								<option value="pam" ${ctf_mth_nm == 'pam' ? 'selected="selected"' : ''}>pam</option>
								<option value="ldap" ${ctf_mth_nm == 'ldap' ? 'selected="selected"' : ''}>ldap</option>
								<option value="gss" ${ctf_mth_nm == 'gss' ? 'selected="selected"' : ''}>gss</option>
								<option value="sspi" ${ctf_mth_nm == 'Sspi' ? 'selected="selected"' : ''}>sspi</option>
								<option value="cert" ${ctf_mth_nm == 'cert' ? 'selected="selected"' : ''}>cert</option>
								<option value="crypt" ${ctf_mth_nm == 'crypt' ? 'selected="selected"' : ''}>crypt</option>
								<option value="radius" ${ctf_mth_nm == 'radius' ? 'selected="selected"' : ''}>radius</option>
								<option value="peer" ${ctf_mth_nm == 'peer' ? 'selected="selected"' : ''}>peer</option>
							</select>
						</td>
						<th scope="row" class="ico_t1">Option</th>
						<td><input type="text" class="txt" name="opt_nm" id="opt_nm"/></td>		
					</tr>
				</tbody>
			</table>
		</div>
		<div class="btn_type_02">
			<span class="btn btnC_01">					
				<c:if test="${act == 'i'}">
					<button type="button" onclick="fn_insert()">저장</button>
				</c:if>
				<c:if test="${act == 'u'}">
					<button type="button" onclick="fn_update()">저장</button>
				</c:if>
			</span>
			<a href="#n" class="btn" onclick="window.close();"><span>취소</span></a>
		</div>
	</div>
</div>

</body>
</html>