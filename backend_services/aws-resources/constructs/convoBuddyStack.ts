'use strict'
import * as cdk from 'aws-cdk-lib';
import * as lambda from 'aws-cdk-lib/aws-lambda';
import * as s3 from 'aws-cdk-lib/aws-s3';
import * as iam from 'aws-cdk-lib/aws-iam';
import * as lambdaEventSources from 'aws-cdk-lib/aws-lambda-event-sources';
import * as ll from 'aws-cdk-lib/aws-lambda';
import * as Iam from "aws-cdk-lib/aws-iam";
import * as ApiGateway from "aws-cdk-lib/aws-apigateway";
import { Construct } from 'constructs';
import * as path from 'path';




export class ConvoBuddyAwsStack extends cdk.Stack{
    constructor(scope:Construct, id:string, props?:cdk.StackProps){
        super(scope, id, props)

    //define s3 buckets for audio files and transcript files
     const convoTranscriptBucket =  new s3.Bucket(this, 'convoBuddyJsonFiles', {
            objectOwnership: s3.ObjectOwnership.BUCKET_OWNER_ENFORCED,
            //blockPublicAccess: s3.BlockPublicAccess.,
            removalPolicy: cdk.RemovalPolicy.DESTROY,
            lifecycleRules: [
                {
                    abortIncompleteMultipartUploadAfter: cdk.Duration.days(1),
                    expiration: cdk.Duration.days(1),
                }
           
            ]
          });

     const convoAudioBucket = new s3.Bucket(this, 'convoBuddyAudioFiles', {
        objectOwnership: s3.ObjectOwnership.BUCKET_OWNER_ENFORCED,
        //blockPublicAccess: s3.BlockPublicAccess.BLOCK_ALL,
        removalPolicy: cdk.RemovalPolicy.DESTROY
      });

       
    //grant read write
    convoAudioBucket.grantReadWrite
    convoTranscriptBucket.grantReadWrite

      //define lambda functions to start transcript job and send transcript job to BESIE
   const convoStartLambda = new lambda.Function(this, 'cdConvoBuddyStartTranscript', {
            code: lambda.Code.fromAsset(path.resolve(__dirname, './convoStartCode')),
            functionName: 'cdkConvoBuddyStartTranscript',
            handler:'main.lambda_handler',
            memorySize:1024,
            runtime:lambda.Runtime.PYTHON_3_9,
            timeout: cdk.Duration.seconds(100), 
        })

        
    //grant read s3 access to audio file lambda
    //grant audio file lambda access to transcription job
     
     const s3ListBucketsPolicy = new iam.PolicyStatement({
      actions: ['s3:ListAllMyBuckets'],
      resources: ['arn:aws:s3:::*'],
    });



    convoStartLambda.role?.attachInlinePolicy(
      new iam.Policy(this, 'list-buckets-policy', {
        statements: [s3ListBucketsPolicy],
      }))

      const runTranscribeJobs = new iam.PolicyStatement({
        effect: iam.Effect.ALLOW,
        actions: ['transcribe:*'],
        resources: ['*']

      })

      convoStartLambda.role?.attachInlinePolicy(
        new iam.Policy(this, 'transcribe-jobs', {
          statements:[runTranscribeJobs]
        })
      )
  
      
    
  const convoSendLambda = new lambda.Function(this, 'cdConvoBuddySendTranscript', {
            code: lambda.Code.fromAsset(path.resolve(__dirname, './convoSendCode')),
            functionName: 'cdkConvoBuddySendTranscript',
            handler:'main.lambda_handler',
            memorySize:1024,
            runtime:lambda.Runtime.PYTHON_3_9,
            timeout: cdk.Duration.seconds(100)
            
        })
  
  //define s3 trigger events for lambda functions
  const s3PutEventSourceTranscripts = new lambdaEventSources.S3EventSource(convoTranscriptBucket, {
            events: [
              s3.EventType.OBJECT_CREATED
            ]
          });
      
    convoSendLambda.addEventSource(s3PutEventSourceTranscripts);

    const s3PutEventSourceAudioFiles = new lambdaEventSources.S3EventSource(convoAudioBucket, {
        events: [
          s3.EventType.OBJECT_CREATED
        ]
      });
  
    convoStartLambda.addEventSource(s3PutEventSourceAudioFiles);

    //define lambda layer for transcription send lambda function and apply to lambda. 
    const transcriptLambdaLayer = new ll.LayerVersion(this, 'convoBudyLayerProd', {
        removalPolicy: cdk.RemovalPolicy.DESTROY,
        code: ll.Code.fromAsset(path.resolve(__dirname, '../lambda-handler')),
        compatibleArchitectures: [ll.Architecture.X86_64, ll.Architecture.ARM_64],
        compatibleRuntimes:[ll.Runtime.PYTHON_3_9]
      });

    convoSendLambda.addLayers(transcriptLambdaLayer);

    // const audioLambdaLayer = new ll.LayerVersion(this, 'convoBudyAudioLayerProd', {
    //     removalPolicy: cdk.RemovalPolicy.DESTROY,
    //     code: ll.Code.fromAsset(path.resolve(__dirname, '../lambda-handler-node')),
    //     compatibleArchitectures: [ll.Architecture.X86_64, ll.Architecture.ARM_64],
    //     compatibleRuntimes:[ll.Runtime.NODEJS_16_X]
    // })

    // convoStartLambda.addLayers(audioLambdaLayer);



    const apiGateway = this.createAPIGateway();

    const executeRole = this.createExecutionRole(convoAudioBucket);
    convoAudioBucket.grantReadWrite(executeRole);

    const s3Integration = this.createS3Integration(convoAudioBucket, executeRole);

    this.addAssetsEndpoint(apiGateway, s3Integration);
}

