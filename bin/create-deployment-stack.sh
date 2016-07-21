#!/bin/bash
stackname=$1
jarname=$2

if [[ -z ${stackname} ]] || [[ -z ${jarname} ]]; then
    echo "usage: $0 <stackname> <jarname>"
    exit 1
fi

aws cloudformation create-stack --region eu-west-1 --stack-name ${stackname} \
    --template-body file://$(pwd)/src/main/cfn/deployment-api.json \
    --capabilities "CAPABILITY_IAM" \
    --parameters "ParameterValue=$jarname,ParameterKey=jarName"

# wait for stack to be created
while [[ ${status} != "CREATE_COMPLETE" ]]; do
    sleep 10
    status=$(aws cloudformation describe-stacks --stack-name ${stackname} --output=json | jq -r '.Stacks[0].StackStatus')
    echo ${status}
done
