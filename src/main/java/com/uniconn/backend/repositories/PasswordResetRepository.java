// Lillian Foster
// PasswordResetRepository.java - connects to the password_reset table in the database
// used by PasswordResetService to look up and save password reset records

package com.uniconn.backend.repositories;

import com.uniconn.backend.entities.PasswordReset;
import com.uniconn.backend.entities.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface PasswordResetRepository extends JpaRepository<PasswordReset, Integer> {

    // find a password reset record by the user
    Optional<PasswordReset> findByUserId(User user);
}