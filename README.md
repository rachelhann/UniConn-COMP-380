# UniConn-COMP-380 :unicorn: 

A Spring Boot REST API backend for UniConn, a social platform for CSUN students.

## :computer: Tech Stack

- Java 17
- Spring Boot
- Spring Security
- Spring Data JPA (Hibernate)
- MySQL
- Maven


## Prerequisites

Make sure you have the following installed before running the project:

- [Java 17+](https://www.oracle.com/java/technologies/downloads/)
- [Maven 3.8+](https://maven.apache.org/download.cgi)
- [MySQL 8+](https://dev.mysql.com/downloads/) - Community Server and Workbench(should have it if followed video tutorial provided)
- [IntelliJ IDEA](https://www.jetbrains.com/idea/) (recommended) or any IDE of your choice (I work in Eclipse)


## :arrow_forward: Getting Started

### 1. Clone the repository

### 2. Create the database

Open MySQL Workbench or your MySQL client and run:

```sql
CREATE DATABASE uni_conn;
```

### 3. Configure environment variables

Open `src/main/resources/application.properties` and update the following with your local MySQL credentials:

```properties
spring.datasource.url=jdbc:mysql://localhost:3306/uni_conn
spring.datasource.username=your_mysql_username  // I have root
spring.datasource.password=your_mysql_password
```

### 4. Run the application :rocket: 

**Option A — IntelliJ IDEA:**
Open the project and click the green Run button. IntelliJ will automatically download all dependencies on first launch.

**Option B — Terminal:**
```bash
mvn spring-boot:run
```

On first run, Maven will download all required dependencies from `pom.xml` automatically.

The API will start at `http://localhost:8080`. I've had issues, so in application.properties added `server.port=9090` to resolve it. You can remove it and run 8080.


## :file_cabinet: Project Structure

```
src/
├── main/
│   ├── java/com/uniconn/backend/
│   │   ├── composite-keys/         # For join tables (UserFollow, CommunityMember, ...)
│   │   ├── config/                 # Security configurations
│   │   ├── dtos/                   # (LoginResponseDTO, CommunityDTO, ...)
│   │   ├── entities/               # JPA entities (User, Community, ...)
│   │   ├── repositories/           # Spring Data repositories
│   │   ├── services/               # Business logic
│   │   └── controllers/            # REST controllers
│   └── resources/
│       ├── static/                 # HTML, CSS, JavaScript
│       ├── application.properties  # (DB connection, methods' properties, ...)
│       └── db/                     # SQL seed scripts (run manually in Workbench)
```
 
## :arrows_clockwise: Loading Test Data
 
Sample seed data is provided in `src/main/resources/db/`. Run the scripts :bangbang:**in order**:bangbang:  after the app has started at least once (so Hibernate can generate the tables).
 
### 1. Open MySQL Workbench and connect to your local instance
 
### 2. Select the database
 
```sql
USE uni_conn;
```
 
### 3. Run the scripts in order
 
**Step 1 — Users:**
Open `src/main/resources/db/users_test_data.sql` in Workbench and execute.
 
**Step 2 — Communities:**
Open `src/main/resources/db/community_test_data.sql` in Workbench and execute.
 
> ⚠️ Communities must be inserted **after** users since they reference `user_id` as a foreign key.
 
### 4. Verify
 
```sql
SELECT COUNT(*) FROM users;
SELECT COUNT(*) FROM community;
```
 
You should see 20 users and 10 communities.

 ## ⚠️ Important

- _**Don't edit**_ any entities/composite keys
- If any changes needed, tell the person whose code it is, and leave comments in code if needed, but _**don't change**_ someone's code
- Commit changes to your own separate branch (e.g. `feature/name-of-the-feature`)
- Use [conventional commit messages](https://gist.github.com/qoomon/5dfcdf8eec66a051ecd85625518cfd13) and [PR templates](https://axolo.co/blog/p/part-3-github-pull-request-template) to keep backlog clean and clear
- <ins>I'll be reviewing pull requests</ins> and merging to `main` branch (except front end, html/css -> `src/resources/static`)
- `README` is only for essential development notes (e.g. changes needed for system files, additional setup required, test data for db etc.)

## 🗒️ Notes

- All entities are available 
- Add classes to corresponding packages (e.g. `package com.uniconn.backend.services;`)
- sql uses `snake_case`, in Java `camelCase` (constants `SCREAMING_SNAKE_CASE`), on github `kebab-case` 
- All student emails must end with `@my.csun.edu`
- Passwords are stored as BCrypt hashes (password for all test users: `Password123!`)
- `spring.jpa.hibernate.ddl-auto` is set to `update` — Hibernate will run entities and create tables in database
- After first run:
   - Verify all tables were created in databse properly and test data was populated
   - Switch `spring.jpa.hibernate.ddl-auto` to `validate` — Hibernate will be checking entity/schema alignment on startup but will not modify the database
