# Authentication and Authorization

## Authentication

1. User registration:
   - Users register with their email, password, and other required information.
   - The `UserRegistrationService` handles the creation of both the user and the associated company (if applicable).
   - Passwords are securely hashed using `has_secure_password`.

2. User login:
   - Users can log in using their email and password.
   - The `AuthController` handles the login process.
   - Upon successful login, a JWT token is generated and returned to the client.

## Authorization

1. JWT-based authorization:
   - The `JwtAuthenticatable` concern is included in controllers that require authentication.
   - The `authorize_request` method checks for a valid JWT token in the request headers.
   - If the token is valid, it sets the `current_user`.

2. Role-based access control:
   - Users have roles (admin or user) stored in the database.
   - Controllers can check the user's role to determine access to specific actions.

## Security Considerations

- Use HTTPS for all API communications to protect sensitive data.
- Store JWT secret key securely (e.g., using Rails credentials).
- Implement token expiration and refresh mechanism for long-term security.
- Regularly audit and update the authentication and authorization system.

## API Endpoints

1. User Registration: POST /users
2. User Login: POST /login
3. User CRUD operations: GET, POST, PUT, DELETE /users
4. Company CRUD operations: GET, POST, PUT, DELETE /companies

Note: All endpoints except registration and login require a valid JWT token in the Authorization header.