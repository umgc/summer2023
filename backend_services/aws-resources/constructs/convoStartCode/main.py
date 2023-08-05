import boto3

def lambda_handler(event, context):

    #define s3 client
    s3_client = boto3.client('s3')
    transcribe_client = boto3.client('transcribe')
    
    
    #get bucket and key from event trigger
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']
    print(bucket,key)

    #get output bucket from cdk creatation
    output_bucket = 'convo'
    bucket_list = s3_client.list_buckets()['Buckets']
    for bucket in bucket_list:
        bucket_name = bucket['Name']
        if 'convobuddytrasncriptions-convobuddyjsonfiles' in bucket_name:
            print(bucket_name)
            output_bucket = bucket_name
    
    
    transcribe_client.start_transcription_job(
        TranscriptionJobName = f'{key}-convo-buddy-transcription',
        Media = {'MediaFileUri': f's3://{bucket}/{key}'},
        OutputBucketName = output_bucket,
        Settings={'MaxSpeakerLabels':10, 'ShowSpeakerLabels':True},
        IdentifyLanguage=True
    )


    
    
    
    return {
        'statusCode': 200,
        'body': 'Transcription Job Completed'
    }