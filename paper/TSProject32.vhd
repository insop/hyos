-- Tagged sorter
ENTITY TSProject32 IS
  PORT
  (
    clk     : IN  STD_LOGIC;
    reset   : IN  STD_LOGIC;
    insert  : IN  STD_LOGIC;	-- enqueue trigger
    extract : IN  STD_LOGIC;	-- dequeue trigger

--  enqueuing elements (key & value)
    LIkey   : IN  STD_LOGIC_VECTOR ( 0 TO WIDTH_KEY-1 );
    LIdata  : IN  STD_LOGIC_VECTOR ( 0 TO WIDTH_DATA-1 );

--  dequeuing elements (key & value)
    ROkey   : BUFFER STD_LOGIC_VECTOR ( 0 TO WIDTH_KEY-1 );
    ROdata  : BUFFER STD_LOGIC_VECTOR ( 0 TO WIDTH_DATA-1 );

    Q_FULL  : OUT STD_LOGIC;
    Q_EMPTY : OUT STD_LOGIC
  );

END TSProject32;
