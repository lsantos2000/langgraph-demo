@echo off
set JMETER_HOME=apache-jmeter-5.6.3

if not exist "%JMETER_HOME%\bin\jmeter.bat" (
    echo JMeter not found. Please download and install it first.
    echo Download from: https://downloads.apache.org/jmeter/binaries/apache-jmeter-5.6.3.zip
    echo Extract it to: %JMETER_HOME%
    exit /b 1
)

echo Running JMeter test...
cd "%JMETER_HOME%\bin"
jmeter.bat -n -t ..\langgraph-platform-test.jmx -JSERVER_HOST "127.0.0.1" -JSERVER_PORT "2024" -JSERVER_PROTOCOL "http" -NUM_USERS "1" -RAMP_UP_TIME "1" -TEST_DURATION "10" -l ..\jmeter-results\results_%date:~-4,4%%date:~-7,2%%date:~-10,2%_%time:~0,2%%time:~3,2%.jtl -e -o ..\jmeter-results\report_%date:~-4,4%%date:~-7,2%%date:~-10,2%_%time:~0,2%%time:~3,2%
