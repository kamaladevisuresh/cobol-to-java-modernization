  01  ACCOUNT-RECORD.
           05  ACCT-NUMBER         PIC 9(10).
           05  ACCT-BALANCE        PIC 9(7)V99.
           05  ACCT-STATUS         PIC X(01).
               88  STATUS-ACTIVE       VALUE 'A'.
               88  STATUS-DORMANT      VALUE 'D'.
               88  STATUS-CLOSED       VALUE 'C'.
           05  KYC-VERIFIED-FLAG   PIC X(01).
               88  KYC-VERIFIED        VALUE 'Y'.
               88  KYC-NOT-VERIFIED    VALUE 'N'.
           05  ACCT-TYPE-REQUESTED PIC X(10).
           05  ELIGIBILITY-RESULT  PIC X(01).
           05  ELIGIBILITY-MSG     PIC X(40).
           