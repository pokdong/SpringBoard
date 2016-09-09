package io.github.xeyez.persistence;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import io.github.xeyez.domain.ReplyCriteria;
import io.github.xeyez.domain.ReplyVO;

@Repository
public class ReplyDAOImpl implements ReplyDAO {

	@Inject
	private SqlSession session;
	
	@Value("${mybatis.reply}")
	private String namespace;
	
	@Override
	public void create(ReplyVO vo) throws Exception {
		session.insert(namespace + ".create", vo);
	}

	@Override
	public void update(ReplyVO vo) throws Exception {
		session.update(namespace + ".update", vo);
	}

	@Override
	public void delete(long rno) throws Exception {
		session.delete(namespace + ".delete", rno);
	}

	@Override
	public List<ReplyVO> listAll(long bno) {
		return session.selectList(namespace + ".listAll", bno);
	}
	
	@Override
	public List<ReplyVO> list(long bno, ReplyCriteria cri) throws Exception {
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("bno", bno);
		paramMap.put("cri", cri);
		
		return session.selectList(namespace + ".list", paramMap);
	}
	
	@Override
	public long count(long bno) throws Exception {
		return session.selectOne(namespace + ".count", bno);
	}

	@Override
	public long recentRno(ReplyVO vo) throws Exception {
		return session.selectOne(namespace + ".recentRno", vo);
	}

	@Override
	public long getBno(long rno) {
		return session.selectOne(namespace + ".getBno", rno);
	}
}
