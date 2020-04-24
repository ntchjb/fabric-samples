export FABRIC_CA_CLIENT_HOME=${PWD}/../organizations/peerOrganizations/org3.example.com/

fabric-ca-client identity add consumer --caname ca-org3 --tls.certfiles ${PWD}/fabric-ca/org3/tls-cert.pem --json '{
  "secret": "user1pw",
  "type": "client",
  "attrs": [
    {
      "name": "name",
      "value": "User Org3name",
      "ecert": true
    }, {
      "name": "role",
      "value": "consumer",
      "ecert": true
    },
    {
      "name": "email",
      "value": "hr@example.com",
      "ecert": true
    },{
      "name": "url",
      "value": "https://example.com/hr/01234",
      "ecert": true
    },
    {
      "name": "telephone",
      "value": "+6629876543",
      "ecert": true
    }
  ]
}'

# Setup MSP path for each users
consumerMSPDir="${PWD}/../organizations/peerOrganizations/org3.example.com/users/consumer@org3.example.com/msp"

# Generate certificates
fabric-ca-client enroll -u https://consumer:user1pw@localhost:11054 --caname ca-org3 --tls.certfiles ${PWD}/fabric-ca/org3/tls-cert.pem -M $consumerMSPDir
