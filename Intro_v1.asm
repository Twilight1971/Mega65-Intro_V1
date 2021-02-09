//--------------------------------------------------------------------------------------
//  Mega65 Intro coded by Twilight 2021
//	Kick Assembler v5.16
//  tested only on Mega65 Emulator Xemu
//
//--------------------------------------------------------------------------------------
.cpu _45gs02                
#import "m65macros.s"
//--------------------------------------------------------------------------------------

.pc = $8000 "sid"
.import binary "Outrun_2018-Splash_Wave.dat",2      

.pc = $4800 "1x2char"
.import binary "1x2char03.prg",2      

.pc = $4000 "logocharset"
.import binary "logocharset.bin"

.pc = $5000
.fill 440,$00
.fill 600,$20

//--------------------------------------------------------------------------------------

BasicUpstart65(Entry)

* = $2020

Entry:

						lda #$00
						tax 
						tay 
						taz 
						map
						eom				
								
						// Background & Bordercolor		
						lda #$00		
						sta $d021		
						lda #$00		
						sta $d020		

						// SID Init
						lda #$00
						jsr $8000
				
				
						ldx #$00
			!:			lda logo1,x
						sta $5000,x
						lda logo2,x
						sta $5000+40,x
						lda logo3,x
						sta $5000+40*2,x
						lda logo4,x
						sta $5000+40*3,x
						lda logo5,x
						sta $5000+40*4,x
						lda logo6,x
						sta $5000+40*5,x
						lda logo7,x
						sta $5000+40*6,x
						lda logo8,x
						sta $5000+40*7,x
						lda logo9,x
						sta $5000+40*8,x
						lda #$20
						sta $5000+40*10,x 
						lda text1,x
						sta $5000+40*11,x
						adc #$80
						sta $5000+40*12,x
						
						lda #$0e
						sta $d800,x
						sta $d800+40*1,x
						sta $d800+40*2,x
						sta $d800+40*3,x
						sta $d800+40*4,x
						lda #$0a
						sta $d800+40*5,x
						sta $d800+40*6,x
						sta $d800+40*7,x
						sta $d800+40*8,x
						inx
						cpx #$28
						bne !-
				
						ldx #$00
				!:		
						lda #$00
						sta $d900+102,x
						sta $da00,x
						inx
						bne !-
		
//--------------------------------------------------------------------------------------
		
						sei
						lda #$35
						sta $01
						
						mapMemory($ffd2000, $c000)
						
						lda #$7f
						sta $dc0d
						sta $dd0d
						lda #$00
						sta $d012
						ldx #<irq1
						ldy #>irq1
						stx $fffe
						sty $ffff
						lda $d01a
						ora #$01
						sta $d01a
						lda #$1b
						sta $d011
						asl $d019
						cli
						jmp *
				
//---------------------------------------------------------------------				
	
	irq1:				pha
						txa
						pha
						tya
						pha
						asl $d019
						
						lda #$50			//ScreenRam
						sta $d061
						
						//	Logoscreen Multicolor
						lda #$d8
						sta $d016
						
						//	Logo MC Colours
						lda #$03
						sta $d022
						lda #$0e
						sta $d023
						
						// Charset Location
						lda #$40
						sta $d069
						
						lda #$00
						sta $d05c
				
						lda $D031
						and #%01111111
						sta $d031				
										
						lda $D030
						and #%01111111
						sta $d030				
										
				
	bo1:				ldx #$00
						ldy bounce,x
						lda #$00
						sta $d04d				// TextScreen  Pos
						sty $d04c				// TextScreen  Pos
						
						
						lda bo1+1
						clc
						adc #01
						sta bo1+1
						
						lda bo2+1
						clc
						adc #01
						sta bo2+1
						
						lda #$42
				!:		cmp $d012
						bne !-
						
						lda #$0f
						sta $d022
						lda #$0a
						sta $d023
						
						lda #$6b
						sta $d012
						ldx #<irq2
						ldy #>irq2
						stx $fffe
						sty $ffff
						pla
						tay
						pla
						tax
						pla
						rti

