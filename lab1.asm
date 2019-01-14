#include "p16f84.inc" 

BEGIN:
    GOTO TASK1

; ***** Wheteher W is greater than INDF *****      

v_cmp_res equ 0x0C
BOOL_BIT set 0
BOOL_TRUE set 1
BOOL_FALSE set 0

IS_W_GREATER_THAN_INDF:
    CALL PERFORM_COMPARE
    MOVWF v_cmp_res
    RETURN
    
PERFORM_COMPARE:
    SUBWF INDF, W
    BTFSC STATUS, C
    RETLW BOOL_FALSE
    RETLW BOOL_TRUE

; ***** ***** *****

; ---------- TASK 1 ----------
; ***** Finds MIN element of array *****

c_adr set 0x10          ; the starting address of the array, a constant
c_num set 0x14          ; the number of elements in array, a constant
v_ptr equ 0x4F          ; the pointer to the current element in array, a variable
v_min equ 0x4E          ; the minimal number in array, a variable

; The allocation of variables in Data Memory:
; Address   :   The value of object
; 0x4F      :   v_ptr
; 0x4E      :   v_min
; 0x10      :   array[0]
; 0x11      :   array[1]
; 0x12      :   array[2]
; ...................
; 0x23      :   array[19]

TASK1:
	BCF STATUS, RP0 ; set Bank0 in Data Memory by clearing RP0 bit in STATUS register
	CLRF v_ptr      ; v_ptr=0
	CLRF v_min      ; v_min=0
    COMF v_min, 1   ; v_min=255
T1LOOP1:
	MOVF v_ptr, W   ; W=v_ptr
	ADDLW c_adr     ; W=W+c_addr
	MOVWF FSR       ; FSR=W, INDF=array[W]
    MOVF v_min, W   ; W=v_min

    CALL IS_W_GREATER_THAN_INDF
    BTFSS v_cmp_res, BOOL_BIT
    GOTO SKIP

SAVE_CURRENT_VALUE_AS_MIN:
	MOVF v_ptr, W
	ADDLW c_adr
	MOVWF FSR
	MOVF INDF, W
	MOVWF v_min     ; v_min=array[v_ptr]
	
SKIP:
	INCF v_ptr, F   ; v_ptr=v_ptr+1
	
    MOVLW v_ptr
    MOVWF FSR
    MOVLW c_num
    CALL IS_W_GREATER_THAN_INDF     ; c_num > v_ptr
    BTFSC v_cmp_res, BOOL_BIT       ;
	GOTO T1LOOP1                    ; yes
	                                ; no
    GOTO PREND

; ---------- ---------- ----------

c_array_start set 0x10
c_items_count set 0x10
c_items_count_minus_one set 0xF
v_i equ 0x0D
v_j equ 0x0E
v_tmp equ 0x0F

; ---------- TASK 2 ----------
; ***** Ascending sort of array using Bubble Sort *****

TASK2:
    BCF STATUS, RP0

    CLRF v_i                ; 
    INCF v_i, F             ; i = 1

T2LOOP1:
    MOVLW v_i                       ;
    MOVWF FSR                       ;
    MOVLW c_items_count             ;
    CALL IS_W_GREATER_THAN_INDF     ; 
    BTFSS v_cmp_res, BOOL_BIT       ; N > i
    GOTO T2END                      ; no
                                    ; yes
    MOVLW c_items_count     ;
    MOVWF v_j               ;
    DECF v_j, 0x1           ; j = N - 1

T2LOOP2:
    MOVLW v_j
    MOVWF FSR
    MOVF v_i, W
    CALL IS_W_GREATER_THAN_INDF ; i > j
    BTFSC v_cmp_res, BOOL_BIT   ;
    GOTO T2LOOP1END             ; yes
                                ; no
    DECF v_j, W             ;
    ADDLW c_array_start     ;
    MOVWF FSR               ;
    MOVF INDF, W            ; W = array[j - 1]
    INCF FSR, F             ; INDF = array[j]

    CALL IS_W_GREATER_THAN_INDF     ;
    BTFSS v_cmp_res, BOOL_BIT       ; array[j - 1] > array[j]
    GOTO T2LOOP2END                 ; no
                                    ; yes
    MOVF v_j, W             ;
    ADDLW c_items_count     ;
    MOVWF FSR               ;
    MOVF INDF, W            ; 
    MOVWF v_tmp             ; v_tmp = array[j]
    DECF FSR, F             ;
    MOVF INDF, W            ;
    INCF FSR, F             ;
    MOVWF INDF              ; array[j] = array[j - 1]
    DECF FSR, F             ;
    MOVF v_tmp, W           ;
    MOVWF INDF              ; array[j - 1] = v_tmp

