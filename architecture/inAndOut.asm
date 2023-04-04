DATA SEGMENT

    ; lower capital words storage--in fact upper version shares the same except the first character
    _a    DB 'pple $'
    _b    DB 'anana $'
    _c    DB 'ake $'
    _d    DB 'essert $'
    _e    DB 'gg $'
    _f    DB 'ig $'
    _g    DB 'rape $'
    _h    DB 'oney $'
    _i    DB 'cecream $'
    _j    DB 'uice $'
    _k    DB 'iwi $'
    _l    DB 'emon $'
    _m    DB 'ango $'
    _n    DB 'ut $'
    _o    DB 'range $'
    _p    DB 'each $'
    _q    DB 'uarenden $'
    _r    DB 'adish $'
    _s    DB 'trawberry $'
    _t    DB 'angerine $'
    _u    DB 'don $'
    _v    DB 'eal $'
    _w    DB 'atermelon $'
    _x    DB 'acuti $'
    _y    DB 'am $'
    _z    DB 'ucchini $'
    ;index for lower
    LOWER DW _a, _b, _c, _d, _e, _f, _g, _h, _i, _j, _k, _l, _m, _n, _o, _p, _q, _r, _s, _t, _u, _v, _w, _x, _y, _z

    ; 0~9 words
    num0  DB 'Zero $'
    num1  DB 'One $'
    num2  DB 'Two $'
    num3  DB 'Three $'
    num4  DB 'Four $'
    num5  DB 'Five $'
    num6  DB 'Six $'
    num7  DB 'Seven $'
    num8  DB 'Eight $'
    num9  DB 'Nine $'
    ; index for numbers
    nums  DW num0, num1, num2, num3 , num4, num5, num6, num7, num8, num9

    ; personal info
    PID   DB 'ID: 2000013137', 13, 10, '$'
    PNAME DB 'NAME: Yusen Wu', 13, 10, '$'

DATA ENDS

; stack: use ? to fill in, and reserve 50
STACK1 SEGMENT STACK
    BASE   DB  50 DUP(?)
    TOP    EQU LENGTH BASE
STACK1 ENDS

; code 
CODE SEGMENT
    ; move code data and stack segment into target assume
                  ASSUME CS:CODE, DS:DATA, SS:STACK1
    BEGIN:        
                  MOV    AX, DATA
                  MOV    DS, AX
                  MOV    AX, STACK1
                  MOV    SS, AX
                  MOV    AX, TOP
                  MOV    SP, AX
    INPUT:        
    ; notice use AX AH AL to settle input
    ; init counter
                  MOV    CX, 1

    ; 7h: read in number
                  MOV    AH, 07H
    ; terminate: system call
                  INT    21H
                  INC    CX
                  MOV    BL, AL
                  

    ; main part compare the character following the sequence of ascii code and jump to fixed print
                  CMP    AL, '0'
                  JL     PRINTQUESTION
                  CMP    AL, ':'
                  JL     PRINTNUM
                  CMP    AL, 'A'
                  JL     PRINTQUESTION
                  CMP    AL, '['
                  JL     PRINTUPPER
                  CMP    AL, 'a'
                  JL     PRINTQUESTION
                  CMP    AL, '{'
                  JL     PRINTLOWER

                  JMP    SHORT PRINTQUESTION
    
    PRINTNUM:     
                  SUB    BL, '0'
                  SHL    BL, 1
                  MOV    SI, BX
                  MOV    DX, nums[SI]
                  JMP    SHORT PRINT
    
    PRINTUPPER:   
                
                  MOV    DX, 'BX'
                  MOV    AH, 02H
                  INT    21H
                  SUB    BL, 'A'
                  SHL    BL, 1
                  MOV    SI, BX
                  MOV    DX, LOWER[SI]
                  JMP    SHORT PRINT

    PRINTLOWER:   
                  MOV    DX, BX
                  MOV    AH, 02H
                  INT    21H
                  SUB    BL, 'a'
                  SHL    BL, 1
                  MOV    SI, BX
                  MOV    DX, LOWER[SI]
                  JMP    SHORT PRINT


    PRINTQUESTION:
                  CMP    AL, 1BH
                  JE     EXIT
                  MOV    DL, '?'
                  MOV    AH, 02H
                  INT    21H
                  JMP    SHORT JUDGEEXIT

    PRINT:        
                  MOV    AH, 09H
                  INT    21H
                  JMP    SHORT JUDGEEXIT
    
    JUDGEEXIT:    
    ; judge exit
                  CMP    AL, 1BH
                  LOOPNZ INPUT
    
    EXIT:         
                  MOV    DL, 0DH
                  MOV    AH, 02H
                  INT    21H
                  MOV    DL, 0AH
                  MOV    AH, 02H
                  INT    21H

    ; print my student id and name
                  MOV    DX, OFFSET PID
                  MOV    AH, 09H
                  INT    21H

                  MOV    DX, OFFSET PNAME
                  MOV    AH, 09H
                  INT    21H

                  MOV    AX, 4C00H
                  INT    21H
 
CODE ENDS
   END BEGIN


