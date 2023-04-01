DATA SEGMENT                                  		;数据段
	BUFFER      DB 81                             	;用于接受从键盘输入的字符串的BUFFER数组，最长可接受81个字符
	            DB 0                              	;用于储存实际输入字符串的长度
	STRING      DB 81	DUP(0)                      	;实际接收到的字符串
	NAME_AND_ID DB 'NAME:Yusen Wu; ID:2000013137$'	;作者的姓名和学号
	SUC         DB 'found$'                       	;查找成功时输出的信息
	FAI         DB 'not found$'                   	;查找失败时输出的信息
DATA ENDS
STACK SEGMENT STACK 		;堆栈段
	STA   DB  50 DUP(?)
	TOP   EQU LENGTH STA
STACK ENDS
CODE SEGMENT                              		;数据段
	         ASSUME CS:CODE, DS:DATA, SS:STACK
	BEGIN:   MOV    AX, DATA
	         MOV    DS, AX                    	;为DS赋初值
	         MOV    AX, DATA
	         MOV    ES, AX                    	;为ES赋初值
	         MOV    AX, STACK
	         MOV    SS, AX                    	;为SS赋初值
	         MOV    AX, TOP
	         MOV    SP, AX                    	;为SP赋初值
			
	         MOV    DX, OFFSET BUFFER         	;从键盘缓冲区接受字符串
	         MOV    AH, 0AH
	         INT    21H
			
	         MOV    DL, 0DH                   	;输出回车
	         MOV    AH, 2
	         INT    21H
	         MOV    DL, 0AH                   	;输出换行
	         MOV    AH, 2
	         INT    21H
			
	ROTATE:  MOV    AH, 07H                   	;轮询开始的地方
	         INT    21H
	         CMP    AL, 1BH                   	;若字符为esc，则退出
	         JNE    HANDLE                    	;否则进入处理流程
	         JMP    NEAR PTR STOP
	HANDLE:  MOV    DI, OFFSET STRING         	;设置好源操作串
	         MOV    BX, OFFSET BUFFER
	         ADD    BX, 1H                    	;得到记录串长度的地址
	         CLD
	         MOV    CL,	BYTE PTR[BX]          	;	;将串长度付给CX
	         MOV    CH, 0
	NEXT:    REPNE  SCASB                     	;使用串操作指令进行寻找
	         JZ     FOUND                     	;若找到，则进入FOUND流程
	NOTFOUND:MOV    DX,	OFFSET FAI            	;否则进入NOTFOUND流程
	         MOV    AH,	09H                   	;输出FAI串
	         INT    21H
			
	         MOV    DL, 0DH                   	;输出回车
	         MOV    AH, 2
	         INT    21H
	         MOV    DL, 0AH                   	;输出换行
	         MOV    AH, 2
	         INT    21H
			
	         JMP    NEAR PTR ROTATE           	;继续查找下一个字符
	FOUND:   MOV    DX,	OFFSET SUC            	;输出SUC串
	         MOV    AH,	09H
	         INT    21H
	         MOV    DX,	[BX]                  	;根据现存的CX的值与串的长度，计算出该字符的位置
	         SUB    DX,	CX
	         ADD    DX,	30H                   	;将该位置转化为ASCII码，并输出
	         MOV    AH,	2H
	         INT    21H
			
	         MOV    DL, 0DH                   	;输出回车
	         MOV    AH, 2
	         INT    21H
	         MOV    DL, 0AH                   	;输出换行
	         MOV    AH, 2
	         INT    21H
			
	         JMP    NEAR PTR ROTATE           	;继续查找下一个字符
	STOP:    MOV    DX, OFFSET NAME_AND_ID    	;程序末尾输出我的姓名和学号
	         MOV    AH, 09H
	         INT    21H
			
	         MOV    AX, 4C00H                 	;带返回码结束，AL=返回码
	         INT    21H
CODE ENDS
            END BEGIN			;程序结束
