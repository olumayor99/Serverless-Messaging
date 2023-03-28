import boto3
import json
import os

sfn = boto3.client('stepfunctions')


def lambda_handler(event, context):
    sfn.start_execution(
        stateMachineArn=os.environ['StateMachineARN'],
        input=event['body']
    )

    return {
        "statusCode": 200,
        "body": json.dumps(
            {"Status": "Instruction sent to the REST API Handler!"},
        )
    }
