package io.github.xeyez.service;

import java.util.List;

import io.github.xeyez.domain.ReplyVO;

public interface ReplyService {
	List<ReplyVO> list(long bno) throws Exception;
	
	void add(ReplyVO vo) throws Exception;
	
	void modify(ReplyVO vo) throws Exception;
	
	void remove(long rno) throws Exception;
	
	long count(long bno) throws Exception;
}
