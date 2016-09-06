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
import io.github.xeyez.domain.Criteria;
import io.github.xeyez.domain.PageMaker;
import io.github.xeyez.domain.SearchCriteria;
import io.github.xeyez.service.BoardService;

@Controller
@RequestMapping("/board/*")
public class BoardController {
	private Logger logger = LoggerFactory.getLogger(BoardController.class);
	
	@Inject
	private BoardService service;
	
	@RequestMapping(value = "/listAll", method = RequestMethod.GET)
	public void listAll(Model model) throws Exception {
		logger.info(">>>>>>>>>>>>>>> show list all");
		
		model.addAttribute("list", service.listAll());
	}
	
	@RequestMapping(value = "/listCri", method = RequestMethod.GET)
	public void listCriteria(Criteria cri, Model model) throws Exception {
		logger.info(">>>>>>>>>>>>>>> show listCriteria");
		model.addAttribute("list", service.listCriteria(cri));
	}
	
	@RequestMapping(value = "/listPage", method = RequestMethod.GET)
	public void listPage(Criteria cri, Model model) throws Exception {
		logger.info(">>>>>>>>>>>>>>> show listPage");
		
		logger.info(">>>>>>>>>> cri : " + cri.toString());
		model.addAttribute("list", service.listCriteria(cri));
		
		int totalPostCount = service.totalPostCount();
		PageMaker pageMaker = new PageMaker();
		pageMaker.calcPaging(cri, totalPostCount);
		model.addAttribute("pageMaker", pageMaker);
		
		logger.info("pageMaker : " + pageMaker.toString());
	}

	
	
	// parameter에 pageMaker의 존재 이유 : pageCount를 사용하기 위함. 
	@RequestMapping(value = "/list", method = RequestMethod.GET)
	public void list(@ModelAttribute("cri") SearchCriteria cri, @ModelAttribute("pageMaker") PageMaker pageMaker, Model model) throws Exception {
		logger.info(">>>>>>>>>>>>>>> show listPage");
		
		logger.info(">>>>>>>>>> cri : " + cri.toString());
		//model.addAttribute("list", service.listCriteria(cri));
		model.addAttribute("list", service.listSearch(cri));

		//int totalPostCount = service.totalPostCount();
		int searchCount = service.searchCount(cri);
		pageMaker.calcPaging(cri, searchCount);
		
		logger.info("pageMaker : " + pageMaker.toString());
	}
	
	
	
	
	
	@RequestMapping(value = "/write", method = RequestMethod.GET)
	public void writeGET(BoardVO board, Model model) throws Exception {
		logger.info("............. write get");
	}
	
	@RequestMapping(value = "/write", method = RequestMethod.POST)
	public String writePOST(BoardVO board, RedirectAttributes rttr) throws Exception {
		
		logger.info("............. write post");
		logger.info(board.toString());
		
		service.write(board);
		
		rttr.addFlashAttribute("result", "SUCCESS");
		
		return "redirect:/board/list";
	}
	
	@RequestMapping(value = "/read", method = RequestMethod.GET)
	public void read(@RequestParam("bno") int bno, @ModelAttribute("cri") SearchCriteria cri, @ModelAttribute("pageMaker") PageMaker pageMaker, Model model) throws Exception {
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
		
		service.remove(bno);
		
		logger.info(cri.toString());
		
		
		
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
		
		service.modify(boardVO);
		
		logger.info(cri.toString());
		
		
		
		
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
		
		
		
		
		
		rttr.addFlashAttribute("result", "SUCCESS");
		
		return "redirect:/board/list";
	}
}