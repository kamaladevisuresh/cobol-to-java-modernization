       IDENTIFICATION DIVISION.
       PROGRAM-ID. ELIGCHK.

       ENVIRONMENT DIVISION.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       COPY "copybooks/ACCTREC.cpy".

       01  WS-MIN-BALANCE          PIC 9(7)V99 VALUE 5000.00.

       PROCEDURE DIVISION.
       MAIN-LOGIC.
           MOVE 1234567890      TO ACCT-NUMBER
           MOVE 7500.50         TO ACCT-BALANCE
           MOVE 'D'             TO ACCT-STATUS
           MOVE 'Y'             TO KYC-VERIFIED-FLAG
           MOVE 'PREMIUM'       TO ACCT-TYPE-REQUESTED

           PERFORM CHECK-ELIGIBILITY

           DISPLAY "Account: " ACCT-NUMBER
           DISPLAY "Result: " ELIGIBILITY-RESULT
           DISPLAY "Message: " ELIGIBILITY-MSG

           STOP RUN.

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
