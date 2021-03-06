#!/bin/sh

# jmeter-rabbitmq-setup.sh From https://github.com/wilsonmar/JMeter-Rabbit-AMQP
# This script bootstraps a OSX laptop for development.
# Resources are created new each run (after deleting leftovers from previous run)
# Steps here are explained in https://wilsonmar.github.io/jmeter-install/
#    - xcode
#    - homebrew, then via brew:
#    - java JDK 
#
# It begins by asking for your sudo password:

fancy_echo() {
  local fmt="$1"; shift
  # shellcheck disable=SC2059
  printf "\n>>> $fmt\n" "$@"
}
function pause(){
   read -p "$*"
}

trap 'ret=$?; test $ret -ne 0 && printf "failed\n\n" >&2; exit $ret' EXIT
set -e

BEGIN=`date +%s`
export FILENAME="jmeter-rabbitmq-setup.sh"  # this Bash shell script file.
fancy_echo "Starting $FILENAME on $OSTYPE ................................."
#  clear
  sw_vers
    # ProductName:	Mac OS X
    # ProductVersion:	10.11.6
    # BuildVersion:	15G18013


# Here we go.. ask for the administrator password upfront and run a
# keep-alive to update existing `sudo` time stamp until script has finished
# sudo -v
# while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Ensure Apple's command line tools are installed
if ! command -v cc >/dev/null; then
  fancy_echo "Installing xcode. It's needed by Homebrew ..."
  xcode-select --install 
else
  fancy_echo "Xcode already installed. Skipping install."
fi
  xcodebuild -version
    # Xcode 7.3.1
    # Build version 7D1014

if ! command -v brew >/dev/null; then
  fancy_echo "Installing Homebrew for brew commands ..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" </dev/null
else
  fancy_echo "Homebrew already installed. Skipping install."
  brew --version  # Homebrew 1.4.2
fi


if ! command -v java >/dev/null; then
  fancy_echo "Installing Java JDK ..."
   brew cask info java8
   brew cask install java8
   javac -version  
else
  fancy_echo "Java JDK already installed. Skipping install."
   javac -version  
fi
   # javac 1.8.0_152


export JMETER_HOME="/usr/local/Cellar/jmeter/3.3"
if [ -d $JMETER_HOME ]; then
  fancy_echo "$JMETER_HOME already installed. Skipping install."
else
  fancy_echo "Installing jmeter to $JMETER_HOME ..."
  brew install jmeter
fi
   ls $JMETER_HOME/libexec
   # jmeter -v  # with that big ASCII art banner.


REPO1="JMeter-Rabbit-AMQP"
if [ -d $REPO1 ]; then
  fancy_echo "Repo $REPO1 folder exists, so deleting..."
  rm -rf $REPO1
else
  fancy_echo "Repo $REPO1 folder does not exist ..."
fi
  fancy_echo "Repo $REPO1 being cloned ..."
   git clone https://github.com/wilsonmar/JMeter-Rabbit-AMQP --depth=1
   cd $REPO1
   pwd
   #tree
   echo "$(git log -1 --format="%ad" -- $FILENAME) $FILENAME"


if ! command -v tree >/dev/null; then
  fancy_echo "Installing tree utility missing in MacOS ..."
  brew install tree
else
  fancy_echo "tree already installed. Skipping install."
fi
   pwd
   tree -L 1



FILE="jmeter-plugins-manager-0.5.jar"  # TODO: Check if version has changed since Jan 4, 2018.
FILE_PATH="$JMETER_HOME/libexec/lib/ext/jmeter-plugins-manager.jar"
if [ -f $FILE_PATH ]; then  # file exists within folder 
   fancy_echo "$FILE already installed. Skipping install."
   ls -al             $FILE_PATH
else
   fancy_echo "Downloading $FILE to $FOLDER ..."
   # From https://jmeter-plugins.org/wiki/StandardSet/
   curl -O http://jmeter-plugins.org/downloads/file/$FILE  # 994 received. 
   fancy_echo "Overwriting $FILE_PATH ..."
   yes | cp -rf $FILE  $FILE_PATH 
   ls -al             $FILE_PATH
fi


FILE="jmeter-plugins-extras-1.4.0.jar"  # TODO: Check if version has changed since Jan 4, 2018.
   # From https://jmeter-plugins.org/downloads/old/
FILE_PATH="$JMETER_HOME/libexec/lib/ext/jmeter-plugins-extras.jar"
if [ -f $FILE_PATH ]; then  # file exists within folder 
   fancy_echo "$FILE already installed. Skipping install."
   ls -al             $FILE_PATH
