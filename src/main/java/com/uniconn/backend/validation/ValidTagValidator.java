package com.uniconn.backend.validation;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import java.util.regex.Pattern;

public class ValidTagValidator implements ConstraintValidator<ValidTag, String> {
    private static final Pattern VALID_TAG = Pattern.compile("^[a-z0-9]+$");

    @Override
    public boolean isValid(String tag, ConstraintValidatorContext context) {
        if (tag == null || tag.isBlank()) return true;
        return VALID_TAG.matcher(tag).matches();
    }
}