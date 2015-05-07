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
            
            //$.PSNMUtils.setDefaultYmd("#FROM_DT", "TO_DT");
            $("#FROM_DT").val(getFirstdate());
            $("#TO_DT").val(getAddDate(getCurrdate(),3));
            $a.page.setEventListener();
            $a.page.setGrid();
            $a.page.setCodeData();
            $("#searchTable").setData(param);  //(설명) 상세페이지에서 돌아오는 경우, 이 값들이 세션스토리지에서 반환됨.
			$a.page.searchList(param);
        },
        setEventListener : function() {
            $("#btnSearch").click($a.page.searchList);
        },
        setGrid : function() {
            $("#grid").alopexGrid({
                rowClickSelect : false,
                rowInlineEdit : true,
                columnMapping : [
                    { columnIndex : 0, key : "APLY_STA_DT",            	title : "적용일자",	align : "center", 	width : "100px" },
                    { columnIndex : 1, key : "DSM_SALES_PLCY_TYP_NM",  	title : "정책유형",	align : "center", 	width : "100px" },
                    { columnIndex : 2
                    	, key : "SALES_PLCY_NM"
                    	, title : "제목"
                    	, align : "left"
                    	, width : "300px"
                    	, render : function(value, data) {
        					if(data["ANNCE_YN"]=="Y") {
        						return '<img src="${pageContext.request.contextPath}/image/blat_a10.gif">&nbsp;<font color="#1B1760"><strong>'+value+'</strong></font>';
        					}else if(data["F"]=="NEW") {
        						return '<img src="${pageContext.request.contextPath}/image/blat_a11.gif">&nbsp;'+value;
        					}
        					return value;
        				}},
                    { columnIndex : 3, key : "USER_NM", 				title : "작성자",	align : "center", 	width : "100px"	},
                    { columnIndex : 4, key : "RGST_DTM",      			title : "작성일시",	align : "center", 	width : "100px" }
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
    							var param = $("#searchTable").getData({selectOptions:true});
    							param["data"] 		= data;
    							param["page"]      	= $("#grid").alopexGrid("pageInfo").customPaging.current;
				            	param["page_size"] 	= $("#grid").alopexGrid("pageInfo").perPage;
			            		$a.navigate("salePlcyBrwsDtl.jsp", param);
    						}
    					}
    				}
                }
            });
        },
        setCodeData : function() {
            $.PSNMUtils.setCodeData([
				{ t:'code', 'elemid' : 'DSM_SALES_PLCY_TYP_CD', 'codeid' : 'DSM_FAX_UNIT_TYP_CD', 'header' : '-전체-' }
            ]);
        },
        searchList: function(param) {
            var _page_no = 1;
            if ( $.PSNMUtils.isNotEmpty(param) && $.PSNMUtils.isNotEmpty(param.page) ) {
                _page_no = param.page;
            }
            var _per_page = $("#grid").alopexGrid("pageInfo").perPage;
            
            $.alopex.request("biz.SALEPLCY@PSALESPLCY001_pSearchSalesPlcyBrws", {
                data: ["#searchTable", function() {
                	this.data.dataSet.fields.FROM_DT   = $.PSNMUtils.getDateInput("FROM_DT");
                	this.data.dataSet.fields.TO_DT     = $.PSNMUtils.getDateInput("TO_DT");
                    this.data.dataSet.fields.page      = _page_no;
                    this.data.dataSet.fields.page_size = _per_page;
                }],
                success: ["#grid", function(res) {
                }]
            });
        }
    });

    </script>

</head>

<body>

<jsp:include page="/view/layouts/default_header.jsp" flush="false" />

<div id="contents">

    <!-- sub title area -->
    <div class="content_title">
        <div id="ub_txt6">
            <span class="txt6_img"><b id="sub-title">영업정책</b>
                <span class="notice-more"> 
                	<img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif">
                	<span class="a2">커뮤니티</span> <span class="a3"> > </span> <span class="a4"><b>Main화면 알림</b></span> 
                </span>
            </span>
        </div>
    </div>

    <!-- find condition area -->
    <div id="searchDiv" class="textAR">
		<form id="searchForm" onsubmit="return false;">
        	<table id="searchTable" class="board02" style="width:92%;">
        	<colgroup>
	            <col style="width:10%"/>
	            <col style="width:30%"/>
	            <col style="width:10%"/>
	            <col style="width:*"/>
            </colgroup>
        	<tbody>
        	<tr>
                <th scope="col" class="fontred">조회기간</th>
                <td class="tleft">
                	<div data-type="daterange" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png" >
						<input id="FROM_DT" name="FROM_DT" data-role="startdate" data-bind="value:FROM_DT" style="width:70px;"/>
						~ <input id="TO_DT" name="TO_DT" data-role="enddate" data-bind="value:TO_DT" style="width:70px;"/>
					</div>
				</td>
				<th>정책유형</th>
				<td class="tleft">
                    <select id="DSM_SALES_PLCY_TYP_CD" data-bind="options: options_DSM_SALES_PLCY_TYP_CD, selectedOptions: DSM_SALES_PLCY_TYP_CD" data-type="select" ></select>
                </td>
            </tr>
        	</tbody>
            </table>
        </form>
		<div class="ab_pos5">
			<button id="btnSearch" type="button" data-type="button" data-theme="af-psnm" data-authtype="R"></button>
		</div>
    </div>

    <div class="floatL4"><img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"><b>영업정책</b></div>

    <!-- main grid -->
    <div id="grid" data-bind="grid:grid"></div>

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>