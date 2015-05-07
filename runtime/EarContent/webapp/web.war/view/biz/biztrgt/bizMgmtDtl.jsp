<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <jsp:include page="/view/layouts/default_head.jsp" flush="false" />
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/vendor/jquery.ui.widget.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/jquery.iframe-transport.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/jquery.fileupload.js"></script>
    <script type="text/javascript">
    var _param;
    $.alopex.page({
        init : function(id, param) { 
            $.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출
            _param = param; //이 페이지로 전달된 파라미터를 저장
            alert(JSON.stringify(param));
            
            $a.page.setEventListener();
            $a.page.setFileUpload();
          
            pSearchBizTrgtPrstDtl(param);
        },
        setEventListener : function() {
            $("#btnList").click(function(){
            	$a.back(_param);
            });
        },
        setFileUpload : function () {
        	$.PSNMUtils.setFileUploadAndGrid("BIZ", "#fileupload", "#gridfile");
        },
    });
    function pSearchBizTrgtPrstDtl(param) {
    	if (null==param || undefined==param) {
    		return;
    	}

    	$.alopex.request("biz.BIZTRGT@PBIZTRGT001_pDetailBizTrgt", {
    		
    		data: {dataSet: {fields: {BIZ_ID :param.BIZ_ID,ATCH_YN: param.ATCH_YN}}},
            success:["#form", "#gridfile",  function(res) {
            }]
        });
    }
    
    </script>
</head>
<body>
<jsp:include page="/view/layouts/default_header.jsp" flush="false" />
<div id="contents">
    <!-- title area -->
    <div class="content_title">
        <div class="ub_txt6">
            <span class="txt6_img"><b>영업목표/현황관리</b><span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif"> 
            <span class="a2">본사업무</span> <span class="a3"> > </span><b>영업목표/현황관리</b></span></span> 
        </div>
    </div>
    <!-- btn area -->
    <div class="btn_area">
        <div class="ab_btn_right">
            <button id="btnList" type="button" data-type="button" data-theme="af-btn14" data-altname="목록" data-authtype="R"></button>
        </div>
    </div>
    <!-- btn area end--> 
    <!--view_list area -->
    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>영업목표/현황</b></div>
    <!--view_table area -->
    <div class="view_list">
        <form id="form" onsubmit="return false;">
        	<input type="hidden" id="BIZ_ID" name="BIZ_ID" data-bind="value:BIZ_ID"/>
        	<div>
	            <table class="board02" style="width:100%;">
	            <colgroup>
		            <col/>
		            <col style="width:220px;"/>
		            <col/>
		            <col style="width:220px;"/>
	            </colgroup>
	            <tbody>
	            <tr>
	                <th scope="col">제목</th>
	                <td colspan="3" class="tleft">
		                <label data-bind="text:BIZ_TITL_NM"></label>
	                </td>
	            </tr>
	            <tr>
	            	<th scope="col">게시일자</th>
	                <td class="tleft">
		                <label data-bind="text:BLTN_DT"></label>
	                </td>
	                <th scope="col">영업국명</th>
	                <td class="tleft time">
		                <label data-bind="text:SALE_DEPT_ORG_NM"></label>
	                </td>
	            </tr>
	            <tr>
	                <td colspan="4" class="tleft" style="word-break:break-all;">
	                <label data-bind="html:BIZ_CTT"></label>
	                </td>
	            </tr>
	            </tbody>
	            </table>
            </div>
            <div>
			</div>
        </form>
    </div>
    <!--view_list area -->
    <div class="floatL4"> 
        <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>첨부파일</b>
    </div>
    <div id="gridfile" class="view_list" data-bind="grid:gridfile"></div>
</div>
<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />
</body>
</html>