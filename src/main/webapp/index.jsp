<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>员工列表</title>

<%
	pageContext.setAttribute("APP_PATH", request.getContextPath());
%>
<!-- web路径
	不以/开始的相对路径，以当前资源的路径为基准，经常容易出问题
	以/开始的相对路径，找资源，以服务器的路径为标准（http://localhost:3306);需要加上项目名
		http://localhost:3306/crud
	所以我们一般通过request.getContextPath()获得项目的路径，将其加在相对路径前面
 -->
<!-- 引入jquery -->
<script type="text/javascript" src="${APP_PATH }/static/js/jquery-1.12.4.min.js"></script>
<!-- 引入样式 -->
<link href="${APP_PATH }/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
<script src="${APP_PATH }/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
</head>
<body>

	<!-- 添加员工信息 -->
	<div class="modal fade" id="myModalAddEmp" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        <h4 class="modal-title" id="myModalLabel">添加员工</h4>
	      </div>
	      <div class="modal-body">
	        <form class="form-horizontal">
			  <div class="form-group">
			    <label class="col-sm-2 control-label">empName</label>
			    <div class="col-sm-10">
			      <input type="text" name="empName" class="form-control" id="empName_add_input" placeholder="empName">
			      <span class="help-block"></span>
			    </div>
			  </div>
			  <div class="form-group">
			    <label class="col-sm-2 control-label">email</label>
			    <div class="col-sm-10">
			      <input type="text" name="email" class="form-control" id="email_add_input" placeholder="email@atguigu.com">
			      <span class="help-block"></span>
			    </div>
			  </div>
			  <div class="form-group">
			    <label class="col-sm-2 control-label">gender</label>
			    <div class="col-sm-10">
			      	<label class="radio-inline">
					  <input type="radio" name="gender" id="gender1_add_input" value="M" checked="checked"> 男
					</label>
					<label class="radio-inline">
					  <input type="radio" name="gender" id="gender2_add_input" value="F"> 女
					</label>
			    </div>
			  </div>
			  <div class="form-group">
			    <label class="col-sm-2 control-label">department</label>
			    <div class="col-sm-4">
			    	<!-- 部门提交部门id即可 -->
			      	<select class="form-control" name="dId">
			      		<!-- 部门下拉列表 -->
					</select>
			    </div>
			  </div>
			  
			</form>
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
	        <button type="button" class="btn btn-primary" id="emp_save_btn">Save changes</button>
	      </div>
	    </div>
	  </div>
	</div>
	
	<!-- 搭建显示页面 -->
	<div class="container">
		<!-- 标题 -->
		<div class="row">
			<div class="col-md-12">
				<h1>SSM-CRUD</h1>
			</div>
		</div>
		<!-- 按钮 -->
		<div class="row">
			<div class="col-md-4 col-md-offset-8">
				<button class="btn btn-primary" id="AddEmp">新增</button>
				<button class="btn btn-danger">删除</button>
			</div>
		</div>
		<!-- 显示表格数据 -->
		<div class="row">
			<div class="col-md-12">
				<table class="table table-hover" id="emps_table">
					<thead>
						<tr>
							<th>#</th>
							<th>empName</th>
							<th>gender</th>
							<th>email</th>
							<th>deptName</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody>
						
					</tbody>
					
				</table>
			</div>
		</div>
		<!-- 显示分页信息 -->
		<div class="row">
			<!-- 分页文字信息 -->
			<div class="col-md-6" id="page_info_area">
				<!-- 当前  页，总  页, 共   条记录 -->
			</div>
			<!-- 分页条信息 -->
			<div class="col-md-6" id="page_nav_area">
				<!-- 分页条 -->
			</div>
		</div>
	
	</div>
	
	<script type="text/javascript">
		var totalRecord;
		//1.页面加载完成以后，直接去发送ajax请求，要到分页数据
		$(function() {
			//去首页
			to_page(1);
		});
		
		function to_page(pn){
			$.ajax({
				url:"${APP_PATH}/emps",
				data:"pn="+pn,
				type:"GET",
				success:function(result){
					//1.解析并显示员工数据
					build_emps_table(result);
					//2.解析并显示分页信息
					build_page_info(result);
					//3.解析显示分页条数据源
					build_page_nav(result);
				}
			});
		}
		
		function build_emps_table(result){
			$("#emps_table tbody").empty();
			var emps = result.extend.pageInfo.list;
			$.each(emps, function(index, item){
				//alert(item.empName);
				var empIdTd = $("<td></td>").append(item.empId);
				var empNameTd = $("<td></td>").append(item.empName);
				var genderTd = $("<td></td>").append(item.gender=="M"?"男":"女");
				var emailTd = $("<td></td>").append(item.email);
				var deptNameTd = $("<td></td>").append(item.department.deptName);
				/** 
					<button class="btn btn-primary btn-xs">
						<span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
							编辑
					</button> 
				*/
				var editBtn = $("<button></button>").addClass("btn btn-primary btn-xs")
					.append($("<span></span>").addClass("glyphicon glyphicon-pencil"))
					.append("编辑");
				var deletBtn = $("<button></button>").addClass("btn btn-danger btn-xs")
					.append($("<span></span>").addClass("glyphicon glyphicon-trash"))
					.append("删除");
				var btnTd = $("<td></td>").append(editBtn).append(" ").append(deletBtn);
				//append方法执行完后还是返回原来的元素
				$("<tr></tr>").append(empIdTd)
					.append(empNameTd)
					.append(genderTd)
					.append(emailTd)
					.append(deptNameTd)
					.append(btnTd)
					.appendTo("#emps_table tbody");
			});
		}
		
		//解析显示分页信息
		function build_page_info(result){
			$("#page_info_area").empty();
			$("#page_info_area").append("当前" + result.extend.pageInfo.pageNum + "页，总" + 
					result.extend.pageInfo.pages +"页, 共" + result.extend.pageInfo.total + "条记录");
			//全局变量，保存总记录数(肯定比总页数大)
			totalRecord = result.extend.pageInfo.total;
		}
		
		//解析显示分页条
		function build_page_nav(result){
			/* $("page_nav_area").app */
			$("#page_nav_area").empty();
			var ul = $("<ul></ul>").addClass("pagination");
			var firstPageLi = $("<li></li>").append($("<a></a>").append("首页").attr("href","#"));
			var prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;"));
			if(result.extend.pageInfo.hasPreviousPage == false){
				firstPageLi.addClass("disabled");
				prePageLi.addClass("disabled");
			}else{
				firstPageLi.click(function(){
					to_page(1);
				});
				prePageLi.click(function(){
					to_page(result.extend.pageInfo.pageNum - 1);
				});
			}
			
			var lastPageLi = $("<li></li>").append($("<a></a>").append("末页").attr("href","#"));
			var nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;"));
			if(result.extend.pageInfo.hasNextPage == false){
				lastPageLi.addClass("disabled");
				nextPageLi.addClass("disabled");
			}else {
				lastPageLi.click(function(){
					to_page(result.extend.pageInfo.pages);
				});
				nextPageLi.click(function(){
					to_page(result.extend.pageInfo.pageNum + 1);
				});
			}
			//先添加首页和前一页
			ul.append(firstPageLi).append(prePageLi);
			
			//遍历显示信息
			$.each(result.extend.pageInfo.navigatepageNums, function(index, item){
				var numLi = $("<li></li>").append($("<a></a>").append(item));
				if(result.extend.pageInfo.pageNum == item){
					numLi.addClass("active");
				}
				numLi.click(function(){
					to_page(item);
				});
				ul.append(numLi);//添加要显示的页
			});
			//最后添加后一页和末页
			ul.append(nextPageLi).append(lastPageLi);
		
			var navEle = $("<nav></nav>").append(ul);
			navEle.appendTo("#page_nav_area");
		}
		
		//清空表单样式及内容
		function reset_form(ele){
			$(ele)[0].reset();
			//清空表单样式
			$(ele).find("*").removeClass("has-error has-success");
			$(ele).find(".help-block").text("");
		}
		
		//点击新增按钮，弹出模态框
		$("#AddEmp").click(function(){
			//清除表单数据(表单完整重置(表单的数据，表单的样式))
			//注意：jquery没有reset()方法，于是我们用dom的reset()方法
			//$("#myModalAddEmp form")[0].reset();
			reset_form("#myModalAddEmp form");
			//发送ajax请求，查出部门信息，显示在下拉列表中
			getDepts();
			
			//弹出模态框
			$("#myModalAddEmp").modal({
				backdrop:"static"
			});
		});
		
		//查出所有的部门信息
		function getDepts(){
			$.ajax({
				url:"${APP_PATH}/depts",
				type:"GET",
				success:function(result){
					/* extend
					{depts: [{deptId: 1, deptName: "开发部"}, {deptId: 2, deptName: "测试部"}]} */
					//console.log(result);
					$.each(result.extend.depts, function(){
						var optionEle = $("<option></option>").append(this.deptName).attr("value", this.deptId);
						optionEle.appendTo("#myModalAddEmp select");
					});
				}
			});
		} 
		
		
		//校验表单数据
		function validate_add_form(){
			//1.拿到要校验的数据，使用正则表达式
			var empName = $("#empName_add_input").val();
			var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
			if(!regName.test(empName)){
				//alert("用户名可以是2-5位中文或者6-16位英文和数字的组合");
				//每一次校验之前都应该清空之前的元素
				show_validate_msg("#empName_add_input","error","用户名可以是2-5位中文或者6-16位英文和数字的组合");
				return false;
			}else{
				show_validate_msg("#empName_add_input","success","");
			}
			
			//2.校验邮箱信息
			var email = $("#email_add_input").val();
			var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
			if(!regEmail.test(email)){
				//alert("邮箱格式不正确");
				show_validate_msg("#email_add_input","error","邮箱格式不正确");
				/* $("#email_add_input").parent().addClass("has-error");
				$("#email_add_input").next("span").text("邮箱格式不正确"); */
				return false;
			}else {
				show_validate_msg("#email_add_input","success","");
				/* $("#email_add_input").parent().addClass("has-success");
				$("#email_add_input").next("span").text(""); */
			}
			
			return true;
		}
		
		//检验用户名是否可用
		$("#empName_add_input").change(function(){
			//发送ajax请求校验用户名是否可用
			var empName = this.value;
			$.ajax({
				url:"${APP_PATH}/checkuser",
				type:"POST",
				data:"empName="+empName,
				success:function(result){
					if(result.code==100){
						show_validate_msg("#empName_add_input","success","用户名可用");
						$("#emp_save_btn").attr("ajax-va","success");
					}else{
						show_validate_msg("#empName_add_input","error",result.extend.va_msg);
						$("#emp_save_btn").attr("ajax-va","error");
					}
				}
			})
		})
		
		
		//显示校验结果的错误信息
		function show_validate_msg(ele,status,msg){
			//清除当前元素的校验状态
			$(ele).parent().removeClass("has-success has-error");//移除class中的属性
			$(ele).next("span").text("");//将span中的文字清空
			
			if("success"==status){
				$(ele).parent().addClass("has-success");
				$(ele).next("span").text(msg);
			}else if("error"==status){
				$(ele).parent().addClass("has-error");
				$(ele).next("span").text(msg);
			}
				
		}
		
		$("#emp_save_btn").click(function(){
			//1.模态框种填写的表单数据提交给服务器进行保存
			//1.先要对提交给服务器的数据进行校验
			if(!validate_add_form()){
				return false;
			} 
			//1.判断之前的ajax用户名校验是否成功。如果成功.
			if($(this).attr("ajax-va")=="error"){
				return false;
			}
			
			//2.发送ajax请求保存员工
			$.ajax({
				url:"${APP_PATH}/emp",
				type:"POST",
				data:$("#myModalAddEmp form").serialize(),
				success:function(result){
					//alert(result.msg);
					if(result.code == 100){
						//员工保存成功
						//1.关闭模态框
						$("#myModalAddEmp").modal('hide');
						//2.来到最后一页，显示刚才保存的数据
						to_page(totalRecord);
					} else {
						//显示错误信息
						//有哪个字段的错误信息，就显示哪个字段的信息
						if(undefined != result.extend.errorFields.email){
							//显示邮箱错误信息
							show_validate_msg("#email_add_input","error",result.extend.errorFields.email);
						}
						if(undefined != result.extend.errorFields.empName){
							//显示员工名字错误信息
							show_validate_msg("#empName_add_input","error",result.extend.errorFields.empName);
						}
					}
				}
			})
		});
	</script>
	
</body>
</html>