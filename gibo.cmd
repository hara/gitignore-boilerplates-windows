@echo off

rem Script for easily accessing gitignore boilerplates from
rem https://github.com/github/gitignore
rem
rem This script is a Windows port of
rem https://github.com/simonwhitaker/gitignore-boilerplates

setlocal
  set remote_repo=https://github.com/github/gitignore.git
  set local_repo=%USERPROFILE%\.gitignore-boilerplates

  if "%~1"=="" call :Usage & exit /b 1

  :loop

  if "%~1"=="-h" call :Usage & exit /b
  if "%~1"=="--help" call :Usage & exit /b

  if "%~1"=="-v" call :Version & exit /b
  if "%~1"=="--version" call :Version & exit /b

  if "%1"=="-l" call :List & exit /b
  if "%1"=="--list" call :List & exit /b

  if "%1"=="-u" call :Update & exit /b
  if "%1"=="--update" call :Update & exit /b

  call :Dump %~1

  shift
  if not "%~1"=="" goto :loop
  exit /b

  :Version
    setlocal
      echo %~n0 1.0.0
    endlocal
  goto :EOF

  :Usage
    setlocal
      echo Fetches gitignore boilerplates from github.com/github/gitignore
      echo Usage:
      echo     %~n0 [options]
      echo     %~n0 [boilerplate boilerplate...]
      echo.
      echo Example:
      echo     %~n0 VisualStudio Windows ^>^> .gitignore
      echo.
      echo Options:
      echo     -l, --list     List available boilerplates
      echo     -u, --update   Update list of available boilerplates
      echo     -v, --version  Display current script version
      echo     -h, --help     Display this help text
    endlocal
  goto :EOF

  :Clone
    setlocal
      if %~1=="--silently" (
        git clone -q "%remote_repo%" "%local_repo%"
      ) else (
        echo Cloning %remote_repo% to %local_repo%
        git clone "%remote_repo%" "%local_repo%"
      )
    endlocal
  goto :EOF

  :Init
    setlocal
      if not exist "%local_repo%\.git" call :Clone %~1
    endlocal
  goto :EOF

  :List
    setlocal
      call :Init

      echo === Languages ===
      echo.
      for %%f in (%local_repo%\*.gitignore) do echo %%~nf

      echo.
      echo === Global ===
      echo.
      for %%f in (%local_repo%\Global\*.gitignore) do echo %%~nf
    endlocal
  goto :EOF

  :Update
    setlocal
      if not exist "%local_repo%\.git" (
        call :Clone
      ) else (
        cd "%local_repo%"
        git pull origin master
      )
    endlocal
  goto :EOF

  :Dump
    setlocal
      call :Init "--silently"

      set language_file=%local_repo%\%~1.gitignore
      set global_file=%local_repo%\Global\%~1.gitignore

      if exist "%language_file%" (
        echo ### %language_file%
        echo.
        cat "%language_file%"
        echo.
        echo.
      ) else if exist "%global_file%" (
        echo ### %global_file%
        echo.
        cat "%global_file%"
        echo.
        echo.
      ) else (
        echo Unknown argument: %~1 1>&2
      )
    endlocal
  goto :EOF

endlocal
