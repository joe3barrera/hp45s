10 REM HP-41C Calculator for Tandy Model 100 - Fixed Version
20 DIM S#(4),R#(9):REM Stack (T,Z,Y,X) and Storage Registers
30 S#(1)=0:S#(2)=0:S#(3)=0:S#(4)=0:REM Initialize stack
40 A$="":E%=0:L%=1:C$="":REM A$=input, E%=entering, L%=lift, C$=command
50 GOSUB 900:REM Display initial state

100 REM Main Input Loop
110 K$=INKEY$:IF K$="" THEN 110
120 IF K$=CHR$(13) THEN GOSUB 200:GOTO 100:REM Enter key
130 IF K$=CHR$(8) THEN GOSUB 250:GOTO 100:REM Backspace
140 IF K$>="0" AND K$<="9" THEN GOSUB 300:GOTO 100:REM Digit
150 IF K$="." THEN GOSUB 360:GOTO 100:REM Decimal point
160 IF K$="+" OR K$="-" OR K$="*" OR K$="/" THEN GOSUB 280:GOSUB 400:GOTO 100
170 REM Only process commands if not a handled key
180 IF K$="S" OR K$="C" OR K$="Q" OR K$="L" OR K$="N" OR K$="I" OR K$="P" OR K$="W" OR K$="R" THEN GOSUB 280:GOSUB 500:GOTO 100
190 GOTO 100

200 REM ENTER Key - Duplicate X to Y with lift
210 GOSUB 280:REM Finish any pending number
220 GOSUB 750:REM Lift stack
230 S#(1)=S#(2):REM Copy Y back to X (duplicate)
240 L%=0:REM No lift on next number
245 GOSUB 900:RETURN

250 REM Backspace - Remove last digit
260 IF E% AND LEN(A$)>0 THEN A$=LEFT$(A$,LEN(A$)-1):IF A$<>"" THEN S#(1)=VAL(A$) ELSE S#(1)=0
270 GOSUB 900:RETURN

280 REM Finish Number Entry
285 IF E% THEN S#(1)=VAL(A$):E%=0:A$=""
290 RETURN

300 REM Digit Entry
305 REM Check if we need to start a new number
310 IF E%=0 THEN IF L% THEN GOSUB 750
312 IF E%=0 THEN S#(1)=0:E%=1:A$=""
315 REM Now add the digit to current number
320 A$=A$+K$:S#(1)=VAL(A$)
325 GOSUB 900:RETURN

360 REM Decimal Point
365 IF E%=0 THEN IF L% THEN GOSUB 750
367 IF E%=0 THEN S#(1)=0:E%=1:A$=""
370 IF INSTR(A$,".")=0 THEN A$=A$+".":IF LEN(A$)>1 THEN S#(1)=VAL(A$)
380 GOSUB 900:RETURN

400 REM Arithmetic Operations
410 REM Make sure we're not in entry mode
415 IF E% THEN S#(1)=VAL(A$):E%=0:A$=""
420 IF K$="+" THEN T#=S#(2)+S#(1):GOSUB 800:S#(1)=T#:L%=1:GOSUB 900:RETURN
430 IF K$="-" THEN T#=S#(2)-S#(1):GOSUB 800:S#(1)=T#:L%=1:GOSUB 900:RETURN
440 IF K$="*" THEN T#=S#(2)*S#(1):GOSUB 800:S#(1)=T#:L%=1:GOSUB 900:RETURN
450 IF K$="/" THEN IF S#(1)<>0 THEN T#=S#(2)/S#(1):GOSUB 800:S#(1)=T#:L%=1:GOSUB 900:RETURN ELSE ?"DIV/0":GOSUB 900:RETURN
460 RETURN

500 REM Command Processing
510 C$=C$+K$:REM Build command string
520 IF K$="S" AND LEN(C$)=1 THEN S#(1)=SIN(S#(1)):L%=1:C$="":GOSUB 900:RETURN
530 IF K$="C" AND LEN(C$)=1 THEN S#(1)=COS(S#(1)):L%=1:C$="":GOSUB 900:RETURN
540 IF K$="Q" AND LEN(C$)=1 THEN IF S#(1)>=0 THEN S#(1)=SQR(S#(1)):L%=1 ELSE ?"NEG SQRT":C$="":GOSUB 900:RETURN
550 IF K$="L" AND LEN(C$)=1 THEN IF S#(1)>0 THEN S#(1)=LOG(S#(1))/LOG(10):L%=1 ELSE ?"LOG<=0":C$="":GOSUB 900:RETURN
560 IF K$="N" AND LEN(C$)=1 THEN IF S#(1)>0 THEN S#(1)=LOG(S#(1)):L%=1 ELSE ?"LN<=0":C$="":GOSUB 900:RETURN
570 IF K$="I" AND LEN(C$)=1 THEN IF S#(1)<>0 THEN S#(1)=1/S#(1):L%=1 ELSE ?"1/0":C$="":GOSUB 900:RETURN
575 IF K$="P" AND LEN(C$)=1 THEN GOSUB 750:S#(1)=3.14159265358979#:L%=0:C$="":GOSUB 900:RETURN
580 IF K$="W" AND LEN(C$)=1 THEN T#=S#(1):S#(1)=S#(2):S#(2)=T#:C$="":GOSUB 900:RETURN
590 IF LEFT$(C$,1)="S" AND LEN(C$)=2 THEN G=ASC(MID$(C$,2,1))-48:IF G>=0 AND G<=9 THEN R#(G)=S#(1):C$="":GOSUB 900:RETURN
600 IF LEFT$(C$,1)="R" AND LEN(C$)=2 THEN G=ASC(MID$(C$,2,1))-48:IF G>=0 AND G<=9 THEN GOSUB 750:S#(1)=R#(G):L%=0:C$="":GOSUB 900:RETURN
610 IF LEN(C$)>=2 THEN C$="":?"UNKNOWN":GOSUB 900:RETURN
620 GOSUB 900:RETURN

750 REM Lift Stack
760 S#(4)=S#(3):S#(3)=S#(2):S#(2)=S#(1):S#(1)=0
770 RETURN

800 REM Drop Stack
810 S#(1)=S#(2):S#(2)=S#(3):S#(3)=S#(4):S#(4)=0
820 RETURN

900 REM Display Stack
910 CLS:?"T:";S#(4):?"Z:";S#(3):?"Y:";S#(2)
920 IF E% THEN ?"X:";A$;"_" ELSE ?"X:";S#(1)
930 ?:IF C$<>"" THEN ?"CMD:";C$
940 ?:?"F1=Help"
950 RETURN