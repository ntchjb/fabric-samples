
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

FABRIC_CFG_PATH=$PWD/../config/
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
. scripts/ccFunc.sh

## at first we package the chaincode
packageChaincode 1

## Install chaincode on peer0.org1 and peer0.org2
echo "Installing chaincode on peer0.org1..."
installChaincode 1
echo "Install chaincode on peer0.org2..."
installChaincode 2

## query whether the chaincode is installed
queryInstalled 1

## approve the definition for org1
approveForMyOrg 1

## check whether the chaincode definition is ready to be committed
## expect org1 to have approved and org2 not to
checkCommitReadiness 1 "\"Org1MSP\": true" "\"Org2MSP\": false"
checkCommitReadiness 2 "\"Org1MSP\": true" "\"Org2MSP\": false"

## now approve also for org2
approveForMyOrg 2

## check whether the chaincode definition is ready to be committed
## expect them both to have approved
checkCommitReadiness 1 "\"Org1MSP\": true" "\"Org2MSP\": true"
checkCommitReadiness 2 "\"Org1MSP\": true" "\"Org2MSP\": true"

## now that we know for sure both orgs have approved, commit the definition
commitChaincodeDefinition 1 2

## query on both orgs to see that the definition committed successfully
queryCommitted 1
queryCommitted 2

## Invoke the chaincode
chaincodeInvokeInit 1 2

sleep 10

exit 0
