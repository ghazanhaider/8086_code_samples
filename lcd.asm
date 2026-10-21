#MAKE_BIN#
#LOAD_SEGMENT=F000h#
#LOAD_OFFSET=0000h#
#CS=F000h#
#IP=FFF0h#
name "lcd"
format binary   
;entry reset

; Very basic boot against a single ROM
; We blink
 

; Beginning of the 64KB ROM  
;org 0xF0000

early:
    jmp reset    
    
start:            
    ; init LCD
    
    ; Setting target segment = DS
    MOV AX, 0x8000 ; LCD segment
    MOV DS, AX
    
    ; offset
    MOV BX, 0x0000 ; Hooked to A0 pin of the LCD, 1=cmd, 0=data
    
    
    ; data
    OR BL, 1        ; A0 = 1
    MOV AL, 0x40    ;                   SYSTEM SET
    MOV [BX], AL
    
    AND BL, 0       ; A0 = 0
    MOV AL, 0x30    ;                   INT CGROM, CHARH=8, SINGLE PANEL
    MOV [BX], AL
    
    MOV AL, 0x87    ;                   CHARW=8
    MOV [BX], AL
        
    MOV AL, 0x07    ;                   CHARH=8
    MOV [BX], AL
    
    MOV AL, 0x28    ;                   CHAR BYTES PER ROW
    MOV [BX], AL
    
    MOV AL, 0x47    ;                   CHAR BYTES PER ROW INC HORZ BLANKING
    MOV [BX], AL
    
    MOV AL, 0xEF    ;                   LINES PER FRAME
    MOV [BX], AL
    
    MOV AL, 0x28    ;                   VIRT SCREEN HOR ADDRESS RANGE
    MOV [BX], AL
    
    MOV AL, 0x00    ;                   HIGH BYTE OF ABOVE
    MOV [BX], AL
    


    OR BL, 1        ; A0 = 1
    MOV AL, 0x59    ;                   DISPLAY ON
    MOV [BX], AL    ;                   SAD1=ON CURSOR=OFF                                    
    
    AND BL, 0       ; A0 = 0
    MOV AL, 0x04    ;                   SCREEN BLOCK ATTRIBUTES ((0 << FP) | (2 << FC))
    MOV [BX], AL    



    OR BL, 1        ; A0 = 1
    MOV AL, 0x44    ;                   CURSOR TYPE
    MOV [BX], AL    
    
    AND BL, 0       ; A0 = 0
    MOV AL, 0x00    ;                   SAD1L
    MOV [BX], AL    ;                       
                
    MOV AL, 0x80    ;                   SAD1H M=0 UNDERSCORE, M=1 BLOCK (8<<M)
    MOV [BX], AL

    MOV AL, 0xEF    ; SAD2 NOT USED
    MOV [BX], AL

    MOV AL, 0x00
    MOV [BX], AL

    MOV AL, 0x00
    MOV [BX], AL

    MOV AL, 0xEF    ; SAD3 NOT USED
    MOV [BX], AL

    MOV AL, 0x00
    MOV [BX], AL

    MOV AL, 0x00
    MOV [BX], AL



    OR BL, 1        ; A0 = 1
    MOV AL, 0x5D    ;                   CURSOR TYPE                
    MOV [BX], AL    
    
    AND BL, 0       ; A0 = 0
    MOV AL, 0x07    ;                   CRX
    MOV [BX], AL    
                
    MOV AL, 0x17    ;                   CRY
    MOV [BX], AL



    OR BL, 1       ; A0 = 1
    MOV AL, 0x4C    ;                   CURSOR DIRECTION    (0 << (CD=00))
    MOV [BX], AL
    
    
    
    ;OR BL,1         ; A0 = 1
    ;MOV AL, 0x5B    ;                   DISPLAY OVERLAY FORMAT
    ;MOV [BX], AL    
    
    ;AND BL,0          ; A0 = 0
    ;MOV AL, 0x05    ;                   OV=0 DM1=0 DM0=1
    ;MOV [BX], AL    



    OR BL, 1        ; A0 = 1
    MOV AL, 0x5A    ;                   HORIZONTAL SCROLL POSITION
    MOV [BX], AL    
    
    AND BL, 0       ; A0 = 0
    MOV AL, 0x00    ;                   NO SCROLL
    MOV [BX], AL    

       

    OR BL, 1        ; A0 = 1
    MOV AL, 0x60    ;                   GREYSCALE DEPTH
    MOV [BX], AL    
    
    AND BL, 0       ; A0 = 0
    MOV AL, 0x00    ;                   1BPP
    MOV [BX], AL




    OR BL, 1        ; A0 = 1
    MOV AL, 0x46    ;                   CURSOR ADDRESS
    MOV [BX], AL    
    
    AND BL, 0       ; A0 = 0
    MOV AL, 0x00    ;                   CSRL
    MOV [BX], AL

    MOV AL, 0x00    ;                   CSRH
    MOV [BX], AL    
    
               
               

loopstart:

    MOV CX,0x02E8  ; counter start     (FOR 2.6MHZ, USE FFFF)
    
loopdelay:
    DEC CX
    JNZ loopdelay





    OR BL, 1        ; A0 = 1                 DISPLAY TEXT
    MOV AL, 0x42
    MOV [BX], AL    
    
    AND BL, 0       ; A0 = 0
    MOV AL, 0x48
    MOV [BX], AL
    MOV AL, 0x65
    MOV [BX], AL
    MOV AL, 0x6C
    MOV [BX], AL
    MOV AL, 0x6C
    MOV [BX], AL
    MOV AL, 0x6F
    MOV [BX], AL
    MOV AL, 0x20
    MOV [BX], AL
    MOV AL, 0x57
    MOV [BX], AL
    MOV AL, 0x6F
    MOV [BX], AL
    MOV AL, 0x72
    MOV [BX], AL
    MOV AL, 0x6C
    MOV [BX], AL
    MOV AL, 0x64
    MOV [BX], AL
    
    

    
    ; fall through
    
    NOT AL
    OUT 199, AL
    JMP loopstart


; PADDING
buffer db (0xFFF0 - ($ - $$)) dup (0xFF)               
              
; Last 16 bytes of the 64KB ROM
;org 0x0005FFF0


reset:      
    cli
    jmp start
; Pad out the remaining bytes of the 16-byte block to complete the 128KB file.
buffertwo db (0x10000 - ($ - $$)) dup 0xFF

