package io.github.xeyez.service;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import io.github.xeyez.domain.ReplyCriteria;
import io.github.xeyez.domain.ReplyVO;
import io.github.xeyez.persistence.ReplyDAO;

@Service
public class ReplyServiceImpl implements ReplyService {

	@Inject
	private ReplyDAO dao;
	
	@Override
	public void add(ReplyVO vo) throws Exception {
		dao.create(vo);
	}

	@Override
	public void modify(ReplyVO vo) throws Exception {
		dao.update(vo);
	}

	@Override
	public void remove(long rno) throws Exception {
		dao.delete(rno);
	}

	@Override
	public List<ReplyVO> listAll(long bno) {
		return dao.listAll(bno);
	}
	
	@Override
	public List<ReplyVO> list(long bno, ReplyCriteria cri) throws Exception {
		return dao.list(bno, cri);
	}
	
	@Override
	public long count(long bno) throws Exception {
		return dao.count(bno);
	}

	@Override
	public long recentRno() throws Exception {
		return dao.recentRno();
	}
}
