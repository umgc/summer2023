"use strict";
import * as ll from 'aws-cdk-lib/aws-lambda';
import * as cdk from 'aws-cdk-lib';
import { Construct } from 'constructs';
import * as path from 'path'

export class LambdaLayerStack extends cdk.Stack {
    constructor(scope: Construct, id: string, props?: cdk.StackProps) {
      super(scope, id, props);
      
      new ll.LayerVersion(this, 'convoBudyLayerProd', {
        removalPolicy: cdk.RemovalPolicy.DESTROY,
        code: ll.Code.fromAsset(path.resolve(__dirname, '../lambda-handler')),
        compatibleArchitectures: [ll.Architecture.X86_64, ll.Architecture.ARM_64],
        compatibleRuntimes:[ll.Runtime.PYTHON_3_9]
      });
    }}