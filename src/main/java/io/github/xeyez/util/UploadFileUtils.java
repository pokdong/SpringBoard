package io.github.xeyez.util;

import java.awt.image.BufferedImage;
import java.io.File;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import javax.imageio.ImageIO;

import org.imgscalr.Scalr;
import org.springframework.http.MediaType;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.multipart.MultipartFile;

public class UploadFileUtils {
	
	private static Map<String, MediaType> mediaMap;
	
	static {
		mediaMap = new HashMap<>();
		mediaMap.put("JPG", MediaType.IMAGE_JPEG);
		mediaMap.put("JPEG", MediaType.IMAGE_JPEG);
		mediaMap.put("GIF", MediaType.IMAGE_GIF);
		mediaMap.put("PNG", MediaType.IMAGE_PNG);
	}
	
	public static MediaType getMediaType(String fileName) {
		String extension = getExtension(fileName);
		return mediaMap.get(extension.toUpperCase());
	}
	
	public static String getExtension(String fileName) {
		return fileName.substring(fileName.lastIndexOf(".") + 1);
	}
	
	public static String uploadFile(String uploadPath, MultipartFile mpf) throws Exception {
		String fileName = UUID.randomUUID().toString() + "_" + mpf.getOriginalFilename();
		
		String formattedDateTime_y = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy"));
		String formattedDateTime_md = LocalDateTime.now().format(DateTimeFormatter.ofPattern("MMdd"));
		//String dirPath = uploadPath + File.separator + formattedDateTime;
		StringBuilder sb_dirPath = new StringBuilder();
		sb_dirPath.append(uploadPath);
		sb_dirPath.append(File.separatorChar);
		sb_dirPath.append(formattedDateTime_y);
		sb_dirPath.append(File.separatorChar);
		sb_dirPath.append(formattedDateTime_md);
		
		String dirPath = sb_dirPath.toString();
		
		File file = new File(dirPath, fileName);
		
		File dir = new File(dirPath);
		if(!dir.exists()) {
			dir.mkdirs();
		}
		
		FileCopyUtils.copy(mpf.getBytes(), file);
		
		
		String uploadedFileName = null;
		
		String hiddenPath = dir.getParentFile().getParent();
		if(getMediaType(file.getName()) != null) {
			uploadedFileName = makeThumbnail(hiddenPath, file, 100);
		}
		else {
			uploadedFileName = file.getAbsolutePath().replace(hiddenPath, "");
		}
		
		return uploadedFileName.replace(File.separatorChar, '/');
	}
	
	public static String uploadProfile(String uploadPath, MultipartFile mpf) throws Exception {
		String fileName = UUID.randomUUID().toString() + "_" + mpf.getOriginalFilename();
		
		File file = new File(uploadPath, fileName);
		
		File dir = new File(uploadPath);
		if(!dir.exists()) {
			dir.mkdirs();
		}
		else {
			// 이미 존재하는 Profile image 삭제
			for(File targetFile : dir.listFiles()) {
				targetFile.delete();
			}
		}
		
		FileCopyUtils.copy(mpf.getBytes(), file);
		
		String uploadedFileName = null;
		String hiddenPath = dir.getParent(); // C:/springboard/profile
		
		uploadedFileName = makeThumbnail(hiddenPath, file, 160);
		
		// 원본 파일 삭제
		file.delete();
		
		return uploadedFileName.replace(File.separatorChar, '/');
	}
	
	private static String makeThumbnail(String hiddenPath, File file, int hightPixel) throws Exception {
		BufferedImage srcImg = ImageIO.read(file);
		BufferedImage destImg = Scalr.resize(srcImg, Scalr.Method.AUTOMATIC, Scalr.Mode.FIT_TO_HEIGHT, hightPixel);
		
		StringBuilder sb_thumbnailFileName = new StringBuilder();
		sb_thumbnailFileName.append(file.getParent());
		sb_thumbnailFileName.append(File.separatorChar);
		sb_thumbnailFileName.append("s_");
		sb_thumbnailFileName.append(file.getName());
		
		String thumbnailFileName = sb_thumbnailFileName.toString();
		File thumbnailFile = new File(thumbnailFileName);
		String extension = getExtension(file.getName());
		ImageIO.write(destImg, extension, thumbnailFile);
		
		return thumbnailFileName.replace(hiddenPath, "");
	}
}