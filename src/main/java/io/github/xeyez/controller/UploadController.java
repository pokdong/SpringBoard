package io.github.xeyez.controller;

import java.io.FileInputStream;
import java.io.InputStream;
import java.util.Iterator;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
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
	
	@RequestMapping(value = "/uploadAjax", method = RequestMethod.GET)
	public void uploadAjax() {
	}
	
	@ResponseBody
	@RequestMapping(value = "/uploadAjax", method = RequestMethod.POST, produces = "text/plain; charset=UTF-8")
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

	public ResponseEntity<byte[]> displayFile(String fileName) throws Exception {
		ResponseEntity<byte[]> entity = null;
		
		logger.info("fileName : " + fileName);
		
		try (InputStream in = new FileInputStream(uploadPath + fileName)) {
			String extension = UploadFileUtils.getExtension(fileName);
			
			HttpHeaders headers = new HttpHeaders();
			
			MediaType mediaType = UploadFileUtils.getMediaType(extension);
			if(mediaType != null) {
				headers.setContentType(mediaType);
			}
			else {
				fileName = fileName.substring(fileName.indexOf("_") + 1);
				headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
				
				String headerName = "Content-Disposition";
				String headerValue = "attachment; filename=\"" + new String(fileName.getBytes("UTF-8"), "ISO-8859-1") + "\"";
				headers.add(headerName, headerValue);
				
				entity = new ResponseEntity<>(IOUtils.toByteArray(in), headers, HttpStatus.CREATED);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			entity = new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}
		
		return entity;
	}
}