T2LOOP2END:
    DECF v_j, F             ; j--
    GOTO T2LOOP2

T2LOOP1END:
    INCF v_i, F             ; i++
    GOTO T2LOOP1

T2END:  
    GOTO PREND

; ---------- ---------- ----------

; ---------- TASK 3 ----------
; ***** Descending sort of array using Bubble Sort *****

TASK3:
    BCF STATUS, RP0

    CLRF v_i                ; 
    INCF v_i, F             ; i = 1

T3LOOP1:
    MOVLW v_i                       ;
    MOVWF FSR                       ;
    MOVLW c_items_count             ;
    CALL IS_W_GREATER_THAN_INDF     ; 
    BTFSS v_cmp_res, BOOL_BIT       ; N > i
    GOTO T3END                      ; no
                                    ; yes
    MOVLW c_items_count     ;
    MOVWF v_j               ;
    DECF v_j, 0x1           ; j = N - 1

T3LOOP2:
    MOVLW v_j
    MOVWF FSR
    MOVF v_i, W
    CALL IS_W_GREATER_THAN_INDF ; i > j
    BTFSC v_cmp_res, BOOL_BIT   ;
    GOTO T3LOOP1END             ; yes
                                ; no
    MOVF v_j, W             ;
    ADDLW c_array_start     ;
    MOVWF FSR               ;
    MOVF INDF, W            ; W = array[j]
    DECF FSR, F             ; INDF = array[j - 1]

    CALL IS_W_GREATER_THAN_INDF     ;
    BTFSS v_cmp_res, BOOL_BIT       ; array[j] > array[j - 1]
    GOTO T3LOOP2END                 ; no
                                    ; yes
    MOVF v_j, W             ;
    ADDLW c_items_count     ;
    MOVWF FSR               ;
    MOVF INDF, W            ; 
    MOVWF v_tmp             ; v_tmp = array[j]
    DECF FSR, F             ;
    MOVF INDF, W            ;
    INCF FSR, F             ;
    MOVWF INDF              ; array[j] = array[j - 1]
    DECF FSR, F             ;
    MOVF v_tmp, W           ;
    MOVWF INDF              ; array[j - 1] = v_tmp

T3LOOP2END:
    DECF v_j, F             ; j--
    GOTO T3LOOP2

T3LOOP1END:
    INCF v_i, F             ; i++
    GOTO T3LOOP1

T3END:  
    GOTO PREND

; ---------- ---------- ----------

; ---------- TASK 4 ----------
; ***** Optimization by code size of TASK 2 *****

TASK4:
    BCF STATUS, RP0

    CLRF v_i                ; 
    INCF v_i, F             ; i = 1

T4LOOP1:
    MOVLW v_i                       ;
    MOVWF FSR                       ;
    MOVLW c_items_count             ;
    CALL IS_W_GREATER_THAN_INDF     ; 
    BTFSS v_cmp_res, BOOL_BIT       ; N > i
    GOTO T4END                      ; no
                                    ; yes
    MOVLW c_items_count - 1         ;
    MOVWF v_j                       ; j = N - 1

T4LOOP2:
    MOVLW v_j
    MOVWF FSR
    MOVF v_i, W
    CALL IS_W_GREATER_THAN_INDF ; i > j
    BTFSC v_cmp_res, BOOL_BIT   ;
    GOTO T4LOOP1END             ; yes
                                ; no
    DECF v_j, W             ;
    ADDLW c_array_start     ;
    MOVWF FSR               ;
    MOVF INDF, W            ; W = array[j - 1]
    INCF FSR, F             ; INDF = array[j]

    CALL IS_W_GREATER_THAN_INDF     ;
    BTFSS v_cmp_res, BOOL_BIT       ; array[j - 1] > array[j]
    GOTO T4LOOP2END                 ; no
                                    ; yes
    MOVF v_j, W             ;
    ADDLW c_items_count     ;
    MOVWF FSR               ;
    MOVF INDF, W            ; 
    MOVWF v_tmp             ; v_tmp = array[j]
    DECF FSR, F             ;
    MOVF INDF, W            ;
    INCF FSR, F             ;
    MOVWF INDF              ; array[j] = array[j - 1]
    DECF FSR, F             ;
    MOVF v_tmp, W           ;
    MOVWF INDF              ; array[j - 1] = v_tmp

T4LOOP2END:
    DECF v_j, F             ; j--
    GOTO T2LOOP2

T4LOOP1END:
    INCF v_i, F             ; i++
    GOTO T2LOOP1

T4END:  
    GOTO PREND

; ---------- ---------- ----------

PREND:
	end