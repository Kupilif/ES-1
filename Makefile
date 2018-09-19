# MPLAB IDE generated this makefile for use with GNU make.
# Project: lab1.mcp
# Date: Sun Sep 16 16:35:52 2018

AS = MPASMWIN.exe
CC = 
LD = mplink.exe
AR = mplib.exe
RM = rm

lab1.cof : lab1.o
	$(CC) /p16F84 "lab1.o" /u_DEBUG /z__MPLAB_BUILD=1 /z__MPLAB_DEBUG=1 /o"lab1.cof" /M"lab1.map" /W /x

lab1.o : lab1.asm C:/Program\ Files\ (x86)/Microchip/MPASM\ Suite/p16f84.inc
	$(AS) /q /p16F84 "lab1.asm" /l"lab1.lst" /e"lab1.err" /d__DEBUG=1

clean : 
	$(CC) "lab1.o" "lab1.hex" "lab1.err" "lab1.lst" "lab1.cof"

