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
                elif "--branch" in arg:
                    self.branch = value
                elif "--job_name" in arg:
                    self.job_name = value
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
        json_lines = ''
        index = 0
        for line in lines:
            print(f'Input Record[{index}]: {line}')
            record = json.loads(line)
            transformed_record = {
                'KEY': str(record['key1']).upper()
            }

            if index > 0:
                json_lines += '\n'
            json_lines += json.dumps(transformed_record)

            index = index + 1

        # WRITE
        print(f'write to S3 here: S3://{self.bucket}/{self.output}')
        s3_client.put_object(Bucket=self.bucket, Key=self.output, Body=json_lines)

        # CLOUDWATCH METRICS
        print('publish CloudWatch metric here')
        cloudwatch = session.client('cloudwatch')
        response = cloudwatch.put_metric_data(
            MetricData=[
                {
                    'MetricName': 'KPIs',
                    'Dimensions': [
                        {
                            'Name': 'GLUE_JOB',
                            'Value': self.job_name
                        },
                        {
                            'Name': 'BRANCH',
                            'Value': self.branch
                        }
                    ],
                    'Unit': 'None',
                    'Value': 1
                },
            ],
            Namespace='examples-aws-glue'
        )
        print('put metric response: ' + json.dumps(response))

        # CLOUDWATCH EVENTS
        print('publish EventBridge event  here')