//---------------------------------------------------------------------				
	
	irq2:				pha
						txa
						pha
						tya
						pha
						asl $d019
						
						// Charset Location
						lda #$48		
						sta $d069
				
	bo2:				ldx #$80
						ldy bounce,x
						lda #$00
						sta $d04d				// Text X Pos
						sty $d04c				// Text X Pos
						
						
						ldx #$00
			!:			lda colortab,x
						sta $d021
						ldy #$60
		lop1:			dey
						bne lop1
						inx
						cpx #$a0
						bne !-
				
				
						lda #$00
						sta $d012
						ldx #<irq1
						ldy #>irq1
						stx $fffe
						sty $ffff
						
						jsr rastereffekt
						jsr fixit
						
						pla
						tay
						pla
						tax
						pla
						rti

//--------------------------------------------------------------------------------------

fixit:					// slowdown Routine for the c64 Sidmusic

						lda #$06
						beq reset
						dec fixit+$01
ntscfix:				jmp $8003 //(play music)

reset:
						lda #$08
						sta fixit+$01
						rts

//--------------------------------------------------------------------------------------

rastereffekt:
						ldx #$00
			!:			lda rastercopy,x
						sta colortab,x
						inx
						cpx #$a0
						bne !-
				
	mov1:				ldx #$00
						ldy barsinus,x
						ldx #$00
			!:			
						lda bar1,x
						sta colortab+35,y
						
						iny
						inx
						cpx #11
						bne !-
				
						lda mov1+1
						clc
						adc #$03
						sta mov1+1
				
	mov2:				ldx #30
						ldy barsinus,x
						ldx #$00
			!:			
						lda bar2,x
						sta colortab+35,y
						
						iny
						inx
						cpx #11
						bne !-
						
						lda mov2+1
						clc
						adc #$03
						sta mov2+1
				
	mov3:				ldx #60
						ldy barsinus,x
						ldx #$00
			!:			
						lda bar3,x
						sta colortab+35,y
						
						iny
						inx
						cpx #11
						bne !-
						
						lda mov3+1
						clc
						adc #$03
						sta mov3+1
						rts
						
//--------------------------------------------------------------------------------------
				
				
bar1: .text "@klogagolk@"				
bar2: .text "@fncgagcnf@"				
bar3: .text "@ibhjajhbi@"				
				
colortab:
.text "ibhjgaaaaaaaaaaaaaaaaaaaaaaaaaagcnf@"
.text "@ibbh bhhj hjjg jgga gaag aggj gjjo jool ollk "		
.text "@kllo looj ojjg jgga gaag aggc gccn cnnd nddf @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@qqq "			

rastercopy:
.text "ibhjgaaaaaaaaaaaaaaaaaaaaaaaaaagcnf@"
.text "@ibbh bhhj hjjg jgga gaag aggj gjjo jool ollk "		
.text "@kllo looj ojjg jgga gaag aggc gccn cnnd nddf @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@qqq "			


text1:				
//     1234567890123456789012345678901234567890				
.text "        Mega 65 Intro by Twilight                "		
				
bounce:				
.fill 256, 78 + 78*sin(toRadians(i*360/256))

barsinus:
 .byte 83,82,81,80,79,78
      .byte 77,76,75,74,73,72
      .byte 71,70,69,68,67,66
      .byte 65,64,63,62,61,60
      .byte 59,58,57,56,55,54
      .byte 53,52,51,50,49,48
      .byte 48,47,46,45,44,43
      .byte 42,41,40,39,39,38
      .byte 37,36,35,34,34,33
      .byte 32,31,30,30,29,28
      .byte 27,27,26,25,24,24
      .byte 23,22,22,21,20,19
      .byte 19,18,18,17,16,16
      .byte 15,15,14,13,13,12
      .byte 12,11,11,10,10,9
      .byte 9,8,8,8,7,7
      .byte 6,6,6,5,5,5
      .byte 4,4,4,3,3,3
      .byte 2,2,2,2,2,1
      .byte 1,1,1,1,1,1
      .byte 0,0,0,0,0,0
      .byte 0,0,0,0,0,0
      .byte 0,0,0,0,0,1
      .byte 1,1,1,1,1,1
      .byte 2,2,2,2,2,3
      .byte 3,3,4,4,4,5
      .byte 5,5,6,6,6,7
      .byte 7,8,8,8,9,9
      .byte 10,10,11,11,12,12
      .byte 13,13,14,15,15,16
      .byte 16,17,18,18,19,19
      .byte 20,21,22,22,23,24
      .byte 24,25,26,27,27,28
      .byte 29,30,30,31,32,33
      .byte 34,34,35,36,37,38
      .byte 39,39,40,41,42,43
      .byte 44,45,46,47,48,48
      .byte 49,50,51,52,53,54
      .byte 55,56,57,58,59,60
      .byte 61,62,63,64,65,66
      .byte 67,68,69,70,71,72
      .byte 73,74,75,76,77,78
      .byte 79,80,81,82      
      
      
