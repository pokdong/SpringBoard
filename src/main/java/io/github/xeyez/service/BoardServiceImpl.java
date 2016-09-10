package io.github.xeyez.service;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

import io.github.xeyez.domain.BoardVO;
import io.github.xeyez.domain.SearchCriteria;
import io.github.xeyez.persistence.BoardDAO;

@Service
public class BoardServiceImpl implements BoardService {

	@Inject
	private BoardDAO dao;
	
	@Transactional
	@Override
	public void write(BoardVO vo) throws Exception {
		dao.create(vo);
		
		String[] files = vo.getFiles();
		if(files != null) {
			for(String fileName : files) {
				dao.addAttach(fileName);
			}
		}
	}

	@Transactional(isolation=Isolation.READ_COMMITTED)
	@Override
	public BoardVO read(long bno) throws Exception {
		dao.updateViewCount(bno);
		return dao.read(bno);
	}

	@Override
	public void modify(BoardVO vo) throws Exception {
		dao.update(vo);
	}

	@Override
	public void remove(long bno) throws Exception {
		dao.delete(bno);
	}

	@Override
	public List<BoardVO> list(SearchCriteria cri) throws Exception {
		return dao.list(cri);
	}

	@Override
	public long count(SearchCriteria cri) throws Exception {
		return dao.count(cri);
	}
}
