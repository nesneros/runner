#! /usr/bin/env bash

TMP=$(tempfile)
kubectl -n gitlab-managed-apps get secrets google-application-credentials --output "jsonpath={.data.gcs-applicaton-credentials-file}" | base64 -d > $TMP

gcloud builds su
