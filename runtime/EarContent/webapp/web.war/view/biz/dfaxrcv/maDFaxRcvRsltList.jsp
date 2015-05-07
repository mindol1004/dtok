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

            $.PSNMUtils.setDefaultYmd("#FROM_DT", "TO_DT");
            $a.page.setEventListener();
            $a.page.setGrid();
            $a.page.setCodeData();
            
          	//MA가 아니면 조회 불가.
    		if($.PSNM.getSession("DUTY") != '15' && $.PSNM.getSession("DUTY") != '17' && $.PSNM.getSession("DUTY") != '18'){
    			$("#btnSearch").hide();
    		}
        },
        setEventListener : function() {
        	$("#btnSearch").click($a.page.searchList);
        	$("#btnExcelAll").click(function(){
            	var oExcelMetaInfo = {
                        filename  : "접수현황(D_FAX).xls",
                        sheetname : "접수현황(D_FAX)",
                        gridname  : "griddfaxrcv" //그리드ID 
                    };
        		var txid = "biz.DFAXRCV@PFAXRCV001_pSearchFaxRcv";

        		$.PSNMUtils.downloadExcelAll("searchForm", txid, "griddfaxrcv", oExcelMetaInfo);
            });
        },
        setGrid : function() {
            $("#griddfaxrcv").alopexGrid({
                rowClickSelect : false,
                rowInlineEdit : true,
                columnMapping : [
                    { columnIndex : 0, key : "RCV_DTM",            	title : "수신일시",		align : "center", 	width : "120px" },
                    { columnIndex : 1, key : "SND_FAX_NUM",  		title : "From",			align : "center", 	width : "75px"  },
                    { columnIndex : 2, key : "FAX_FILE_PG",    		title : "페이지수",		align : "center", 	width : "50px" 	},
                    { columnIndex : 3, key : "RCV_FAX_NUM", 		title : "수신팩스번호",	align : "center", 	width : "75px"	},
                    { columnIndex : 4, key : "FAX_UNIT_TYP_NM",     title : "상품유형",		align : "center", 	width : "70px" 	},
                    { columnIndex : 5, key : "FAX_SCRB_TYP_NM", 	title : "가입유형",		align : "center", 	width : "60px"	},
                    { columnIndex : 6, key : "PROD_ABBR_NM", 		title : "상품약어명",		align : "center", 	width : "80px"	},
                    { columnIndex : 7, key : "CUST_NM", 			title : "고객명",		align : "center", 	width : "55px"	},
                    { columnIndex : 8, key : "HDQT_PART_ORG_NM", 	title : "본사파트",		align : "center", 	width : "80px"	},
                    { columnIndex : 9, key : "SALE_DEPT_ORG_NM", 	title : "영업국명",		align : "center", 	width : "80px"	},
                    { columnIndex : 10, key : "SALE_TEAM_ORG_NM", 	title : "영업팀명",		align : "center", 	width : "70px"	},
                    { columnIndex : 11, key : "AGNT_ID",			title : "에이전트코",		align : "center", 	width : "75px"	},
                    { columnIndex : 12, key : "AGNT_NM", 			title : "에이전트명",		align : "center", 	width : "100px"	},
                    { columnIndex : 13, key : "OPR_NM", 			title : "담당자명",		align : "center", 	width : "55px"	},
                    { columnIndex : 14, key : "FAX_OP_ST_NM", 		title : "처리현황",		align : "center", 	width : "50px"	},
                    { columnIndex : 15, key : "MEMO", 				title : "메모",			align : "left", 	width : "200px"	},
                    { columnIndex : 16, key : "CNSNT_MEMO", 		title : "동의",			align : "center", 	width : "90px"	}
                ],
                on : {
                    pageSet : function(pageNoToGo) {
                    	var p = {};
	                        p.page = pageNoToGo;
	                        $a.page.searchList(p);
                    }
                }
            });
        },
        setCodeData : function() {
            $.PSNMUtils.setCodeData([
                { t:'code',  'elemid' : 'FAX_OP_ST_CD', 'codeid' : 'DSM_FAX_OP_ST_CD', 'header' : '-전체-' }
            ]);
        },
        searchList: function(param) {
        	
        	//전월 이전 자료는 조회 불가
    		var strdDt = getAddMonthDate(0,'yyyymm')+'-'+'01';
    		if($("#FROM_DT").val() < strdDt){
    			$.PSNM.alert('전월 1일 이후만 조회 가능합니다.');
    			$("#FROM_DT").val(getCurrdate());
    			return;
    		}
        	
        	var _page_no = 1;
            if ( $.PSNMUtils.isNotEmpty(param) && $.PSNMUtils.isNotEmpty(param.page) ) {
                _page_no = param.page;
            }
            var _per_page = $("#griddfaxrcv").alopexGrid("pageInfo").perPage;
            
            $.alopex.request("biz.DFAXRCV@PFAXRCV001_pSearchFaxRcv", {
                data: ["#searchTable", function() {
                	this.data.dataSet.fields.FROM_DT   = $.PSNMUtils.getDateInput("FROM_DT");
                	this.data.dataSet.fields.TO_DT     = $.PSNMUtils.getDateInput("TO_DT");
                    this.data.dataSet.fields.page      = _page_no;
                    this.data.dataSet.fields.page_size = _per_page;
                }],
                success: ["#griddfaxrcv", function(res) {
                }]
            });
        }
    });

    </script>

</head>

<body>

<jsp:include page="/view/layouts/default_header.jsp" flush="false" />

<!-- contents area -->
<div id="contents">

	<!-- sub title area -->
    <div class="content_title">
        <div id="ub_txt6">
            <span class="txt6_img"><b id="sub-title">접수현황(D-FAX)</b>
                <span class="notice-more"> 
                	<img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif">
                	<span class="a2">영업정보</span> <span class="a3"> > </span> <span class="a4"><b>판매관리</b></span> 
                </span>
            </span>
        </div>
    </div>

    <!-- find condition area -->
    <div id="searchDiv" class="textAR">
		<form id="searchForm" onsubmit="return false;">
        	<table id="searchTable" class="board02" style="width:92%;">
        	<colgroup>
	            <col style=""/>
	            <col style="width:320px"/>
	            <col style=""/>
	            <col style="*"/>
            </colgroup>
            <tr>
                <th scope="col" class="fontred">조회기간</th>
                <td class="tleft">
                	<div data-type="daterange" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png" >
						<input id="FROM_DT" name="FROM_DT" data-role="startdate" data-bind="value:FROM_DT" style="width:70px;"/>
						~ <input id="TO_DT" name="TO_DT" data-role="enddate" data-bind="value:TO_DT" style="width:70px;"/>
					</div>
				</td>
				<th>처리현황</th>
				<td class="tleft">
                    <select id="FAX_OP_ST_CD" data-bind="options: options_FAX_OP_ST_CD, selectedOptions: FAX_OP_ST_CD" data-type="select" ></select>
                </td>
            </tr>
            </table>
			<div class="ab_pos5">
				<button id="btnSearch" type="button" data-type="button" data-theme="af-psnm" data-authtype="R"></button>
			</div>
        </form>
    </div>

    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>접수현황(D-FAX)</b></div>

    <!-- main grid -->
    <div id="griddfaxrcv" data-bind="grid:griddfaxrcv"></div>

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>