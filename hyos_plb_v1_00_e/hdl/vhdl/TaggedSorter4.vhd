--
-- Title :TaggedSorter4
--
-- Note  : has 8 (4 * 2) queue capacities 

-- Author: Insop Song
-- Begin Date  : 2007 05 01 
-- Ver   : 0.1
--
-- Revision History 
-- ---------------------------------------------------------------
-- Date         Author          Comments 
-- 2007 05 01   Insop Song      
--
-- 


LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- width_key, width_data definitions
use work.tagged_pak.all;
	
ENTITY TaggedSorter4 IS
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
	
END TaggedSorter4;

ARCHITECTURE struct OF TaggedSorter4 IS
 ------------------------------------------
COMPONENT TaggedSorter2 IS
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
	
END COMPONENT;
 ------------------------------------------

   SIGNAL LOtag1 : STD_LOGIC;
   SIGNAL LOkey1 : STD_LOGIC_VECTOR ( 0 TO WIDTH_KEY-1 );
   SIGNAL LOdata1: STD_LOGIC_VECTOR ( 0 TO WIDTH_DATA-1 );

   SIGNAL ROtag2 : STD_LOGIC;
   SIGNAL ROkey2 : STD_LOGIC_VECTOR ( 0 TO WIDTH_KEY-1 );
   SIGNAL ROdata2: STD_LOGIC_VECTOR ( 0 TO WIDTH_DATA-1 );

BEGIN


TS1: TaggedSorter2 PORT MAP( clk, reset  , insert, extract,
                    LItag, LIkey, LIdata,
                    ROtag, ROkey, ROdata,  
                    LOtag1, LOkey1, LOdata1, 
                    ROtag2, ROkey2, ROdata2);

TS2: TaggedSorter2 PORT MAP( clk, reset  , insert, extract,
                    LOtag1, LOkey1, LOdata1, 
                    ROtag2, ROkey2, ROdata2,  
                    LOtag , LOkey , LOdata , 
                    RItag , RIkey , RIdata);

END struct;
