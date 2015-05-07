<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
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
    _LOG_LEVEL = 0; //로그레벨 :: 0=debug, 1=info, 2=error

    var _TX_SEARCH	= "biz.MAINSCHD@PSCHMGMT001_pSearchSchMgmtBrws";
    var _param;
    
    $.alopex.page({
        init : function(id, param) { 
			$.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출
			
			_param = param;
			
			$a.page.setEventListener(); //버튼 초기화
			$a.page.setGrid(); //그리드 초기화
			$("#searchForm").setData(param);
			
			if(param.SEARCH_DT==null){
            	var today = new Date();
                var Day = today.getFullYear()+"-"+((today.getMonth()+1)<10?"0"+(today.getMonth()+1):(today.getMonth()+1)); //현재 년/월
           		$("#SEARCH_DT").val(Day);
           }
			$a.page.searchList(param);
			
			if(_param.tabindex != null){
				$("#tabs").setTabIndex(_param.tabindex);	
			}
			
        },
        setEventListener : function() {
			$("#btnSearch").click($a.page.searchList);//조회
        }, 
        setGrid : function() {
            $("#grid").alopexGrid({
                rowClickSelect : false,
                //rowInlineEdit : true,
                columnMapping : [

                    { columnIndex : 0, key  : "SCH_DT",			title : "일정",			align : "center", 	width : "20%" },
                    { columnIndex : 1, key  : "SCH_TITL_NM",	title : "제목",			align : "left",  	width : "45%" },
                    { columnIndex : 2, key  : "VIEW_CNT",		title : "조회수",		align : "center",	width : "10%" },
                    { columnIndex : 3, key  : "BLTNR_NM",		title : "게시자",		align : "center", 	width : "10%" },
                    { columnIndex : 4, key  : "BLTN_DT",		title : "게시일",		align : "center", 	width : "15%" }
                    
                ],
                on : {
                	pageSet : function(pageNoToGo) {
                        var p = {};
                            p.page = pageNoToGo;
                            $a.page.searchList(p);
                    },
                    "cell" : {
    					"click" : function(data, eh, e) {
    							
   							var param = $("#searchForm").getData({});
   							param["tabindex"]	 =	$("#tabs").getCurrentTabIndex();
							param["SCH_ID"]      =	data.SCH_ID;
							param["page"]     	 =	$("#grid").alopexGrid("pageInfo").customPaging.current; //
							param["page_size"]	 =	$("#grid").alopexGrid("pageInfo").perPage;
   			            	$a.navigate("mainSchdDtl.jsp", param);
    					}
    				}
                }
            });
        },
         searchList : function(param){
			var _page_no = 1;
			if ( $.PSNMUtils.isNotEmpty(param) && $.PSNMUtils.isNotEmpty(param.page) ) {
				_page_no = param.page; //(설명) 페이지 이동할때만 페이지번호가 넘어옴.
            }
            var _per_page = $('#grid').alopexGrid('pageInfo').perPage;
            
            //$("#calendardata").empty();
            
            $.alopex.request(_TX_SEARCH, {
				data : ["#searchForm", function(){
					this.data.dataSet.fields.SEARCH_DT	=	$.PSNMUtils.getDateInput("SEARCH_DT");
					this.data.dataSet.fields.page		=	_page_no;
					this.data.dataSet.fields.page_size	=	_per_page;
				}],
				success: ["#grid", function(res) {
				} ]
            });
        }
    });
    function goDetail(param){
    	$a.popup({
			url				:	 "/view/biz/mainschd/mainSchdCldrDtl.jsp"
			, data			:	 { SCH_ID : param ,popli : false }
			, width			:	 900
			, height		:	 700
			, windowpopup	:	 false
			, iframe		:	 true
			, title			:	 "주요일정상세"
        });
    }
    function goList(param){
    	$a.popup({
			url				:	 "/view/biz/mainschd/mainSchdCldrListPopup.jsp"
			, data			: 	{ SCH_DT : param.slice(0, 4)+"-"+param.slice(4, 9) }
			, width			: 	900
			, height		: 	700
			, windowpopup	: 	false
			, iframe		: 	true
			, title			: 	"일정상세"
        });
    }
    </script>
</head>
<body>
	<!-- title area -->
<div id="contents">
	<div id="grid" data-bind="grid:grid"></div>
</div>
</body>
</html>