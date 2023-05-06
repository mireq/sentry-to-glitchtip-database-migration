#!/bin/bash

# before run export SENTNRY_CONFIG variable
# e.g. SENTRY_CONFIG=/opt/sentry/sentry.conf.py

cmd=sentry --config=$SENTRY_CONFIG django dumpdata --indent 2
mkdir -p data

$cmd sentry.user | grep -v "\[WARNING\]" > data/sentry_user.json
cat data/sentry_user.json|jq '[.[] | .model="users.user" | del(.fields.username) | del(.fields.last_active) | del(.fields.is_sentry_app) | del(.fields.last_password_change) | del(.fields.is_managed) | del(.fields.flags) | del(.fields.session_nonce) | .fields = .fields + {"created": .fields.date_joined} | del(.fields.date_joined) | del(.fields.is_password_expired)]' > data/users_user.json
