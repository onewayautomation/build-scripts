call setup-environment
@echo off
SET vc_bat_name1="C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat"
SET VSV=VS2017\

REM SET vc_bat_name1="C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat"

REM To build with Visual Studio 2008, set the following below options:
REM Modify acording to Vs 2008 installation location:
REM SET vc_bat_name1="D:\Microsoft Visual Studio 9.0\VC\vcvarsall.bat"
REM SET VSV=VS2008\

REM If the build fails with error that UINT16_MAX is not defined, then:
REM in file OpenSSL_Src\crypto\sm2\sm2_sign.c add following directive (after other includes):
REM #include "internal/numbers.h"

@echo on




REM Add path to rc tool:
SET PATH=%PATH%;C:\Program Files (x86)\Windows Kits\10\bin\10.0.16299.0\x86
SET PATH_OPENSSL=openssl-1.1.1
SET PATH_ZLIB=zlib

SET INSTALL_DIR=%REPO_BASE_FOLDER%\%PATH_OPENSSL%-distr
REM *****************************

SET TAG_OPENSSL=OpenSSL_1_1_1

REM SET BUILD_MODE=VC-WIN32
SET BUILD_MODE=VC-WIN64A
IF "%1"=="Debug" SET BUILD_MODE=debug-VC-WIN64A
REM 64 bit Release version: VC-WIN64A
REM 32 bit Release version: VC-WIN32
REM Note that even if openssl is built for x64 target, files will be named ssleay32.lib and libeay.32.lib under stage\lib. In fact they are 64 bit libraries.
SET MODE_FOLDER=x64\Release
IF "%1"=="Debug" SET MODE_FOLDER=x64\Debug

pushd %REPO_BASE_FOLDER%

IF EXIST %PATH_OPENSSL% GOTO BUILD_OPENSSL
echo Cloning OpenSSL %TAG_OPENSSL% ...
git clone --recursive --branch %TAG_OPENSSL% --depth 1 https://github.com/openssl/openssl.git %PATH_OPENSSL%

:BUILD_OPENSSL

REM IF EXIST %INSTALL_DIR%\%MODE_FOLDER%\lib\libeay32.lib GOTO END_OPENSSL

echo *************** Building OpenSSL %TAG_OPENSSL% ******************
PUSHD %PATH_OPENSSL%

rem The following command below with no-shared shoudd build static libraries, but did not work (unresolved links errors)
rem perl Configure VC-WIN64A no-shared --prefix=%INSTALL_DIR% --openssldir=%INSTALL_DIR%\SSL
rem Building DLLs:

perl Configure no-shared %BUILD_MODE% --prefix=%INSTALL_DIR%\%VSV%%MODE_FOLDER% --openssldir=%INSTALL_DIR%\SSL

rem ************* 
REM Example:
REM perl Configure debug-VC-WIN32 --prefix=D:\RTA\WorkSpace\OpcUaSdk\securityLibraries\OpenSSL\x32\Debug --openssldir=D:\RTA\WorkSpace\OpcUaSdk\securityLibraries\OpenSSL\SSL
REM perl Configure VC-WIN32 --prefix=D:\RTA\WorkSpace\OpcUaSdk\securityLibraries\OpenSSL\x32\Release --openssldir=D:\RTA\WorkSpace\OpcUaSdk\securityLibraries\OpenSSL\SSL

nmake clean
nmake
nmake install
POPD
:END_OPENSSL
POPD
