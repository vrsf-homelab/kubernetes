#!/bin/bash

if [ -f values.secrets.enc.yaml ]; then
  echo "Detected secrets for Helm values! Decrypting ..."
  helm secrets decrypt values.secrets.enc.yaml > values.secrets.yaml
else
  echo "No secrets for Helm detected, ignoring ..."
fi
