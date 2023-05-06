#!/bin/bash

# before run export SENTNRY_CONFIG variable
# e.g. SENTRY_CONFIG=/opt/sentry/sentry.conf.py

cmd=sentry --config=$SENTRY_CONFIG django dumpdata --indent 2
mkdir -p data

$cmd sentry.user sentry.organization | grep -v "\[WARNING\]" > data/sentry_data.json
cat data/sentry_data.json|jq '[.[] | select(.model=="sentry.user") | .model="users.user" | del(.fields.username) | del(.fields.last_active) | del(.fields.is_sentry_app) | del(.fields.last_password_change) | del(.fields.is_managed) | del(.fields.flags) | del(.fields.session_nonce) | .fields = .fields + {"created": .fields.date_joined} | del(.fields.date_joined) | del(.fields.is_password_expired)]' > data/users_user.json
cat data/sentry_data.json|jq '[.[] | select(.model=="sentry.organization") | .model="organizations_ext.organization" | del(.fields.status) | del(.fields.default_role) | del(.fields.flags) | .fields.created=.fields.date_added | del(.fields.date_added)]' > data/organizations_organization.json
