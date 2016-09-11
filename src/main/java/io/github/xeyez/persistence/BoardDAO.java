package io.github.xeyez.persistence;

import java.util.List;

import io.github.xeyez.domain.BoardVO;
import io.github.xeyez.domain.SearchCriteria;

public interface BoardDAO {
	void create(BoardVO vo) throws Exception;

	BoardVO read(long bno) throws Exception;

	void update(BoardVO vo) throws Exception;

	void delete(long bno) throws Exception;
	
	List<BoardVO> list(SearchCriteria cri) throws Exception;
	
	long count(SearchCriteria cri) throws Exception;
	
	void updateReplyCount(long bno, long amount) throws Exception;
	
	void updateViewCount(long bno) throws Exception;

	void addAttach(String fullName) throws Exception;
}