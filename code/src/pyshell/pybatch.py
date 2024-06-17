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
        data_input = s3_client.get_object(Bucket=self.bucket, Key=self.input)
        body = data_input['Body'].read().decode('utf-8')
        print('S3 Input: ' + body)

        print(f'write to S3 here: S3://{self.bucket}/{self.output}')

        print('publish CloudWatch metric here')
