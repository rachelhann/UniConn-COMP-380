# UniConn-COMP-380

A Spring Boot REST API backend for UniConn, a social platform for CSUN students.

---

## Tech Stack

- Java 17
- Spring Boot
- Spring Security
- Spring Data JPA (Hibernate)
- MySQL
- Maven

---

## Prerequisites

Make sure you have the following installed before running the project:

- [Java 17+](https://www.oracle.com/java/technologies/downloads/)
- [Maven 3.8+](https://maven.apache.org/download.cgi)
- [MySQL 8+](https://dev.mysql.com/downloads/) - Community Server and Workbench(should have it if followed video tutorial provided)
- [IntelliJ IDEA](https://www.jetbrains.com/idea/) (recommended) or any IDE of your choice (I work in Eclipse)

---

## Getting Started

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

### 4. Run the application

**Option A — IntelliJ IDEA:**
Open the project and click the green Run button. IntelliJ will automatically download all dependencies on first launch.

**Option B — Terminal:**
```bash
mvn spring-boot:run
```

On first run, Maven will download all required dependencies from `pom.xml` automatically.

The API will start at `http://localhost:8080`. I've had issues, so in application.properties added `server.port=9090` to resolve it. You can remove it and run 8080.


---

## Project Structure

```
src/
├── main/
│   ├── java/com/uniconn/backend/
│   │   ├── composite-keys/
│   │   ├── config/
│   │   ├── dtos/
│   │   ├── entities/       # JPA entities (User, Community, ...)
│   │   ├── repositories/   # Spring Data repositories
│   │   ├── services/       # Business logic
│   │   └── controllers/    # REST controllers
│   └── resources/
│       ├── application.properties
│       └── db/             # SQL seed scripts (run manually in Workbench)
```

---

## Notes

- All student emails must end with `@my.csun.edu`
- Passwords are stored as BCrypt hashes
- `spring.jpa.hibernate.ddl-auto` is set to `validate` — Hibernate will check entity/schema alignment on startup but will not modify the database
- If tables don't get created in db(refresh it after running app) set `spring.jpa.hibernate.ddl-auto` to `update`. And switch back if all works well. 
