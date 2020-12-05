#!/bin/sh
cd path/to/repo
for iterationno in {1..80}
do
	scp -i path/to/bboard_rsa data/captchas/output/${iterationno}-answers-100-3-demo.txt path/to/server
	scp -i path/to/bboard_rsa data/captchas/output/${iterationno}-answers-100-3-real.txt path/to/server
	scp -i path/to/bboard_rsa data/captchas/output/${iterationno}-captchas-100-3-demo.txt path/to/server
	scp -i path/to/bboard_rsa data/captchas/output/${iterationno}-captchas-100-3-real.txt path/to/server
done
