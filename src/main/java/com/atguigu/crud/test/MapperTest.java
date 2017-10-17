package com.atguigu.crud.test;

import java.util.UUID;

import javax.websocket.Session;

import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.atguigu.crud.bean.Department;
import com.atguigu.crud.bean.Employee;
import com.atguigu.crud.dao.DepartmentMapper;
import com.atguigu.crud.dao.EmployeeMapper;

/**
 * 测试dao层的工作
 * 推荐 Spring 项目就可以使用Spring的单元测试，可以自动的注入我们需要的组件
 * 1.导入SpringTest 模块
 * 2.@ContextConfiguration 指定 Spring 配置文件的位置
 * 3.@RunWith 指定使用spring 的单元测试还是用 eclipse 自带的单元测试
 * 4.直接Autowire 要使用的组件即可
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath*:applicationContext.xml"})
public class MapperTest {
	
	@Autowired
	DepartmentMapper departmentMapper;
	
	@Autowired
	EmployeeMapper employeeMapper;
	
	@Autowired
	SqlSession sqlSession;
	
	@Test
	public void testCRUD(){
//		//1.创建ioc容器
//		ApplicationContext ioc = new ClassPathXmlApplicationContext("applicationContext.xml");
//		//2.从容器中获取mapper
//		DepartmentMapper bean = ioc.getBean(DepartmentMapper.class);
		System.out.println(departmentMapper);
		System.out.println(employeeMapper);
		
//		//1.插入几个部门
//		departmentMapper.insertSelective(new Department(null,"开发部"));
//		departmentMapper.insertSelective(new Department(null,"测试部"));
//		System.out.println(departmentMapper.selectByPrimaryKey(1));
		
		//2.生成员工数据，测试员工插入
//		employeeMapper.insertSelective(new Employee(null, "Jerry", "M", "jerry@atguigu.com", 1));

//		Employee ee = new Employee();
//		ee = employeeMapper.selectByPrimaryKey(1);
//		System.out.println(ee);
		
		//3.批量插入多个员工
		/* 这样的for循环并不是批量插入
		 * for(){
		 * 		employeeMapper.insertSelective(new Employee());
		 * }
		 */
		
		//使用sqlsession （一个就代表一个数据库连接）
		EmployeeMapper mapper = (EmployeeMapper) sqlSession.getMapper(EmployeeMapper.class);
		for(int i=0;i<100;i++){
			String uid = UUID.randomUUID().toString().substring(0,5) + i;
			mapper.insertSelective(new Employee(null, uid, "M", uid+"@atguigu.com", 1));
		}
		System.out.println("批量完成");
	}

}
