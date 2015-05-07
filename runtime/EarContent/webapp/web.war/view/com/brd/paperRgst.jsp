<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<style>
</style>
    <jsp:include page="/view/layouts/default_head.jsp" flush="false" />

    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/vendor/jquery.ui.widget.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/jquery.iframe-transport.js"></script>
    <script type="text/javascript" src="<c:out value='${pageContext.request.contextPath}'/>/script/lib/jQuery-File-Upload-9.8.0/js/jquery.fileupload.js"></script>
    <script type="text/javascript">
    var _mode = "";
    var _param;
    var add = "";
    
    $.alopex.page({
        init : function(id, param) { 
            $.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출

            _param = null; //이 페이지로 전달된 파라미터를 저장

            $a.page.setEventListener(); //페이지내 버튼에 이벤트 핸들러 매핑

            $a.page.setFileUpload();
            $a.page.setValidators();
        },
        setEventListener : function() {
            $("#btnSend").click( SendPaper );
            $("#btnChart").click( ChartView );
        }, //end-of-setEventListener
        setFileUpload : function () {
            $.PSNMUtils.setFileUploadAndGrid("PAP", "#fileupload", "#gridfile");
        },
        setValidators : function() {
            $('#RCV_USER_ID').validator({
                rule : { required: true },
                message: {
                    required: $.PSNM.msg('E011', ["받는사람에 선택된"]) //{0} 데이터가 없습니다!
                }
            });
            $('#CONTENT').validator({
                rule : { required: true },
                message: {
                    required: $.PSNM.msg('E012', ["내용"]) //{0} 항목은 필수값입니다!
                }
            });
        }
        
        
        
    });

     function SendPaper() {
        console.log("<저장> 시작 ... _mode = %s", _mode);
        if ( !$.PSNM.isValid("form") ) {
            return false;
        }

        //폼과 첨부파일 그리드 모두 합쳐 request 데이터를 생성함. 그리드가 1개이상 가능함.
        var requestData = $.PSNMUtils.getRequestData("form", "gridfile");

        console.log("<저장> requestData --------------------\n\n" + JSON.stringify(requestData));
        $.alopex.request('com.PAPER@PPAPERMGMT001_pInsertPaper', {
            data: requestData,
            success: function(res) { 
                console.log("<저장> 원래 전달되었던 파라미터 ---\n\n" + JSON.stringify(_param));
                $a.navigate("sndPaper.jsp", _param);
            }
        });
    }  
    
    function ChartView() {
        $a.popup({
            url: "/view/com/brd/paperRcvSelPopup.jsp"
          , data: {}
          , width: 900
          , height: 700
          , windowpopup: false
          , iframe: true
          , title: "조직도"
          , callback : function(data) {
                memberView(data);
                $("#TITLE").focus();
          }
        });
    }  
    function closeConfirm(oReturn) {
        $a.close(oReturn);
    }    
    function memberView(param){
        var htm    ="";
        var dataID   ="";
        var dataNM ="";

        for(var i=0; i< param.length; i++){
            dataID = param[i][0]; //유저아이디
            dataNM = param[i][1]; //유저이름
            htm  += dataNM ;
            add += dataID+",";
            htm  +="&nbsp;";
        }
        
        $("#sname").append(htm);
        $("#RCV_USER_ID").val(add);
    }
    
    </script>

</head>

<body>
    <jsp:include page="/view/layouts/default_header.jsp" flush="false" />

<div id="contents">
    
    <!-- title area -->
    <div class="content_title">
        <div class="ub_txt6">
            <span class="txt6_img"><b>쪽지 쓰기</b><span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif"> 
            <span class="a2">커뮤니티</span> <span class="a3"> > </span><b>쪽지함</b></span></span> 
        </div>
    </div>

    <!-- btn area -->
    <div class="btn_area">
        <div class="ab_btn_right">
        <button id="btnSend" type="button" data-type="button" data-theme="af-n-btn13" data-authtype="R" data-altname="보내기" class="af-button af-n-btn13" data-converted="true"></button>
        </div>
    </div>
    <!-- btn area end--> 
    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>쪽지내용</b></div>

    <!--view_table area -->
    <div class="view_list">
        <form id="form">
            <table class="board02" width="100%" >
            <tr>
                <th scope="col" style="width:100px;">제목</th>
                <td colspan="5" class="tleft">
                    <input id="TITLE" name="TITLE" data-bind="value:TITLE" data-type="textinput" 
                           data-validation-rule="{required:true, minlength:5}" 
                           data-validation-message="{required:'반드시 입력하세요!', minlength:'5글자 이상 입력하세요!'}" style="width:95%" value="">
                </td>
            </tr>
            <tr>
                 <th scope="col" style="width:100px;">받는사람</th>
                <td colspan="4" class="tleft" width="90%">
                    <span id="sname"></span>
                    <input id="RCV_USER_ID" name="RCV_USER_ID" type="hidden" >
                    <button id="btnChart" type="button" data-type="button" data-theme="af-n-btn14"  data-authtype="R" data-altname="조직도" class="af-button af-n-btn14" style="text-align: right" data-converted="true"></button>    
                </td>
            </tr> 
            <tr>
                <td colspan="6" class="tleft">
                    <textarea id="CONTENT" data-type="textarea"  rows="10" cols="30" 
                              style='overflow: auto; width: 98%;/*  height: 350px; */'></textarea>
                </td>
            </tr>
            </table>
        </form>
    </div>

    <!--view_list area -->
    <div class="floatL4"> 
        <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>첨부파일</b>
        <div class="ab_pos1">
            <div style="position:relative;">
                <span class="file-button type1"><input id="fileupload" type="file"></span>
                <button id="btnFileDel" data-type="button" class="af-n-btn5"></button>
            </div>
        </div>
    </div>
    <div id="gridfile" class="view_list" data-bind="grid:gridfile" data-ui="ds"></div>

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>
