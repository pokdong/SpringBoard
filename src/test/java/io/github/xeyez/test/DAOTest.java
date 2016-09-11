package io.github.xeyez.test;

import java.sql.Connection;
import java.util.List;

import javax.inject.Inject;
import javax.sql.DataSource;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;

import io.github.xeyez.domain.BoardVO;
import io.github.xeyez.domain.SearchCriteria;
import io.github.xeyez.persistence.BoardDAO;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations={"file:src/main/webapp/WEB-INF/spring/**/*.xml"})
public class DAOTest {

	private DataSource ds;
	
	private Logger logger = LoggerFactory.getLogger(DAOTest.class);
	
	@Inject
	private BoardDAO dao;
	
	public void testConn() throws Exception {
		try (Connection conn = ds.getConnection()){
			System.out.println(">>>>>>>>>>" + conn);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void testCreate() throws Exception {
		logger.info("============== 삽입");
		
		//BoardVO vo = new BoardVO("adminTitle", "adminContent", "admin");
		//BoardVO vo = new BoardVO("managerTitle", "managerContent", "manager");
		//BoardVO vo = new BoardVO("userTitle", "userContent", "user");
		//dao.create(vo);
	}

	public void testRead() throws Exception {
		logger.info(">>>>>>>>>>>>>>>" + dao.read(1).toString());
	}
	
	public void testListSearch() {
		SearchCriteria cri = new SearchCriteria();
		cri.setPage(1);
		cri.setPostCount(20);
		cri.setSearchType("t");
		cri.setKeyword("admin");
		
		try {
			List<BoardVO> list = dao.list(cri);
			
			for(BoardVO vo : list) {
				logger.info(">>>>>>>>>>>" + vo.toString());
			}
		} catch (Exception e) {
			System.out.println("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
			e.printStackTrace();
		}
		
		
		
		try {
			long count = dao.count(cri);
			logger.info("count??? " + count);
		} catch (Exception e) {
			System.out.println("=========================================================");
			e.printStackTrace();
		}
		
	}
	
	
	@Test
	@Transactional
	public void test() throws Exception {
		List<String> list = dao.getAttach(917500);
		
		logger.info("==================================");
		for(String s : list) {
			logger.info(s);
		}
	}
}
