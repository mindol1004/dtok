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
            	$a.navigate("faqEditForm.jsp", param);
            });
        },
        setGrid : function() {
        	$("#grid").alopexGrid({
                rowClickSelect : false,
                rowInlineEdit : true,
                columnMapping : [
					{ columnIndex : 0, key : "BLTCONT_ST",       title : "F",		    hidden : true },
                    { columnIndex : 1, key : "BLTCONT_ID",       title : "상담ID",	 	align : "center", 	width : "100px" },
                    { columnIndex : 2, key : "BLTCONT_TITL_NM",  title : "제목",		align : "left", 	width : "430px",
                      render : function(value, data) {
                    	  
                    	var disk  = data["ATCH_YN"] == 'Y' ? '&nbsp;<img src="${pageContext.request.contextPath}/image/blat_adisk.gif"/>' : '';
                    	var reple = '&nbsp;<img src="${pageContext.request.contextPath}/image/blat_a25.gif"/>';
                    	var cmnt  = '&nbsp;<font color="red">['+data['CMNT_CNT']+']</font>';
                    	
       					if(data["BLTCONT_TYP_CD"] == "1" && data['CMNT_CNT'] > 0) { return reple + value + cmnt + disk; }
       					else if(data["BLTCONT_TYP_CD"] == "1" && data['CMNT_CNT'] < 0) { return reple + value + disk; }
       					else if(data["BLTCONT_TYP_CD"] == "0" && data['CMNT_CNT'] > 0) { return value + cmnt + disk; }
       					else { return value + disk; }
       					
       					return value;
       			      }
                    },
                    { columnIndex : 3, key : "ATCH_YN",  	     title : "첨부파일",	hidden : true },                    
                    { columnIndex : 4, key : "DSM_HEADQ_NM",     title : "영업국명",	align : "center", 	width : "70px"  },
                    { columnIndex : 5, key : "RGSTR_NM", 		 title : "에이전트명",	align : "center", 	width : "70px"	},
                    { columnIndex : 6, key : "RGST_DT", 		 title : "등록일",		align : "center", 	width : "70px"	},
                    { columnIndex : 7, key : "BLTCONT_TYP_CD", 	 title : "",		    hidden : true	}                   
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
   								p["page"]      = $("#grid").alopexGrid("pageInfo").customPaging.current;
   				            	p["page_size"] = $("#grid").alopexGrid("pageInfo").perPage;
   			            		$a.navigate("p2pCnslBrwsForm.jsp", p);
    						}
    					}
    				}
                }
            });
        },
        setCodeData : function() {
            $.PSNMUtils.setCodeData([
				 //{ t:'code', 'elemid' : 'FAQ_TYP_CD', 'codeid' : 'DSM_FAQ_TYP_CD', 'header' : '-전체-' }
				 { t:'code', 'elemid' : 'BLTCONT_BRWS_COND_CD', 'header' : '-전체-' }
            ]);
        },
        searchList: function(param) {
        	var _page_no = 1;
            if ( $.PSNMUtils.isNotEmpty(param) && $.PSNMUtils.isNotEmpty(param.page) ) {
                _page_no = param.page;
            }
            var _per_page = $("#grid").alopexGrid("pageInfo").perPage;
            
            $.alopex.request("com.PPCNSLMGMT@PP2PCNSLMGMT001_pSearchP2pCnsl", {
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
            <span class="txt6_img"><b id="sub-title">무엇이든 물어보세요</b>
                <span class="notice-more"> <img src="<c:out value='${pageContext.request.contextPath}'/>/image/blat_a6.gif">
                <span class="a2">나의 D-tok</span> <span class="a3"> > </span> <span class="a4"><b>무엇이든 물어보세요</b></span> 
            </span>
        </div>
    </div>

    <!-- find condition area -->
    <div id="searchDiv" class="textAR">
		<form id="searchForm">
        	<table id="searchTable" class="board02" style="width:92%;">
        	<tr>
                <th>조회조건</th>
				<td class="tleft">
                    <select id="BLTCONT_BRWS_COND_CD" data-bind="options:options_BLTCONT_BRWS_COND_CD, selectedOptions:BLTCONT_BRWS_COND_CD" data-type="select" data-wrap="true"></select>
                    <input id="BLTCONT_BRWS_COND_NM" name="BLTCONT_BRWS_COND_NM" data-type="textinput" data-bind="value:BLTCONT_BRWS_COND_NM" style="width:170px"/>
                </td>
            </tr>
            </table>
        </form>
		<div class="ab_pos5">
			<button id="btnSearch" data-type="button" data-theme="af-psnm"></button>
		</div>
    </div>

    <div class="floatL4"><b>(회사와 의견을 주고 받을 수 있는 공간입니다.)</b>
        <p class="ab_pos2">
            <button id="btnNew" data-type="button" data-theme="af-btn2" data-altname="신규"></button>
        </p>
    </div>

    <!-- main grid -->
    <div id="grid" data-bind="grid"></div>

</div>

<jsp:include page="/view/layouts/default_footer.jsp" flush="false" />

</body>
</html>