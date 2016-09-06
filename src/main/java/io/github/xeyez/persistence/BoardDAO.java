package io.github.xeyez.persistence;

import java.util.List;

import io.github.xeyez.domain.BoardVO;
import io.github.xeyez.domain.SearchCriteria;

public interface BoardDAO {
	void create(BoardVO vo) throws Exception;

	BoardVO read(int bno) throws Exception;

	void update(BoardVO vo) throws Exception;

	void delete(int bno) throws Exception;

	
	int totalPostCount() throws Exception;
	
	
	List<BoardVO> listSearch(SearchCriteria cri) throws Exception;
	
	int searchCount(SearchCriteria cri) throws Exception;
}