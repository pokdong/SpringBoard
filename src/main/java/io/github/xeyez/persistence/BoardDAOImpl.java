package io.github.xeyez.persistence;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import io.github.xeyez.domain.BoardVO;
import io.github.xeyez.domain.SearchCriteria;

@Repository
public class BoardDAOImpl implements BoardDAO {

	@Inject
	private SqlSession session;
	
	@Value("${mybatis.board}")
	private String namespace;
	
	@Override
	public void create(BoardVO vo) throws Exception {
		session.insert(namespace + ".create", vo);
	}

	@Override
	public BoardVO read(long bno) throws Exception {
		return session.selectOne(namespace + ".read", bno);
	}

	@Override
	public void update(BoardVO vo) throws Exception {
		session.update(namespace + ".update", vo);
	}

	@Override
	public void delete(long bno) throws Exception {
		session.delete(namespace + ".delete", bno);
	}
	
	@Override
	public List<BoardVO> list(SearchCriteria cri) throws Exception {
		return session.selectList(namespace + ".list", cri);
	}

	@Override
	public long count(SearchCriteria cri) throws Exception {
		return session.selectOne(namespace + ".count", cri);
	}

	@Override
	public void updateReplyCount(long bno, long amount) throws Exception {
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("bno", bno);
		paramMap.put("amount", amount);
		
		session.update(namespace + ".updateReplyCount", paramMap);
	}

	@Override
	public void updateViewCount(long bno) throws Exception {
		session.update(namespace + ".updateViewCount", bno);
	}
	
	@Override
	public void addAttach(String fullName) throws Exception {
		session.selectOne(namespace + ".addAttach", fullName);
	}
}
