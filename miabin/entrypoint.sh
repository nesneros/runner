#! /bin/sh

kubectl -n gitlab-managed-apps get secrets google-application-credentials --output "jsonpath={.data.gcs-applicaton-credentials-file}" | base64 -d

echo "Date/time: $(date)"
echo "Execute: $@"
exec "$@"