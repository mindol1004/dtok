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
            $.PSNM.initialize(id, param);
            
            _param = param;
            
            $a.page.setEventListener();
            $a.page.setFileUpload();
            $a.page.setCodeData();
            
            $("#BLTCONT_ID").val(_param.data.BLTCONT_ID);
            $a.page.searchFaq(_param.data.BLTCONT_ID);
            $("#DSM_HEADQ_NM").text(_param.data.DSM_HEADQ_NM);
        },
        setEventListener : function() {
            $("#btnList").click(function(){
            	$a.back(_param);
            });
        },
        setCodeData : function() {
            $.PSNMUtils.setCodeData([
				 //{ t:'code', 'elemid' : 'FAQ_TYP_CD', 'codeid' : 'DSM_FAQ_TYP_CD', 'header' : '-전체-' }
				 { t:'code', 'elemid' : 'BLTCONT_BRWS_COND_CD', 'header' : '-전체-' }
            ]);
        },
        searchFaq : function(bltcontId) {        	
        	$.alopex.request('com.PPCNSLMGMT@PP2PCNSLMGMT001_pSearchP2pCnslDtl', {
                data: {
                    dataSet: {
                        fields: {
                        	BLTCONT_ID : bltcontId
                        }
                    }
                },
                success: ['#form', '#gridfile', function(res) { 
                    $("#ED_CON_VIEW").ckeditor();
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
            <span class="txt6_img"><b>무엇이든 물어보세요</b><span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif"> 
            <span class="a2">나의 D-tok</span> <span class="a3"> > </span><b>무엇이든 물어보세요</b></span></span> 
        </div>
    </div>

    <!-- btn area -->
    <div class="btn_area">
        <div class="ab_btn_right">
            <!-- <button id="btnInit" type="button" data-type="button" data-theme="af-psnm0"  data-altname="초기화" style="padding-bottom:3px !important; padding-left:18px !important;">초기화</button> -->
            <button id="btnSave" type="button" data-type="button" data-theme="af-btn4"  data-altname="저장"></button>
            <button id="btnDel"  type="button" data-type="button" data-theme="af-btn13" data-altname="삭제"></button>
            <button id="btnList" type="button" data-type="button" data-theme="af-btn14" data-altname="목록"></button>
        </div>
    </div>
    <!-- btn area end--> 

    <!--view_list area -->
    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>무엇이든 물어보세요</b></div>

    <!--view_table area -->
    <div class="view_list">

        <form id="form">
        	<input id="BLTCONT_ID" name="BLTCONT_ID" type="hidden" data-bind="value:BLTCONT_ID" data-type="hidden" />
				
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
			                	<input id="BLTCONT_TITL_NM" name="BLTCONT_TITL_NM" data-bind="value:BLTCONT_TITL_NM" data-type="textinput" 
			                           data-validation-rule="{required:true}" 
			                           data-validation-message="{required:'제목을 입력해 주세요.'}" style="width:95%">
			                </td>
			            </tr>
			            <tr>
			            	<th scope="col">영업국</th>
			                <td class="tleft">
			                	<input id="DSM_HEADQ_NM"  data-type="textinput" style="width:120px" data-theme="af-textinput" data-disabled=true></input>
          						<input id="DSM_HEADQ_CD"  data-bind="value:DSM_HEADQ_CD" data-type="textinput" style="width:80px" data-theme="af-textinput" data-disabled=true>
			                </td>
			            	<th scope="col">에이전트명</th>
			                <td class="tleft">
			                	<input id="RGSTR_NM" name="RGSTR_NM" data-type="textinput" data-bind="value:RGSTR_NM" style="width:120px" data-disabled="true"/>
			                </td>
			            </tr>
			            <tr>
			            	<th scope="col">작성일자</th>
			                <td class="tleft time" colspan="3">
			                	<input id="RGST_DT" name="RGST_DT" data-type="dateinput" data-bind="value:RGST_DT" data-disabled="true" style="width:100px;"/>
			                </td>
			            </tr>
			            <tr>
			                <td colspan="4" class="tleft">
			                	<textarea id="BLTCONT_CTT" name="BLTCONT_CTT" data-type="textarea" data-bind="value:BLTCONT_CTT" rows="10" cols="80" 
			                              data-validation-rule="{required:true}" 
			                              data-validation-message="{required:'내용을 입력해 주세요.'}" 
			                              style='overflow: auto; width: 100%;'></textarea>
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
        <div class="ab_pos1">
            <div style="width:95px; height: 24px; background:url('/web/image/btn_c16.gif') no-repeat; border:0px;">
                 <input id="fileupload" type="file" name="files[]" multiple style="width:44px; height:24px; filter:alpha(opacity=0); opacity: 0; cursor: pointer;" /> 
                 <input id="btnFileDel" type="button" data-type="button" class="inputButton">
            </div>
        </div>
    </div>
    <div id="gridfile" class="view_list" data-bind="grid:gridfile" data-ui="ds"></div>

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>