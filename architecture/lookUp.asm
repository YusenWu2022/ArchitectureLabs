DATA SEGMENT
    BUFFER DB 99
    LEN    DB ?                                    ; record length of string
    STRING DB 99 DUP(0)                            ; real sentence
    INFO   DB "name: Yusen Wu, id: 2000013137$"
    POSI   DB "Yes!Location: $"
    NEGA   DB "NO...$"
DATA ENDS

STACK1 SEGMENT STACK
    STA    DB  50 DUP(?)
    TOP    EQU LENGTH STA
STACK1 ENDS

CODE SEGMENT
             ASSUME CS:CODE, DS:DATA, SS:STACK1
    BEGIN:   
    ; load stack data in
             MOV    AX, DATA
             MOV    DS, AX
             MOV    AX, STACK1
             MOV    SS, AX
             MOV    AX, TOP
             MOV    SP, AX
             MOV    AX, DATA
             MOV    ES, AX
     
             MOV    DX, OFFSET BUFFER              ; read in buffer string
             MOV    AH, 0AH
             INT    21H
    ; output enter
             MOV    DL, 0DH
             MOV    AH, 2
             INT    21H
    ; another line
             MOV    DL, 0AH
             MOV    AH, 2
             INT    21H
    CYCLE:   
             MOV    AH, 07H                        ; read one character in and cycle
             INT    21H
             CMP    AL, 1BH                        ; current input: esc
             JNE    SETTLE
             JMP    NEAR PTR EXIT
    SETTLE:                                        ; search for given character with bunch method
             MOV    DI, OFFSET STRING              ; original sentence
             MOV    BX, OFFSET BUFFER              ; target sentences
             ADD    BX, 1H                         ; get sentence length address
             CLD
             MOV    CL, BYTE PTR[BX]               ; set length to CL
             MOV    CH, 0
    SEARCH:                                        ; bunch operation search function
             REPNE  SCASB                          ; kernel search function
             JNZ    NOTFOUND                       ; if find one fitted just jump to success procedure
    FOUND:   
    ; output suc string
             MOV    DX, OFFSET POSI
             MOV    AH, 09H
             INT    21H
    ; calculate character searched's index
             MOV    DL, LEN
             SUB    DX, CX                         ; sub length: get relative index
    ;          ADD    DX, 30H                       ; add ascii number 0 to relative: get absolute numnber of index
    ;  if length too large may get ;<> instead of 10,11,12... so change output method instead of direct output
    ;          MOV    AH, 2H
    ;          INT    21H

    ; currently number is in DX
             MOV    AX, DX                         ; move from dx to store in ax
             MOV    BL, 10
             DIV    BL                             ;calculate AX/BL, right on AH，result on AL
             MOV    DX, AX
             CMP    DL, 0
             JE     SINGLE
             ADD    DL, 30H                        ;transform into 10-ascii code
             MOV    AH, 2H
             INT    21H
    SINGLE:  
             MOV    DL, DH
             ADD    DL, 30H
             MOV    AH, 2H
             INT    21H


    ; enter
             MOV    DL, 0DH
             MOV    AH, 2
             INT    21H
    ; another line
             MOV    DL, 0AH
             MOV    AH, 2
             INT    21H
             JMP    NEAR PTR CYCLE
    NOTFOUND:
    ; output fai string
             MOV    DX, OFFSET NEGA
             MOV    AH, 09H
             INT    21H
    ; output enter and change line directly without changing into ascii number or so
    ; enter
             MOV    DL, 0DH
             MOV    AH, 2
             INT    21H
    ; another line
             MOV    DL, 0AH
             MOV    AH, 2
             INT    21H
             JMP    NEAR PTR CYCLE
    EXIT:    
    ; output personal infomation
             MOV    DX, OFFSET INFO
             MOV    AH, 09H
             INT    21H
    ; return
             MOV    AX, 4C00H
             INT    21H

CODE ENDS
    END BEGIN