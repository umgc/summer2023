'use strict'
import * as cdk from 'aws-cdk-lib';
import * as lambda from 'aws-cdk-lib/aws-lambda';
import { Construct } from 'constructs';

import * as path from 'path';




export class ConvoBuddyStartTranscriptLambda extends cdk.Stack{
    constructor(scope:Construct, id:string, props?:cdk.StackProps){
        super(scope, id, props)

        new lambda.Function(this, 'cdConvoBuddyStartTranscript', {
            code: lambda.Code.fromAsset(path.resolve(__dirname, './convoStartCode')),
            functionName: 'cdkConvoBuddyStartTranscript',
            handler:'index.handler',
            memorySize:1024,
            runtime:lambda.Runtime.NODEJS_16_X,
            timeout: cdk.Duration.seconds(100),
             
        })
      }
    }


export class ConvoBuddySendTranscriptLambda extends cdk.Stack{
    constructor(scope:any, id:any, props?:any){
        super(scope, id, props)

        new lambda.Function(this, 'cdConvoBuddySendTranscript', {
            code: lambda.Code.fromAsset(path.resolve(__dirname, './convoSendCode')),
            functionName: 'cdkConvoBuddySendTranscript',
            handler:'main.lambda_handler',
            memorySize:1024,
            runtime:lambda.Runtime.PYTHON_3_9,
            timeout: cdk.Duration.seconds(100)
            
        })
    }
}