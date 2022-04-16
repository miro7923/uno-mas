package com.unomas.web;

import java.sql.Connection;
import java.sql.SQLException;

import javax.inject.Inject;
import javax.sql.DataSource;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(
		locations = {"file:src/main/webapp/WEB-INF/spring/root-context.xml"}
		)
public class DataSourceTest {
	
	private static final Logger log = LoggerFactory.getLogger(DataSourceTest.class);

	@Inject
	private DataSource ds;
	
	@Test
	public void DB연결테스트()
	{
		log.info("ds: "+ds);
		
		try {
			Connection con = ds.getConnection();
			
			log.info("DB 연결 성공");
			log.info("con: "+con);
		}
		catch (SQLException e) {
			e.printStackTrace();
		}
	}
}
