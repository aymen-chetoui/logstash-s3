#!/usr/bin/env python
import os

from jinja2 import Environment, FileSystemLoader

PATH = os.path.dirname(os.path.abspath(__file__))

TEMPLATE_ENVIRONMENT = Environment(
    autoescape=False,
    loader=FileSystemLoader(os.path.join(PATH, 'templates')),
    trim_blocks=False)

def render_template(template_filename, context):
    return TEMPLATE_ENVIRONMENT.get_template(template_filename).render(context)

def create_logstash_conf():
    fname = "logstash.conf"
    input_tcp_codec = os.environ['INPUT-TCP-CODEC']
    input_tcp_port = os.environ['INPUT-TCP-PORT']
    output_s3_region = os.environ['OUTPUT-S3-REGION']
    output_s3_bucket = os.environ['OUTPUT-S3-BUCKET']
    output_s3_sizefile = os.environ['OUTPUT-S3-SIZEFILE']
    output_s3_timefile = os.environ['OUTPUT-S3-TIMEFILE']
    output_s3_codec = os.environ['OUTPUT-S3-CODEC']
    context = {
        'input_tcp_codec': input_tcp_codec,
        'input_tcp_port': input_tcp_port,
        'output_s3_region': output_s3_region,
        'output_s3_bucket': output_s3_bucket,
	'output_s3_sizefile': output_s3_sizefile,
        'output_s3_timefile': output_s3_timefile,
        'output_s3_codec': output_s3_codec
    }
    with open(fname, 'w') as f:
        conf = render_template('logstash_template.conf', context)
        f.write(conf)

def main():
    create_logstash_conf()

if __name__ == "__main__":
    main()
