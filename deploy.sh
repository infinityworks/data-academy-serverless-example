#!/usr/bin/env bash
set -eu
profile=$1

FILES=~/.aws/sso/cache/*
logged_in=false

for f in $FILES
do
  trimmed=${f: -46}
  first_char=${trimmed:0:1}

  if [ $first_char == '/' ]; then
    logged_in=true
    break
  fi
done

if [ "$logged_in" = false ]; then
  aws sso login --profile $profile        # login to AWS CLI
fi

npx ssocred $profile                    # generate temporary local credentials
npx sls deploy --aws-profile $profile   # deploy serverless application to AWS
