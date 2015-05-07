<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="nexcore.framework.core.Constants"%>
<%@ page import="nexcore.framework.core.code.ICode"%>
<%@ page import="nexcore.framework.core.data.user.IUserInfo"%>
<%@ page import="nexcore.framework.core.util.BaseUtils"%>
<%@ page import="nexcore.framework.online.channel.util.WebUtils"%>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>회원가입요청 승인/반려 결제의견</title>

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />

    <script type="text/javascript">
    $a.page({
        init : function(id, param) {
            $a.page.setEventListener();
            $('#SCRB_ST_CHG_RSN').focus();
        },
        setEventListener : function() {
            $("#btnConfirm").click( closeWith );
            $("#btnCancel").click( closeWithout );
        }
    });
    
    //현재창을 닫고 객체를 반환
    function closeWith( val ) {
        $a.close(  $("#SCRB_ST_CHG_RSN").val()  );
    }

    function closeWithout() {
        $a.close();
    }    
    </script>
</head>

<body>

<!-- title area -->
<div class="psnm-pop-body" style="">

    <!--view_list area -->
    <div class="floatL4" style="width:100%;"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>결재의견</b></div>
    <form id="aform">
            <div class="floatL4">
                <p class="textAR">
                    <textarea id="SCRB_ST_CHG_RSN" name="SCRB_ST_CHG_RSN"  data-type="textinput" ></textarea>
                </p>
            </div>
                
    </form>

    <!-- btn area -->
    <div class="btn_area" style="width:500px;">
      <p class="floatL3">
        <input id="btnConfirm" type="button" data-type="button" value="" data-theme="af-btn8">
        <input id="btnCancel"  type="button" data-type="button" value="" data-theme="af-btn10">
      </p>
    </div>

</div>

</body>
</html>