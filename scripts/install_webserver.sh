#!/bin/bash
set -e

sudo yum install python36  python36-devel python36-setuptools unzip -y
sudo easy_install-3.6 pip

sudo /usr/local/bin/pip install flask

TEMP_DIR="/tmp"
PYTHON_FILE_SERVER_ROOT=${TEMP_DIR}/python-simple-http-webserver
if [ -d ${PYTHON_FILE_SERVER_ROOT} ]; then
	echo "Removing file server root folder ${PYTHON_FILE_SERVER_ROOT}"
	rm -rf ${PYTHON_FILE_SERVER_ROOT}
fi
ctx logger info "Creating python server root directory at ${PYTHON_FILE_SERVER_ROOT}"

mkdir -p ${PYTHON_FILE_SERVER_ROOT}

cd ${PYTHON_FILE_SERVER_ROOT}

resource_path="resources/Cards.zip"

ctx logger info "Downloading blueprint resources..."
ctx download-resource ${resource_path} ${PYTHON_FILE_SERVER_ROOT}/Cards.zip
unzip Cards.zip -d cards

PID_FILE="server.pid"

ctx logger info "Starting python server from ${PYTHON_FILE_SERVER_ROOT}"

port=5000

cd ${PYTHON_FILE_SERVER_ROOT}/cards
ctx logger info "Starting Server"

nohup /usr/bin/python3 app.py > /dev/null 2>&1 &
echo $! > ${PID_FILE}

ctx logger info "Waiting for server to launch on port ${port}"
url="http://localhost:${port}"

server_is_up() {
	if which wget >/dev/null; then
		if wget $url >/dev/null; then
			return 0
		fi
	elif which curl >/dev/null; then
		if curl $url >/dev/null; then
			return 0
		fi
	else
		ctx logger error "Both curl, wget were not found in path"
		exit 1
	fi
	return 1
}

STARTED=false
for i in $(seq 1 15)
do
	if server_is_up; then
		ctx logger info "Server is up."
		STARTED=true
    	break
	else
		ctx logger info "Server not up. waiting 1 second."
		sleep 1
	fi
done
if [ ${STARTED} = false ]; then
	ctx logger error "Failed starting web server in 15 seconds."
	exit 1
fi
