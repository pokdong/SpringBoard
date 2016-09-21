var maxUploadSize = 10485760;

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

function getProfileImageURL(fileName) {
	if(checkImageFile(fileName) == null)
		return null;
	
	return '/profile?img=' + fileName;
}

function isMobile() {
	var filter = "win16|win32|win64|mac";

	if (navigator.platform) {
		return 0 > filter.indexOf(navigator.platform.toLowerCase());
	}
	else
		return false;
}

function IEVersionCheck() {
	 
    var word;
    var version = "N/A";

    var agent = navigator.userAgent.toLowerCase();
    var name = navigator.appName;

    // IE old version ( IE 10 or Lower )
    if ( name == "Microsoft Internet Explorer" ) word = "msie ";

    else {
        // IE 11
        if ( agent.search("trident") > -1 ) word = "trident/.*rv:";

        // IE 12  ( Microsoft Edge )
        else if ( agent.search("edge/") > -1 ) word = "edge/";
    }

    var reg = new RegExp( word + "([0-9]{1,})(\\.{0,}[0-9]{0,1})" );
    if (  reg.exec( agent ) != null  )
        version = RegExp.$1 + RegExp.$2;

    return version;
};