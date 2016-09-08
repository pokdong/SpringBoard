package io.github.xeyez.persistence;

import java.util.List;

import io.github.xeyez.domain.ReplyCriteria;
import io.github.xeyez.domain.ReplyVO;

public interface ReplyDAO {
	void create(ReplyVO vo) throws Exception;
	
	void update(ReplyVO vo) throws Exception;
	
	void delete(long rno) throws Exception;
	
	List<ReplyVO> listAll(long bno);
	
	List<ReplyVO> list(long bno, ReplyCriteria cri) throws Exception;
	
	long count(long bno) throws Exception;
	
	long recentRno() throws Exception;
}
