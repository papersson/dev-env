# shells/nu/login.nu

# Show a welcome message once per day
if ($env.CMD_DURATION_MS | into int) == 0 {
  echo "👋 Welcome back, $env.USER — today is $(date now)" 
}

# Check for updates
def check_updates [] { nu plugin list | where status != "Up to date" }
if (check_updates | count) > 0 {
  echo "⚠️  Some plugins need updating! Run 'nu plugin update'"
}