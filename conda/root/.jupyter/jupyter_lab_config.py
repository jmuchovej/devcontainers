# Configuration file for lab.
c = get_config()

#------------------------------------------------------------------------------
# Application(SingletonConfigurable) configuration
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# JupyterApp(Application) configuration
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# ExtensionApp(JupyterApp) configuration
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# LabServerApp(ExtensionApp) configuration
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# LabApp(LabServerApp) configuration
#------------------------------------------------------------------------------

c.LabApp.open_browser = False
c.LabApp.user_settings_dir = '/root/.jupyter/lab/user-settings'
c.LabApp.workspaces_dir = '/root/.jupyter/lab/workspaces'

#------------------------------------------------------------------------------
# ServerApp(JupyterApp) configuration
#------------------------------------------------------------------------------

c.ServerApp.allow_origin = '*'
c.ServerApp.allow_remote_access = True
c.ServerApp.allow_root = True
c.ServerApp.answer_yes = True
c.ServerApp.autoreload = True
c.ServerApp.iopub_data_rate_limit = 10000000
c.ServerApp.iopub_msg_rate_limit = 10000
c.ServerApp.ip = "0.0.0.0"
# c.ServerApp.local_hostnames = ['localhost']
c.ServerApp.open_browser = False
c.ServerApp.password = ''
c.ServerApp.password_required = False
c.ServerApp.port = 8888
c.ServerApp.port_retries = 50
c.ServerApp.root_dir = "/workspace"
c.ServerApp.terminals_enabled = True
c.ServerApp.token = ''
