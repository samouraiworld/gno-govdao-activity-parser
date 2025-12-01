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

## 💡 Need More?

<details>
<summary>Prerequisites</summary>

- Git
- Go (1.21+)
- Make
- A web browser
</details>

<details>
<summary>Custom Address</summary>

```bash
./setup_environment.sh "" "g1youraddress123"
```
</details>

<details>
<summary>Custom Gno Repository & Branch</summary>

```bash
./setup_environment.sh "git@github.com:your/gno.git" "your-branch" "g1youraddress" 
```

Parameters:
1. Repository URL (default: `git@github.com:gnolang/gno.git`)
2. Branch (default: `master`)
3. Address (default: `g17raryfukyf7an7p5gcklru4kx4ulh7wnx44ync`)
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
