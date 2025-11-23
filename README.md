# kexpose - Your Kubernetes Port-Forward Manager

> **Stop juggling terminal windows. Manage all your Kubernetes port forwards in one beautiful TUI.**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Homebrew](https://img.shields.io/badge/Homebrew-ready-orange.svg)](https://github.com/donsolly/homebrew-kexpose)

---

## The Problem

If you work with Kubernetes, you know the drill:

```bash
# Terminal 1
kubectl port-forward svc/frontend 8080:80

# Terminal 2
kubectl port-forward svc/backend 9000:9000

# Terminal 3
kubectl port-forward svc/database 5432:5432

# ... 10 more terminals later
# Which port was the API on again? 🤔
```

**Port forwarding is essential for Kubernetes development, but managing multiple forwards is painful:**

- 🪟 **Too many terminals** - Each forward needs its own terminal window
- 🔍 **Lost connections** - Forwards silently die and you don't notice until your app breaks
- 🎯 **Port conflicts** - "Address already in use" errors waste your time
- 🔄 **No visibility** - What's running? Where? For how long?
- 🌍 **Context switching** - Manually tracking forwards across clusters and namespaces

---

## The Solution

**kexpose** is a cross-platform TUI (Terminal User Interface) that gives you complete control over your Kubernetes port forwards in a single, beautiful interface.

<!-- Screenshot: Main TUI interface showing the browse pane and active forwards -->
*[Screenshot: Full TUI showing services on the left, active forwards on the right]*

### What Makes kexpose Different

✨ **Visual Dashboard** - See all your port forwards at a glance
🚀 **One-Key Operations** - Start, stop, restart forwards with a single keypress
🎯 **Smart Port Selection** - Automatically finds available ports
📊 **Real-time Status** - Know immediately when a forward fails
🔄 **Auto-Reconnect** - Forwards automatically recover from network hiccups
⚡ **Multi-Cluster Support** - Switch between contexts and namespaces instantly
🎨 **Keyboard-First** - No mouse needed, lightning fast workflow

---

## See It In Action

### 1. Launch and Browse Your Services

Simply run `kexpose` to open the TUI. Browse services or pods across any namespace:

```
┌─ Browse Services (default) ──────────┐┌─ Active Forwards ────────────────┐
│ ● Service/frontend        :80       ││                                   │
│ ● Service/backend         :9000     ││  No active forwards              │
│ ● Service/database        :5432     ││                                   │
│ ● Service/redis           :6379     ││  Press 'f' to create one         │
│ ● Service/elasticsearch   :9200     ││                                   │
└──────────────────────────────────────┘└───────────────────────────────────┘
```

**Navigation:**
- `↑/↓` or `j/k` - Move through the list
- `Tab` - Switch between panes
- `p` - Toggle between Services and Pods view

### 2. Create Port Forwards Instantly

Select a service and press `f` to create a port forward:

```
Forward started! Access at http://localhost:8080 (→ frontend:80)
```

kexpose automatically:
- Finds an available local port (tries to match the remote port first)
- Establishes the connection
- Adds it to your Active Forwards pane
- Shows you exactly how to access it

### 3. Monitor All Your Forwards

The Active Forwards pane shows real-time status of every connection:

```
┌─ Active Forwards ─────────────────────────┐
│ ● Service/frontend      localhost:8080→80      2m  │
│ ◐ Service/backend       localhost:9000→9000    5s  │
│ ● Pod/worker-xyz        localhost:3000→3000    1h  │
│ ✗ Service/broken        localhost:5000→5000    -   │
└────────────────────────────────────────────────────┘
```

**Status Indicators:**
- `●` Running - Forward is active and healthy
- `◐` Connecting - Establishing connection
- `⟲` Reconnecting - Auto-recovery in progress
- `✗` Error - Forward failed (check logs)

**Quick Actions:**
- `x` - Stop a forward
- `r` - Restart a forward
- `R` - Refresh all forwards

### 4. Switch Contexts and Namespaces

Work across multiple clusters and namespaces seamlessly:

```
Context: production-cluster (c)  |  Namespace: default (n)
```

Press `c` for contexts or `n` for namespaces:

```
┌─ Select Context ─────────────┐
│ ● production-cluster         │
│   staging-cluster            │
│   development-cluster        │
│   minikube                   │
│                              │
│ Position: 1/4                │
└──────────────────────────────┘
```

When you switch, kexpose automatically reloads all resources. Your active forwards persist until you explicitly stop them.

---

## Real-World Use Cases

### Microservices Development

Working on a microservices architecture with 10+ services?

**Before kexpose:**
```bash
# 10 terminal windows, manually tracking ports
# Oh no, the auth service forward died 20 minutes ago
# and I've been debugging the wrong thing...
```

**With kexpose:**
- See all 10 forwards in one view
- Get instant notifications when a forward fails
- Restart failed forwards with one keypress
- Switch between staging and production clusters in seconds

### Database Access

Need to connect to multiple databases across different environments?

```
● Service/postgres-prod      localhost:5432→5432    Running
● Service/postgres-staging   localhost:5433→5432    Running
● Service/redis-cache        localhost:6379→6379    Running
● Service/mongo-db           localhost:27017→27017  Running
```

Now your database tools can connect to `localhost:5432`, `localhost:5433`, etc. without any terminal juggling.

### Team Debugging

Quickly expose internal services for troubleshooting:

1. `kexpose` - Launch the TUI
2. `n` - Switch to the namespace with issues
3. Navigate to the problematic service
4. `f` - Forward it to localhost
5. Open your browser or curl to investigate
6. `x` - Clean up when done

Total time: **10 seconds** vs manually typing commands and tracking ports.

### Multi-Cluster Management

Platform engineers managing multiple clusters:

```
Context: prod-us-east (c)    |  Namespace: monitoring (n)
Context: prod-eu-west (c)    |  Namespace: monitoring (n)
Context: staging-cluster (c) |  Namespace: monitoring (n)
```

Switch contexts with `c`, and all your forwards automatically reconnect to the right cluster.

---

## Installation

### macOS (Homebrew)

```bash
brew tap donsolly/homebrew-kexpose
brew install kexpose
```

### Linux (Universal Installer)

```bash
curl -sSL https://raw.githubusercontent.com/donsolly/homebrew-kexpose/main/scripts/install-linux.sh | bash
```

### Verify Installation

```bash
kexpose --version
kexpose doctor  # Check system requirements
```

**Requirements:**
- Access to a Kubernetes cluster with valid `kubeconfig`
- `lsof` for port scanning (pre-installed on macOS)

---

## Quick Start

### 1. Launch kexpose

```bash
kexpose
```

The TUI opens with your current kubectl context and namespace.

### 2. Create Your First Forward

1. Navigate to a service using `↑/↓` or `j/k`
2. Press `f` to create a port forward
3. See the success message: `Forward started! Access at http://localhost:8080`
4. The forward appears in the right pane

### 3. Access Your Service

Open your browser or make a request:

```bash
curl http://localhost:8080
```

### 4. Manage Forwards

- `Tab` - Switch to the Active Forwards pane
- `x` - Stop the forward
- `r` - Restart the forward
- `q` - Quit kexpose (all forwards stop automatically)

---

## Complete Keyboard Reference

### Navigation
| Key | Action |
|-----|--------|
| `↑/↓` or `j/k` | Move through lists |
| `Tab` | Switch between Browse and Active Forwards panes |
| `Enter` | Confirm selection in dialogs |
| `Esc` | Cancel dialog |

### Resource Management
| Key | Action |
|-----|--------|
| `f` | **Forward** - Create a port forward for selected resource |
| `p` | **Toggle view** - Switch between Services and Pods |
| `c` | **Context** - Switch Kubernetes context |
| `n` | **Namespace** - Switch namespace |
| `R` | **Refresh** - Reload current view |

### Forward Control
| Key | Action |
|-----|--------|
| `x` | **Stop** - Terminate selected forward |
| `r` | **Restart** - Restart selected forward |

### General
| Key | Action |
|-----|--------|
| `q` or `Ctrl+C` | **Quit** - Exit kexpose |
| `?` | **Help** - Show keyboard shortcuts |

---

## Advanced Features

### Smart Port Allocation

kexpose automatically handles port conflicts:

```
Target port: 8080
Local port 8080 is busy → Trying 8081
Local port 8081 is busy → Trying 8082
✓ Forward started on localhost:8082
```

You always know exactly which port to use.

### Auto-Reconnect

Network interruptions? No problem. kexpose automatically attempts to reconnect failed forwards:

```
● Service/frontend  localhost:8080→80  Running
⟲ Service/frontend  localhost:8080→80  Reconnecting...
● Service/frontend  localhost:8080→80  Running
```

### Multiple Forwards for the Same Resource

Need to forward multiple ports from the same service?

```
● Service/api  localhost:8080→80    HTTP endpoint
● Service/api  localhost:9090→9090  Metrics endpoint
```

Just create another forward - kexpose tracks them independently.

### CLI Mode (Non-Interactive)

Prefer the command line? kexpose works both ways:

```bash
# List active forwards
kexpose list

# Start a forward
kexpose start svc/myservice -n production -L 8080:80

# Stop a forward
kexpose stop <forward-id>
```

Perfect for scripts and automation.

---

## Upgrading

### Homebrew

```bash
brew update && brew upgrade kexpose
```

Homebrew automatically keeps kexpose up to date with the latest releases.

### Universal Installer (Linux)

Re-run the installer:

```bash
curl -sSL https://raw.githubusercontent.com/donsolly/homebrew-kexpose/main/scripts/install-linux.sh | bash
```

---

## Configuration

kexpose stores its configuration and logs in `~/.kexpose/`:

```
~/.kexpose/
├── config.yaml          # User preferences
└── logs/
    └── kexpose.log     # Debug logs
```

### Logs

Having issues? Check the logs:

```bash
tail -f ~/.kexpose/logs/kexpose.log
```

---

## Troubleshooting

### "Cannot connect to cluster"

Run the doctor command to check your setup:

```bash
kexpose doctor
```

This checks:
- ✓ Valid kubeconfig exists
- ✓ Can connect to current context
- ✓ `lsof` is installed
- ✓ Required permissions

### "Address already in use"

kexpose automatically finds available ports. If you see this error:

1. The port range might be exhausted
2. Check what's using ports: `lsof -i :8080`
3. Stop conflicting processes or let kexpose auto-select a port

### Forwards Keep Failing

Check network connectivity:

```bash
kubectl get pods  # Can you reach the cluster?
```

Also check pod status:

```bash
kubectl get pods -n <namespace>  # Are the pods running?
```

### Still Stuck?

- Check logs: `~/.kexpose/logs/kexpose.log`
- Run: `kexpose doctor`
- Open an issue: [GitHub Issues](https://github.com/donsolly/homebrew-kexpose/issues)

Include:
- OS and version
- kexpose version (`kexpose --version`)
- Output of `kexpose doctor`
- Relevant logs

---

## Why kexpose?

### Built by Developers, for Developers

We've all been there - juggling 10 terminal windows, losing track of which port forwards which service, debugging issues only to realize a forward died an hour ago.

**kexpose was born from that frustration.**

It's designed around how you actually work:
- **Keyboard-first** - No context switching to grab your mouse
- **Visual feedback** - See what's happening at a glance
- **Fail fast** - Know immediately when something breaks
- **Zero config** - Works with your existing kubectl setup
- **Reliable** - Auto-reconnect means your workflow doesn't break

### Open Source & Community Driven

kexpose is MIT licensed and built in the open. We welcome contributions, feedback, and feature requests.

- Star us on GitHub: [donsolly/kexpose-dev](https://github.com/donsolly/kexpose-dev)
- Report issues: [GitHub Issues](https://github.com/donsolly/homebrew-kexpose/issues)
- Contribute: Pull requests welcome!

---

## Under the Hood

kexpose is built with:
- **Go** - Fast, cross-platform, single binary
- **Bubble Tea** - Powerful TUI framework
- **Kubernetes Client-Go** - Official Kubernetes API client

### How Releases Work

This tap is automatically updated when new versions are released:

1. New tag pushed to [kexpose-dev](https://github.com/donsolly/kexpose-dev) (e.g., `v1.0.0`)
2. GitHub Actions builds binaries for all platforms
3. `homebrew-releaser` updates the formula with new URLs and checksums
4. Formula committed to this repository
5. `brew upgrade kexpose` gets you the latest version

You always get signed, verified binaries straight from the official release.

---

## FAQ

### Does kexpose work with any Kubernetes cluster?

Yes! If `kubectl` can connect to it, kexpose can too. Works with:
- Minikube
- kind
- Docker Desktop
- EKS, GKE, AKS
- On-premises clusters
- Any Kubernetes 1.19+

### Can I use kexpose with multiple clusters?

Absolutely. Press `c` to switch between contexts defined in your kubeconfig. All your forwards are tracked per-context.

### Does kexpose modify my cluster?

No. kexpose is read-only and only creates local port forwards. It never modifies resources in your cluster.

### What happens to forwards when I quit?

All active forwards are automatically stopped when you quit kexpose.

### Can I run kexpose in CI/CD?

While kexpose is primarily designed for interactive use, the CLI mode (`kexpose start`, `kexpose list`, etc.) can be used in automated scripts.

### Is kexpose secure?

kexpose uses your existing kubeconfig credentials and doesn't store or transmit any sensitive data. All connections are local to your machine.

---

## Contributing

We welcome contributions! Whether it's:
- 🐛 Bug reports
- 💡 Feature requests
- 📖 Documentation improvements
- 🔧 Code contributions

Visit our [main repository](https://github.com/donsolly/kexpose-dev) to get started.

---

## License

MIT License - see [LICENSE](LICENSE) for details.

---

## Get Started Now

```bash
brew tap donsolly/homebrew-kexpose
brew install kexpose
kexpose
```

**Stop managing terminals. Start managing forwards.**

---

*Made with ❤️ by a developer who were tired of terminal chaos*