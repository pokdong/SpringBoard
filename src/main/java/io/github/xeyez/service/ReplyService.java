package io.github.xeyez.service;

import java.util.List;

import io.github.xeyez.domain.ReplyCriteria;
import io.github.xeyez.domain.ReplyVO;

public interface ReplyService {
	void add(ReplyVO vo) throws Exception;

	void modify(ReplyVO vo) throws Exception;

	void remove(long rno) throws Exception;

	List<ReplyVO> listAll(long bno);
	
	List<ReplyVO> list(long bno, ReplyCriteria cri) throws Exception;
	
	long count(long bno) throws Exception;
	
	long recentRno() throws Exception;
}
