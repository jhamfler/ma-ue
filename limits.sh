#!/bin/bash
# test if change in file open limit (sockets) are working by adjusting iterations

for i in {1..1000}
do
	curl -v --http2 --insecure 'https://127.0.0.1:4430/amfstart' &
done

