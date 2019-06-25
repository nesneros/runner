#! /bin/sh

helm upgrade --namespace gitlab-managed-apps -f $(dirname $0)../helm/values.yaml mia-runner gitlab/gitlab-runner