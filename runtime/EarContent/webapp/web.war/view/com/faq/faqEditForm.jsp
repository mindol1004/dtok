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
    
    var _mode = "";
    var _param;
    
    $.alopex.page({
    	
        init : function(id, param) {
            $.PSNM.initialize(id, param);
            
            _param = param;
            _mode = "insert";
            
            $a.page.setEventListener();
            $a.page.setCodeData();
            $a.page.setFileUpload();
            
            $("#FAQ_ID").val("");            
            if ( $.PSNMUtils.isNotEmpty(_param.data.FAQ_ID) ) {
                _mode = "update";
                $("#FAQ_ID").val(_param.data.FAQ_ID);                
            }
            
            if (_mode == "update") {
                $a.page.searchFaq(_param.data.FAQ_ID);
            }
            else {
            	$("#btnDel").hide();
                $("#FAQ_CTT").ckeditor();
                $("#BLTN_DT").val(getCurrdate());
                $("#BLTNR_NM").val($.PSNM.getSession("USER_NM"));
            }
        },
        setEventListener : function() {
            $("#btnSave").click(function(){
            	var validator = $("#form").validator();
            	
            	if(!validator.validate()){
            		var errormessages = validator.getErrorMessage();
                    for(var name in errormessages) {
                    	alert(errormessages[name]);
                    	$("#"+name).focus();
                        return;
                    }
            	}
            	
            	if( $.PSNM.confirm("I004", ["저장"] ) ){
            		var requestData = $.PSNMUtils.getRequestData("form", "gridfile");
                	
                	$.alopex.request("com.FAQMGMT@PFAQMGMT001_pSaveFaq", {
                        data: requestData,
                        success: function(res) { 
                            $a.navigate("faqMgmt.jsp", _param);
                        }
                    });
            	}
            });
            $("#btnList").click(function(){
            	$a.back(_param);
            });
            $("#btnDel").click(function(){
            	if( $.PSNM.confirm("I004", ["삭제"] ) ){
            		$("#gridfile").alopexGrid("dataEdit", {"FLAG":"D"});
            		var requestData = $.PSNMUtils.getRequestData("form", "gridfile");
                	$.alopex.request("com.FAQMGMT@PFAQMGMT001_pDelFaq", {
                		data: requestData,
                        success : function(res) {
                        	$a.navigate("faqMgmt.jsp", _param);
                        }
                    });
            	}
            });
            $("#btnFileDel").click(function(){
            	$.PSNMUtils.delFile();
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
                    console.log("<faqEditForm> 조회성공 FAQ_ID = " + JSON.stringify(res));
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
            <!-- <button id="btnInit" type="button" data-type="button" data-theme="af-psnm0"  data-altname="초기화" style="padding-bottom:3px !important; padding-left:18px !important;">초기화</button> -->
            <button id="btnSave" type="button" data-type="button" data-theme="af-btn4"  data-altname="저장"></button>
            <button id="btnDel"  type="button" data-type="button" data-theme="af-btn13" data-altname="삭제"></button>
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
			                <th scope="col" class="fontred">제목</th>
			                <td class="tleft">
			                    <input id="FAQ_TITL_NM" name="FAQ_TITL_NM" data-bind="value:FAQ_TITL_NM" data-type="textinput" 
			                           data-validation-rule="{required:true}" 
			                           data-validation-message="{required:'제목을 입력해 주세요.'}" style="width:95%">
			                </td>
			                <th scope="col" class="fontred">FAQ유형</th>
			                <td class="tleft">
			                    <select id="FAQ_TYP_CD" data-bind="options: options_FAQ_TYP_CD, selectedOptions: FAQ_TYP_CD" data-type="select" data-wrap="true"
			                    	   	data-validation-rule="{required:true}" 
			                           	data-validation-message="{required:'FAQ유형을 선택해 주세요.'}"></select>
			                </td>
			            </tr>
			            <tr>
			            	<th scope="col">작성자</th>
			                <td class="tleft">
			                    <input id="BLTNR_NM" name="BLTNR_NM" data-type="textinput" data-bind="value:BLTNR_NM" style="width:120px" data-disabled="true"/>
			                </td>
			                <th scope="col">작성일자</th>
			                <td class="tleft time">
			                    <input id="BLTN_DT" name="BLTN_DT" data-type="dateinput" data-bind="value:BLTN_DT" data-disabled="true" style="width:100px;"/>
			                </td>
			            </tr>
			            <tr>
			                <td colspan="4" class="tleft">
			                    <textarea id="FAQ_CTT" name="FAQ_CTT" data-type="textarea" data-bind="value:FAQ_CTT" rows="10" cols="80" 
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