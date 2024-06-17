import json

import boto3.session


class PyBatch(object):

    def __init__(self, raw_args: list[str]):
        super().__init__()

        self.session = boto3.session.Session(region_name='us-west-1')

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
        try:

            print('hello world!')

            print(f'read from S3 here: S3://{self.bucket}/{self.input}')

            s3_client = self.session.client('s3')

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

            # CLOUDWATCH ALARMS
            print('publish EventBridge event  here')
            # https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/cloudwatch/client/put_metric_alarm.html

        except Exception as e:
            print(f'Error: {e}')

            # CLOUDWATCH METRICS
            print('publish CloudWatch metric here')
            cloudwatch = self.session.client('cloudwatch')
            response = cloudwatch.put_metric_data(
                Namespace='examples-aws-glue',
                MetricData=[
                    {
                        'MetricName': 'GlueJobException',
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
                        # 'Unit': 'Seconds' | 'Microseconds' | 'Milliseconds' | 'Bytes' | 'Kilobytes' | 'Megabytes' | 'Gigabytes' | 'Terabytes' | 'Bits' | 'Kilobits' | 'Megabits' | 'Gigabits' | 'Terabits' | 'Percent' | 'Count' | 'Bytes/Second' | 'Kilobytes/Second' | 'Megabytes/Second' | 'Gigabytes/Second' | 'Terabytes/Second' | 'Bits/Second' | 'Kilobits/Second' | 'Megabits/Second' | 'Gigabits/Second' | 'Terabits/Second' | 'Count/Second' | 'None',
                        'Unit': 'Count',
                        'Value': 1
                    },
                ]
            )
            print('put metric response: ' + json.dumps(response))

            #  throw the exception!
            raise e
