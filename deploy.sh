#!/usr/bin/env bash
set -eu
profile=$1

FILES=~/.aws/sso/cache/*
logged_in=false

for f in $FILES
do
    # SSO token sessions are 46 characters long
    # if the first_char from the trimmed filepath is a /
    # then we know we have a session token
    trimmed=${f: -46}
    first_char=${trimmed:0:1}

    if [ $first_char == '/' ]; then
        sso_expiry=$(cat $f | jq -r '.expiresAt')
        now=$(date +"%Y-%m-%dT%TZ")

        # even with a session tokenm, it could still have expired
        # if it has then log back in
        if [[ "$sso_expiry" < "$now" ]]; then
            aws sso login --profile $profile
        fi
            logged_in=true
            break
    fi
done

# no session token, log in
if [ "$logged_in" = false ]; then
    aws sso login --profile $profile
fi

npx ssocred $profile                    # generate temporary local credentials
npx sls deploy --aws-profile $profile   # deploy serverless application to AWS