else
   fancy_echo "Downloading $FILE_PATH ..."
   # See https://mvnrepository.com/artifact/kg.apc/jmeter-plugins-extras
   curl -O http://central.maven.org/maven2/kg/apc/jmeter-plugins-extras/1.4.0/jmeter-plugins-extras-1.4.0.jar
   # 400K received. 
   fancy_echo "Overwriting $FILE_PATH ..."
   yes | cp -rf $FILE $FILE_PATH
   ls -al             $FILE_PATH
fi


FILE="jmeter-plugins-standard-1.4.0.jar"  # TODO: Check if version has changed since Jan 4, 2018.
   # From https://jmeter-plugins.org/downloads/old/
   # From https://jmeter-plugins.org/downloads/file/JMeterPlugins-Standard-1.4.0.zip
FILE_PATH="$JMETER_HOME/libexec/lib/ext/jmeter-plugins-standard.jar"
if [ -f $FILE_PATH ]; then  # file exists within folder 
   fancy_echo "$FILE already installed. Skipping install."
   ls -al             $FILE_PATH
else
   fancy_echo "Downloading $FILE_PATH ..."
   # See https://mvnrepository.com/artifact/kg.apc/jmeter-plugins-standard
   curl -O http://central.maven.org/maven2/kg/apc/jmeter-plugins-standard/1.4.0/jmeter-plugins-standard-1.4.0.jar
   # 400K received. 
   fancy_echo "Overwriting $FILE_PATH ..."
   yes | cp -rf $FILE $FILE_PATH
   ls -al             $FILE_PATH
fi


FILE="jmeter-plugins-extras-libs-1.4.0.jar"  # TODO: Check if version has changed since Jan 4, 2018.
   # From https://jmeter-plugins.org/downloads/old/
FILE_PATH="$JMETER_HOME/libexec/lib/ext/jmeter-plugins-extras-libs.jar"
if [ -f $FILE_PATH ]; then  # file exists within folder 
   fancy_echo "$FILE already installed. Skipping install."
   ls -al             $FILE_PATH
else
   fancy_echo "Downloading $FILE_PATH ..."
   # See https://mvnrepository.com/artifact/kg.apc/jmeter-plugins-extras-libs
   curl -O http://central.maven.org/maven2/kg/apc/jmeter-plugins-extras-libs/1.4.0/jmeter-plugins-extras-libs-1.4.0.jar
   # 400K received. 
   fancy_echo "Overwriting $FILE_PATH ..."
   yes | cp -rf $FILE $FILE_PATH
   ls -al             $FILE_PATH
fi



if ! command -v ant >/dev/null; then
  fancy_echo "Installing ant utlity ..."
  brew install ant
  ant -v
else
  fancy_echo "ant already installed. Skipping install."
  ant -v
fi
  fancy_echo "ant run to process ant.xml ..."
  ant
  # Ant can pick up the Test.jmx file, execute it, and generate an easily-readable HTML report.


FILE="amqp-client-3.6.1.jar"  # TODO: Check if version has changed since Jan 4, 2018.
FILE_PATH="$JMETER_HOME/libexec/lib/amqp-client-3.6.1.jar"  # TODO: Check if version has changed since Jan 4, 2018.
if [ -f $FILE_PATH ]; then  # file exists within folder $REPO1
   fancy_echo "$FILE found. Continuing ..."
   ls -al $FILE_PATH
else
   fancy_echo "Downloading $FILE_PATH ..."
  # NOTE: JMeterPlugins-Extras-1.4.0.zip now incorporated into Packages?
  # Download:
  java -jar ivy/ivy.jar -dependency com.rabbitmq amqp-client 3.6.1 \
      -retrieve "$JMETER_HOME/libexec/lab/[artifact](-[classifier]).[ext]"

  # found using command: find / -name amqp-client-3.6.1.jar 
  yes | cp -rf ~/.ivy2/cache/com.rabbitmq/amqp-client/jars/amqp-client-3.6.1.jar  $FILE_PATH

  ls -al $FILE_PATH
fi



FILE="target/dist/JMeterAMQP.jar"
if [ -f $FILE ]; then  # file exists within folder $REPO1
  fancy_echo "$FILE was created ..."
   ls -al    $FILE                        | grep JMeterAMQP.jar
  fancy_echo "Removing previous within JMETER_HOME ..."
   ls -al    $JMETER_HOME/libexec/lib/ext | grep JMeterAMQP.jar
   rm        $JMETER_HOME/libexec/lib/ext/JMeterAMQP.jar
  fancy_echo "Copying in from $FILE ..."
   cp $FILE  $JMETER_HOME/libexec/lib/ext
   ls -al    $JMETER_HOME/libexec/lib/ext | grep JMeterAMQP.jar
