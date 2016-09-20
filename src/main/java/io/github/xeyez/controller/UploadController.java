package io.github.xeyez.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.Iterator;

import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import io.github.xeyez.util.UploadFileUtils;

@Controller
public class UploadController {

	private static final Logger logger = LoggerFactory.getLogger(UploadController.class);

	@Value("${attach.uploadPath}")
	private String uploadPath;
	
	@Value("${attach.profilePath}")
	private String profilePath;

	/*@RequestMapping(value = "/uploadAjax2", method = RequestMethod.GET)
	public void uploadAjax() {
	}*/
	
	@ResponseBody
	@RequestMapping(value = "/uploadAjax", method = RequestMethod.POST, produces = "text/plain; charset=UTF-8")
	public ResponseEntity<String> uploadAjax(MultipartHttpServletRequest req, HttpServletResponse res)
			throws Exception {

		Iterator<String> itr = req.getFileNames();
		MultipartFile mpf = req.getFile(itr.next());

		String originFileName = mpf.getOriginalFilename();
		long size = mpf.getSize();
		String contentType = mpf.getContentType();

		logger.info(originFileName + "/" + size + "/" + contentType);

		String fileName = UploadFileUtils.uploadFile(uploadPath, mpf);

		return new ResponseEntity<>(fileName, HttpStatus.CREATED);
	}
	
	@ResponseBody
	@RequestMapping(value = "/uploadProfile", method = RequestMethod.POST, produces = "text/plain; charset=UTF-8")
	public ResponseEntity<String> uploadProfile(MultipartHttpServletRequest req, HttpServletResponse res, Authentication auth)
			throws Exception {
		
		if(!auth.isAuthenticated())
			return new ResponseEntity<>("DENIED", HttpStatus.BAD_REQUEST);

		Iterator<String> itr = req.getFileNames();
		MultipartFile mpf = req.getFile(itr.next());

		String originFileName = mpf.getOriginalFilename();
		long size = mpf.getSize();
		String contentType = mpf.getContentType();

		logger.info(originFileName + "/" + size + "/" + contentType);

		//권한을 통하여 id 얻음.
		String profilePathById = profilePath + File.separatorChar + auth.getName();
		logger.info("profilePathById : " + profilePathById);
		
		String fileName = UploadFileUtils.uploadProfile(profilePathById, mpf);

		return new ResponseEntity<>(fileName, HttpStatus.CREATED);
	}

	@ResponseBody
	@RequestMapping("/displayFile")
	public ResponseEntity<byte[]> displayFile(String fileName) throws Exception {

		logger.info("fileName : " + fileName);
		logger.info("uploadPath : " + uploadPath);
		
		ResponseEntity<byte[]> entity = null;

		try (InputStream in = new FileInputStream(uploadPath + fileName)) {
			HttpHeaders headers = new HttpHeaders();
			
			MediaType mediaType = UploadFileUtils.getMediaType(fileName);
			if (mediaType != null) {
				headers.setContentType(mediaType);
			} else {
				fileName = fileName.substring(fileName.indexOf("_") + 1);
				
				headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
				String headerName = "Content-Disposition";
				StringBuilder sb_headerValue = new StringBuilder();
				sb_headerValue.append("attachment; filename=\"");
				sb_headerValue.append(new String(fileName.getBytes("UTF-8"), "ISO-8859-1"));
				sb_headerValue.append("\"");
				headers.add(headerName, sb_headerValue.toString());
			}
			
			entity = new ResponseEntity<>(IOUtils.toByteArray(in), headers, HttpStatus.CREATED);
		} catch (Exception e) {
			e.printStackTrace();
			entity = new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}
		
		return entity;
	}
	
