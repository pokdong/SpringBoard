package io.github.xeyez.service;

import java.util.List;

import io.github.xeyez.domain.BoardVO;
import io.github.xeyez.domain.SearchCriteria;

public interface BoardService {
	void write(BoardVO vo) throws Exception;

	BoardVO read(long bno) throws Exception;

	void modify(BoardVO vo) throws Exception;

	void remove(long bno) throws Exception;
	
	List<BoardVO> list(SearchCriteria cri) throws Exception;
	
	long count(SearchCriteria cri) throws Exception;
	
	List<String> getAttach(long bno) throws Exception;
}
