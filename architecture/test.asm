DATA SEGMENT
    ; words for capital letter
    A      DB 'Apple $'
    B      DB 'Banana $'
    C      DB 'Cake $'
    D      DB 'Dessert $'
    E      DB 'Egg $'
    F      DB 'Fig $'
    G      DB 'Grape $'
    H      DB 'Honey $'
    I      DB 'Icecream $'
    J      DB 'Juice $'
    K      DB 'Kiwi $'
    L      DB 'Lemon $'
    M      DB 'Mango $'
    N      DB 'Nut $'
    O      DB 'Orange $'
    P      DB 'Peach $'
    Q      DB 'Quarenden $'
    R      DB 'Radish $'
    S      DB 'Strawberry $'
    T      DB 'Tangerine $'
    U      DB 'Udon $'
    V      DB 'Veal $'
    W      DB 'Watermelon $'
    X      DB 'Xacuti $'
    Y      DB 'Yam $'
    Z      DB 'Zucchini $'
    ; index for capital letter
    CAPS   DW A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z

    ; words for lower case letter
    aa     DB 'apple $'
    bb     DB 'banana $'
    cc     DB 'cake $'
    ddd    DB 'dessert $'
    ee     DB 'egg $'
    ff     DB 'fig $'
    gg     DB 'grape $'
    hh     DB 'honey $'
    ii     DB 'icecream $'
    jj     DB 'juice $'
    kk     DB 'kiwi $'
    ll     DB 'lemon $'
    mm     DB 'mango $'
    nn     DB 'nut $'
    oo     DB 'orange $'
    pp     DB 'peach $'
    qq     DB 'quarenden $'
    rr     DB 'radish $'
    sss    DB 'strawberry $'
    tt     DB 'tangerine $'
    uu     DB 'udon $'
    vv     DB 'veal $'
    ww     DB 'watermelon $'
    xx     DB 'xacuti $'
    yy     DB 'yam $'
    zz     DB 'zucchini $'
    ; index for lower case letter
    LOWS   DW aa, bb, cc, ddd, ee, ff, gg, hh, ii, jj, kk, ll, mm, nn, oo, pp, qq, rr, sss, tt, uu, vv, ww, xx, yy, zz

    ; words for numbers
    NUM0   DB 'Zero $'
    NUM1   DB 'One $'
    NUM2   DB 'Two $'
    NUM3   DB 'Three $'
    NUM4   DB 'Four $'
    NUM5   DB 'Five $'
    NUM6   DB 'Six $'
    NUM7   DB 'Seven $'
    NUM8   DB 'Eight $'
    NUM9   DB 'Nine $'
    ; index for numbers
    NUMS   DW NUM0, NUM1, NUM2, NUM3, NUM4, NUM5, NUM6, NUM7, NUM8, NUM9

    ; words for signs
    SPARK  DB 'Spark $'
    AT     DB 'At $'
    AAND   DB 'And $'

    ; personal identification
    MYID   DB 'ID: 666666', 13, 10, '$'
    MYNAME DB 'NAME: Shuai Ge', 13, 10, '$'

DATA ENDS
STACK SEGMENT STACK
    STA   DB  50 DUP(?)
    TOP   EQU LENGTH STA
STACK ENDS
CODE SEGMENT
                 ASSUME CS:CODE, DS:DATA, SS:STACK
    BEGIN:       
                 MOV    AX, DATA
                 MOV    DS, AX
                 MOV    AX, STACK
                 MOV    SS, AX
                 MOV    AX, TOP
                 MOV    SP, AX

    INPUT:       
    ; to use Loop, give CX an initial value
                 MOV    CX, 1
    ; get input character
                 MOV    AH, 07H
                 INT    21H
    ; inorder to avoid Loop is stopped by CX=0, increase CX everytime gets a new character
                 INC    CX
    ; use register BX to help printing
                 MOV    BL, AL

    ; follow the sequence of ascii code to compare the character
    ; and jump to the print function
                 CMP    AL, '&'
                 JL     QUESTIONMARK
                 JE     PRINTAND

                 CMP    AL, '*'
                 JL     QUESTIONMARK
                 JE     PRINTSPARK

    ; character is a number
                 CMP    AL, '0'
                 JL     QUESTIONMARK
                 CMP    AL, ':'
                 JL     PRINTNUM

                 CMP    AL, '@'
                 JL     QUESTIONMARK
                 JE     PRINTAT

    ; as 'A' is just behind '@' in ascii, and '[' is just behind 'Z'
    ; character is a capital letter
                 CMP    AL, '['
                 JL     PRINTCAPL

    ; character is a small letter
                 CMP    AL, 'a'
                 JL     QUESTIONMARK
                 CMP    AL, '{'
                 JL     PRINTLOWL

                 JMP    SHORT QUESTIONMARK

    ; in every print function, just print the proper word
    PRINTAND:    
                 MOV    DX, OFFSET AAND
                 JMP    SHORT PRINT

    PRINTSPARK:  
                 MOV    DX, OFFSET SPARK
                 JMP    SHORT PRINT

    ; for numbers, let input minus '0' to get the index
    PRINTNUM:    
                 SUB    BL, '0'
                 SHL    BL, 1
                 MOV    SI, BX
                 MOV    DX, NUMS[SI]
                 JMP    SHORT PRINT

    PRINTAT:     
                 MOV    DX, OFFSET AT
                 JMP    SHORT PRINT

    ; for capital letters, let input minus 'A' to get the index
    PRINTCAPL:   
                 SUB    BL, 'A'
                 SHL    BL, 1
                 MOV    SI, BX
                 MOV    DX, CAPS[SI]
                 JMP    SHORT PRINT

    ; for small letters, let input minus 'a' to get the index
    PRINTLOWL:   
                 SUB    BL, 'a'
                 SHL    BL, 1
                 MOV    SI, BX
                 MOV    DX, LOWS[SI]
                 JMP    SHORT PRINT

    PRINT:       
                 MOV    AH, 09H
                 INT    21H
                 JMP    SHORT IFEXIT

    ; judge whether input is ESC or not, if not then print '?'
    QUESTIONMARK:
                 CMP    AL, 1BH
                 JE     EXIT
                 MOV    DL, '?'
                 MOV    AH, 02H
                 INT    21H

    ; let ZF be the sign to decide whether to loop or end the program
    ; if input is not ESC, then ZF will be 0 and the loop will jump to INPUT
    IFEXIT:      
                 CMP    AL, 1BH
                 LOOPNZ INPUT

    ; input is ESC, terminate the program
    EXIT:        
                 MOV    DL, 0DH
                 MOV    AH, 02H
                 INT    21H
                 MOV    DL, 0AH
                 MOV    AH, 02H
                 INT    21H

    ; print my student id and name
                 MOV    DX, OFFSET MYID
                 MOV    AH, 09H
                 INT    21H

                 MOV    DX, OFFSET MYNAME
                 MOV    AH, 09H
                 INT    21H

                 MOV    AX, 4C00H
                 INT    21H

CODE ENDS
	END BEGIN