	@ResponseBody
	@RequestMapping("/displayProfile")
	public ResponseEntity<byte[]> displayProfile(String fileName) throws Exception {

		ResponseEntity<byte[]> entity = null;

		try (InputStream in = new FileInputStream(profilePath + fileName)) {
			HttpHeaders headers = new HttpHeaders();
			
			MediaType mediaType = UploadFileUtils.getMediaType(fileName);
			if (mediaType != null) {
				headers.setContentType(mediaType);
			} else {
				fileName = fileName.substring(fileName.indexOf("_") + 1);
				
				logger.info("displayProfile - modified fileName : " + fileName);
				
				headers.setContentType(MediaType.APPLICATION_OCTET_STREAM);
				String headerName = "Content-Disposition";
				StringBuilder sb_headerValue = new StringBuilder();
				sb_headerValue.append("attachment; filename=\"");
				sb_headerValue.append(new String(fileName.getBytes("UTF-8"), "ISO-8859-1"));
				sb_headerValue.append("\"");
				headers.add(headerName, sb_headerValue.toString());
			}
			
			entity = new ResponseEntity<>(IOUtils.toByteArray(in), headers, HttpStatus.CREATED);
		} catch (Exception e) {
			e.printStackTrace();
			entity = new ResponseEntity<>(HttpStatus.BAD_REQUEST);
		}
		
		return entity;
	}
	
	@ResponseBody
	@RequestMapping(value = "/deleteFile", method = RequestMethod.POST)
	public ResponseEntity<String> deleteFile(String fileName) throws Exception {
		logger.info("fileName : " + fileName);
		
		MediaType mediaType = UploadFileUtils.getMediaType(fileName);
		if (mediaType != null) {
			new File(getThumbnailPath(fileName)).delete();
		}
		
		new File(getFilePath(fileName)).delete();
		
		return new ResponseEntity<>("SUCCESS", HttpStatus.OK);
	}
	
	@ResponseBody
	@RequestMapping(value = "/deleteAllFiles", method = RequestMethod.POST)
	public ResponseEntity<String> deleteAllFiles(@RequestParam("files[]") String[] files) throws Exception {
		logger.info("deleteAllFiles : " + files.toString());
		
		if(files != null) {
			if(files.length > 0) {
				for(String fileName : files) {
					MediaType mediaType = UploadFileUtils.getMediaType(fileName);
					if (mediaType != null) {
						new File(getThumbnailPath(fileName)).delete();
					}
					
					new File(getFilePath(fileName)).delete();
				}
			}
		}
		
		return new ResponseEntity<>("SUCCESS", HttpStatus.OK);
	}
	
	@ResponseBody
	@RequestMapping(value = "/deleteProfile", method = RequestMethod.POST)
	public ResponseEntity<String> deleteProfile(String fileName, boolean isConfirm, Authentication auth) throws Exception {
		logger.info("fileName : " + fileName + " / isConfirm : " + isConfirm);
		
		if(fileName != null) {
			if(!fileName.trim().isEmpty()) {
				
				String id = auth.getName();
				
				String dirPath = profilePath + File.separatorChar + id;
				logger.info("dirPath : " + dirPath);
				
				File[] files = new File(dirPath).listFiles();
				
				String addedFileName = fileName.substring(fileName.lastIndexOf('/') + 1).replace('/', File.separatorChar);
				logger.info(addedFileName);
				
				for(File file : files) {
					boolean isTargetFile = addedFileName.equals(file.getName());
					
					// 확인이면 추가한 이미지 제외 모두 삭제
					// 취소이면 추가한 이미지만 삭제
					if(isConfirm) {
						if(isTargetFile)
							continue;
						
						file.delete();
					}
					else {
						if(isTargetFile) {
							
							logger.info(isTargetFile + " / " + file.getName());
							
							file.delete();
							break;
						}
					}
					
				}
				
			}
		}
		
		return new ResponseEntity<>("SUCCESS", HttpStatus.OK);
	}
	

	private String getThumbnailPath(String fileName) {
		return uploadPath + fileName.replaceFirst("s_", "").replace('/', File.separatorChar);
	}
	
	private String getFilePath(String fileName) {
		return uploadPath + fileName.replace('/', File.separatorChar);
	}
}