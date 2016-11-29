import argparse
import os
import shlex
import subprocess
import sys
import yaml

from jinja2 import Environment, FileSystemLoader


TEMPLATE_DIR = "platform-template"

# Modified http://blog.endpoint.com/2015/01/getting-realtime-output-using-python.html for Python3 and stdin
def run_command(command, stdin):
    process = subprocess.Popen(shlex.split(command), stdin=subprocess.PIPE, stdout=subprocess.PIPE)
    process.stdin.write(str.encode(stdin))
    process.stdin.close()
    while True:
        output = process.stdout.readline().decode()
        if output == "" and process.poll() is not None:
            break
        if output:
            print(output, end="")


    rc = process.poll()
    return rc

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Deploy a platform stack.")
    parser.add_argument("operation", choices=["create", "apply", "delete"], help="kubectl operation")
    parser.add_argument("-s", "--stack-name", help="Stack name")
    parser.add_argument("-d", "--domain-name", help="Domain name (not including stack name prefix)")
    parser.add_argument("-p", "--platform-version", help="Platform version")
    parser.add_argument("-w", "--weyl-memory", help="Weyl memory (in JVM arg format e.g. 4g)")
    args = parser.parse_args()

    env = Environment(loader=FileSystemLoader(TEMPLATE_DIR))
    for template_name in env.list_templates():
        print("--- {} ---".format(template_name))
        template = env.get_template(template_name)
        rendered = template.render(vars(args))
        run_command("kubectl create -f -", stdin=rendered)
