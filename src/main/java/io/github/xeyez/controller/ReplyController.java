package io.github.xeyez.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import io.github.xeyez.domain.PageMaker;
import io.github.xeyez.domain.ReplyCriteria;
import io.github.xeyez.domain.ReplyVO;
import io.github.xeyez.security.CustomUserDetailsService;
import io.github.xeyez.service.ReplyService;

@RestController
@RequestMapping("/replies")
public class ReplyController {
	private Logger logger = LoggerFactory.getLogger(ReplyController.class);
	
	@Inject
	private ReplyService service;
	
	@Inject
	private CustomUserDetailsService userDetailsService;
	
	@Transactional
	@RequestMapping(value = "", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> add(@RequestBody ReplyVO vo, Authentication auth) {
		logger.info("add reply");
		
		ResponseEntity<Map<String, Object>> entity = null;
		Map<String, Object> paramMap = new HashMap<>();
		
		//로그인된 사용자만 댓글 쓰기 허용
		if(!auth.isAuthenticated()) {
			paramMap.put("message", "ACCESS_DENIED");
			return new ResponseEntity<>(paramMap, HttpStatus.BAD_REQUEST);
		}
		
		try {
			service.add(vo);
			// 가장 최근 rno 조회. (= 방금 등록한 글 rno)
			// animation 효과를 주기 위함.
			long recentRno = service.recentRno(vo);
			
			paramMap.put("message", "SUCCESS");
			paramMap.put("rno", recentRno);
			
			entity = new ResponseEntity<>(paramMap, HttpStatus.OK);
		} catch (Exception e) {
			e.printStackTrace();
			
			paramMap.put("message", e.getMessage());
			entity = new ResponseEntity<>(paramMap, HttpStatus.BAD_REQUEST);
		}
		
		return entity;
	}
	
	@RequestMapping(value = "/{rno}", method = {RequestMethod.PUT, RequestMethod.PATCH})
	public ResponseEntity<String> modify(@PathVariable("rno") int rno, @RequestBody ReplyVO vo, Authentication auth) throws Exception {
		logger.info("replyer : " + vo.getReplyer() + " / id : " + auth.getName());
		
		// 로그인한 id와 작성자가가 같은 지 비교 (단, 예외로 admin은 허용)
		if(!userDetailsService.hasAuthority(vo.getReplyer(), auth)) {
			return new ResponseEntity<>("ACCESS_DENIED", HttpStatus.BAD_REQUEST);
		}
		
		logger.info("modify reply");
		
		ResponseEntity<String> entity = null;
		
		try {
			vo.setRno(rno);
			service.modify(vo);
			entity = new ResponseEntity<>("SUCCESS", HttpStatus.OK);
		} catch (Exception e) {
			e.printStackTrace();
			entity = new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
		}
		
		return entity;
	}
	
	@RequestMapping(value = "/{rno}", method = RequestMethod.DELETE)
	public ResponseEntity<String> remove(@PathVariable("rno") int rno, @RequestBody String replyer, Authentication auth) throws Exception {
		logger.info("replyer : " + replyer + " / id : " + auth.getName());
		
		// 로그인한 id와 작성자가가 같은 지 비교 (단, 예외로 admin은 허용)
		if(!userDetailsService.hasAuthority(replyer, auth)) {
			return new ResponseEntity<>("ACCESS_DENIED", HttpStatus.BAD_REQUEST);
		}
		
		logger.info("remove reply " + rno);
		
		ResponseEntity<String> entity = null;
		
		try {
			service.remove(rno);
			entity = new ResponseEntity<>("SUCCESS", HttpStatus.OK);
		} catch (Exception e) {
			e.printStackTrace();
			entity = new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
		}
		
		return entity;
	}
	
	@RequestMapping(value = "/all/{bno}", method = RequestMethod.GET)
	public ResponseEntity<List<ReplyVO>> listAll(@PathVariable("bno") long bno) {
		logger.info("show all reply");
		
		ResponseEntity<List<ReplyVO>> entity = null;
		
		try {
			List<ReplyVO> list = service.listAll(bno);
			
			entity = new ResponseEntity<>(list, HttpStatus.OK);
		} catch (Exception e) {
			e.printStackTrace();
			entity = new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}
		
		return entity;
	}
	
	@RequestMapping(value = "/{bno}/{page}", method = RequestMethod.GET)
	public ResponseEntity<Map<String, Object>> list(@PathVariable("bno") long bno, @PathVariable("page") long page) {
		logger.info("show reply // bno : " + bno + "/page : " + page);
		
		ResponseEntity<Map<String, Object>> entity = null;
		
		try {
			ReplyCriteria cri = new ReplyCriteria();
			cri.setPage(page);
			
			List<ReplyVO> list = service.list(bno, cri);
			
			PageMaker pageMaker = new PageMaker();
			//무한 Scrolling이기 때문에 변경
			pageMaker.setPageCount(Integer.MAX_VALUE);
			
			long replyCount = service.count(bno);
			pageMaker.calcPaging(cri, replyCount);

			Map<String, Object> map = new HashMap<>();
			map.put("list", list);
			map.put("pageMaker", pageMaker);
			
			entity = new ResponseEntity<>(map, HttpStatus.OK);
		} catch (Exception e) {
			e.printStackTrace();
			entity = new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}
		
		return entity;
	}
	
	// 삭제할 때 사용
	@RequestMapping(value = "/count/{bno}", method = RequestMethod.POST)
	public ResponseEntity<Long> count(@PathVariable("bno") long bno) {
		
		logger.info("replyCount, bno : " + bno);
		
		ResponseEntity<Long> entity = null;
		
		try {
			long replyCnt = service.count(bno);
			logger.info("replyCnt : " + replyCnt);
			
			return new ResponseEntity<>(replyCnt, HttpStatus.OK);
		} catch (Exception e) {
			e.printStackTrace();
			entity = new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}
		
		return entity;
	}
}
