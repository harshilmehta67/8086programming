data   SEGMENT
        mes1 DB "Enter binary number : $"
        buf  DB 18,19 dup(0)
        mes2 DB 0Dh,0Ah,"Octal of given binary is : $"
data   ENDS
 
my_stack   SEGMENT stack
           DW 50 dup(0)
stack_top  LABEL word
my_stack   ENDS

code   SEGMENT
        ASSUME cs:code,ds:data
     
start: MOV AX, data     ;initialize data segment
        MOV DS, AX
MOV AX, my_stack   ;initialize stack segment
        MOV SS, AX
        MOV SP, offset stack_top

        ;PART-1 Convert from hex string to binary

        MOV AH, 09h     ;print message
        LEA DX, mes1
        INT 21h
 
        MOV AH, 0ah     ;read hex string
        LEA DX, buf
        INT 21h

        LEA SI, buf+1   ;get length of string
        MOV BX, 0
        MOV BL, [si]
        INC SI           ;point to first char
        MOV CX, 1       ;initialize
        MOV AX, 0
next:   MOV DX, 0
        MOV DL, [si]     ;get next ASCII digit
        CMP DL, '9'     ;convert it to binary
        JLE digit
        SUB DL, 7
digit: SUB DL, '0'
        SHL AX, CL       ;shift the partial conversion
        ADD AX, DX       ;add current digit
        INC SI           ;increment pointer
        DEC BX           ;decrement length counter
        JNZ next         ;if not zero, goto next

        PUSH AX         ;push binary number on stack

        ;PART-2 Convert binary to decimal string

        MOV AH, 09h     ;print message
        LEA DX, mes2
        INT 21h

        POP AX           ;get binary number back
        MOV CX, 0       ;set counter to 0
        MOV BX, 8          ;set divider
next1: MOV DX, 0
        DIV BX           ;divide number by divider
        PUSH DX         ;push decimal digit on stack
        INC CX           ;increment counter
        CMP AX, 0       ;f number is not zero
        JA next1         ;goto next1
     
        MOV AH, 2      
next2: POP DX           ;pop the decimal digit
        ADD DX,'0'       ;convert to ASCII
        INT 21h         ;print on screen
        LOOP next2
       
        MOV AX,4C00h     ;terminate the program
        INT 21h

code   ENDS
        END start
