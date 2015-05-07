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
            
            $a.page.setViewData();

            $a.page.setEventListener();
            $a.page.setFileUpload();
            $a.page.setCodeData(); //공통코드 호출
            $a.page.setGridauthgrp();
            $a.page.setGridauthorg();
            $a.page.setValidators();
        },

        setCodeData : function() {
        	
        	var id = _param.data != null ? _param.data.BIZ_ID : "";
	
        	if($.PSNMUtils.isNotEmpty(id)){
               
        		$.PSNMUtils.setCodeData([
                                         { t:'org2',  'elemid' : 'HDQT_PART_ORG_ID', 'header' : '-선택-' }
                                        ,{ t:'org3',  'elemid' : 'SALE_DEPT_ORG_ID', 'codeid': _param.data.HDQT_PART_ORG_ID, 'header' : '-선택-' }
                                     ]);
                                     $("#HDQT_PART_ORG_ID").val(_param.data.HDQT_PART_ORG_ID); //본사파트 설정(선택)
                                     $("#SALE_DEPT_ORG_ID").val(_param.data.BIZ_TYP_CD); //영업국 설정(선택)
                                 		 
        	}else{
        		$.PSNMUtils.setCodeData([
                                         { t:'org2',  'elemid' : 'HDQT_PART_ORG_ID', 'header' : '-선택-' }
                ])
        	}
           
        },  
        setValidators : function() {
            $('#BIZ_TITL_NM').validator({
                rule : { required: true },
                message: {
                    required: $.PSNM.msg('E012', ["제목"]) //{0} 데이터가 없습니다!
                }
            });
            $('#HDQT_PART_ORG_ID').validator({
                rule : { required: true },
                message: {
                    required: $.PSNM.msg('E012', ["본사파트"]) //{0} 항목은 필수값입니다!
                }
            });
            $('#SALE_DEPT_ORG_ID').validator({
                rule : { required: true },
                message: {
                    required: $.PSNM.msg('E012', ["영업국"]) //{0} 항목은 필수값입니다!
                }
            });
        },
        
        setEventListener : function() {
            //저장버튼
            $("#btnSave").click(function(){
                if ( ! $.PSNM.isValid("#form") ) {
                    return false; //값 검증
                }
                if( $.PSNM.confirm("I004", ["저장"] ) ){
                    var requestData = $.PSNMUtils.getRequestData("form", "gridauthgrp", "gridauthorg", "gridfile");
                
                    $.alopex.request("biz.BIZTRGT@PBIZTRGT001_pSaveBizTrgt", {//pu -> 저장주소 바꾸고
                        data: requestData,
                        success: function(res) { 
                            $a.navigate("bizMgmtList.jsp", _param);           //JSP 불러오는곳 바꾸고
                        }
                    });
                }
            });
            //목록버튼
            $("#btnList").click(function(){
                $a.back(_param);
            });
            //취소버튼
            $("#btnCancel").click(function(){
                $a.back(_param);
            });
            //삭제버튼
            $("#btnDel").click(function(){
                if( $.PSNM.confirm("I004", ["삭제"] ) ){
                    var id = _param.data != null ? _param.data.BIZ_ID : "";
                    $.alopex.request("biz.BIZTRGT@PBIZTRGT001_pDeleteBizTrgt", {//삭제하는 주소로 바꾸고
                        data: {dataSet: {fields: {BIZ_ID : id}}}, 
                        success : function(res) {
                            $a.navigate("bizMgmtList.jsp", _param);

                        }
                    });
                }
            });
            //파일삭제버튼  
            $("#btnFileDel").click(function(){
            	$.PSNMUtils.delFile();
            });
            //조직그룹추가
            $("#btnAddAuthGrp").click(function(){
            	$.PSNMAction.popFindAuthGrp(function(data) {
                    if (null!=data && data.length>0) {
                        for(var i=0; i<data.length; i++) {
                            var authGrpId = data[i]["AUTH_GRP_ID"];
                            var arr = $("#gridauthgrp").alopexGrid('dataGet', {AUTH_GRP_ID: authGrpId});
                            if (arr.length>0) {
                            }else {
                                data[i]["FLAG"] = "I";
                                $("#gridauthgrp").alopexGrid("dataAdd", data[i]);
                            }
                        }
                    }
                });
            });
            //조직그룹 삭제
            $("#btnDelAuthGrp").click(function(){
                var oRecord = $("#gridauthgrp").alopexGrid( "dataGet" , { _state : { selected : true } } );
                if(oRecord.length == 0){
                    $.PSNM.alert("삭제할 행을 선택해 주십시오.");
                    return;
                }
                // 시스템관리자일 경우 삭제 안됨
                var result = true;
                $.each(oRecord, function(index, val){
                    if(val.AUTH_GRP_ID=="99"){
                        result = false;
                    }
                });
                if(result){
                    $("#gridauthgrp").alopexGrid("dataDelete", {_state:{selected:true}});
                }else{
                    $.PSNM.alert("시스템관리자권한은 삭제할 수 없습니다.");
                    return;
                }
            });
            //본사파트 추가
            $("#btnAddSaleDept").click(function(){
                //'본사파트 찾기' 팝업창을 오픈하고, 선택된 데이터를 처리함
                $.PSNMAction.popFindHdqtPart(function(data) {
                    if (null!=data && data.length>0) {
                        for(var i=0; i<data.length; i++) {
                            var hdqtPartOrgId = data[i]["HDQT_PART_ORG_ID"];
                            var arr = $("#gridauthorg").alopexGrid('dataGet', {HDQT_PART_ORG_ID: hdqtPartOrgId});
                            if (arr.length>0) {
                            }else {
                                data[i]["FLAG"] = "I";
                                $("#gridauthorg").alopexGrid("dataAdd", data[i]);
                            }
                        }
                    }
                });
            });
            //본사파트 삭제
            $("#btnDelSaleDept").click(function(){
                var oRecord = $("#gridauthorg").alopexGrid( "dataGet" , { _state : { selected : true } } );
                if(oRecord.length == 0){
                    $.PSNM.alert("삭제할 행을 선택해 주십시오.");
                    return;
                }
                $("#gridauthorg").alopexGrid("dataDelete", {_state:{selected:true}});
            });
            
        },
        setFileUpload : function () {
            $.PSNMUtils.setFileUploadAndGrid("BIZ", "#fileupload", "#gridfile");
        },
        setGridauthgrp : function () {
            $("#gridauthgrp").alopexGrid({
                pager : false,
                height : "200px",
                columnMapping : [
                    { columnIndex : 0, selectorColumn : true, width : "20px" },
                    { columnIndex : 1, key : "AUTH_GRP_ID",     title : "권한그룹ID",        align : "center", width : "100px" },
                    { columnIndex : 2, key : "AUTH_GRP_NM",     title : "권한그룹명",        align : "center", width : "100px" },
                    { columnIndex : 3, key : "AUTH_GRP_DESC",   title : "권한그룹설명",      align : "center", width : "100px" }
                ]                                                                            
            });                                                                              
        },                                                                                   
        setGridauthorg : function () {                                                       
            $("#gridauthorg").alopexGrid({                                                   
                pager : false,                                                               
                height : "200px",                                                            
                columnMapping : [                                                            
                    { columnIndex : 0, selectorColumn : true, width : "20px" },              
                    { columnIndex : 1, key : "HDQT_PART_ORG_ID",     title : "본사파트ID",   align : "center", width : "100px" },
                    { columnIndex : 2, key : "HDQT_PART_ORG_NM",     title : "본사파트명",   align : "center", width : "100px" }
                ]                                                                            
            });
        },
       setViewData : function() {
            
        	var id = _param.data != null ? _param.data.BIZ_ID : "";

        	if($.PSNMUtils.isNotEmpty(id)){
 
        	}else{
        		$("#RGSTR_NM").val($.PSNM.getSession("USER_NM"));
        		$("#RGSTR_DT").val(getCurrdate());
        		$("#btnDel").hide();
        	}
        	
            $.alopex.request("biz.BIZTRGT@PBIZTRGT001_pDetailBizTrgt", {
                data: {dataSet: {fields: {BIZ_ID : id}}},
                success:["#form",  function(res) {
				
					
					$("#BIZ_CTT").ckeditor();

                    var gridList = res.dataSet.recordSets;
                    
                    $.each(gridList, function(key, data) {
                        $("#"+key).alopexGrid("dataSet", data.nc_list);
                    });
                }]
            });
        },
    });
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
            <button id="btnDel" type="button" data-type="button" data-theme="af-btn13" data-altname="삭제" data-authtype="W"></button>
            <button id="btnCancel" type="button" data-type="button" data-theme="af-btn10" data-altname="취소" data-authtype="R"></button>
            <button id="btnSave" type="button" data-type="button" data-theme="af-btn4"  data-altname="저장" data-authtype="W"></button>
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
                            <td class="tleft" colspan="3">
                                <input id="BIZ_TITL_NM" name="BIZ_TITL_NM" data-bind="value:BIZ_TITL_NM" data-type="textinput" style="width:95%">
                            </td>
                        </tr>
                        <tr>
                            <th scope="col">본사파트</th>
                            <td class="tleft">
								<select id="HDQT_PART_ORG_ID" data-type="select" data-bind="options:options_HDQT_PART_ORG_ID, selectedOptions:HDQT_PART_ORG_ID" data-wrap="false" style="width:185px!important">
                                </select>
                            </td>
                        
		                    <th scope="col">영업국명</th>
                            <td class="tleft">
								<select id="SALE_DEPT_ORG_ID" data-type="select" data-bind="options:options_SALE_DEPT_ORG_ID, selectedOptions:SALE_DEPT_ORG_ID" data-wrap="false" style="width:185px!important">
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <th scope="col">작성자</th>
                            <td class="tleft">
                                <input id="RGSTR_NM" name="RGSTR_NM" data-type="textinput" data-bind="value:RGSTR_NM" style="width:120px" data-disabled=true data-theme="af-textinput"/>
                            </td>
                            <th scope="col">작성일자</th>
                            <td class="tleft time">
                                <input id="RGSTR_DT" name="RGSTR_DT" data-type="dateinput" data-bind="value:RGSTR_DT" style="width:100px;" data-disabled=true data-theme="af-textinput"/>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="4" class="tleft">
		                    <textarea id="BIZ_CTT" name="BIZ_CTT" data-type="textarea" data-bind="value:BIZ_CTT" rows="10" cols="80" 
	                              data-validation-rule="{required:true}" 
	                              data-validation-message="{required:$.PSNM.msg('E012', ['내용'])}" 
	                              style='overflow: auto; width: 100%;'></textarea>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <!--view_list area -->
            <div class="floatL4"> 
                <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>첨부파일</b>
                <div class="ab_pos1" style="float:right;">
                    <div style="position:relative;">
                        <span class="file-button type1"><input id="fileupload" type="file"></span>
                        <button id="btnFileDel" data-type="button" class="af-n-btn5"></button>
                    </div>
                </div>
            </div>
            <div id="gridfile" class="view_list" data-bind="grid:gridfile"></div>
            
            <div class="psnm-section">
                <div class="psnm-secleft">
                    <div class="floatL4" style="clear:both;"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>공지할그룹</b>
                        <p class="ab_pos1">
                            <input id="btnAddAuthGrp" type="button" data-type="button" class="psnm-sbtn-add" />
                                    <input id="btnDelAuthGrp" type="button" data-type="button" class="psnm-sbtn-del" />
                        </p>
                    </div>
                    <!-- 왼쪽 그리드1 -->
                    <div id="gridauthgrp" data-bind="grid:gridauthgrp"></div>
                </div>
                
                <div class="psnm-secright">
                    <div class="floatL4" style="clear:both;"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>공지할본사파트</b>
                        <p class="ab_pos1">
                            <input id="btnAddSaleDept" type="button" data-type="button" class="psnm-sbtn-add" />
                            <input id="btnDelSaleDept" type="button" data-type="button" class="psnm-sbtn-del" />
                        </p>
                    </div>
                    <!-- 오른쪽 그리드1 -->
                    <div id="gridauthorg" data-bind="grid:gridauthorg"></div>
                </div>
            </div>
        </form>
	</div>
</div>
<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />
</body>
</html>