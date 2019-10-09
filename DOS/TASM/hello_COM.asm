.model tiny
.code 
org 100h

start:
	mov ah, 			9
	lea dx, 			message
	int 				21h
	ret

	message db			'Hello world!$'

end start
