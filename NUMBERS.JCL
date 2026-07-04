//NUMBERSJ JOB 1,NOTIFY=&SYSUID
//*******************************************************
//COBRUN  EXEC IGYWCL
//COBOL.SYSIN  DD DSN=&SYSUID..CBL(NUMBERS),DISP=SHR
//LKED.SYSLMOD DD DSN=&SYSUID..LOAD(NUMBERS),DISP=SHR
//*******************************************************
// IF RC = 0 THEN
//*******************************************************
//RUN     EXEC PGM=NUMBERS
//STEPLIB   DD DSN=&SYSUID..LOAD,DISP=SHR
//SYSOUT    DD SYSOUT=*,OUTLIM=15000
//CEEDUMP   DD DUMMY
//SYSUDUMP  DD DUMMY
//*******************************************************
// ENDIF
