class PyBatch(object):

    def __init__(self, raw_args: list[str]):
        super().__init__()

        print('raw_args: ' + str(raw_args))

        # glue args seem to have randomly injected props which make no sense
        # we need to remove this junk before we can parse the args
        # raw_args = EnvArgsBuilder.normalize_args(raw_args)


    def run(self, job_args: list[str]):

        print('hello world!')
