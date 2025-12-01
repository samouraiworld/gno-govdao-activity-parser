# Environment Setup

## 🚀 One Command Setup

```bash
make all
```

Done! The DAO is running at `http://localhost:8888` 🎉

Press `Ctrl+C` to stop.

---

## 📚 What You Can Do

| Command | What it does |
|---------|--------------|
| `make all` | Setup + start everything |
| `make setup` | Just setup (clone & build) |
| `make fake-data` | Add test proposals & members |

### Customize Your Setup

Use environment variables to configure:

```bash
# Custom repository
make all GNO_REPO=git@github.com:moul/gno.git

# Custom branch
make all BRANCH=dev

# Custom address
make all ADDRESS=g1youraddress123

# All together
make all GNO_REPO=git@github.com:moul/gno.git BRANCH=dev ADDRESS=g1youraddress123
```

**Available variables:**
- `GNO_REPO` - Repository URL (default: `git@github.com:gnolang/gno.git`)
- `BRANCH` - Git branch (default: `master`)
- `ADDRESS` - Your Gno address (default: `g17raryfukyf7an7p5gcklru4kx4ulh7wnx44ync`)

## 💡 Advanced Options

<details>
<summary>Using the Script Directly</summary>

```bash
./setup_environment.sh [REPO] [BRANCH] [ADDRESS]
```

Example:
```bash
./setup_environment.sh "git@github.com:your/gno.git" "your-branch" "g1youraddress"
```
</details>

<details>
<summary>Prerequisites</summary>

- Git
- Go (1.21+)
- Make
- A web browser
</details>

<details>
<summary>Problems?</summary>

**Port 8888 already in use?**
```bash
pkill gnodev
```

**Browser didn't open?**  
Go to `http://localhost:8888/r/gov/dao/v3/loader`

**Want to stop?**  
Press `Ctrl+C` in the terminal running the setup script

**Need help?**
```bash
make help
```
</details>
