#!/usr/bin/env bash


cat bootstrap.ign | jq ".storage.files |= . + $(./static-ip.sh bootstrap.ocp4-upi.bohne.io 10.84.3.2)"  -c > bootstrap-0.ign

cat master.ign | jq ".storage.files |= . + $(./static-ip.sh controller-0.ocp4-upi.bohne.io 10.84.3.30)"  -c > master-0.ign
cat master.ign | jq ".storage.files |= . + $(./static-ip.sh controller-1.ocp4-upi.bohne.io 10.84.3.31)"  -c > master-1.ign
cat master.ign | jq ".storage.files |= . + $(./static-ip.sh controller-2.ocp4-upi.bohne.io 10.84.3.32)"  -c > master-2.ign

cat worker.ign | jq ".storage.files |= . + $(./static-ip.sh worker-0.ocp4-upi.bohne.io 10.84.3.40)"  -c > worker-0.ign
cat worker.ign | jq ".storage.files |= . + $(./static-ip.sh worker-1.ocp4-upi.bohne.io 10.84.3.41)"  -c > worker-1.ign
cat worker.ign | jq ".storage.files |= . + $(./static-ip.sh worker-2.ocp4-upi.bohne.io 10.84.3.42)"  -c > worker-2.ign