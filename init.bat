@echo 复制障碍点文件...
mkdir tmx
copy /Y ..\..\..\AsktaoMobile\res\\maps\tmx .\tmx\

@echo 开始转换...
cd convertLua
copy /Y ..\..\..\..\AsktaoMobile\res\cfg\MapInfo.lua .\

mkdir global
copy /Y ..\..\..\..\AsktaoMobile\src\global\CHS.lua .\
copy /Y ..\..\..\..\AsktaoMobile\src\global\CHS3.lua .\global\

D:\nodejs\node tabel2js.js D:/Lua/5.1/lua.exe MapInfo.lua > ..\MapInfo.js

cd ..
PAUSE
