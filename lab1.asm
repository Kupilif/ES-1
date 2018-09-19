#include "p16f84.inc" 

BEGIN:
    GOTO TASK1

; ---------- TASK 1 ----------

TASK1:
c_adr set 0x10  ; the starting address of the array, a constant
v_ptr equ 0x4F  ; the pointer to the current element in array, a variable
v_min equ 0x4E  ; the minimal number in array, a variable
c_num set 0x14  ; the number of elements in array, a constant 

; The allocation of variables in Data Memory:
; Address   :   The value of object
; 0x2E      :   v_ptr
; 0x2F      :   v_max
; 0x30      :   array[0]
; 0x31      :   array[1]
; 0x32      :   array[2]
; ...................
; 0x39      :   array[9]


	BCF STATUS, 0x5 ; set Bank0 in Data Memory by clearing RP0 bit in STATUS register
	CLRF v_ptr      ; v_ptr=0
	CLRF v_min      ; v_min=0
    COMF v_min, 1   ; v_min=255
T1LOOP1:
	MOVF v_ptr,0    ; W=v_ptr
	ADDLW c_adr     ; W=W+c_addr
	MOVWF FSR       ; FSR=W, INDF=array[W]
	MOVF INDF,0     ; W=INDF
	SUBWF v_min,0   ; W=v_min-W
	BTFSS STATUS,0  ; W > v_min ?
	GOTO SKIP       ; no
                    ; yes
    BTFSC STATUS, 2 ; W = v_min ?
    GOTO SKIP       ; yes
                    ; no
	MOVF v_ptr,0
	ADDLW c_adr
	MOVWF FSR
	MOVF INDF,0
	MOVWF v_min     ; v_min=array[v_ptr]
	
SKIP:
	INCF v_ptr,0x1  ; v_ptr=v_ptr+1
	MOVLW c_num     ; W=c_num
	SUBWF v_ptr,0   ; W=v_ptr-W
	BTFSS STATUS,0  ; v_ptr >= c_num ?
	GOTO T1LOOP1      ; no
	                ; yes
	CLRF v_ptr      ; v_ptr=0
	CLRF v_min      ; v_max=0
    GOTO PREND

; ---------- ---------- ----------

c_array_start set 0x10
c_items_count set 0x10
c_items_count_minus_one set 0xF
v_i equ 0x0C
v_j equ 0x0D
v_a equ 0x0E
v_b equ 0x0F

; ---------- TASK 2 ----------

TASK2:
    BCF STATUS, 0x5

    CLRF v_i                ; 
    INCF v_i, 0x1           ; i = 1

T2LOOP1:
    MOVLW c_items_count     ;
    SUBWF v_i, 0            ;
    BTFSC STATUS,0          ; i < N
    GOTO T2END              ; no
                            ; yes
    MOVLW c_items_count     ;
    MOVWF v_j               ;
    DECF v_j, 0x1           ; j = N - 1

T2LOOP2:
    MOVF v_i, 0             ;
    SUBWF v_j, 0            ;
    BTFSS STATUS, 0         ; j >= i
    GOTO T2LOOP1END         ; no
                            ; yes
    MOVF v_j, 0             ;
    ADDLW c_array_start     ;
    MOVWF FSR               ;
    MOVF INDF,0             ;
    MOVWF v_a               ; a = array[j]

    DECF v_j, 0             ;
    ADDLW c_array_start     ;
    MOVWF FSR               ;
    MOVF INDF,0             ; W = array[j - 1]
    MOVWF v_b               ; b = array[j - 1]

    SUBWF v_a, 0            ; array[j] - array[j - 1]

    BTFSC STATUS, 0         ; array[j-1] > array[j]
    GOTO T2LOOP2END         ; no
                            ; yes
    MOVF v_j, 0             ;
    ADDLW c_array_start     ;
    MOVWF FSR               ;
    MOVF v_b, 0             ;
    MOVWF INDF              ; array[j] = b = array[j - 1]

    DECF v_j, 0             ;
    ADDLW c_array_start     ;
    MOVWF FSR               ;
    MOVF v_a, 0             ;
    MOVWF INDF              ; array[j - 1] = a = array[j]

