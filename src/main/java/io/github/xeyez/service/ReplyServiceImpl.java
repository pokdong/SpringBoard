package io.github.xeyez.service;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import io.github.xeyez.domain.ReplyCriteria;
import io.github.xeyez.domain.ReplyVO;
import io.github.xeyez.persistence.BoardDAO;
import io.github.xeyez.persistence.ReplyDAO;

@Service
public class ReplyServiceImpl implements ReplyService {

	@Inject
	private ReplyDAO replyDAO;
	
	@Inject
	private BoardDAO boardDAO;
	
	@Transactional
	@Override
	public void add(ReplyVO vo) throws Exception {
		replyDAO.create(vo);
		boardDAO.updateReplyCount(vo.getBno(), 1);
	}

	@Override
	public void modify(ReplyVO vo) throws Exception {
		replyDAO.update(vo);
	}

	@Transactional
	@Override
	public void remove(long rno) throws Exception {
		long bno = replyDAO.getBno(rno);
		replyDAO.delete(rno);
		boardDAO.updateReplyCount(bno, -1);
	}

	@Override
	public List<ReplyVO> listAll(long bno) {
		return replyDAO.listAll(bno);
	}
	
	@Override
	public List<ReplyVO> list(long bno, ReplyCriteria cri) throws Exception {
		return replyDAO.list(bno, cri);
	}
	
	@Override
	public long count(long bno) throws Exception {
		return replyDAO.count(bno);
	}

	@Override
	public long recentRno(ReplyVO vo) throws Exception {
		return replyDAO.recentRno(vo);
	}
}
