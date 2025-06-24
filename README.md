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
- Expose the site on [http://localhost:8080](http://localhost:8080).

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
