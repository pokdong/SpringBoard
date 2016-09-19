function trim(str) {
	return str.replace(/(^\s*)|(\s*$)/gi, "");
}

function prependZero(num, len) {
    while(num.toString().length < len) {
        num = "0" + num;
    }
    return num;
}