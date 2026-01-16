```markdown
# 🟩 Minecraft Docker + Tailscale (MC Tool)

A system to manage **multiple Minecraft servers** using **Docker Compose**, with private access via **Tailscale**, and a unified `mc` command to control everything from any PC with zero friction.

Designed for:
- No public ports
- No hardcoded servers
- Easy scaling
- Daily usage without operational pain

---

## 📦 Requirements

Before starting, make sure you have:

- Docker
- Docker Compose (the `docker compose` plugin)
- Tailscale (already authenticated on the host)
- Bash or Zsh
- Git

> ⚠️ Tailscale does **not** run inside Docker. It uses the host’s Tailscale connection.

---

## 📁 Project structure

```

minecraft/
├── docker-compose.yml
├── mc
├── init.sh
├── .gitignore
└── servers/
    ├── survival/
    │   └── data/
    ├── creative/
    │   └──data/
    └── modded/
        └── data/

````

Each folder represents **one independent Minecraft server**.

---

## 🚀 Installation (once per PC)

```bash
git clone https://github.com/knameless27/mc-admin.git
cd minecraft
chmod +x init.sh mc
./init.sh
source ~/.bashrc   # or ~/.zshrc
````

This will:

* Register the repo path as `MC_HOME`
* Add the `mc` command to your `PATH`
* Avoid duplicating configuration if already installed

---

## 🎮 The `mc` command

The `mc` command is the **single control interface** for the whole system.

### 📋 List servers

```bash
mc list
```

### ▶️ Start servers

```bash
mc up              # all servers
mc up survival     # a specific server
```

### 🛑 Stop everything

```bash
mc down
```

### 🔄 Restart a server

```bash
mc restart modded
```

### 📜 View logs

```bash
mc logs survival
```

### 📊 Status

```bash
mc ps
```

---

## 🧠 Run commands inside the server (RCON)

Run Minecraft commands **without entering the container**.

```bash
mc exec survival op Jefe
mc exec survival weather clear
mc exec survival time set day
mc exec modded say Server will restart in 5 minutes
```

This uses the built-in `rcon-cli` provided by the `itzg/minecraft-server` image.

⚠️ Make sure the service has RCON enabled:

```yaml
environment:
  ENABLE_RCON: "true"
```

---

## ➕ Adding a new server

1. Add a service to `docker-compose.yml`:

```yaml
skyblock:
  image: itzg/minecraft-server
  container_name: mc-skyblock
  ports:
    - "25568:25565"
  environment:
    EULA: "TRUE"
    TYPE: PAPER
  volumes:
    - ./skyblock/data:/data
```

2. Create the folder:

```bash
mkdir -p skyblock/data
touch skyblock/data/.gitkeep
```

3. Start it:

```bash
mc up skyblock
```

🚫 No aliases or scripts need to be modified.

---

## 🌐 Access via Tailscale

1. Get your Tailscale IP:

```bash
tailscale ip -4
```

2. Connect from Minecraft:

```
<tailscale-ip>:25565
<tailscale-ip>:25566
```

🔒 Access is limited to devices in your tailnet
🔒 No public ports exposed

---

## ⬆️ Upgrading Minecraft versions (Vanilla / Paper)

### 1️⃣ Backup (mandatory)

```bash
docker stop mc-vanilla
tar -czf backup-vanilla-$(date +%F).tar.gz vanilla/data
```

### 2️⃣ Change version

```yaml
environment:
  VERSION: "1.21"
```

### 3️⃣ Start the server

```bash
mc up vanilla
mc logs vanilla
```

Minecraft will automatically apply **DataFixer** to migrate the world.

⚠️ Never downgrade versions.

---

## 🧾 .gitignore

The project ignores:

* Worlds
* Logs
* Downloaded plugins / mods
* Local runtime files

Only infrastructure and tooling are versioned.

---

## 🧬 Design philosophy

* `docker-compose.yml` is the **single source of truth**
* `mc` is the **only command you need**
* `init.sh` runs **once**
* No hardcoded servers
* Works the same on every PC

---

## 🛠️ Possible extensions

* `mc new <name>` → auto-create a server
* Bash/Zsh tab-completion
* Automated backups
* Test/staging servers
* Per-server Tailscale ACLs

---

## 🟢 TL;DR

```bash
mc list
mc up survival
mc exec survival op Jefe
mc logs survival
mc down
```

System ready. Zero friction operations.

```