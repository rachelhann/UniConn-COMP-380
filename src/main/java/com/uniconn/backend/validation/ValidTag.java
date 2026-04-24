package com.uniconn.backend.validation;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

import jakarta.validation.Constraint;
import jakarta.validation.Payload;

@Documented
@Constraint(validatedBy = ValidTagValidator.class)
@Target({ ElementType.TYPE_USE })
@Retention(RetentionPolicy.RUNTIME)
public @interface ValidTag {
    String message() default "Tag must be lowercase, alphanumeric, no spaces or special characters";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}