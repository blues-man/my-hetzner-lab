#!/usr/bin/env bash

DEST_DIR=/var/www/html/ocp4/
SRC_DIR=installer-config/
echo "Write ${DEST_DIR}bootstrap-0.ign"
cat ${SRC_DIR}bootstrap.ign | jq ".storage.files |= . + $(./static-ip.sh bootstrap.ocp4-upi.bohne.io 10.84.3.2)"  -c > ${DEST_DIR}bootstrap-0.ign

echo "Write ${DEST_DIR}master-[0:2].ign"
cat ${SRC_DIR}master.ign | jq ".storage.files |= . + $(./static-ip.sh controller-0.ocp4-upi.bohne.io 10.84.3.30)"  -c > ${DEST_DIR}master-0.ign
cat ${SRC_DIR}master.ign | jq ".storage.files |= . + $(./static-ip.sh controller-1.ocp4-upi.bohne.io 10.84.3.31)"  -c > ${DEST_DIR}master-1.ign
cat ${SRC_DIR}master.ign | jq ".storage.files |= . + $(./static-ip.sh controller-2.ocp4-upi.bohne.io 10.84.3.32)"  -c > ${DEST_DIR}master-2.ign

echo "Write ${DEST_DIR}worker-[0:2].ign"
cat ${SRC_DIR}worker.ign | jq ".storage.files |= . + $(./static-ip.sh worker-0.ocp4-upi.bohne.io 10.84.3.40)"  -c > ${DEST_DIR}worker-0.ign
cat ${SRC_DIR}worker.ign | jq ".storage.files |= . + $(./static-ip.sh worker-1.ocp4-upi.bohne.io 10.84.3.41)"  -c > ${DEST_DIR}worker-1.ign
cat ${SRC_DIR}worker.ign | jq ".storage.files |= . + $(./static-ip.sh worker-2.ocp4-upi.bohne.io 10.84.3.42)"  -c > ${DEST_DIR}worker-2.ign
