#!/bin/sh
export PATH=${PWD}/../bin:${PWD}:$PATH
export FABRIC_CFG_PATH=$PWD/../config/

export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.example.com/users/issuer@org1.example.com/msp

peer chaincode invoke --channelID mychannel --name microc \
--ctor '{"Args":["createTemplate", "{\"name\":\"lasdjkflsjdfkl \",\"description\":\"jkldsafj sdkl;fj askl;f ajskld;f jk\",\"image\":\"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg==\",\"criteria\":{\"narrative\":\"io jkasl; jkdlgjskl \"},\"alignment\":[{\"targetName\":\"sdfjkasldf;jkalsdj kl\",\"targetUrl\":\"jksdl;jkdslg djfkl\",\"targetDescription\":\"jio;dgj aksl;jk\",\"targetFramework\":\"ljfklg;jdfgkl;\",\"targetCode\":\"jkljfdklgsldfg\"}],\"tags\":[\"jkl\",\"gsdf\",\"gfds\",\"gs\"]}"]}' \
--transient '{"profile":"eyJpZCI6InVybjp1dWlkOjdkMmJlYmI3LTUyYTItNWQ1OC04MzNhLWE4ODNlNWM1NDc4ZSIsIm5hbWUiOiJBbGJlcnQgRWluc3RlaW4iLCJ0ZWxlcGhvbmUiOiIrNjYyMTIzNDEyMzQiLCJlbWFpbCI6Imlzc3VlckBleGFtcGxlLmNvbSIsInVybCI6Imh0dHBzOi8vd3d3LmV4YW1wbGUuY29tL3N0YWZmLzAxMjMvIiwibXNwaWQiOiJPcmcxTVNQIiwicm9sZSI6Imlzc3VlciIsInB1YmxpY0tleSI6eyJwdWJsaWNLZXlQZW0iOiItLS0tLUJFR0lOIFBVQkxJQyBLRVktLS0tLVxuTUZrd0V3WUhLb1pJemowQ0FRWUlLb1pJemowREFRY0RRZ0FFVXNRRER2ZW80ZkxNYVFsN2dhcy8rUDBNeFA1Q1xuTyszLzh0S1hPTzBmR0FzOHdlWEd0S2g0UnoySFBINUVSTUxmdVpPUnVudWFKNWtMVk5JYTZxR24yQT09XG4tLS0tLUVORCBQVUJMSUMgS0VZLS0tLS1cbiJ9fQ=="}' \
--peerAddresses localhost:7051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt \
--peerAddresses localhost:9051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt \
--peerAddresses localhost:11051 --tlsRootCertFiles ${PWD}/organizations/peerOrganizations/org3.example.com/peers/peer0.org3.example.com/tls/ca.crt \
--orderer localhost:7050 --tls --cafile ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem