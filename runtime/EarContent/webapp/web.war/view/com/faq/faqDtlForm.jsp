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
            
            $a.page.setEventListener();
            $a.page.setCodeData();
            $a.page.setFileUpload();
            
            $("#FAQ_ID").val(_param.data.FAQ_ID);
            $a.page.searchFaq(_param.data.FAQ_ID);
        },
        setEventListener : function() {
            $("#btnList").click(function(){
            	/* $a.navigate("faqMgmt.jsp", _param); */
            	$a.back(_param);
            });
        },
        setCodeData : function() {
        	$.PSNMUtils.setCodeData([
				{ t:'code', 'elemid' : 'FAQ_TYP_CD', 'header' : '-전체-' }
            ]);
        },
        searchFaq : function(faqId) {        	
        	$.alopex.request('com.FAQMGMT@PFAQMGMT001_pSearchFaqDtl', {
                data: {
                    dataSet: {
                        fields: {
                            FAQ_ID : faqId
                        }
                    }
                },
                success: ['#form', '#gridfile', function(res) { 
                    $("#FAQ_CTT").ckeditor();
                }]
            });
        },
        setFileUpload : function () {
        	$.PSNMUtils.setFileUploadAndGrid("DSM", "#fileupload", "#gridfile");
        }
    });

    
    </script>

</head>

<body>

<jsp:include page="/view/layouts/default_header.jsp" flush="false" />

<div id="contents">

    <!-- title area -->
    <div class="content_title">
        <div class="ub_txt6">
            <span class="txt6_img"><b>FAQ관리</b><span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif"> 
            <span class="a2">나의 D-tok</span> <span class="a3"> > </span><b>FAQ관리</b></span></span> 
        </div>
    </div>

    <!-- btn area -->
    <div class="btn_area">
        <div class="ab_btn_right">
            <button id="btnList" type="button" data-type="button" data-theme="af-btn14" data-altname="목록"></button>
        </div>
    </div>
    <!-- btn area end--> 

    <!--view_list area -->
    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>FAQ관리</b></div>

    <!--view_table area -->
    <div class="view_list">

        <form id="form">
        	<input id="FAQ_ID" name="FAQ_ID" type="hidden" data-bind="value:FAQ_ID" data-type="hidden" />
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
			                <td class="tleft" colspan="3">
			                    <label data-bind="text:FAQ_TITL_NM"></label>
			                </td>
			            </tr>
			            <tr>    
			                <th scope="col">FAQ유형</th>
			                <td class="tleft" colspan="3">
			                	<label data-bind="text:FAQ_TYP_NM"></label>
			                </td>
			            </tr>
			            <tr>
			            	<th scope="col">작성자</th>
			                <td class="tleft">
			                	<label data-bind="text:BLTNR_NM"></label>
			                </td>
			                <th scope="col">작성일자</th>
			                <td class="tleft time">
			                	<label data-bind="text:BLTN_DT" style="width:60%"></label>
			                </td>
			            </tr>
			            <tr>
			                <td colspan="4" class="tleft">
			                	<label data-bind="html:FAQ_CTT"></label>
			                </td>
			            </tr>
		            </tbody>
	            </table>
            </div>
        </form>
    </div>

    <!--view_list area -->
    <div class="floatL4"> 
        <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>첨부파일</b>
    </div>
    <div id="gridfile" class="view_list" data-bind="grid:gridfile" data-ui="ds"></div>

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>