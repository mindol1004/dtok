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

            $.PSNMUtils.setDefaultYmd("#FROM_DT", "TO_DT");
          
            $a.page.setEventListener(); //버튼 초기화
            $a.page.setGrid(); //그리드 초기화
            $a.page.setCodeData(); //공통코드 호출
            
            $("#searchTable").setData(param);
//            $a.page.searchList(param);
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

    	        $a.navigate("bizMgmtRgst.jsp",param);
            });
            $("#btnExcelPage").click(function(){
            	var oExcelMetaInfo = {
                        filename  : "영업목표목록.xls",
                        sheetname : "영업목표목록",
                        gridname  : "grid" //그리드ID 
                    };
            	var txid= "biz.BIZTRGT@PBIZTRGT001_pSearchBizTrgt"
            	                       
            	$.PSNMUtils.downloadExcelAll("searchForm", txid, "grid", oExcelMetaInfo);
            });
        }, 
        setGrid : function() {
            $("#grid").alopexGrid({
                rowClickSelect : false,
                rowInlineEdit : true,
                columnMapping : [
                    { columnIndex : 0, key : "BIZ_ID",     	 	 title : "영업목표ID",     align : "center", width : "100px"  			   },
                    { columnIndex : 1, key : "HDQT_PART_ORG_NM", title : "본사파트",       align : "center", width : "100px"  			   },
                    { columnIndex : 2, key : "SALE_DEPT_ORG_NM", title : "영업국명",       align : "center", width : "100px"  			   },
                    { columnIndex : 3, key : "BIZ_TITL_NM",  	 title : "제목", 		   align : "left", width : "250px"  		
                    	, render : function(value, data) {
                            if(data["ATCH_YN"]=="Y") {
                                return value+'&nbsp;<img src="${pageContext.request.contextPath}/image/blat_adisk.gif">';

                            }
                            return value;
                        },	
                    },
                    { columnIndex : 4, key : "VIEW_CNT", 	 	 title : "조회수",     align : "center", width : "100px" 			   },
                    { columnIndex : 5, key : "RGSTR_NM", 	 	 title : "게시자",     align : "center", width : "100px" 			   },
                    { columnIndex : 6, key : "RGSTR_DT",      	 title : "게시일",       align : "center", width : "100px" 			   }
                ],
                on : {
                    pageSet : function(pageNoToGo) {
                    	 var p = {};
                         p.page = pageNoToGo;
                    	 $a.page.searchList(p); //페이지 이동
                    },"cell" : {
    					"dblclick" : function(data, eh, e) {
    						if(data._index.column != 0) {

    							var param = $("#searchTable").getData({selectOptions:true});

    							param["data"] 		= data;

    							param["page"]      	= $("#grid").alopexGrid("pageInfo").customPaging.current;
    							param["page_size"] 	= $("#grid").alopexGrid("pageInfo").perPage;
   			            		$a.navigate("bizMgmtRgst.jsp", param);
    						}
    					}
    				}
                    
                }
            });
        }, 
        setCodeData : function() {
            $.PSNMUtils.setCodeData([
            	{ t:'org2',  'elemid' : 'HDQT_PART_ORG_ID', 'header' : '-선택-' }
            ]);
        },
 
        searchList : function(param){
        	var _page_no = 1;
            if ( $.PSNMUtils.isNotEmpty(param) && $.PSNMUtils.isNotEmpty(param.page) ) {
                _page_no = param.page; //(설명) 페이지 이동할때만 페이지번호가 넘어옴.
            }
            var _per_page = $('#grid').alopexGrid('pageInfo').perPage; 
        	
            $.alopex.request("biz.BIZTRGT@PBIZTRGT001_pSearchBizTrgt", {
    			data : ["#searchTable", function(){
	    				this.data.dataSet.fields.FROM_DT   = $.PSNMUtils.getDateInput("FROM_DT");
	                	this.data.dataSet.fields.TO_DT     = $.PSNMUtils.getDateInput("TO_DT");
	    				this.data.dataSet.fields.page      = _page_no;
	    				this.data.dataSet.fields.page_size = _per_page;
    			}],
                success: "#grid"
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
          <th scope="col">조회기간</th>
          <td class="tleft">
          <input id="FROM_DT" name="FROM_DT" data-type="dateinput" data-bind="value:FROM_DT" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png"/> ~
		  <input id="TO_DT" name="TO_DT" data-type="dateinput" data-bind="value:TO_DT" data-image="<c:out value='${pageContext.request.contextPath}'/>/image/ico_calendar.png"/>
          </td>
          <th >본사파트</th>
          <td class="tleft"><select id="HDQT_PART_ORG_ID" data-type="select" data-bind="options:options_HDQT_PART_ORG_ID, selectedOptions:HDQT_PART_ORG_ID" data-wrap="false" style="width:185px!important"></select>
          </td>
          <th >영업팀</th>
          <td class="tleft"><select id="SALE_DEPT_ORG_ID" data-type="select" data-bind="options:options_SALE_DEPT_ORG_ID, selectedOptions:SALE_DEPT_ORG_ID" data-wrap="false" style="width:185px!important"></select>
          </td>
        </tr>
      </table>
      <div class="ab_pos5"><!-- 1줄 class="ab_pos5"-->
        <input id="btnSearch" type="button" value="" data-type="button" data-theme="af-psnm" style="padding-left:5px" data-authtype="R">
      </div>
    </form>
  </div>
  
  <!--view_list area -->
  <div class="floatL4"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a7.gif"> <b>영업현황/현황관리목록</b>
  <p class="ab_pos2">
      <button id="btnNew" type="button" data-type="button" data-theme="af-btn2" data-altname="신규" data-authtype="W"></button>
      <button id="btnExcelPage" type="button" data-type="button" data-theme="af-btn3" data-altname="엑셀" data-authtype="R"></button>
  </p>
  </div>
  <!-- main grid -->
  <div id="grid" data-bind="grid"></div>
</div>
<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />
</body>
</html>
 