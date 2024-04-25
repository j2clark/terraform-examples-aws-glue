import sys
from pyshell.pybatch import PyBatch


def main():
    # we have a chicken/egg problem wrt glue and logging
    # we need glue contexts for any logging to work, but we need to parse args to determine exec env
    # if parsing goes wrong, we can't log it
    # part of the issue is the design of argparse - it does a system exit on error
    # we will need to extend argparse and modify its behavior

    raw_args = sys.argv

    #  todo: add --help job-parameters

    # todo: add --help job-parameters

    pybatch_job = PyBatch(raw_args)

    pybatch_job.run(raw_args)


if __name__ == '__main__':
    main()
