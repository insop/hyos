--
-- Title TaggedSorter
--
-- Note:  has 2 (1 * 2) queue capacities 
--        basic block of tagged sorter
--        C-C Wang's style implementation
--
-- Author: Insop Song
-- Begin Date  : 2007 04 23 
-- Ver   : 0.3b
-- Ver   : 0.3c
--
-- Revision History 
-- ---------------------------------------------------------------
-- Date         Author          Comments 
-- 2007 05 01   Insop Song      
-- 2007 05 01   Insop Song      FSM way, not stable yet
-- 2007 05 01   Insop Song      
--
-- 

LIBRARY ieee;
USE ieee.std_logic_1164.all;


-- width_key, width_data definitions
use work.tagged_pak.all;
	

ENTITY TaggedSorter IS
--  GENERIC (WIDTH_KEY: integer :=16;
--           WIDTH_DATA: integer :=16);
  PORT
  (   
    clk     : IN  STD_LOGIC;
    reset   : IN  STD_LOGIC;
    insert  : IN  STD_LOGIC;
    extract : IN  STD_LOGIC;

    LItag   : IN  STD_LOGIC;
    LIkey   : IN  STD_LOGIC_VECTOR ( 0 TO WIDTH_KEY-1 );
    LIdata  : IN  STD_LOGIC_VECTOR ( 0 TO WIDTH_DATA-1 );

    ROtag   : BUFFER STD_LOGIC;
    ROkey   : BUFFER STD_LOGIC_VECTOR ( 0 TO WIDTH_KEY-1 );
    ROdata  : BUFFER STD_LOGIC_VECTOR ( 0 TO WIDTH_DATA-1 );

    LOtag   : BUFFER STD_LOGIC;
    LOkey   : BUFFER STD_LOGIC_VECTOR ( 0 TO WIDTH_KEY-1 );
    LOdata  : BUFFER STD_LOGIC_VECTOR ( 0 TO WIDTH_DATA-1 );

    RItag   : IN  STD_LOGIC;
    RIkey   : IN  STD_LOGIC_VECTOR ( 0 TO WIDTH_KEY-1 );
    RIdata  : IN  STD_LOGIC_VECTOR ( 0 TO WIDTH_DATA-1 )
  );
END TaggedSorter;

ARCHITECTURE RTL_FSM OF TaggedSorter IS
  -- state definition
  type cntl_state is (s_compare, s_swap);
  signal cs: cntl_state;

  SIGNAL  Akey, Bkey	: STD_LOGIC_VECTOR ( 0 TO WIDTH_KEY-1 );
  SIGNAL  Adata, Bdata	: STD_LOGIC_VECTOR ( 0 TO WIDTH_DATA-1 );
  SIGNAL  Atag, Btag	: STD_LOGIC;  

  SIGNAL  swap          : STD_LOGIC;

BEGIN 
  
--sync:	PROCESS(clk, reset) 
--BEGIN
  --IF reset = '1'  THEN
    --cs <= s_init;
--
  --ELSIF (rising_edge(clk)) THEN
    --cs <= ns;
  --END IF;
--END PROCESS sync;


--comb:   PROCESS(cs, insert, extract, swap)  

PROCESS(clk, reset)
BEGIN

IF reset ='1' THEN
  --cs < = s_init;
        Akey  <= (others=>'1');
        Adata <= (others=>'1');
        Atag  <= '0'; 
        Bkey  <= (others=>'1');
        Bdata <= (others=>'1');
        Btag  <= '0';
      
        LOkey  <= (others=>'1');
        LOdata <= (others=>'1');
        LOtag  <= '0';
        ROkey  <= (others=>'1');      
        ROdata <= (others=>'1');
        ROtag  <= '0';
        cs    <= s_compare;
ELSIF (rising_edge(clk)) THEN
    case (cs) is
      --when s_init =>
        --
        --ns    <= s_compare;
      when s_compare =>
        IF (insert ='1' AND extract ='0') THEN
          Akey  <= LIkey;
          Adata <= LIdata;
          Atag  <= LItag;
          Bkey  <= ROkey;
          Bdata <= ROdata;
          Btag  <= ROtag; 
          cs    <= s_swap;
        ELSIF (insert = '0' AND extract ='1') THEN
          Akey  <= LOkey;
          Adata <= LOdata;
          Atag  <= LOtag;
          Bkey  <= RIkey;
          Bdata <= RIdata;
          Btag  <= RItag;	    
          cs    <= s_swap;
        ELSE
          cs    <= s_compare;
        END IF;
      when s_swap =>
        if swap = '1' then
          LOkey <= Bkey;
          LOdata<= Bdata;
          LOtag <= Btag;
          ROkey <= Akey;
          ROdata<= Adata;
          ROtag <= '1';
          cs    <= s_compare;
        else
          LOkey <= Akey;
          LOdata<= Adata;
          LOtag <= Atag;
          ROkey <= Bkey;
          ROdata<= Bdata;
          ROtag <= Btag;
          cs    <= s_compare;
        end if;
      when others => null;
    end case;

    --cs <= ns;
end if;
END PROCESS;



--p_swap:	PROCESS(Akey, Bkey, Atag) 
--BEGIN
  --IF ( (Akey < Bkey) OR (Atag ='1')) THEN  
    --swap <= '1';
  --ELSE
    --swap <= '0';
  --END IF;
--END PROCESS p_swap;  
--
  swap <= '1' when (Akey < Bkey) OR (Atag ='1') else
          '0';
END RTL_FSM;
