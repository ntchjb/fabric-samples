CHANNEL_NAME="$1"
CC_NAME="$2"
CC_PATH="$3"
CC_SRC_LANGUAGE="$4"
VERSION="$5"
DELAY="$6"
MAX_RETRY="$7"
VERBOSE="$8"
: ${CHANNEL_NAME:="mychannel"}
: ${CC_NAME:="mycc"}
: ${CC_SRC_LANGUAGE:="golang"}
: ${VERSION:="1"}
: ${DELAY:="3"}
: ${MAX_RETRY:="5"}
: ${VERBOSE:="false"}
CC_SRC_LANGUAGE=`echo "$CC_SRC_LANGUAGE" | tr [:upper:] [:lower:]`

FABRIC_CFG_PATH=$PWD/../../config/
CC_SRC_PATH="$CC_PATH"

if [ "$CC_SRC_LANGUAGE" = "go" -o "$CC_SRC_LANGUAGE" = "golang" ] ; then
	CC_RUNTIME_LANGUAGE=golang

	echo Vendoring Go dependencies ...
	pushd $CC_PATH
	GO111MODULE=on go mod vendor
	popd
	echo Finished vendoring Go dependencies

elif [ "$CC_SRC_LANGUAGE" = "javascript" ]; then
	CC_RUNTIME_LANGUAGE=node # chaincode runtime language is node.js

elif [ "$CC_SRC_LANGUAGE" = "java" ]; then
	CC_RUNTIME_LANGUAGE=java

	echo Compiling Java code ...
  pushd $CC_PATH
	./gradlew installDist
	popd
	echo Finished compiling Java code

elif [ "$CC_SRC_LANGUAGE" = "typescript" ]; then
	CC_RUNTIME_LANGUAGE=node # chaincode runtime language is node.js

	echo Compiling TypeScript code into JavaScript ...
  pushd $CC_PATH
	npm install
	npm run build
	popd
	echo Finished compiling TypeScript code into JavaScript

else
	echo The chaincode language ${CC_SRC_LANGUAGE} is not supported by this script
	echo Supported chaincode languages are: go, java, javascript, and typescript
	exit 1
fi

# import chaincode operation functions
. ../scripts/org3-scripts/ccFunc.sh

## at first we package the chaincode
packageChaincode 3

## Install chaincode on peer0.org3
echo "Installing chaincode on peer0.org3..."
installChaincode 3

## query whether the chaincode is installed
queryInstalled 3

## approve the definition for org3
approveForMyOrg 3

## query on both orgs to see that the definition committed successfully
queryCommitted 3

sleep 10

exit 0
