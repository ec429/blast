#pragma name test
#pragma line start
#pragma renum =5 +5
.start
	load "bin" code !HEX 8000
	print usr !HEX 8000
