--
-- Title :TSProject32
-- 
-- Description: Tagged sorter project using TaggedSorter8.vhd
--              This component has 64 queue capacities
--
-- Note  : based on Wang's algorith (TaggedSorter)
--         current fMax is 91.76Mhz (10.9 nsec)
--         if you do the timing sim faster than that, it will now work
--         make sure up and down clock can be read properly           
--         
--         design with Xilinx V4FX model (-10)
--         and fMax is (9.828ns), so got little faster than Altera
--
-- Author: Insop Song
-- Begin Date  : 2007 
-- Ver   : 0.5
--
-- Revision History 
-- --------------------------------------------------------------------
-- Date         Author          Comments 
-- 2007 04 24   Insop Song      fix the problem putting max to RI of Rn
-- 2007 05 01   Insop Song      using the cleaned up tagged sorter
-- 2012 04 22   Insop Song      update for Full/Empty and Tag
--
-- 

LIBRARY ieee;
USE ieee.std_logic_1164.all;
	
-- width_key, width_data definitions
use work.tagged_pak.all;

ENTITY TSProject32 IS
--  GENERIC (WIDTH_KEY: integer :=16;
--           WIDTH_DATA: integer :=16);
  PORT
  (   
    clk     : IN  STD_LOGIC;
    reset   : IN  STD_LOGIC;
    insert  : IN  STD_LOGIC;
    extract : IN  STD_LOGIC;

--    LItag   : IN  STD_LOGIC;
    LIkey   : IN  STD_LOGIC_VECTOR ( 0 TO WIDTH_KEY-1 );
    LIdata  : IN  STD_LOGIC_VECTOR ( 0 TO WIDTH_DATA-1 );

--    ROtag   : BUFFER STD_LOGIC;
    ROkey   : BUFFER STD_LOGIC_VECTOR ( 0 TO WIDTH_KEY-1 );
    ROdata  : BUFFER STD_LOGIC_VECTOR ( 0 TO WIDTH_DATA-1 );
    
    Q_FULL  : OUT STD_LOGIC;
    Q_EMPTY : OUT STD_LOGIC
  );
	
END TSProject32;

ARCHITECTURE struct OF TSProject32 IS
 ------------------------------------------
COMPONENT TaggedSorter32 IS
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
   
   SIGNAL LItag1 : STD_LOGIC;
	
   SIGNAL LOtag1 : STD_LOGIC;
   SIGNAL LOkey1 : STD_LOGIC_VECTOR ( 0 TO WIDTH_KEY-1 );
   SIGNAL LOdata1: STD_LOGIC_VECTOR ( 0 TO WIDTH_DATA-1 );

   SIGNAL ROtag1 : STD_LOGIC;

   SIGNAL ROtag2 : STD_LOGIC;
   SIGNAL ROkey2 : STD_LOGIC_VECTOR ( 0 TO WIDTH_KEY-1 );
   SIGNAL ROdata2: STD_LOGIC_VECTOR ( 0 TO WIDTH_DATA-1 );

   -- to make maximum value for key
   constant MAX_KEY_VAL  : std_logic_vector ( 0 TO WIDTH_KEY -1 ) :=(others=>'1');
   -- to make maximum value for key
   constant MAX_DATA_VAL : std_logic_vector ( 0 TO WIDTH_DATA-1 ) :=(others=>'1');

BEGIN

  -- this full indicator doesn't work
  -- maybe need to add some counter type
  -- 
  Q_FULL <= '0' WHEN LOkey1 = MAX_KEY_VAL  ELSE
            '1';

  Q_EMPTY <= '1' WHEN ROkey = MAX_KEY_VAL  ELSE
             '0';
--ext('1', LOkey5'length)

   LItag1  <= '0';

--   ROtag2  <= '0';
--   ROkey2  <= MAX_KEY_VAL;
--   ROdata2 <= MAX_DATA_VAL;

ext:   PROCESS(clk)
BEGIN
  
  IF (rising_edge(clk)) THEN
    IF (extract = '1') THEN
      ROtag2  <= '0';
      ROkey2 <= (others=>'1');
      ROdata2 <= (others=>'1');
      --ROkey2  <= MAX_KEY_VAL;
      --ROdata2 <= MAX_DATA_VAL;
    END IF;
  END IF;
END PROCESS ext;


TS1: TaggedSorter32 PORT MAP( clk, reset  , insert, extract,
                    LItag1, LIkey, LIdata,
                    ROtag1, ROkey, ROdata,  
                    LOtag1, LOkey1, LOdata1, 
                    ROtag2, ROkey2, ROdata2);

END struct;
