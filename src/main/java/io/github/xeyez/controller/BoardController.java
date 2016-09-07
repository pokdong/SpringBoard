package io.github.xeyez.controller;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import io.github.xeyez.domain.BoardVO;
import io.github.xeyez.domain.PageMaker;
import io.github.xeyez.domain.SearchCriteria;
import io.github.xeyez.service.BoardService;

@Controller
@RequestMapping("/board/*")
public class BoardController {
	private Logger logger = LoggerFactory.getLogger(BoardController.class);
	
	@Inject
	private BoardService service;
	
	// parameter에 pageMaker의 존재 이유 : pageCount를 사용하기 위함. 
	@RequestMapping(value = "/list", method = RequestMethod.GET)
	public void list(@ModelAttribute("cri") SearchCriteria cri, @ModelAttribute("pageMaker") PageMaker pageMaker, Model model) throws Exception {
		logger.info(">>>>>>>>>>>>>>> show listPage");
		
		logger.info(">>>>>>>>>> cri : " + cri.toString());
		model.addAttribute("list", service.list(cri));

		long postCount = service.count(cri);
		pageMaker.calcPaging(cri, postCount);
		
		logger.info("pageMaker : " + pageMaker.toString());
	}
	
	@RequestMapping(value = "/write", method = RequestMethod.GET)
	public void writeGET(BoardVO board, @ModelAttribute("cri") SearchCriteria cri, @ModelAttribute("pageMaker") PageMaker pageMaker, Model model) throws Exception {
		logger.info("............. write get");
	}
	
	@RequestMapping(value = "/write", method = RequestMethod.POST)
	public String writePOST(BoardVO board, SearchCriteria cri, PageMaker pageMaker, RedirectAttributes rttr) throws Exception {
		
		logger.info("............. write post");
		logger.info(board.toString());
		
		service.write(board);
		
		rttr.addAttribute("postCount", cri.getPostCount());
		rttr.addAttribute("pageCount", pageMaker.getPageCount());
		
		rttr.addFlashAttribute("result", "SUCCESS");
		
		return "redirect:/board/list";
	}
	
	@RequestMapping(value = "/read", method = RequestMethod.GET)
	public void read(@RequestParam("bno") long bno, @ModelAttribute("cri") SearchCriteria cri, @ModelAttribute("pageMaker") PageMaker pageMaker, Model model) throws Exception {
		logger.info(">>>>>>>>>>>>>>> read");
		
		BoardVO vo = service.read(bno);
		if(vo == null)
			throw new NullPointerException("존재하지 않는 게시물입니다.");
		
		logger.info(cri.toString());
		
		model.addAttribute(vo);
	}
	
	@RequestMapping(value = "/remove", method = RequestMethod.POST)
	public String remove(@RequestParam("bno") int bno, SearchCriteria cri, PageMaker pageMaker, RedirectAttributes rttr) throws Exception {
		logger.info(">>>>>>>>>>>>>>> remove");
		logger.info(cri.toString());
		
		service.remove(bno);
		
		makeQuery(rttr, cri, pageMaker);
		rttr.addFlashAttribute("result", "SUCCESS");
		
		return "redirect:/board/list";
	}
	
	@RequestMapping(value = "/modify", method = RequestMethod.GET)
	public void modifyGET(@RequestParam("bno") int bno, @ModelAttribute("cri") SearchCriteria cri, @ModelAttribute("pageMaker") PageMaker pageMaker, Model model) throws Exception {
		logger.info(">>>>>>>>>>>>>>> modifyGET");
		logger.info(pageMaker.toString());
		
		model.addAttribute(service.read(bno));
	}
	
	@RequestMapping(value = "/modify", method = RequestMethod.POST)
	public String modifyPOST(BoardVO boardVO, SearchCriteria cri, PageMaker pageMaker, RedirectAttributes rttr) throws Exception {
		logger.info(">>>>>>>>>>>>>>> modifyPOST");
		logger.info(boardVO.toString());
		logger.info(cri.toString());
		
		service.modify(boardVO);
		
		makeQuery(rttr, cri, pageMaker);
		rttr.addFlashAttribute("result", "SUCCESS");
		
		return "redirect:/board/list";
	}
	
	private void makeQuery(RedirectAttributes rttr, SearchCriteria cri, PageMaker pageMaker) {
		rttr.addAttribute("page", cri.getPage());
		rttr.addAttribute("postCount", cri.getPostCount());
		
		rttr.addAttribute("pageCount", pageMaker.getPageCount());

		String searchType = cri.getSearchType();
		String keyword = cri.getKeyword();
		
		boolean isNullSearchCondition = searchType == null || keyword == null;
		boolean isEmptySearchCondition = false;
		boolean isEqualComma = false;
		if(!isNullSearchCondition) {
			searchType = searchType.trim();
			keyword = keyword.trim();
			
			isEmptySearchCondition = (searchType.isEmpty() || keyword.isEmpty()) 
					|| (searchType.equals("") || keyword.equals(""));
			
			//빈 데이터 보내면 ","가 전송되기 때문
			isEmptySearchCondition = searchType.equals(",") || keyword.equals(",");
		}
		
		if(!isNullSearchCondition && !isEmptySearchCondition && !isEqualComma) {
			if(!searchType.equals("") && !keyword.equals("")) {
				rttr.addAttribute("searchType", cri.getSearchType());
				rttr.addAttribute("keyword", cri.getKeyword());
			}
		}
	}
}