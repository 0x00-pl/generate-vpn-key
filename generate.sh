SERVER_USER=$1
SERVER_ADDR=$2
SERVER_PASS=$3
SERVER_PORT=$4
FILE_PREFIX=$5

SERVER=${SERVER_USER}"@"${SERVER_ADDR}

SSH_OPTION="StrictHostKeyChecking no"

MACNAME=`echo "${FILE_PREFIX}" | sed 'y/:/-/'`
FNAME=${MACNAME}"--"${SERVER_ADDR}
echo "name is: ${FNAME}"


echo
echo "# gen client file"
echo "#################"
sshpass -p ${SERVER_PASS} ssh -o "${SSH_OPTION}" ${SERVER} -p ${SERVER_PORT} << EOF
cd /etc/openvpn/easy-rsa/
. ./vars
./revoke-full ${FNAME}
./build-key --batch ${FNAME}
EOF

mkdir -p ./${SERVER_ADDR}/
sshpass -p ${SERVER_PASS} scp -o "${SSH_OPTION}" -P ${SERVER_PORT} ${SERVER}:/etc/openvpn/easy-rsa/keys/${FNAME}.crt ./${SERVER_ADDR}/
sshpass -p ${SERVER_PASS} scp -o "${SSH_OPTION}" -P ${SERVER_PORT} ${SERVER}:/etc/openvpn/easy-rsa/keys/${FNAME}.key ./${SERVER_ADDR}/
sshpass -p ${SERVER_PASS} scp -o "${SSH_OPYION}" -P ${SERVER_PORT} ${SERVER}:/etc/openvpn/ca.crt ./${SERVER_ADDR}/

