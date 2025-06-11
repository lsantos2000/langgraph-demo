@echo off
set JMETER_VERSION=5.6.3
set JMETER_HOME=apache-jmeter-%JMETER_VERSION%
set TEST_PLAN=langgraph-platform-test.jmx
set OUTPUT_DIR=jmeter-results
set DATE=%date:~-4,4%%date:~-7,2%%date:~-10,2%_%time:~0,2%%time:~3,2%

:: Ensure JMeter directory exists
if not exist "%JMETER_HOME%" mkdir "%JMETER_HOME%"

:: Check if JMeter is installed
if not exist "%JMETER_HOME%\bin\jmeter.bat" (
    echo JMeter not found. Downloading and installing JMeter %JMETER_VERSION%...
    
    :: Download JMeter
    powershell -Command "Invoke-WebRequest https://downloads.apache.org/jmeter/binaries/apache-jmeter-%JMETER_VERSION%.zip -OutFile jmeter.zip"
    
    :: Extract JMeter
    powershell -Command "Expand-Archive -Path jmeter.zip -DestinationPath . -Force"
    move /Y "apache-jmeter-%JMETER_VERSION%\*" "%JMETER_HOME%"
    rmdir /s /q "apache-jmeter-%JMETER_VERSION%"
    del jmeter.zip
)

:: Create and clean output directory
if exist "%OUTPUT_DIR%" rmdir /s /q "%OUTPUT_DIR%"
mkdir "%OUTPUT_DIR%"

:: Set output files
set JTL_FILE=%OUTPUT_DIR%\results_%DATE%.jtl
set HTML_REPORT=%OUTPUT_DIR%\report_%DATE%

:: Run JMeter
call "%JMETER_HOME%\bin\jmeter.bat" -n -t "%TEST_PLAN%" -Jbase_url=http://127.0.0.1:2024 -JJSERVER_HOST=127.0.0.1 -JJSERVER_PORT=2024 -JJSERVER_PROTOCOL=http -Jnamespace=test -Jkey=test_key -Jthread_id=dummy_thread_id -Japi_key=your_api_key_here -JNUM_USERS=1 -JRAMP_UP_TIME=1 -JTEST_DURATION=10 -l "%JTL_FILE%" -e -o "%HTML_REPORT%"

:: Print results location
echo Test results saved to:
echo JTL file: %JTL_FILE%
echo HTML report: %HTML_REPORT%/report.html

:: Open HTML report in default browser
if exist "%HTML_REPORT%\report.html" start "%HTML_REPORT%\report.html"
