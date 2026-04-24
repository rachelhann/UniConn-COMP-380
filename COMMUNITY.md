# Community Component

| :sparkles:  Explore page | :heavy_plus_sign:  Create community | :mag: Search&Filter |
| --- | --- | --- |
| Separate page | Popup window (right sidebar stays on a side during that) | serach bar on explore communities page |
| All communities | Required fields | serach by community name and tags |
| Search by community name and tags | Tags (need to discuss) | Filter by categories ("All" and 5 categories we have) |
| Filter by category |
| My communities -> created by and member of list + search |
| Create community -> popup window |

## Frontend

### Communities button -> explore page -> create community workflow:

<img width="4477" height="1396" alt="image" src="https://github.com/user-attachments/assets/b97e0867-63e1-4230-85cf-1a7883364edd" />

### Tags (community&post)

<img width="7588" height="823" alt="image" src="https://github.com/user-attachments/assets/f96a7e03-bba3-44e4-a4da-7db219ba3de1" />

### Input values for `Create Community`

| Variable | Required? | Max chars | Notes |
| --- | --- | --- | --- |
| `communityName` | yes | 30 | NO special chars/spaces(nums, ".", "_" are allowed), lowercase only(regardless `toLowerCase()` in backend, but in frontend could also auotomatically make to lowercase, not throw error) |
| `description` | yes | 300 | on explore page (and maybe in search? :thinking: ) description shortened to 112 chars + "..." |
| `category` | yes | chose from 5 options(drop down box) |
| `tags` | no(optional) | 20 | *__MAX 5 TAGS__* per community/post, no special chars(nums allowed), separated by space(make sure not creating empty tags when just pressing space in that field), lowercase only(regardless `toLowerCase()` in backend, but in frontend could also auotomatically make to lowercase, not throw error) |
| `communityPicture` | no(optional) | dims(idk yet) | haven't created this feature yet(and idk if I even will), but would be available in community profile update, NOT during create |

> Still need to fix those values' checks for backend, but that's, I think, is final version

## Icons

### Sparkle for explore section: <img width="36" height="36" alt="image" src="https://github.com/user-attachments/assets/a897a877-348e-4a2f-bdd0-0ba4eba7812c" />


```svg
<svg width="36" height="36" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <!-- Main sparkle -->
  <path d="M12 2 
           C12.5 6 14 7.5 18 8 
           C14 8.5 12.5 10 12 14 
           C11.5 10 10 8.5 6 8 
           C10 7.5 11.5 6 12 2Z"
        fill="white"
        stroke="black"
        stroke-width="1.5"
        stroke-linejoin="round"/>

  <!-- Small sparkle -->
  <path d="M6 14 
           C6.3 16 7 16.7 9 17 
           C7 17.3 6.3 18 6 20 
           C5.7 18 5 17.3 3 17 
           C5 16.7 5.7 16 6 14Z"
        fill="white"
        stroke="black"
        stroke-width="1"
        stroke-linejoin="round"/>

  <!-- Tiny sparkle -->
  <path d="M17 13 
           C17.2 14.2 17.8 14.8 19 15 
           C17.8 15.2 17.2 15.8 17 17 
           C16.8 15.8 16.2 15.2 15 15 
           C16.2 14.8 16.8 14.2 17 13Z"
        fill="white"
        stroke="black"
        stroke-width="0.9"
        stroke-linejoin="round"/>
</svg>
````
