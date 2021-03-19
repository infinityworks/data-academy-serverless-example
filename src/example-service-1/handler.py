import boto3
import csv

def handle(event):
    # Get key and bucket informaition
    key = event['Records'][0]['s3']['object']['key']
    bucket = event['Records'][0]['s3']['bucket']['name']
    
    # use boto3 library to get object from S3
    s3 = boto3.client('s3')
    s3_object = s3.get_object(Bucket = bucket, Key = key)
    data = s3_object['Body'].read().decode('utf-8')
    
    # read CSV
    csv_data = csv.reader(data.splitlines())
    print(csv_data)
