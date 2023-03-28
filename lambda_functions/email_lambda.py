import boto3
import os

ses = boto3.client('ses')


def lambda_handler(event, context):
    ses.send_email(
        Source=os.environ['SourceEmail'],
        Destination={
            'ToAddresses': [
                event['destinationEmail'],
            ]
        },
        Message={
            'Subject': {
                'Data': 'Serverless Email Tool'
            },
            'Body': {
                'Text': {
                    'Data': event['message']
                }
            }
        }
    )
    return 'Email sent!'
