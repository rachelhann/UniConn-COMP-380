# GlobalExceptionHandler (optional)

### — mechanism to centralize the handling of exceptions that may occur during a request and return an appropriate response.

> When an exception occurs, the Spring Boot application will redirect it to the `GlobalExceptionHandler`. Depending on the specific type of exception, the `GlobalExceptionHandler` can generate an appropriate error message and return it to the client. This helps provide more meaningful error messages to the clients. It can also be used to log detailed information about exceptions.

> [!IMPORTANT]
> Either implement them all, or don't use any at all. They only work together.

# How to implement

| Exceptions available | Status | Meaning |
| --- | --- | --- |
| `ResourceNotFoundException` | 404 | Not found |
| `ResourceAlreadyExistsException` | 409 | Already exists |
| `UnauthorizedException` | 403 | Unauthorized action |

### Service level

Throw them from any service, with a custom message:

```java
// UserService.java
public User getUserById(Long id) {
    return userRepository.findById(id)
        .orElseThrow(() -> new ResourceNotFoundException(
            "User with id " + id + " not found"
        ));
}
```

```java
// CommunityService.java
public Community createCommunity(CreateCommunityDTO dto) {
    if (communityRepository.existsByName(dto.getName())) {
        throw new ResourceAlreadyExistsException(
            "Community '" + dto.getName() + "' already exists"
        );
    }
}
```

```java
// PostService.java
public void deletePost(Long postId, Long requestingUserId) {
    Post post = postRepository.findById(postId)
        .orElseThrow(() -> new ResourceNotFoundException("Post not found"));

    if (!post.getAuthor().getId().equals(requestingUserId)) {
        throw new UnauthorizedException("You cannot delete someone else's post");
    }
    postRepository.delete(post);
}
```
The message that ends up in the JSON response is exactly the string you passed when throwing — that's the connection. The service writes the message, the handler delivers it.

### DTO level:

```java
public class CommunityDTO {
	
	@NotBlank(message = "Community name is required")
	@Size(min = 3, max = 50, message = "Name must be between 3 and 50 characters")
	@Pattern(
		    regexp = "^(?=[a-z0-9._]{3,50}$)(?=.*[a-z0-9]).*$",
		    message = "Only lowercase letters, digits, dots, and underscores are allowed — must contain at least one letter or digit"
		)
	private String communityName;
	
	@NotBlank(message = "Description is required")
	@Size(max = 500, message = "Description cannot exceed 500 characters")
    private String description;
	
	@NotNull(message = "Category is required")
    private CommunityCategory category;
	
    private String communityPicture;
    
    @Size(max = 5, message = "Maximum 5 tags allowed")
    @Valid
    private List<@NotBlank(message = "Tag cannot be blank")
    			@Size(max = 30, message = "Tag cannot exceed 30 characters") String> tags;
// getters&setters
}
```
If someone sends a blank `communityName` and a description that's too long, the handler returns all failures at once — not just the first one:

```json
{
  "communityName": "Community name is required",
  "description": "Description cannot exceed 500 characters"
}
```

| Common Annotations | What it checks | Common use |
| --- | --- | --- |
| `@NotBlank` | Not null, not empty, not just whitespace | Every required string |
| `@NotNull` | Not null (empty string passes) | Non-string required fields |
| `@Size(min, max)` | String length or collection size | Names, descriptions |
| `@Email` | Valid email format | Email fields |
| `@Pattern(regexp)` | Matches a regex | Username format, no spaces |
| `@Min(value)` | Number ≥ value | Age, quantities |
| `@Max(value)` | Number ≤ value | Limits, page sizes |
| `@Positive` | Number > 0 | IDs, counts |
| `@Future` | Date is in the future | Event dates |
| `@Past` | Date is in the past | Birthdates |

> research for more if needed

### Controller level

Stays clean. No try/catch. No error handling. If anything goes wrong at any point in the call chain, Spring catches it and routes it to your handler automatically:

```java
@PostMapping("/communities")
public ResponseEntity<CommunityResponseDTO> createCommunity(
        @Valid @RequestBody CreateCommunityDTO dto) {
    return ResponseEntity.status(201).body(communityService.createCommunity(dto));
}
```

`@Valid` is what activates the annotations on that DTO. Without it, the annotations are decoration.

### Imports (references)

```java
// CommunityService.java
import com.uniconn.backend.dtos.*;
import com.uniconn.backend.entities.*;
import com.uniconn.backend.exception.*;
import com.uniconn.backend.repositories.*;
import jakarta.transaction.Transactional;
import com.uniconn.backend.composite_keys.CommunityMemberId;

import java.util.List;
import java.util.stream.Collectors;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
```

```java
// CommunityDTO.java
import java.util.List;
import com.uniconn.backend.entities.*;
import jakarta.validation.Valid;
import jakarta.validation.constraints.*;
```

```java
// CommunityController.java
import com.uniconn.backend.dtos.CommunityDTO;
import com.uniconn.backend.dtos.CommunityResponseDTO;
import com.uniconn.backend.services.CommunityService;

import jakarta.validation.Valid;

import java.util.List;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
```

## Workflow 

<img width="3201" height="1252" alt="image" src="https://github.com/user-attachments/assets/017a3726-c2b7-4abc-b3f7-459da21b3a37" />




