<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
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
            
            $a.page.setEventListener(); //버튼 초기화
            $a.page.setGrid(); //그리드 초기화
            $("#searchTable").setData(param);
          	// $a.page.searchList(param); //조회후 볼수있음
        },
        setEventListener : function() {
            $("#btnSearch").click(function(param){
            	$a.page.searchList(param);
            });
        }, 
        setGrid : function() {
            $("#grid").alopexGrid({
                rowClickSelect : false,
                rowInlineEdit : true,
                columnMapping : [
                    { columnIndex : 0, key : "BIZ_ID",     	 	 title : "영업목표ID",    hidden : true	   },
                    { columnIndex : 1, key : "SALE_DEPT_ORG_NM", title : "영업국",       align : "center", width : "100px"  			   },
                    { columnIndex : 2, key : "BIZ_TITL_NM",  	 title : "제목", 		   align : "left", width : "250px"  			  
                    	, render : function(value, data) {
                            if(data["ATCH_YN"]=="Y") {
                                return value+'&nbsp;<img src="${pageContext.request.contextPath}/image/blat_adisk.gif">';

                            }
                            return value;
                        },
                    },
                     { columnIndex : 3, key : "RGSTR_NM", 	 	 title : "게시자",     hidden : true		   },
                     { columnIndex : 4, key : "RGSTR_DT",      	 title : "게시일",       align : "center", width : "100px" 			   }
                ],
                on : {
                    perPageChange : function(arg1) {
                    }
                    ,
                    pageSet : function(pageNoToGo) {
                    	 var p = {};
                         p.page = pageNoToGo;
                    	 $a.page.searchList(p); //페이지 이동
                    },
                    'cell' : {
                        "click" : function(data, eh, e) {
                            if(data._index.column != 0) {
                                var param = $("#searchTable").getData({selectOptions:true});
                                    param["BIZ_ID"]      = data.BIZ_ID;
                                    param["ATCH_YN"]      = data.ATCH_YN; 
                                    param["page"]      = $("#grid").alopexGrid("pageInfo").customPaging.current;
                                    param["page_size"] = $("#grid").alopexGrid("pageInfo").perPage;
                                $a.navigate("bizTrgtPrstDtl.jsp", param);
                            }
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
        	
            $.alopex.request('biz.BIZTRGT@PBIZTRGT001_pSearchBizTrgtBrws', {
            	
    			data : ["#searchTable", function(){
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
<!--// left area -->
<div class="left_bar"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/left_bar.gif" width="22" height="106"></div>
<!-- title area -->
<div id="contents">
  <div class="content_title">
    <div class="ub_txt6"> <span class="txt6_img"><b>영업목표/현황관리</b> <span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif"> <span class="a2">본사업무</span> <span class="a3"> > </span> <b>영업목표/현황조회</b> </span> </span> </div>
  </div>
  <!-- find condition area -->
    <div class="textAR"> 
    <form id="searchForm">
      <table id="searchTable" class="board02" style="width:92%;">
        <tr>
          <th >영업국명</th>
          <td class="tleft"><select id="HDQT_TEAM_ORG_ID" data-type="select" data-bind="options:options_HDQT_TEAM_ORG_ID, selectedOptions:HDQT_TEAM_ORG_ID" data-wrap="false" style="width:185px!important">
           </select></td>
           <th >영업국명</th>
          <td class="tleft"><select id="HDQT_PART_ORG_ID" data-type="select" data-bind="options:options_HDQT_PART_ORG_ID, selectedOptions:HDQT_PART_ORG_ID" data-wrap="false" style="width:185px!important">
           </select></td>
          <th >영업국명</th>
          <td class="tleft"><select id="SALE_DEPT_ORG_ID" data-type="select" data-bind="options:options_SALE_DEPT_ORG_ID, selectedOptions:SALE_DEPT_ORG_ID" data-wrap="false" style="width:185px!important">
           </select></td>
        </tr>
      </table>
      <div class="ab_pos5"><!-- 1줄 class="ab_pos5"-->
        <input id="btnSearch" type="button" value="" data-type="button" data-theme="af-psnm" style="padding-left:5px" data-authtype="R">
      </div>
    </form>
  </div>
  <!--view_list area -->
  <div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>영업현황/현황관리목록</b>
  </div>
  <!-- main grid -->
  <div id="grid" data-bind="grid" data-ui="ds"></div>
</div>
<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />
</body>
</html>