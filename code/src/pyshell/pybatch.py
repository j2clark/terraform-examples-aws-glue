class PyBatch(object):

    def __init__(self, raw_args: list[str]):
        super().__init__()

        print('raw_args: ' + str(raw_args))

        # count = len(raw_args)
        # skip first parameter
        index = 0
        while index < len(raw_args):
            arg = raw_args[index]
            if arg.startswith('--'):
                value = raw_args[index + 1]
                if "--input" in arg:
                    self.input = arg.split("=")[1]
                elif "--output" in arg:
                    self.output = arg.split("=")[1]
                elif "--bucket" in arg:
                    self.bucket = arg.split("=")[1]
                index = index + 2
            else:
                index = index + 1



    def run(self, job_args: list[str]):

        print('hello world!')

        print(f'read from S3 here: S3://{self.bucket}/{self.input}')

        print(f'write to S3 here: S3://{self.bucket}/{self.output}')

        print('publish CloudWatch metric here')
