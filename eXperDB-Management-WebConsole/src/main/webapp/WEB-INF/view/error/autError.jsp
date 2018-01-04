<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>  
<style>
#error {
	float: left;
	position: relative;
	right: 50%;
	margin-top: 50%;
}
</style>
<body class="bg">
	<div id="login_wrap">
		<div class="inr">
			<div id="error">
				<c:set var="data" value="${pageContext.response.locale}" />
					<c:choose>
				    <c:when test="${data eq 'en'}">
				       <img src="../images/en_error403.png">
				    </c:when>
				    <c:otherwise>
				      <img src="../images/error403.png">
				    </c:otherwise>
				</c:choose>
				<div class="btn_wrap">
					<button onclick="history.go(-1)"><spring:message code="common.back"/></button>
				</div>
			</div>
		</div>
	</div>
</body>
</html>