# UniConn-COMP-380 :unicorn: 
> [!NOTE]
> ***Author: Daria Taradina***

**A (Uni)versity (Conn)ection platform for CSUN students.**  
Discover communities, spark conversations, and stay in the loop with everything campus.

*Built with💙 by fellow Matadors — COMP 380/L · Spring 2026 · CSUN*

## :computer: Tech Stack

| Layer | Technology |
|---|---|
| Backend | Java 17, Spring Boot 3.3.5, Spring Security, Hibernate/JPA |
| Database | MySQL (Community Server & Workbench) |
| Auth | JWT |
| Frontend | HTML, CSS, JS (Thymeleaf) |

## Prerequisites

Make sure you have the following installed before running the project:
- [Java 17](https://www.oracle.com/java/technologies/downloads/)
- [Maven 3.8+](https://maven.apache.org/download.cgi)
- [MySQL 8+](https://dev.mysql.com/downloads/) - Community Server and Workbench
- [IntelliJ IDEA](https://www.jetbrains.com/idea/) (recommended) or any IDE of your choice


## :arrow_forward: Getting Started

**1. Clone the repository**

**2. Create the database**

Open MySQL Workbench or your MySQL client and run:

```sql
CREATE DATABASE uni_conn;
```

**3. Configure environment variables**

Open `src/main/resources/application.properties` and update the following with your local MySQL credentials:

```properties
spring.application.name=UniConn

# Database connection
spring.datasource.url=jdbc:mysql://localhost:3306/uni_conn?useUnicode=true&characterEncoding=UTF-8&connectionCollation=utf8mb4_unicode_ci
spring.datasource.username=your_mysql_username 
spring.datasource.password=your_mysql_password

## Hibernate properties
spring.jpa.hibernate.ddl-auto=update
spring.jpa.open-in-view=false
```

**4. Run the application** :rocket: 

**Option A — IntelliJ IDEA:**
Open the project and click the green Run button. IntelliJ will automatically download all dependencies on first launch.

**Option B — Terminal:**
```bash
mvn spring-boot:run
```

On first run, Maven will download all required dependencies from `pom.xml` automatically.

The API will start at `http://localhost:8080`.

> [!IMPORTANT]
> `spring.jpa.hibernate.ddl-auto` set to `update` — Hibernate will run entities and create tables in database
> 
> After first run:
> - Verify all tables were created in database properly
> - Switch `spring.jpa.hibernate.ddl-auto` to `validate` — Hibernate will be checking entity/schema alignment on startup but will not modify the database

## :file_cabinet: Project Structure

```
src/
├── main/
│   ├── java/com/uniconn/backend/
│   │   ├── composite-keys/         # Composite PKs for join tables (UserFollowId, PostLikeId, ...)
│   │   ├── config/                 # Security configurations
│   │   ├── controllers/            # REST controllers
│   │   ├── dtos/                   # Data transfer objects (request/response)
│   │   ├── entities/               # JPA entities (User, Community, ...)
│   │   ├── exception/              # GlobalExceptionHandler and related exception classes
│   │   ├── repositories/           # Spring Data repositories
│   │   ├── services/               # Business logic
│   │   ├── utils/                  # JWT
│   │   └── validation/             # Tags validator
│   └── resources/
│       ├── static/                          # HTML, CSS, JavaScript
│       ├── db/                              # SQL seed scripts (run manually in Workbench)
│       └── application.properties.template  # (DB connection, methods' properties, ...)
```
 
## :arrows_clockwise: Loading Test Data
 
**Sample seed data is provided in `src/main/resources/db/`.** 
 
**1. Open MySQL Workbench and connect to your local instance**
  
**2. Run the scripts in order**
 
**Step 1 — Users:**
Open `src/main/resources/db/users_test_data.sql` in Workbench and execute.
 
**Step 2 — Communities:**
Open `src/main/resources/db/community_test_data.sql` in Workbench and execute.

**Step 3 — Posts:**
Open `src/main/resources/db/posts_test_data.sql` in Workbench and execute.

**Test data summary:**
* 20 Active Users (password for all accounts: `Password123!`, emails end with `@my.csun.edu`)
* 20 Tags (used both by communities and posts)
* 10 Communities
* Members added to communities
* Community member roles (`ADMIN`, `REGULAR_MEMBER`)
* 150 Posts: 105 Community posts, 45 Profile posts 

:white_check_mark: **Verification is included in sql files so will run after data is populated.** 

## :camera: Image Upload

> [!WARNING]
> :bangbang: Include local image upload feature
> 
> ***(guide wasn't included)*** 




## :woman_technologist: User Management System (Lily)
| Feature | Description | 
|---|---|
|  |  |


## :joystick: Interactive Systems (Abi)
| Feature | Description | 
|---|---|
|  | |


## :bell: Notification System (Supti)
| Feature | Description | 
|---|---|
|  |  |

## ⚠️ Important

- If any code changes needed, tell the person whose code it is, and leave comments in code if needed, but _**don't change**_ someone's code
- Commit changes to your own separate branch (e.g. `feature/name-of-the-feature`)
- Use [conventional commit messages](https://gist.github.com/qoomon/5dfcdf8eec66a051ecd85625518cfd13) and fill out provided template on PR creation to keep backlog clean and clear

> [!CAUTION]
> ### ❌ Do NOT edit any of the following
>
> These files are owned by the project lead.
>
> | File / Folder | Reason |
> |---|---|
> | `src/main/java/.../entities/` | Shared data model — breaks everyone's code |
> | `src/main/java/.../composite-keys/` | Shared join table keys |
> | `.gitignore` | Tracks what stays out of version control |
> | `pom.xml` | Dependency config — coordinate with project lead |
> | `dependency-versions.properties` | Version pinning |
> | `application.properties` (template in repo) | Shared config template |
>
> If you think a change is needed, **leave a comment in the code** and message the owner — do not edit directly.

## 🗒️ Notes

> - Add testing guide for your feature to README, to test in Postman or in browser (if applicable) 
> - sql uses `snake_case`, in Java `camelCase` (constants `SCREAMING_SNAKE_CASE`), on github `kebab-case`
> - PR template included
> GitHub syntax resources:
> - [General](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax)
> - [Code styling](https://docs.github.com/en/get-started/writing-on-github/working-with-advanced-formatting/creating-and-highlighting-code-blocks) 
