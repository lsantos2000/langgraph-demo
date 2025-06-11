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
    powershell -Command "Expand-Archive -Path jmeter.zip -DestinationPath %JMETER_HOME% -Force"
    rmdir /s /q "apache-jmeter-%JMETER_VERSION%"
    del jmeter.zip
# Default parameters
DEFAULT_PARAMS=(
    "-n"  # Non-GUI mode
    "-t" "$TEST_PLAN"
    "-JSERVER_HOST" "127.0.0.1"
    "-JSERVER_PORT" "2024"
    "-JSERVER_PROTOCOL" "http"
    "-NUM_USERS" "1"
    "-RAMP_UP_TIME" "1"
    "-TEST_DURATION" "10"
)

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --jmeter-home)
            JMETER_HOME="$2"
            shift 2
            ;;
        --test-plan)
            TEST_PLAN="$2"
            shift 2
            ;;
        --output-dir)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        --*)
            DEFAULT_PARAMS+=("$1" "$2")
            shift 2
            ;;
        *)
            DEFAULT_PARAMS+=("$1")
            shift
            ;;
    esac
done

# Set output files
JTL_FILE="$OUTPUT_DIR/results_$DATE.jtl"
HTML_REPORT="$OUTPUT_DIR/report_$DATE"

# Run JMeter
"$JMETER_HOME/apache-jmeter-$JMETER_VERSION/bin/jmeter.bat" -n -t "$TEST_PLAN" -JSERVER_HOST "127.0.0.1" -JSERVER_PORT "2024" -JSERVER_PROTOCOL "http" -NUM_USERS "1" -RAMP_UP_TIME "1" -TEST_DURATION "10" -l "$JTL_FILE" -e -o "$HTML_REPORT"

# Print results location
echo "Test results saved to:"
echo "JTL file: $JTL_FILE"
echo "HTML report: $HTML_REPORT/report.html"

# Open HTML report in default browser
if [[ -f "$HTML_REPORT/report.html" ]]; then
    start "$HTML_REPORT/report.html"
fi
