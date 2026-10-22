#MAKE_BIN#
#LOAD_SEGMENT=F000h#
#LOAD_OFFSET=0000h#
#CS=FFFFh#
#IP=0000h#
name "lcd"
format binary

LOOPDELAY equ 0xE030   
;entry reset

; Very basic boot against a single ROM
; We blink
 

; Beginning of the 64KB ROM  
;org 0xF0000

early:
    jmp reset    
    
start:            
       
     
    ; delay to let LCD osc settle (3-4ms)   
    
                                                                                 
                                                                                 
    ; delay loop
    ; uses 23 clks per loop
    ; one clk is                (2.6MHz = 378.79ns, 30.2kHz = 33.16us)
    ; one loop is               (2.6MHz = 8.71us  , 30.2kHz = 754.4us)
    ; 0.5 second cycle would be (2.6MHz = 0xE030  , 30.2kHz = 0x0297)
                                                                                 
startloop:
    MOV CX,LOOPDELAY  ; 5ms in 2.64MHz, 433ms for 30.5kHz
startloopdelay:
    DEC CX
    JNZ startloopdelay



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
    
    MOV AL, 0x87    ;                   CHARW=8 WF=1
    MOV [BX], AL
        
    MOV AL, 0x07    ;                   CHARH=8
    MOV [BX], AL
    
    MOV AL, 0x27    ;                  CHAR BYTES PER ROW
    MOV [BX], AL
    
    MOV AL, 0x2F    ;                   CHAR BYTES PER ROW INC HORZ BLANKING
    MOV [BX], AL
    
    MOV AL, 0xEF    ;                   LINES PER FRAME
    MOV [BX], AL
    
    MOV AL, 0x28    ;                   VIRT SCREEN HOR ADDRESS RANGE
    MOV [BX], AL
    
    MOV AL, 0x00    ;                   HIGH BYTE OF ABOVE
    MOV [BX], AL
    
   

               
    OR BL, 1        ; A0 = 1
    MOV AL, 0x59    ;                   DISPLAY ON
    MOV [BX], AL    ;                                                       
    
    AND BL, 0       ; A0 = 0
    MOV AL, 0x04    ;                   FCs are 01, FP01=01=SAD1 on, FP45=01=SAD3 on
    MOV [BX], AL 
    


    OR BL, 1        ; A0 = 1
    MOV AL, 0x44    ;                   SCROLL
    MOV [BX], AL    
    
    AND BL, 0       ; A0 = 0
    MOV AL, 0x00    ;                   SAD1L
    MOV [BX], AL    ;                       
                
    MOV AL, 0x00    ;                   SAD1H
    MOV [BX], AL

    MOV AL, 0x7F   
    MOV [BX], AL

    MOV AL, 0x00    ; SAD2 address
    MOV [BX], AL

    MOV AL, 0x00
    MOV [BX], AL

    MOV AL, 0x7F    
    MOV [BX], AL

    MOV AL, 0x00    ; SAD3 address
    MOV [BX], AL

    MOV AL, 0x00
    MOV [BX], AL
      
    MOV AL, 0x00    ; SAD4 address
    MOV [BX], AL

    MOV AL, 0x00
    MOV [BX], AL    
    


    OR BL, 1        ; A0 = 1
    MOV AL, 0x5D    ;                   CURSOR TYPE                
    MOV [BX], AL    
    
    AND BL, 0       ; A0 = 0
    MOV AL, 0x07    ;                   CRX
    MOV [BX], AL    
                
    MOV AL, 0x87    ;                   CRY
    MOV [BX], AL
    


    OR BL, 1        ; A0 = 1
    MOV AL, 0x4C    ;                   CURSOR DIRECTION
    MOV [BX], AL   

    
        

    OR BL,1         ; A0 = 1
    MOV AL, 0x5B    ;                   DISPLAY OVERLAY FORMAT
    MOV [BX], AL    
    
    AND BL,0          ; A0 = 0
    MOV AL, 0x00    ;                   OV=0 DM1=0(lyr3,lyr1 text mode) MX01(Inverse)
    MOV [BX], AL
    
    
    
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
    
    
displayloop_start:

    OR BL, 1        ; A0 = 1
    MOV AL, 0x46    ;                   CURSOR ADDRESS = SAD1
    MOV [BX], AL    
    
    AND BL, 0       ; A0 = 0
    MOV AL, 0x00    ;                   CSRL
    MOV [BX], AL

    MOV AL, 0x00    ;                   CSRH
    MOV [BX], AL
    
        ; Clear screen buffers here by writing zeroes
        
        

    MOV CX,0x0020
sad1_display_loop:

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
    
    

    
    ; IO OUT
    
    NOT AL
    OUT 199, AL           



    DEC CX
    JNZ sad1_display_loop





    ; SAD3 display loop
    
    OR BL, 1        ; A0 = 1
    MOV AL, 0x46    ;                   CURSOR ADDRESS = SAD3
    MOV [BX], AL    
    
    AND BL, 0       ; A0 = 0
    MOV AL, 0x00    ;                   CSRL
    MOV [BX], AL

    MOV AL, 0x00    ;                   CSRH
    MOV [BX], AL  

    

    MOV CX,0x0020
sad3_display_loop:

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
    
    

    
    ; IO OUT
    
    NOT AL
    OUT 199, AL           



    DEC CX
    JNZ sad3_display_loop

    JMP displayloop_start


; PADDING
buffer db (0xFFF0 - ($ - $$)) dup (0xFF)               
              
; Last 16 bytes of the 64KB ROM
;org 0x0005FFF0


reset:      
    cli
    jmp 0xF000:start
    
; Pad out the remaining bytes of the 16-byte block to complete the 128KB file.
buffertwo db (0x10000 - ($ - $$)) dup 0xFF

