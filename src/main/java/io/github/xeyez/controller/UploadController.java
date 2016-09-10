package io.github.xeyez.controller;

import java.io.File;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Iterator;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import io.github.xeyez.util.UploadFileUtils;

@Controller
public class UploadController {
	
	private static final Logger logger = LoggerFactory.getLogger(UploadController.class);

	@Resource
	private String uploadPath;
	
	@RequestMapping(value = "/uploadForm", method = RequestMethod.GET)
	public void uploadForm() {
	}
	
	@RequestMapping(value = "/uploadForm", method = RequestMethod.POST)
	public void uploadForm(MultipartFile file, Model model) throws Exception {
		String name = file.getOriginalFilename();
		long size = file.getSize();
		String contentType = file.getContentType();
		
		logger.info(name + "/" + size + "/" + contentType);
		
		String savedName = UUID.randomUUID().toString() + "_" + file.getOriginalFilename();
		String formattedDateTime = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));
		String dirPath = uploadPath + File.separator + formattedDateTime;
		File newFile = new File(dirPath, savedName);

		File dir = new File(dirPath);
		if(!dir.exists()) {
			dir.mkdirs();
		}
		
		FileCopyUtils.copy(file.getBytes(), newFile);
		
		model.addAttribute("savedName", savedName);
	}
	
	@RequestMapping(value = "/uploadAjax", method = RequestMethod.GET)
	public void uploadAjax() {
	}
	
	@RequestMapping(value = "/uploadAjax", method = RequestMethod.POST, produces = "text/plain; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<String> uploadAjax(MultipartHttpServletRequest req, HttpServletResponse res) throws Exception {
	    
		Iterator<String> itr =  req.getFileNames();
	    MultipartFile mpf = req.getFile(itr.next());
	    
	    String originFileName = mpf.getOriginalFilename();
	    long size = mpf.getSize();
		String contentType = mpf.getContentType();
		
		logger.info(originFileName + "/" + size + "/" + contentType);
		
		
		String fileName = UploadFileUtils.uploadFile(uploadPath, mpf);
		
	     
		return new ResponseEntity<>(fileName, HttpStatus.CREATED);
	}

}