#!/bin/bash

/opt/zato/current/bin/py << IN_PYTHON
# stdlib
import os
from json import dumps

# sh
import sh

# The list of environment variables that we recognize
# and that can be passed to the underlying Ansible playbook.
env_keys = [
    'Zato_SSH_Password',
    'Zato_Dashboard_Password',
    'Zato_IDE_Password',
    'Zato_Python_Reqs',
    'Zato_Hot_Deploy_Dir',
    'Zato_User_Conf_Dir',
    'Zato_Extlib_Dir',
    'Zato_Cluster_Name',
    'Zato_Enmasse_File',
    'Zato_ODB_Type',
    'Zato_ODB_Hostname',
    'Zato_ODB_Port',
    'Zato_ODB_Name',
    'Zato_ODB_Username',
    'Zato_ODB_Password',
    'Zato_IP_Address',
    'Zato_Host_Dashboard_Port',
    'Zato_Host_Server_Port',
    'Zato_Host_LB_Port',
    'Zato_Host_Database_Port',
    'Zato_Host_SSH_Port',
    'Zato_Run_Internal_Tests',
    'Zato_Run_Quickstart_Step_01',
    'Zato_Run_Quickstart_Step_02',
]

# Build a mapping of environment values that were provided on input
env_values = {}

for name in env_keys:
    value = os.environ.get(name) or None
    env_values[name] = value

# For backward compatibility, map the following keys to the current ones.
# Note that the current keys have priority in case both are specified.
env_keys_prev = {
    'ODB_TYPE':     'Zato_ODB_Type',
    'ODB_HOSTNAME': 'Zato_ODB_Hostname',
    'ODB_PORT':     'Zato_ODB_Port',
    'ODB_NAME':     'Zato_ODB_Name',
    'ODB_USERNAME': 'Zato_ODB_Username',
    'ODB_PASSWORD': 'Zato_ODB_Password',

    'ZATO_SSH_PASSWORD':           'Zato_SSH_Password',
    'ZATO_WEB_ADMIN_PASSWORD':     'Zato_Dashboard_Password',
    'ZATO_IDE_PUBLISHER_PASSWORD': 'Zato_IDE_Password',
    'ZATO_ENMASSE_FILE':           'Zato_Enmasse_File',
}

for prev_name, current_name in env_keys_prev.items():
    current_value = env_values.get(current_name)
    if not current_value:
        prev_value = os.environ.get(prev_name) or None
        if prev_value:
            env_values[current_name] = prev_value

#
# These two previous keys used to be supported but they are not anymore
# REDIS_HOSTNAME
# ZATO_ENMASSE_INITIAL_SLEEP
#

# Turn the dictionary of parameters into a JSON document expected by Ansible.
env_values = dumps(env_values)

# Build a list of Ansible parameters to invoke via sh
cli_params = []
cli_params.append('-c')
cli_params.append('local')
cli_params.append('-i')
cli_params.append('localhost,')
cli_params.append('/zato-ansible/zato-quickstart.yaml')
cli_params.append('-v')
cli_params.append('--extra-vars')
cli_params.append(env_values)
cli_params.append('&&')
cli_params.append('tail')
cli_params.append('-n')
cli_params.append('500')
cli_params.append('-f')
cli_params.append('/opt/zato/env/qs-1/server1/logs/server.log')

# Invoke Ansible now
command = sh('ansible-playbook')
command(*cli_params)

IN_PYTHON

#ansible-playbook -c local -i localhost, /zato-ansible/zato-quickstart.yaml -v \
#    --extra-vars '{"Zato_Run_Quickstart_Step_02":true}' && \

# Tail server logs in foreground
#tail -n 500 -f /opt/zato/env/qs-1/server1/logs/server.log
