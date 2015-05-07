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
            
            $a.page.setEventListener(param);
            $a.page.setFileUpload();

            pSearchSndPaperDtl(param);
        },
        setEventListener : function(param) {
            $("#btnList").click(function(){
                $a.back(_param); // param 값이 넘어가면서 back 해줌. 
            });
            $("#btnDel").click(function(){
                if( $.PSNM.confirm("I004", ["삭제"] ) ){
                $.alopex.request("com.PAPER@PPAPERMGMT001_pDeletePaper", {
                    data:   {
                            dataSet: 
                                {fields: 
                                    {PAPER_ID :param.PAPER_ID}
                                }
                            },
                    success:[function(res) {
                        $a.navigate("sndPaper.jsp"); 
                    }]
                });
                }
            });
        },  
        setFileUpload : function () {
            $.PSNMUtils.setFileUploadAndGrid("PAP", "#fileupload", "#gridfile"); 
        }
    });

    function pSearchSndPaperDtl(param) {
        if (null==param || undefined==param) {
            return;
        }
        $.alopex.request("com.PAPER@PPAPERMGMT001_pSearchSndPaperDtl", {
            data:   {
                dataSet:{
                    fields: {
                            PAPER_ID :param.PAPER_ID , ATCH_FILE_YN :param.ATCH_FILE_YN
                            }
                        }
                    },
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
            <span class="txt6_img"><b>보낸쪽지</b><span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif"> 
            <span class="a2">커뮤니티</span> <span class="a3"> > </span><b>쪽지함</b></span></span> 
        </div>
    </div>

    <!-- btn area -->
    <div class="btn_area">
        <div class="ab_btn_right">
            <button id="btnList" type="button" data-type="button" data-theme="af-btn14" data-altname="목록" data-authtype="R"></button>
            <button type="button" id="btnDel" data-type="button" data-theme="af-btn13" data-authtype="R" data-altname="삭제"></button>
        </div>
    </div>
    <!-- btn area end--> 

    <!--view_list area -->
    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>쪽지내용</b></div>

    <!--view_table area -->
    <div class="view_list">

        <form id="form" onsubmit="return false;">
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
                    <td colspan="3" class="tleft"><label data-bind="text:TITLE"></label></td>
                </tr>
                <tr>
                    <th scope="col">받는 사람</th>
                    <td class="tleft time"><label data-bind="text:SND_USER_NM"></label></td>
                    <th scope="col">보낸 시간</th>
                    <td class="tleft"><label data-bind="text:RGST_DT"></label></td>
                </tr>
                <tr>
                    <td colspan="4" class="tleft" style="word-break:break-all;"><label data-bind="html:CONTENT"></label></td>
                </tr>
            </tbody>
            </table>
        </form>
    </div>

    <!--view_list area -->
    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>첨부파일</b></div>
    <div id="gridfile" class="view_list" data-bind="grid:gridfile"></div><!--  이거는 파일처리 하는 공간 .. 다음주에 확인!  -->
</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>