else
   fancy_echo "File '$FILE' not found. Aborting..."
   exit
fi




if ! command -v rabbitmq-server >/dev/null; then
  fancy_echo "Installing rabbitmq-server locally as server under test ..."
  brew install rabbitmq
else
  fancy_echo "rabbitmq-server already installed. Skipping install."
fi

if [[ ":$PATH:" == *":$HOME/usr/local/sbin:"* ]]; then
  fancy_echo "rabbitmq in path. Continuing ..."
else
  fancy_echo "Add path of rabbitmq /usr/local/sbin ..."
   export PATH=$PATH:/usr/local/sbin
fi



  fancy_echo "Starting Rabbitmq server in background using nohup ..."
   nohup rabbitmq-server &>/dev/null &
   jobs
   ps 



# TODO: Copy in rebbitmq configuration file. << Praveen?
#  fancy_echo "TODO: Alternative: Use rabbitmq API to configure exchanges..."
# https://pulse.mozilla.org/api/

# sudo rabbitmqctl list_queues


  fancy_echo "Add vHost..."
curl -i -u guest:guest -H "content-type:application/json" \
   -XPUT http://localhost:15672/api/vhosts/foo


  fancy_echo "Create new exchange in the default virtual Rabbitmq host ..."
curl -i -u guest:guest -H "content-type:application/json" \
    -XPUT -d'{"type":"direct","durable":true}' \
    http://localhost:15672/api/exchanges/%2f/my-new-exchange
  # No return a body in response to a PUT or DELETE, unless it fails.


exit

# http://hints.macworld.com/article.php?story=20021202054815892
# On Ubuntu:
# https://askubuntu.com/questions/192050/how-to-run-sudo-command-with-no-password?noredirect=1&lq=1


# Install Node Package amqplib to make RabbitMQ API calls:
# https://www.rabbitmq.com/tutorials/tutorial-one-javascript.html
# npm install amqplib


#FIX: pause( "Press [Enter] to continue." )

   #open http://localhost:15672  # 5672 default port (open is Mac only command)
#pause 'Press [Enter] key to continue...'
#curl -i -u guest:guest http://localhost:15672/api/vhosts


export JMETER_FILE="rabbitmq_test"
   fancy_echo "Starting JMeter in background for $JMETER_FILE ..."
   ls -al examples/$JMETER_FILE.jmx 
   $JMETER_HOME/libexec/bin/jmeter.sh -n -t examples/rabbitmq_test.jmx -l rabbitmq_test.jtl
#   nohup "./jmeter.sh -n -t $REPO1/examples/rabbitmq_test.jmx -l result.jtl" > /dev/null 2>&1 &
# -n for NON-GUI mode jmeter -n -t [jmx file] -l [results file] -e -o [Path to output folder]

#   fancy_echo "Process rabbitmq_test.jtl ..."
#   subl rabbitmq_test.jtl
# https://blogs.perficient.com/delivery/blog/2015/04/08/generate-performance-testing-report-with-jmeter-plugins-and-ant/


FILE="$JMETER_FILE.jtl"  # created above by JMeter in the current folder (.gitignore'd)
if [ -f $FILE ]; then  # file exists within folder $REPO1
   fancy_echo "$FILE found. Copying .csv for display in Excel ..."
   ls -al $FILE
   # TODO: Check if Microsoft Excel is installed:
   # Rename to .CSV for a spreadsheet program to open: # libreoffice --calc $FILE
   yes | cp -rf $JMETER_FILE.jtl  $JMETER_FILE.csv
   open $JMETER_FILE.csv -a "Microsoft Excel" 
   # Example contents:
   # timeStamp,elapsed,label,responseCode,responseMessage,threadName,dataType,success,failureMessage,bytes,sentBytes,grpThreads,allThreads,Latency,IdleTime,Connect
   # 1516143497026,2,AMQP Publisher,200,OK,Thread Group 1-1,text,true,,11,0,1,1,0,0,0
   rm $JMETER_FILE.csv
else
   fancy_echo "JMeter output $FILE not found. Run failed ..."
   abort
fi

#   fancy_echo "TODO: Display run results (comparing against previous runs) ..."


END=`date +%s`
RUNTIME=$((END-BEGIN))
fancy_echo "Done in $RUNTIME seconds."
