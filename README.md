# dreblow-php-nginx

### 🧪 Local Docker Test Setup

This guide will help you spin up your local Docker test container using your custom NGINX + PHP image and test content from a mounted website repo.

---

### 🔥 A. Fire Up Docker Test Container

```bash
docker compose -f support/testing/docker-compose.test.yml up --build
```

- `-f support/testing/docker-compose.test.yml`: Points to the test-specific compose file.
- `--build`: Forces a rebuild using your local Dockerfile.

This will:
- Build your custom Docker image (if needed),
- Mount your local website repo into `/var/www/html`,
- Load your custom `default.conf` into NGINX,
> If everything worked out of the box, head to the non HTTPS since ACME currently doesn't go online:
> We may have to kick off the network, bash: `docker network create webproxy`
- Expose the site on [http://www.dreblowdesigns.127.0.0.1.nip.io:8000](http://www.dreblowdesigns.127.0.0.1.nip.io:8000).

---

### 🔥 B. Re-Fire Up Docker Test Container

```bash
docker compose -f support/testing/docker-compose.test.yml up --build --force-recreate
```
---

### 🧪 C. Terminal Commands to Check

1. **See logs (verify build, PHP, NGINX):**
   ```bash
   docker compose -f support/testing/docker-compose.test.yml logs -f
   ```

2. **Check running containers:**
   ```bash
   docker ps
   ```

3. **Exec into container (optional debugging):**
   ```bash
   docker exec -it <container_id_or_name> sh
   ```

4. **Tear it down when done:**
   ```bash
   docker compose -f support/testing/docker-compose.test.yml down
   ```

---

### 🔥 D. Push to the Repo
#### 1. 🧩 Push the repo to GitHub

#### 2. ⚙️ Setup docker for multi-platform builder

Run this once on your Mac:
```bash
docker buildx create --name multiarch --driver docker-container --use
```
This does three things:
* 	Creates a new Buildx builder (multiarch)
*	Uses the Docker container driver instead of the legacy “docker” driver
*	Sets it as your active builder

Confirm it worked:
```bash
docker buildx inspect --bootstrap
```

You should see:
```bash
Driver: docker-container
Platforms: linux/amd64, linux/arm64, linux/arm/v7, ...
```
Ready to push!

#### 3. 🐳 Push the built Docker image
* Once your repo is pushed and up-to-date, you can safely push the image to GitHub Container Registry (GHCR):

```bash
export GIT_TAG=$(git rev-parse --short HEAD)
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t ghcr.io/dreblow/dreblow-php-nginx:latest \
  --push .
```