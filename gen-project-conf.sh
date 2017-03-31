#!/usr/bin/env sh
if ! type yaml2json > /dev/null; then
  echo 'Please install yaml2json to run this command, or create the hasura-project-conf configmap yourself.'
else

  cat << EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: hasura-project-conf
  namespace: default
data:
  project: |
$(yaml2json project-conf.yaml | jq '.' | awk '$0="    "$0')
EOF

fi
