## 🔄 Clean Start Required — Read Before Doing Anything
> [!CAUTION]
> The repository has been reset. **Everyone must follow these steps before working on any code.** Do not skip or reorder steps.

---

### Step 1 — Delete your local repository

Simply delete the project folder from your computer entirely.
If you made changes to any files after merge - save those files in separate place, not to lose progress.

---

### Step 2 — Drop and recreate the database

Open **MySQL Workbench**, connect to your local instance, and run:

```sql
DROP DATABASE IF EXISTS uni_conn;
CREATE DATABASE uni_conn;
```

This wipes all old tables and gives you a clean schema.

---

### Step 3 — Clone the repository fresh

```bash
git clone https://github.com/rachelhann/UniConn-COMP-380.git
```

Open the project in your IDE.

---

### Step 4 — Set up `application.properties`

In `src/main/resources/application.properties`, fill in your local MySQL credentials:

```properties
spring.application.name=UniConn

# Database connection
spring.datasource.url=jdbc:mysql://localhost:3306/uni_conn
spring.datasource.username=root
spring.datasource.password=YOUR_PASSWORD

## Hibernate properties
spring.jpa.hibernate.ddl-auto=update
spring.jpa.open-in-view=false
```

> [!CAUTION]
> `application.properties` is in `.gitignore` — it will **never** be committed. Do not change the template in the repo. Do not commit credentials.

---

### Step 5 — Run the application (first time)

**IntelliJ:** Click the green Run button.

**Terminal:**
```bash
mvn spring-boot:run
```

Spring Boot will auto-create all tables from entities via `ddl-auto=update`. Wait until you see the startup success log.

---

### Step 6 — Verify tables were created

Open MySQL Workbench and confirm all tables exist in `uni_conn`:

```sql
USE uni_conn;
SHOW TABLES;
```

Expected tables (12): `users`, `communities`, `community_members`, `community_tags`, `follows`, `posts`, `post_tags`, `post_likes`, `comments`, `comment_likes`, `notifications`, `tags`

> [!IMPORTANT]
> If any tables are missing, **stop here** and message Daria before continuing.

---

### Step 7 — Load test data

Run the seed scripts **in order** from MySQL Workbench:

**Step 7a — Users:**
Open `src/main/resources/db/users_test_data.sql` → execute.

**Step 7b — Communities:**
Open `src/main/resources/db/community_test_data.sql` → execute.

Verification queries are included at the bottom of each file and will run automatically.

---

### Step 8 — Switch to `validate` mode

Once tables are confirmed and data is loaded, update `application.properties`:

```properties
spring.jpa.hibernate.ddl-auto=validate
```

Restart the app and confirm it starts without errors. This prevents Hibernate from modifying the schema going forward.

---

### Step 9 — Create your feature branch

> [!IMPORTANT]
> Always branch off `dev`, not `main`
> ```
> git checkout dev
> git pull origin dev
> git checkout -b feature/your-feature-name
> ```
> Push to **your branch only** — never commit directly to `main` or `dev`

Pull from `dev` into your feature branch at least once before opening a PR, ideally daily if the project is active — the longer you wait, the worse the merge conflicts

Use [conventional commit messages](https://gist.github.com/qoomon/5dfcdf8eec66a051ecd85625518cfd13).

---

> [!CAUTION]
> ### ❌ Do NOT edit any of the following
>
> These files are owned by the project lead. Changes require a PR approved by Daria:
>
> | File / Folder | Reason |
> |---|---|
> | `README.md` | Project documentation — PR required |
> | `src/main/java/.../entities/` | Shared data model — breaks everyone's code |
> | `src/main/java/.../composite-keys/` | Shared join table keys |
> | `.gitignore` | Tracks what stays out of version control |
> | `pom.xml` | Dependency config — coordinate with Daria |
> | `dependency-versions.properties` | Version pinning |
> | `application.properties` (template in repo) | Shared config template |
>
> If you think a change is needed, **leave a comment in the code** and message the owner — do not edit directly.
