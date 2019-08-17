;*********************************************************************************
; Filename:		ID_Number.asm
; Author:		Graham Winchester
; Student ID: 	1814444 
; Date:  		03/12/18

; Description:
; Program to count and flash to my student ID number

; DEC: 1814444
;
; OCT: 6727654
;*********************************************************************************
	list p=16F684			; list directive to define processor
	#include <p16f684.inc>	; processor specific variable definitions
	__CONFIG _CP_OFF & _WDT_OFF & _PWRTE_ON & _INTRC_OSC_NOCLKOUT & _MCLRE_OFF & _CPD_OFF
	radix dec				; default radix is decimal
	errorlevel -302			; suppress warnings when accessing SFRs in bank 1
;****************************** Assignment Statements ****************************
; SET 2 COUNTERS
COUNT1 EQU 20h	; COUNT1
COUNT2 EQU 21h	; COUNT2
;******************************* Define Preprocessor Statements *****************
; Define the 'direction' TRISA
#define TRISA_D0_D1	B'00001111'	; D0 and D1 connected between RA4 and RA5
#define TRISA_D2_D3	B'00101011'	; D2 and D3 connected between RA4 and RA2
#define TRISA_D4_D5	B'00011011'	; D4 and D5 connected between RA2 and RA5
#define TRISA_D6_D7	B'00111001'	; D6 and D7 connected between RA2 and RA1

; Define the 'data output' PORTA
#define LED_D0_ON	B'00010000'	; Sending HIGH to D0
#define LED_D1_ON	B'00100000'	; Sending HIGH to D1
#define LED_D2_ON	B'00010000'	; Sending HIGH to D2
#define LED_D3_ON	B'00000100'	; Sending HIGH to D3
#define LED_D4_ON	B'00100000'	; Sending HIGH to D4
#define LED_D5_ON	B'00000100'	; Sending HIGH to D5
#define LED_D6_ON	B'00000100'	; Sending HIGH to D6
#define LED_D7_ON	B'00000010'	; Sending HIGH to D7

;****************************** Start of Program ******************************
; Initial configuration - Common for all programs for CIS018-1
	 	org    	0x000		; Processor reset vector
	 	bcf    	STATUS,RP0	; Bank 0 selected
	 	movlw	07h			; Set RA<2:0> to digital and 
	 	movwf  	CMCON0 		; Comparators turned OFF
	 	bsf    	STATUS,RP0	; Bank 1 selected
	 	clrf   	ANSEL 		; Digital I/O selected
	 	movlw	B'00111111'	; Move in W - 0x3F - Set all I/O pins as digital inputs
	 	movwf	TRISA		; Configure I/O ports		
	 	clrf	INTCON		; Disable all interrupts, clear all flags	
	 	bcf    	STATUS,RP0	; Bank 0 selected
	 	clrf	PORTA		; Clear all outputs
;*********************************************************************************
;PRELOAD COUNT VALUES
		movlw	0xFF
		movwf	COUNT1 ;MOVE VALUE INTO COUNT1
     	movlw  	0xFF
	 	movwf  	COUNT2 ;MOVE VALUE INTO COUNT2
;*********************************************************************************
START	call	SETD6D7		;SET LED BANK D6 D7
		call 	LED6 		;TURN LED6 ON
		call	DELAYCLEAR	;DELAY AND CLEAR
		call 	LED7 		;TURN LED7 ON
		call	DELAYCLEAR	;DELAY AND CLEAR
		call	SETD2D3		;SET LED BANK D2 D3
		call 	LED2 		;TURN LED2 ON
		call	DELAYCLEAR	;DELAY AND CLEAR
		call	SETD6D7		;SET LED BANK D6 D7
		call 	LED7 		;TURN LED7 ON
		call	DELAYCLEAR	;DELAY AND CLEAR
		call 	LED6 		;TURN LED6 ON
		call	DELAYCLEAR	;DELAY AND CLEAR
		call	SETD4D5		;SET LED BANK D4 D5
		call 	LED5 		;TURN LED5 ON
		call	DELAYCLEAR	;DELAY AND CLEAR
		call 	LED4 		;TURN LED4 ON
		call	DELAYCLEAR	;DELAY AND CLEAR
		call	DELAY		;DELAY
;*********************************************************************************
		goto	START		;LOOP
;*********************************************************************************
; SET LED BANK
;*********************************************************************************
SETD0D1
	 	bsf		STATUS, RP0
	 	movlw	TRISA_D0_D1 ;SET D0 D1
	 	movwf	TRISA
	 	bcf		STATUS,RP0	;CLEAR
		return
;*********************************************************************************
SETD2D3
	 	bsf		STATUS, RP0
	 	movlw	TRISA_D2_D3 ;SET D2 D3
	 	movwf	TRISA
	 	bcf		STATUS,RP0	;CLEAR
		return
;*********************************************************************************
SETD4D5
	 	bsf		STATUS, RP0
	 	movlw	TRISA_D4_D5 ;SET D4 D5
	 	movwf	TRISA
	 	bcf		STATUS,RP0	;CLEAR
		return
;*********************************************************************************
SETD6D7
		bsf		STATUS,RP0
	 	movlw	TRISA_D6_D7 ;SET D6 D7
	 	movwf	TRISA
	 	bcf		STATUS, RP0	;CLEAR
		return
;*********************************************************************************
; TURN LED ON
;*********************************************************************************
LED0	movlw	LED_D0_ON	;LED 0 ON
		movwf	PORTA
		return
;*********************************************************************************
LED1	movlw	LED_D1_ON	;LED 1 ON
		movwf	PORTA
		return
;*********************************************************************************
LED2	movlw	LED_D2_ON	;LED 2 ON
		movwf	PORTA
		return
;*********************************************************************************
LED3	movlw	LED_D3_ON	;LED 3 ON
		movwf	PORTA
		return
;*********************************************************************************
LED4	movlw	LED_D4_ON	;LED 4 ON
		movwf	PORTA
		return
;*********************************************************************************
LED5	movlw	LED_D5_ON	;LED 5 ON
		movwf	PORTA
		return
;*********************************************************************************
LED6	movlw	LED_D6_ON	;LED 6 ON
 	 	movwf	PORTA
		return
;*********************************************************************************
LED7	movlw	LED_D7_ON	;LED 7 ON
 	 	movwf	PORTA
		return
;*********************************************************************************
; DELAY CLEAR
;*********************************************************************************
DELAYCLEAR
		call	DELAY		;DELAY
	 	call	CLEARA		;CLEAR PORTA
		call	DELAY		;DELAY
		return
;*********************************************************************************
; CLEAR PORTA
;*********************************************************************************
CLEARA
	 	clrf	PORTA		;CLEAR
		return
;*********************************************************************************
; DELAY TWICE
;*********************************************************************************
DELAY
		call LOOP1	;RUN LOOP1
		call LOOP1	;RUN LOOP1
		return
;*********************************************************************************
; LOOP
;*********************************************************************************
LOOP1   decfsz   COUNT1,1
     	goto     LOOP1
	 	decfsz   COUNT2,1
     	goto     LOOP1

		movlw	 0xFF
		movwf	 COUNT2
		return
;*********************************************************************************
	 	end
;*********************************************************************************
