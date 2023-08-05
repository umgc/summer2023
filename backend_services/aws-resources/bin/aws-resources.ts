#!/usr/bin/env node
//import 'source-map-support/register';
import * as cdk from 'aws-cdk-lib';

import { ConvoBuddyAwsStack } from '../constructs/convoBuddyStack';

const app = new cdk.App();
new ConvoBuddyAwsStack(app, 'ConvoBuddyTrasncriptionStack');


