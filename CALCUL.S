PROCEDURE calcul(depth%)
  LOCAL amp%,n%,i%,j%
  PRINT "Calcul en cours..."
  amp%=256
  n%=2
  PRINT "   Itérations:";
  FOR iter%=1 TO depth%
    PRINT iter%;"..";
    FOR j%=n% DOWNTO 0
      FOR i%=n% DOWNTO 0
        h%(i%*2,j%*2)=h%(i%,j%)
      NEXT i%
    NEXT j%
    n%=n%*2
    FOR j%=1 TO n%-1 STEP 2
      FOR i%=1 TO n%-1 STEP 2
        h%(i%-1,j%)=(h%(i%-1,j%-1)+h%(i%-1,j%+1))/2
        ADD h%(i%-1,j%),INT(RND*amp%)-amp%/2
        h%(i%,j%-1)=(h%(i%-1,j%-1)+h%(i%+1,j%-1))/2
        ADD h%(i%,j%-1),INT(RND*amp%)-amp%/2
        h%(i%,j%)=h%(i%-1,j%-1)+h%(i%-1,j%+1)
        ADD  h%(i%,j%),h%(i%+1,j%-1)+h%(i%+1,j%+1)
        h%(i%,j%)=h%(i%,j%)/4+INT(RND*amp%)-amp%/2
      NEXT i%
    NEXT j%
    FOR i%=1 TO n%-1 STEP 2
      h%(n%,i%)=(h%(n%,i%-1)+h%(n%,i%+1))/2+INT(RND*amp%)-amp%/2
      h%(i%,n%)=(h%(i%-1,n%)+h%(i%+1,n%))/2+INT(RND*anp%)-amp%/2
    NEXT i%
    amp%=amp%/2
  NEXT iter%
  PRINT CHR$(7)
RETURN