    private createAPIGateway() {
        return new ApiGateway.RestApi(this, "convo-budy-api", {
          restApiName: "Convo budy api",
          description: "Api for s3 upload of convo buddy audio files",
          binaryMediaTypes: ["audio/mpeg", "audio/mp3"],
          minimumCompressionSize: 0,
        });
      }
    
      private createExecutionRole(bucket: s3.IBucket) {
        const executeRole = new Iam.Role(this, "api-gateway-s3-convo-budy-api", {
          assumedBy: new Iam.ServicePrincipal("apigateway.amazonaws.com"),
          roleName: "API-Gateway-S3-Integration-Role-Convo-Budy",
        });
    
        executeRole.addToPolicy(
          new Iam.PolicyStatement({
            resources: [bucket.bucketArn],
            actions: ["s3:Put"],
          })
        );
    
        return executeRole;
      }
    
      private createS3Integration(assetsBucket: s3.IBucket, executeRole: Iam.Role) {
        return new ApiGateway.AwsIntegration({
          service: "s3",
          integrationHttpMethod: "PUT",
          path: `/{folder}/{key}`,
          options: {
            credentialsRole: executeRole,
            integrationResponses: [
              {
                statusCode: "200",
                responseParameters: {
                  "method.response.header.Content-Type": "integration.response.header.Content-Type",
                },
              },
            ],
    
            requestParameters: {
              "integration.request.path.folder": "method.request.path.folder",
              "integration.request.path.key": "method.request.path.key",
            },
          },
        });
      }
    
      private addAssetsEndpoint(
        apiGateway: ApiGateway.RestApi,
        s3Integration: ApiGateway.AwsIntegration
      ) {
        apiGateway.root
          .addResource("{folder}")
          .addResource("{key}")
          .addMethod("PUT", s3Integration, {
            methodResponses: [
              {
                statusCode: "200",
                responseParameters: {
                  "method.response.header.Content-Type": true,
                },
              },
            ],
            requestParameters: {
              "method.request.path.folder": true,
              "method.request.path.key": true,
              "method.request.header.Content-Type": true,
            },
          });
        }
}