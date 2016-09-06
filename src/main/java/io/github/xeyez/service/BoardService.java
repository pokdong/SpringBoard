package io.github.xeyez.service;

import java.util.List;

import io.github.xeyez.domain.BoardVO;
import io.github.xeyez.domain.Criteria;
import io.github.xeyez.domain.SearchCriteria;

public interface BoardService {
	void write(BoardVO vo) throws Exception;

	BoardVO read(int bno) throws Exception;

	void modify(BoardVO vo) throws Exception;

	void remove(int bno) throws Exception;

	List<BoardVO> listAll() throws Exception;
	
	List<BoardVO> listCriteria(Criteria cri) throws Exception;
	
	int totalPostCount() throws Exception;
	
	List<BoardVO> listSearch(SearchCriteria cri) throws Exception;
	
	int searchCount(SearchCriteria cri) throws Exception;
}
