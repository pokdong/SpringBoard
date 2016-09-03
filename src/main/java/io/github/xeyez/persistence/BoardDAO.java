package io.github.xeyez.persistence;

import java.util.List;

import io.github.xeyez.domain.BoardVO;

public interface BoardDAO {
	void create(BoardVO vo) throws Exception;

	BoardVO read(int bno) throws Exception;

	void update(BoardVO vo) throws Exception;

	void delete(int bno) throws Exception;

	List<BoardVO> listAll() throws Exception;
}