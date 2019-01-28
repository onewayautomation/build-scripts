call setup-environment.cmd

SET PATH_ZLIB=%REPO_BASE_FOLDER%\zlib
SET TAG_ZLIB=v1.2.11

SET ARCH= 
IF "%ARCHITECTURE%"=="x64" SET ARCH=Win64

IF EXIST %PATH_ZLIB% GOTO BUILD_ZLIB
echo Cloning ZLib ...
git clone --recursive --branch %TAG_ZLIB% --depth 1 https://github.com/madler/zlib.git %PATH_ZLIB%
:BUILD_ZLIB
PUSHD %PATH_ZLIB%
cmake -G "Visual Studio 15 2017" -A %ARCHITECTURE% .
cmake --build .
msbuild zlib.sln /p:Configuration=Release
msbuild zlib.sln /p:Configuration=Debug
POPD
:END_ZLIB