       IDENTIFICATION DIVISION.
       PROGRAM-ID. ELIGCHK.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT INPUT-FILE ASSIGN TO "./data/test-input.txt"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT OUTPUT-FILE ASSIGN TO "./data/test-output.txt"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD  INPUT-FILE.
       01  INPUT-LINE                 PIC X(100).

       FD  OUTPUT-FILE.
       01  OUTPUT-LINE                PIC X(100).

       WORKING-STORAGE SECTION.
       COPY "copybooks/ACCTREC.cpy".

       01  WS-MIN-BALANCE          PIC 9(7)V99 VALUE 5000.00.
       01  WS-EOF-FLAG              PIC X(01) VALUE 'N'.
       01  WS-BALANCE-TEXT          PIC X(09).

       PROCEDURE DIVISION.
       MAIN-LOGIC.
           OPEN INPUT INPUT-FILE
           OPEN OUTPUT OUTPUT-FILE

           PERFORM UNTIL WS-EOF-FLAG = 'Y'
               READ INPUT-FILE
                   AT END
                       MOVE 'Y' TO WS-EOF-FLAG
                   NOT AT END
                       PERFORM PROCESS-ONE-RECORD
               END-READ
           END-PERFORM

           CLOSE INPUT-FILE
           CLOSE OUTPUT-FILE

           DISPLAY "Processing complete. See data/test-output.txt"
           STOP RUN.

       PROCESS-ONE-RECORD.
           UNSTRING INPUT-LINE DELIMITED BY ","
               INTO ACCT-NUMBER
                    WS-BALANCE-TEXT
                    ACCT-STATUS
                    KYC-VERIFIED-FLAG
                    ACCT-TYPE-REQUESTED
           END-UNSTRING

           COMPUTE ACCT-BALANCE = FUNCTION NUMVAL(WS-BALANCE-TEXT)

           PERFORM CHECK-ELIGIBILITY

           MOVE SPACES TO OUTPUT-LINE

           STRING ACCT-NUMBER DELIMITED BY SIZE
                  "," DELIMITED BY SIZE
                  ELIGIBILITY-RESULT DELIMITED BY SIZE
                  "," DELIMITED BY SIZE
                  ELIGIBILITY-MSG DELIMITED BY SIZE
               INTO OUTPUT-LINE
           END-STRING

           WRITE OUTPUT-LINE

           DISPLAY ACCT-NUMBER " -> " ELIGIBILITY-RESULT
               " : " ELIGIBILITY-MSG.

       CHECK-ELIGIBILITY.
           EVALUATE TRUE
               WHEN NOT STATUS-ACTIVE
                   MOVE 'N' TO ELIGIBILITY-RESULT
                   MOVE 'Account is not active' TO ELIGIBILITY-MSG
               WHEN KYC-NOT-VERIFIED
                   MOVE 'N' TO ELIGIBILITY-RESULT
                   MOVE 'KYC verification pending' TO ELIGIBILITY-MSG
               WHEN ACCT-BALANCE < WS-MIN-BALANCE
                   MOVE 'N' TO ELIGIBILITY-RESULT
                   MOVE 'Balance below minimum requirement' TO ELIGIBILITY-MSG
               WHEN OTHER
                   MOVE 'Y' TO ELIGIBILITY-RESULT
                   MOVE 'Eligible for requested account type' TO ELIGIBILITY-MSG
           END-EVALUATE.
           