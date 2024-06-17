import json

import boto3.session


class PyBatch(object):

    def __init__(self, raw_args: list[str]):
        super().__init__()

        print('raw_args: ' + str(raw_args))

        index = 0
        while index < len(raw_args):
            arg = raw_args[index]
            if arg.startswith('--'):
                value = raw_args[index + 1]
                if "--input" in arg:
                    self.input = value
                elif "--output" in arg:
                    self.output = value
                elif "--bucket" in arg:
                    self.bucket = value
                index = index + 2
            else:
                index = index + 1



    def run(self, job_args: list[str]):

        print('hello world!')

        print(f'read from S3 here: S3://{self.bucket}/{self.input}')
        session = boto3.session.Session(region_name='us-west-1')
        s3_client = session.client('s3')

        # READ
        data_input = s3_client.get_object(Bucket=self.bucket, Key=self.input)
        body = data_input['Body'].read().decode('utf-8')
        # print('S3 Input: ' + body)
        lines = body.splitlines()

        # TRANSFORM
        output = ''
        index = 0
        for line in lines:
            print(f'Input Record[{index}]: {line}')
            record = json.loads(line)
            transformed = {
                'KEY': str(record['key1']).upper()
            }

            if index > 0:
                output += '\n'
            output += json.dumps(transformed)

            index = index + 1

        # WRITE
        print(f'write to S3 here: S3://{self.bucket}/{self.output}')
        s3_client.put_object(Bucket=self.bucket, Key=self.output, Body=json.dumps(output))

        # CLOUDWATCH METRICS
        print('publish CloudWatch metric here')

        # CLOUDWATCH EVENTS
        print('publish EventBridge event  here')