# CESM function to set the 'site' environment variable via 'neon_site' function call
# (Essentially, a helper file.. )

import os

def neon_site(name):
  # Can add some checking here later:

  # Set the environment variable:
  os.environ['site'] = name


