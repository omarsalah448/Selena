# User Registration Process

## Fields Required for Registration

1. Company Name
2. Timezone of the company
3. Start day of the work week
4. Full name of the company owner (first name and last name)
5. Email
6. Title
7. Phone number (without country code)
8. Password
9. Confirm password

## Validations

### User Model Validations

- First name and last name must be between 2-20 characters
- Title should be between 2-20 characters
- Phone number must be between 4-20 characters
- Password and confirm password should match
- All fields are required

### Company Model Validations

- Company name is required
- Timezone is required
- Work week start day is required

## Registration Process

1. User fills out the registration form with all required fields
2. Backend validates the input data
3. If validation passes:
   - Create a new Company record
   - Create a new User record with admin role
   - Associate the User as the owner of the Company
4. If validation fails, return error messages to the user

## Post-Registration

- After successful registration, the user should be logged in automatically
- Redirect the user to their dashboard or a welcome page

## Security Considerations

- Ensure passwords are properly hashed before storing in the database
- Implement proper authentication and authorization mechanisms
- Use HTTPS for all communications to protect sensitive data