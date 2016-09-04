package io.github.xeyez.test;

import java.sql.Connection;
import java.util.List;

import javax.inject.Inject;
import javax.sql.DataSource;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import io.github.xeyez.domain.BoardVO;
import io.github.xeyez.domain.Criteria;
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
		BoardVO vo = new BoardVO("userTitle", "userContent", "user");
		dao.create(vo);
	}

	public void testRead() throws Exception {
		logger.info(">>>>>>>>>>>>>>>" + dao.read(1).toString());
	}
	
	public void testListAll() throws Exception {
		logger.info("============== 조회");
		
		List<BoardVO> list = dao.listAll();
		for(BoardVO vo2 : list) {
			logger.info(">>>>>>>>>>>" + vo2.toString());
		}
	}

	
	
	public void testListCri() throws Exception {
		
		Criteria cri = new Criteria(1, 20);
		
		for(BoardVO vo : dao.listCrieria(cri)) {
			logger.info(">>>>>>>>>>>" + vo.toString());
		}
	}
	
	@Test
	public void totalPostCount() throws Exception {
		logger.info(">>>>>>>>>>>>>>" + dao.totalPostCount());
	}
}