T2LOOP2END:
    DECF v_j, 0x1           ; j--
    GOTO T2LOOP2

T2LOOP1END:
    INCF v_i, 0x1           ; i++
    GOTO T2LOOP1

T2END:  
    GOTO PREND

; ---------- ---------- ----------

; ---------- TASK 3 ----------

TASK3:
    BCF STATUS, 0x5

    CLRF v_i                ; 
    INCF v_i, 0x1           ; i = 1

T3LOOP1:
    MOVLW c_items_count     ;
    SUBWF v_i, 0            ;
    BTFSC STATUS,0          ; i < N
    GOTO T3END              ; no
                            ; yes
    MOVLW c_items_count     ;
    MOVWF v_j               ;
    DECF v_j, 0x1           ; j = N - 1

T3LOOP2:
    MOVF v_i, 0             ;
    SUBWF v_j, 0            ;
    BTFSS STATUS, 0         ; j >= i
    GOTO T3LOOP1END         ; no
                            ; yes
    DECF v_j, 0             ;
    ADDLW c_array_start     ;
    MOVWF FSR               ;
    MOVF INDF,0             ;
    MOVWF v_a               ; a = array[j - 1]

    MOVF v_j, 0             ;
    ADDLW c_array_start     ;
    MOVWF FSR               ;
    MOVF INDF,0             ; W = array[j]
    MOVWF v_b               ; b = array[j]

    SUBWF v_a, 0            ; array[j - 1] - array[j]

    BTFSC STATUS, 0         ; array[j - 1] < array[j]
    GOTO T3LOOP2END         ; no
                            ; yes
    MOVF v_j, 0             ;
    ADDLW c_array_start     ;
    MOVWF FSR               ;
    MOVF v_a, 0             ;
    MOVWF INDF              ; array[j] = a = array[j - 1]

    DECF v_j, 0             ;
    ADDLW c_array_start     ;
    MOVWF FSR               ;
    MOVF v_b, 0             ;
    MOVWF INDF              ; array[j - 1] = b = array[j]

T3LOOP2END:
    DECF v_j, 0x1           ; j--
    GOTO T3LOOP2

T3LOOP1END:
    INCF v_i, 0x1           ; i++
    GOTO T3LOOP1

T3END:                      
    GOTO PREND

; ---------- ---------- ----------

; ---------- TASK 4 ----------

TASK4:
    BCF STATUS, 0x5

    CLRF v_i                ; 
    INCF v_i, 0x1           ; i = 1

T4LOOP1:
    MOVLW c_items_count     ;
    SUBWF v_i, 0            ;
    BTFSC STATUS,0          ; i < N
    GOTO T4END              ; no
                            ; yes
    MOVLW c_items_count_minus_one ;
    MOVWF v_j                     ; j = N - 1

T4LOOP2:
    MOVF v_i, 0             ;
    SUBWF v_j, 0            ;
    BTFSS STATUS, 0         ; j >= i
    GOTO T4LOOP1END         ; no
                            ; yes
    MOVF v_j, 0             ;
    ADDLW c_array_start     ;
    MOVWF FSR               ;
    MOVF INDF,0             ;
    MOVWF v_a               ; a = array[j]

    DECF v_j, 0             ;
    ADDLW c_array_start     ;
    MOVWF FSR               ;
    MOVF INDF,0             ; W = array[j - 1]
    MOVWF v_b               ; b = array[j - 1]

    SUBWF v_a, 0            ; array[j] - array[j - 1]

    BTFSC STATUS, 0         ; array[j-1] > array[j]
    GOTO T4LOOP2END         ; no
                            ; yes
    MOVF v_a, 0             ;
    MOVWF INDF              ; array[j - 1] = a = array[j]

    MOVF v_j, 0             ;
    ADDLW c_array_start     ;
    MOVWF FSR               ;
    MOVF v_b, 0             ;
    MOVWF INDF              ; array[j] = b = array[j - 1]

T4LOOP2END:
    DECF v_j, 0x1           ; j--
    GOTO T4LOOP2

T4LOOP1END:
    INCF v_i, 0x1           ; i++
    GOTO T4LOOP1

T4END:  
    GOTO PREND

; ---------- ---------- ----------

PREND:
	end