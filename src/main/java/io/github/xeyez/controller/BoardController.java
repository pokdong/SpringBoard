package io.github.xeyez.controller;

import javax.inject.Inject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import io.github.xeyez.domain.BoardVO;
import io.github.xeyez.service.BoardService;

@Controller
@RequestMapping("/board/*")
public class BoardController {
	private Logger logger = LoggerFactory.getLogger(BoardController.class);
	
	@Inject
	private BoardService service;
	
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
		
		return "redirect:/board/listAll";
	}
	
	@RequestMapping(value = "/listAll", method = RequestMethod.GET)
	public void listAll(Model model) throws Exception {
		logger.info(">>>>>>>>>>>>>>> show list all");
		
		model.addAttribute("list", service.listAll());
	}
	
	@RequestMapping(value = "/read", method = RequestMethod.GET)
	public void read(@RequestParam("bno") int bno, Model model) throws Exception {
		logger.info(">>>>>>>>>>>>>>> read");
		
		BoardVO vo = service.read(bno);
		if(vo == null)
			throw new NullPointerException("존재하지 않는 게시물입니다.");
		
		model.addAttribute(vo);
	}
	
	@RequestMapping(value = "/remove", method = RequestMethod.POST)
	public String remove(@RequestParam("bno") int bno, RedirectAttributes rttr) throws Exception {
		logger.info(">>>>>>>>>>>>>>> remove");
		
		service.remove(bno);
		
		rttr.addFlashAttribute("result", "SUCCESS");
		
		return "redirect:/board/listAll";
	}
	
	@RequestMapping(value = "/modify", method = RequestMethod.GET)
	public void modifyGET(@RequestParam("bno") int bno, Model model) throws Exception {
		logger.info(">>>>>>>>>>>>>>> modifyGET");
		
		model.addAttribute(service.read(bno));
	}
	
	@RequestMapping(value = "/modify", method = RequestMethod.POST)
	public String modifyPOST(@RequestParam("bno") int bno, BoardVO boardVO, RedirectAttributes rttr) throws Exception {
		logger.info(">>>>>>>>>>>>>>> modifyPOST");
		
		service.modify(boardVO);
		rttr.addFlashAttribute("result", "SUCCESS");
		
		return "redirect:/board/listAll";
	}
}