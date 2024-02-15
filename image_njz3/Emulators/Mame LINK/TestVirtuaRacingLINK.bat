:: Our local IP address
SET LOCALIP=192.168.1.201
:: Next machine IP address
SET NEXTIP=192.168.1.202
:: Our local incoming port
SET LOCALPORT=15112
:: Outgoing connection port
SET NEXTPORT=15113

:: Normal command
::start mame.exe vr -nvram_directory nvram1 -comm_localport %LOCALPORT% -comm_remoteport %NEXTPORT% -comm_localhost %LOCALIP% -comm_remotehost %NEXTIP%

:: Local loopback only for testing
start mame.exe vr -nvram_directory nvram1 -comm_localport %LOCALPORT% -comm_remoteport %NEXTPORT% -comm_localhost 127.0.0.1 -comm_remotehost 127.0.0.1
start mame.exe vr -nvram_directory nvram2 -comm_localport %NEXTPORT% -comm_remoteport %LOCALPORT% -comm_localhost 127.0.0.1 -comm_remotehost 127.0.0.1
