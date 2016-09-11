function checkImageFile(fullName) {
		return fullName.match(/jpg|jpeg|gif|png/i);
	}

	function getFileInfo(fullName) {
		var fileName, imgsrc, getLink;
		var fileLink;
		
		if(checkImageFile(fullName)) {
			imgsrc = "/displayFile?fileName="+fullName; //thumbnail
			fileLink = fullName.substr(fullName.lastIndexOf('/') + 3); //UID_파일명
			getLink = "/displayFile?fileName="+fullName.replace(/s_/, ''); //실제파일
			
			isImage = true;
		}
		else {
			imgsrc ="/resources/dist/img/file.png";
			fileLink = fullName.substr(fullName.lastIndexOf('/') + 1); //UID_파일명
			getLink = "/displayFile?fileName="+fullName;
			
			isImage = false;
		}
		
		fileName = fileLink.substr(fileLink.indexOf("_") + 1);
		
		return  {fileName:fileName, imgsrc:imgsrc, getLink:getLink, fullName:fullName, isImage:isImage};
	}

