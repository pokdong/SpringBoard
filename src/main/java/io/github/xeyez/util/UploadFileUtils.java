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
	
	public static MediaType getMediaType(String extension) {
		return mediaMap.get(extension.toUpperCase());
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
		
		// 확장자 판별
		String extension = getExtension(file.getName());
		String hiddenPath = dir.getParentFile().getParent();
		if(getMediaType(extension) != null) {
			uploadedFileName = makeThumbnail(hiddenPath, file);
		}
		else {
			uploadedFileName = file.getAbsolutePath().replace(hiddenPath, "");
		}
		
		return uploadedFileName.replace(File.separatorChar, '/');
	}
	
	public static String getExtension(String fileName) {
		return fileName.substring(fileName.lastIndexOf(".") + 1);
	}
	
	private static String makeThumbnail(String hiddenPath, File file) throws Exception {
		BufferedImage srcImg = ImageIO.read(file);
		BufferedImage destImg = Scalr.resize(srcImg, Scalr.Method.AUTOMATIC, Scalr.Mode.FIT_TO_HEIGHT, 100);
		
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