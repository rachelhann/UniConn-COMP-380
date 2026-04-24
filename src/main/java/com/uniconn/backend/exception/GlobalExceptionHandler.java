package com.uniconn.backend.exception;

import java.util.LinkedHashMap;
import java.util.Map;

import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class GlobalExceptionHandler {
	
	// Spring throws this — multiple field errors, returns a map
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<Map<String, String>> handleValidation(
            MethodArgumentNotValidException ex) {
        Map<String, String> errors = new LinkedHashMap<>();
        ex.getBindingResult().getFieldErrors()
          .forEach(e -> errors.put(e.getField(), e.getDefaultMessage()));
        return ResponseEntity.badRequest().body(errors);
        // returns: { "communityName": "must not be blank", "email": "must be a valid email" }
    }
        
    // You throw this — single specific error, returns one message
    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<Map<String, String>> handleNotFound(
            ResourceNotFoundException ex) {
        return ResponseEntity.status(404)
            .body(Map.of("error", ex.getMessage()));
        // returns: { "error": "User with id 5 not found" }
    }
    
    // You throw this — single specific error, returns one message
    @ExceptionHandler(ResourceAlreadyExistsException.class)
    public ResponseEntity<Map<String, String>> handleAlreadyExists(
            ResourceAlreadyExistsException ex) {
        return ResponseEntity.status(409)
            .body(Map.of("error", ex.getMessage()));
        // returns: { "error": "User with this name already exists" }
    }

    @ExceptionHandler(UnauthorizedException.class)
    public ResponseEntity<Map<String, String>> handleUnauthorized(
            UnauthorizedException ex) {
        return ResponseEntity.status(403)
            .body(Map.of("error", ex.getMessage()));
    }

    @ExceptionHandler(DataIntegrityViolationException.class)
    public ResponseEntity<Map<String, String>> handleDbConstraint(
            DataIntegrityViolationException ex) {
        return ResponseEntity.badRequest()
            .body(Map.of("error", "A database constraint was violated"));
    }
    
    // You throw this — single specific error, returns one message
    @ExceptionHandler(InvalidInputException.class)
    public ResponseEntity<Map<String, String>> handleInvalidInput(
            InvalidInputException ex) {
        return ResponseEntity.badRequest().body(Map.of("error", ex.getMessage()));
        // returns: { "error": "Invalid tag name: @@@" }
    }

    @ExceptionHandler(Exception.class) // catch-all — always put this last
    public ResponseEntity<Map<String, String>> handleGeneral(Exception ex) {
        return ResponseEntity.internalServerError()
            .body(Map.of("error", "Something went wrong"));
    }
}
