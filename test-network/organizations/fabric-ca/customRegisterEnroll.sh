export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org1.example.com/

echo
echo "Register issuer at org1"
echo
fabric-ca-client identity add issuer --caname ca-org1 --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem --json '{
  "secret": "user1pw",
  "type": "client",
  "affiliation": "org1",
  "attrs": [
    {
      "name": "name",
      "value": "Issuer Org1name",
      "ecert": true
    },
    {
      "name": "role",
      "value": "issuer",
      "ecert": true
    },
    {
      "name": "email",
      "value": "issuer@example.com",
      "ecert": true
    },
    {
      "name": "url",
      "value": "https://www.example.com/staff/0123/",
      "ecert": true
    },
    {
      "name": "telephone",
      "value": "+66212341234",
      "ecert": true
    }
  ]
}'

echo
echo "Enroll issuer at org1"
echo
issuerMSPDir="${PWD}/organizations/peerOrganizations/org1.example.com/users/issuer@org1.example.com/msp"
fabric-ca-client enroll -u https://issuer:user1pw@localhost:7054 --caname ca-org1 --tls.certfiles ${PWD}/organizations/fabric-ca/org1/tls-cert.pem -M $issuerMSPDir


export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/org2.example.com/

echo
echo "Register earner at org2"
echo
fabric-ca-client identity add earner --caname ca-org2 --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem --json '{
  "secret": "user1pw",
  "type": "client",
  "affiliation": "org2",
  "attrs": [
    {
      "name": "name",
      "value": "Earner Org2name",
      "ecert": true
    }, {
      "name": "role",
      "value": "earner",
      "ecert": true
    }, {
      "name": "email",
      "value": "earner@example.com",
      "ecert": true
    },
    {
      "name": "telephone",
      "value": "+66812341234",
      "ecert": true
    }
  ]
}'

echo
echo "Enroll earner at org2"
echo
earnerMSPDir="${PWD}/organizations/peerOrganizations/org2.example.com/users/earner@org2.example.com/msp"
fabric-ca-client enroll -u https://earner:user1pw@localhost:8054 --caname ca-org2 --tls.certfiles ${PWD}/organizations/fabric-ca/org2/tls-cert.pem -M $earnerMSPDir
