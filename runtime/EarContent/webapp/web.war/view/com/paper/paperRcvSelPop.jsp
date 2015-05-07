
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="nexcore.framework.core.Constants"%>
<%@ page import="nexcore.framework.core.code.ICode"%>
<%@ page import="nexcore.framework.core.data.user.IUserInfo"%>
<%@ page import="nexcore.framework.core.util.BaseUtils"%>
<%@ page import="nexcore.framework.online.channel.util.WebUtils"%>
<%
    IUserInfo userInfo = WebUtils.getSessionUserInfo(request);
%>
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

    <jsp:include page="/view/layouts/popup_head.jsp" flush="false" />
<script src="../../../script/jquery.cookie.js" type="text/javascript"></script>
<script src="../../../script/jquery.treeview.js" type="text/javascript"></script>
    <script type="text/javascript">
    
    var _TX_SEARCH1     =           "com.PAPER@PPAPERMGMT001_pSearchSaleTeam";         
    var _TX_SEARCH2     =           "com.PAPER@PPAPERMGMT001_pAgntList";
    var arr             =           new Array();
    var authgrp = ($.PSNM.getSession("DUTY"));
	var admin ;
    $.alopex.page({

        init : function(id, param) { 
            //$.PSNM.initialize(id, param); //팝업에서는 initialize() 사용치 않음!
            $.PSNM.setOrgSelectBox(); //팝업에서 조직 선택상자를 초기화 할 때 사용

            $( "#SALE_DEPT_ORG_ID" ).unbind();
		    if(authgrp<12){
            	$( "#SALE_DEPT_ORG_ID" ).bind("change",teamSearch);
            	admin = "1";
            }else {
            	admin = "2";
            	teamSearch();
            }
            
            $a.page.setGrid(); //그리드
            $a.page.setEventListener(); //버튼이 눌렸을때 실행할 이벤트리스너 
        },
        setGrid : function() {
            $("#grid").alopexGrid({
                pager :false,
                height:400,
                virtualScroll:true,
                rowClickSelect : false,
                rowInlineEdit : true,
                columnMapping : [   //컬럼맵핑     
                    {
                        columnIndex : 0, width : "10px",
                        selectorColumn : true
                    },
                    {
                        columnIndex : 1, key : "HDQT_PART_ORG_NM", title : "본사파트", align: "center", width: "30px"
                    },
                    {
                        columnIndex : 2, key : "SALE_TEAM_ORG_NM", title : "영업팀명",  align: "center", width: "30px"
                    },
                    {
                        columnIndex : 3, key : "AGNT_ID", title : "에이전트코드	",align: "center", width: "30px"
                    },
                    {
                        columnIndex : 4, key : "REAL_DUTY", title : "직책명", align: "center", width: "30px"
                    },
                    {
                        columnIndex : 5, key : "USER_NM", title : "성명", align: "center", width: "30px"
                    },
                    {
                        columnIndex : 6, key : "FLAG", title : "확인여부", hidden:true
                    },
                    { 
                    	columnIndex : 7, key : "LVL_CD", 	title : "LVL_CD", 		hidden:true 
                    },
                ],
                on : {
                    perPageChange : function(arg1) {
                        _debug("<annceList> <grid.on.perPageChange> 페이지당개수 변경 : arg1 = " + arg1);//만약에 마지막 페이지가 7개면 7개만 들어감. 
                    }
                }
            });
        },setEventListener : function() {
            $("#btnOk").click(function(){
                $("#grid").alopexGrid( "dataEdit", {"FLAG":"I"}, { _state: { selected : true } } );//그리드 에서 선택된것을 flag:I로 바꿔준다. 이거는 추가할데이터인지 확인하기위함
                var state  = $.PSNMUtils.getRequestData("grid");
                var state2 = state.dataSet.recordSets;
                var list   = eval(state2.grid.nc_list);
                var count  = 0;
                
                console.log(list);
                
                for(var i = 0; i<list.length;i++){
                    if(list[i].FLAG==="I"){
                        RgstSet(list[i].USER_ID,list[i].USER_NM,count);
                        count ++;
                    }
                }
                $a.close(arr);
            });
            $("#btnCancel").click(function(){
            	$a.close();
            });
        }
    });
    function teamSearch(e) {
       var val;
       
       if(admin == 1 ){
    	   if ( !$("#" + e.target.id).val() ) return false; 
    	      val = $("#" + e.target.id).val();	   
       }
       else if(admin == 2){
    	    val = $("#SALE_DEPT_ORG_ID").val();
       }      
        $("#hTeamNM").empty();
        $("#sTeamNM").empty();
        $("#tree").empty();
        pSearchAuthGrp();
    }
    function pSearchAuthGrp() {
        if ( ! $.PSNM.isValid("#searchForm") ) return false; 

        $.alopex.request(_TX_SEARCH1, {
            data: ["#searchForm", function() {
            }],
            success: ['#teamSearch', function(res) {
                treeData(res.dataSet.recordSets.teamSearch);
            }]
        });
    }

    function treeData(param){
        var htm    ="";
        var data   ="";
        var dataNM ="";
            
        for(var i=0;i<param.nc_recordCount;i++){
        	if(param.nc_list[i].LVL_CD == '0'){ /* 본사팀 */
               /*  htm ='<li><p>'+param.nc_list[i].DSM_ORG_NM+'</p><ul id="'+param.nc_list[i].DSM_ORG_CD+'"></ul></li>';	
                $("#tree").append(htm);
                htm=""; */
        		 $('#tree').createNode("", {
                    text	:	 param.nc_list[i].DSM_ORG_NM,
                    id 		:	 param.nc_list[i].DSM_ORG_CD
                }); 
        	}
        	else if(param.nc_list[i].LVL_CD == '1'){ /* 영업국 */
        			if(param.nc_list[i].DSM_ORG_CD == "01010000"){ /* 사무국 */
        				/* htm +='<li><a href="javascript:void(TeamMember(\''+param.nc_list[i].DSM_ORG_CD+'\'));">'+param.nc_list[i].DSM_ORG_NM+'</a></li>';	
                        $("#"+param.nc_list[i].SUP_DSM_ORG_CD).append(htm);
                        htm=""; */
        				 var node = $("#tree").getNode(param.nc_list[i].SUP_DSM_ORG_CD, "id");
     	                $("#tree").createNode(node, {
     	                    text	:	 param.nc_list[i].DSM_ORG_NM,
     	                    id 		:	 param.nc_list[i].DSM_ORG_CD,
     	                    linkUrl :    "javascript:void(TeamMember(\'" + param.nc_list[i].DSM_ORG_CD + "\'\,\'" + param.nc_list[i].LVL_CD + "\'));"
     	                }); 
        			}
        			else{
        				/* htm ='<li><p>'+param.nc_list[i].DSM_ORG_NM+'</p><ul id="'+param.nc_list[i].DSM_ORG_CD+'"></ul></li>';	
                        $("#"+param.nc_list[i].SUP_DSM_ORG_CD).append(htm);
                        htm=""; */
		                 var node = $("#tree").getNode(param.nc_list[i].SUP_DSM_ORG_CD, "id");
		                $("#tree").createNode(node, {
		                    text	:	 param.nc_list[i].DSM_ORG_NM,
		                    id 		:	 param.nc_list[i].DSM_ORG_CD
		                }); 
        			}
        		
        	}
        	else if(param.nc_list[i].LVL_CD == '2'){ /* 영업팀 */
	        		/* htm +='<li><a href="javascript:void(TeamMember(\''+param.nc_list[i].DSM_ORG_CD+'\'));">'+param.nc_list[i].DSM_ORG_NM+'</a></li>';	
	                $("#"+param.nc_list[i].SUP_DSM_ORG_CD).append(htm);
	                htm=""; */
	                
	       			var node = $("#tree").getNode(param.nc_list[i].SUP_DSM_ORG_CD, "id");
	                $("#tree").createNode(node, {
	                    text	:	 param.nc_list[i].DSM_ORG_NM,
	                    id 		:	 param.nc_list[i].DSM_ORG_CD,
	                    linkUrl :    "javascript:void(TeamMember(\'" + param.nc_list[i].DSM_ORG_CD + "\'\,\'" + param.nc_list[i].LVL_CD + "\'));"
	                }); 
        	}
        }
        $("#tree").treeview({
   			collapsed: true
        });
        $("#tree").expandAll();
    }
    function TeamMember(m_id ,m_lvl){
        $.alopex.request(_TX_SEARCH2, {
            data:{dataSet: {fields: {
            	SALE_TEAM_ORG_ID   :    m_id
            	,LVL_CD 		   : 	m_lvl	
            }}},
            success: ['#grid', function(res) {
            }]
        });
    }
    $(function() {
        $("#tree").treeview({
        });
    })
    function RgstSet(u_id,u_nm,count){
        arr[count]=[(u_id),(u_nm)];
    }
    </script>
</head>

<body>
<div id="Wrap">
    <div class="pop_header" >
        <div class="textAR">
            <form id="searchForm" onsubmit="return false;">
                <table id="searchTable" class="board02" >
                    <colgroup>
                            <col style="10%">
                            <col style="23%">
                            <col style="10%">
                            <col style="23%">
                            <col style="10%">
                            <col style="*">
                    </colgroup>
                    <tbody>
                        <tr>
                            <th class="fontred">본사팀</th>
                            <td class="tleft">
                                <select id="HDQT_TEAM_ORG_ID" data-bind="options:options_HDQT_TEAM_ORG_ID, selectedOptions: HDQT_TEAM_ORG_ID" data-type="select" 
                                        data-validation-rule="{required:true}" data-validation-message="{required:$.PSNM.msg('E012', ['본사팀'])}">
                                    <option value="">-선택-</option>
                                </select>
                            </td>
                                
                            <th class="fontred">본사파트</th>
                            <td class="tleft">
                                <select id="HDQT_PART_ORG_ID" data-bind="options:options_HDQT_PART_ORG_ID, selectedOptions: HDQT_PART_ORG_ID" data-type="select"  
                                        data-validation-rule="{required:true}" data-validation-message="{required:$.PSNM.msg('E012', ['본사파트'])}">
                                    <option value="">-선택-</option>
                                </select>
                            </td>
                            <th class="fontred">영업국</th>
                            <td class="tleft">
                                <select id="SALE_DEPT_ORG_ID" data-bind="options:options_SALE_DEPT_ORG_ID, selectedOptions: SALE_DEPT_ORG_ID" data-type="select" 
                                        data-validation-rule="{required:true}" data-validation-message="{required:$.PSNM.msg('E012', ['영업국'])}">
                                    <option value="">-선택-</option>
                                </select>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </form>
            <div class="org_wrap">
					<form id="treeform">
					 <div class="org_tree">
	                       <ul id='tree' data-type="tree">
	                       </ul>
	                       </div>
	               	</form>
                <div class="org_result">
                    <div id="grid" data-bind="grid:grid" data-ui="ds"></div>
            
                    <div class="floatL2">
                        <input type="button" id="btnOk" value="" data-type="button" data-theme="af-btn8">
                        <input type="button" id="btnCancel" value="" data-type="button" data-theme="af-btn10">
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>