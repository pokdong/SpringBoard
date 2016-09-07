package io.github.xeyez.persistence;

import java.util.List;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import io.github.xeyez.domain.ReplyVO;

@Repository
public class ReplyDAOImpl implements ReplyDAO {

	@Inject
	private SqlSession session;
	
	@Value("${mybatis.reply}")
	private String namespace;
	
	@Override
	public List<ReplyVO> list(long bno) throws Exception {
		return session.selectList(namespace + ".list", bno);
	}

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
	public long count(long bno) throws Exception {
		return session.selectOne(namespace + ".count", bno);
	}
}