.pc = $2600 "Logo Map"

logo1:
.byte $00, $00, $01, $02, $03, $04, $05, $06, $07, $08, $09, $07, $08, $09, $01, $02, $03, $04, $05, $06, $01, $02, $03, $04, $05, $06, $01, $02, $03, $04, $05, $06, $01, $02, $03, $04, $05, $06, $00, $00
logo2:
.byte $00, $00, $0a, $0b, $0c, $00, $00, $00, $0a, $0b, $0d, $0a, $0b, $0d, $0a, $0b, $0c, $00, $00, $00, $0a, $0b, $0c, $00, $00, $00, $0a, $0b, $0c, $00, $00, $00, $0a, $0b, $0c, $00, $00, $00, $00, $00
logo3:
.byte $00, $00, $0e, $0f, $10, $00, $00, $00, $0e, $0f, $10, $0e, $0f, $10, $0e, $0f, $10, $00, $00, $00, $0e, $0f, $10, $00, $00, $00, $0e, $0f, $10, $00, $00, $00, $0e, $0f, $10, $00, $00, $00, $00, $00
logo4:
.byte $00, $00, $11, $12, $13, $00, $00, $00, $14, $15, $16, $11, $12, $17, $11, $12, $13, $00, $00, $00, $11, $12, $13, $00, $00, $00, $11, $12, $13, $00, $00, $00, $11, $12, $13, $00, $00, $00, $00, $00
logo5:
.byte $00, $00, $18, $19, $1a, $1b, $1c, $00, $1d, $1e, $1f, $20, $21, $22, $18, $19, $23, $00, $00, $00, $18, $19, $1a, $1b, $1c, $00, $24, $25, $26, $1b, $27, $28, $24, $25, $26, $1b, $27, $28, $00, $00
logo6:
.byte $00, $00, $29, $2a, $2b, $2c, $2d, $2e, $2f, $30, $31, $32, $2a, $33, $29, $2a, $2b, $2c, $2d, $2e, $29, $2a, $2b, $2c, $2d, $2e, $34, $35, $36, $37, $38, $39, $34, $35, $36, $37, $38, $39, $00, $00
logo7:
.byte $00, $00, $3a, $3b, $3c, $3a, $3b, $3d, $3a, $3b, $3c, $3a, $3b, $3c, $3a, $3b, $3c, $3a, $3b, $3d, $3a, $3b, $3c, $3a, $3b, $3d, $3a, $3b, $3c, $3a, $3b, $3d, $3a, $3b, $3c, $3a, $3b, $3d, $00, $00
logo8:
.byte $00, $00, $3e, $3f, $40, $3e, $3f, $40, $3e, $3f, $40, $3e, $3f, $40, $3e, $3f, $40, $3e, $3f, $40, $3e, $3f, $40, $3e, $3f, $40, $3e, $3f, $40, $3e, $3f, $40, $3e, $3f, $40, $3e, $3f, $40, $00, $00
logo9:
.byte $00, $00, $41, $42, $43, $44, $45, $46, $41, $42, $47, $41, $42, $47, $41, $42, $43, $44, $45, $46, $41, $42, $43, $44, $45, $46, $41, $42, $43, $44, $45, $46, $41, $42, $43, $44, $45, $46, $00, $00
