<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

    <jsp:include page="/view/layouts/default_head.jsp" flush="false" />

    <script type="text/javascript">
    
    $.alopex.page({

        init : function(id, param) { 
            $.PSNM.initialize(id, param); //PSNM공통 초기화함수 호출
            
            /* $.PSNMUtils.setDefaultYmd("#FROM_DT", "TO_DT"); */
            $a.page.setEventListener();
            $a.page.setGrid(); 
            $a.page.setCodeData();
            $("#searchTable").setData(param);  //(설명) 상세페이지에서 돌아오는 경우, 이 값들이 세션스토리지에서 반환됨.
			$a.page.searchList(param);
        },
        setEventListener : function() {
        	$("#btnSearch").click($a.page.searchList);
        	$("#btnNew").click(function(){
            	var param = $('#searchTable').getData();
                param["page_size"] = $('#grid').alopexGrid('pageInfo').perPage;
    	        try { 
    	            param["page"]  = $("#grid").alopexGrid("pageInfo").customPaging.current; 
    	        } catch(E) {
    	            param["page"]  = 1; //디폴트 1페이지
    	        }
    	        
    	        param["data"]  = ["FAQ_ID", ""];
    	        //_debug("<gotoNew> param : " + JSON.stringify(param));
            	$a.navigate("faqEditForm.jsp", param);
            });
        	$("#btnExcelAll").click(function(){
            	var oExcelMetaInfo = {
                        filename  : "FAQ관리.xls",
                        sheetname : "FAQ관리",
                        gridname  : "grid"
                    };
        		var txid = "com.FAQMGMT@PFAQMGMT001_pSearchFaq";

        		$.PSNMUtils.downloadExcelAll("searchForm", txid, "grid", oExcelMetaInfo, [2]);
            });
            
        },
        setGrid : function() {
        	$("#grid").alopexGrid({
                rowClickSelect : false,
                rowInlineEdit : true,
                columnMapping : [
					{ columnIndex : 0, key : "FAQ_ID",          title : "FAQ ID",		align : "center", 	width : "60px" },
                    { columnIndex : 1, key : "FAQ_TYP_NM",      title : "FAQ 유형",	 	align : "center", 	width : "100px" },
                    { columnIndex : 2, key : "FAQ_TYP_CD",  	title : "FAQ 코드",		hidden : true },
                    { columnIndex : 3, key : "FAQ_TITL_NM",  	title : "제목",			align : "left", 	width : "430px" },                    
                    { columnIndex : 4, key : "VIEW_CNT",    	title : "조회수",		align : "center", 	width : "60px"  },
                    { columnIndex : 5, key : "ATCH_YN", 		title : "첨부파일",		align : "center", 	width : "70px"	},
                    { columnIndex : 6, key : "BLTNR_NM", 		title : "게시자",		align : "center", 	width : "80px"	},
                    { columnIndex : 7, key : "BLTN_DT", 		title : "게시일",		align : "center", 	width : "80px"	}                   
                ],
                on : {
                	pageSet : function(pageNoToGo) {
                        var p = {};
                            p.page = pageNoToGo;
                            $a.page.searchList(p);
                    },
                    "cell" : {
    					"click" : function(data, eh, e) {
    						if(data._index.column != 0) {
    							
    							var p = $("#searchTable").getData({selectOptions:true});
    							p["data"] = data;
    							
    							/* if( data._key == "TOTAL" ) { 
    			            		$a.popup({
    			                        url: "salePlcyStcList.jsp",
    			                        data: param,
    			                        title : "영업국별/일별 접속현황",
    			                        width: 1000,
    			                        height: 700,
    			                        iframe: true,
    			                        windowpopup: false
    			                    });
    			            	}else{ */
    								p["page"]      = $("#grid").alopexGrid("pageInfo").customPaging.current;
    				            	p["page_size"] = $("#grid").alopexGrid("pageInfo").perPage;
    				            	//_debug("<gotoNew> param : " + JSON.stringify(param));
    			            		$a.navigate("faqEditForm.jsp", p);
    			            	/* } */
    						}
    					}
    				}
                }
            });
        },
        setCodeData : function() {
            $.PSNMUtils.setCodeData([
				 //{ t:'code', 'elemid' : 'FAQ_TYP_CD', 'codeid' : 'DSM_FAQ_TYP_CD', 'header' : '-전체-' }
				 { t:'code', 'elemid' : 'FAQ_TYP_CD', 'header' : '-전체-' }
            ]);
        },
        searchList: function(param) {
        	var _page_no = 1;
            if ( $.PSNMUtils.isNotEmpty(param) && $.PSNMUtils.isNotEmpty(param.page) ) {
                _page_no = param.page;
            }
            var _per_page = $("#grid").alopexGrid("pageInfo").perPage;
            
            $.alopex.request("com.FAQMGMT@PFAQMGMT001_pSearchFaq", {
                data: ["#searchTable", function() {
                	/* this.data.dataSet.fields.FROM_DT   = $.PSNMUtils.getDateInput("FROM_DT"); */
                	/* this.data.dataSet.fields.TO_DT     = $.PSNMUtils.getDateInput("TO_DT"); */
                    this.data.dataSet.fields.page      = _page_no;
                    this.data.dataSet.fields.page_size = _per_page;
                }],
                success: ["#grid", function(res) {}]
            });
        }
    });
    
    
    </script>

</head>

<body>

<jsp:include page="/view/layouts/default_header.jsp" flush="false" />

<div id="contents">

    <!-- sub title area -->
    <div id="lay_out">
        <div id="ub_txt6">
            <span class="txt6_img"><b id="sub-title">FAQ관리</b>
                <span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif">
                <span class="a2">나의 D-tok</span> <span class="a3"> > </span> <span class="a4"><b>FAQ관리</b></span> 
            </span>
        </div>
    </div>

    <!-- find condition area -->
    <div id="searchDiv" class="textAR">
		<form id="searchForm">
        	<table id="searchTable" class="board02" style="width:92%;">
        	<colgroup>
	            <col style="width:100px;"/>
	            <col style="*"/>
	            <col style="width:100px;"/>
	            <col style="*"/>
            </colgroup>
        	<tbody>
        	<tr>
                <th>FAQ유형</th>
				<td class="tleft">
                    <select id="FAQ_TYP_CD" data-bind="options:options_FAQ_TYP_CD, selectedOptions:FAQ_TYP_CD" data-type="select" data-wrap="true"></select>
                </td>
				<th>게시자</th>
				<td class="tleft">
                    <!-- <select id="BLTNR_NM" data-bind="options: options_BLTNR_NM, selectedOptions: BLTNR_NM" data-type="select" data-wrap="true" data-placeholder="-전체-"></select> -->
                    <input id="BLTNR_NM" name="BLTNR_NM" data-type="textinput" data-bind="value:BLTNR_NM" style="width:120px"/>
                </td>
            </tr>
        	</tbody>
            </table>
        </form>
		<div class="ab_pos5">
			<button id="btnSearch" data-type="button" data-theme="af-psnm"></button>
		</div>
    </div>

    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>FAQ목록</b>
        <p class="ab_pos2">
        	<button id="btnExcelAll" data-type="button" data-theme="af-btn3" data-altname="엑셀다운"></button>
            <button id="btnNew" data-type="button" data-theme="af-btn2" data-altname="신규"></button>
        </p>
    </div>

    <!-- main grid -->
    <div id="grid" data-bind="grid"></div>

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>