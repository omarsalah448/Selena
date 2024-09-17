# Selena-AI Recreation Project Overview

## Project Description
This project aims to recreate the backend functionality of Selena-AI (https://selena-ai.com/), a time tracking system for employees. The system will be built using Ruby on Rails with PostgreSQL as the database.

## Core Features
1. Employee time tracking (check-in and check-out)
2. Multiple check-ins/check-outs per day
3. Time reports generation (daily, monthly, yearly)
4. Role-based access control (User and Admin roles)
5. Admin functionalities (edit user time logs, view reports, invite users)

## User Roles
1. User (Normal Employee)
   - Can check-in and check-out
   - Can view their own time logs and reports
   - Cannot access other employees' data

2. Admin (Employee with additional privileges)
   - All User functionalities
   - Can edit any user's check-in/check-out times
   - Can view time reports for all users
   - Can invite new users to the system

## Database Schema (Updated Tables)

1. Companies
   - id
   - name
   - timezone
   - work_week_start
   - owner_id (foreign key to Users)
   - created_at
   - updated_at

2. Users
   - id
   - company_id (foreign key to Companies)
   - email
   - password_digest
   - first_name
   - last_name
   - title
   - phone_number
   - role (enum: user, admin)
   - created_at
   - updated_at

3. TimeLogs
   - id
   - user_id (foreign key to Users)
   - check_in_time
   - check_out_time
   - created_at
   - updated_at

4. Holidays
   - id
   - company_id (foreign key to Companies)
   - name
   - date
   - created_at
   - updated_at

5. Vacations
   - id
   - user_id (foreign key to Users)
   - start_date
   - end_date
   - status (enum: pending, approved, rejected)
   - created_at
   - updated_at

## Key Functionalities to Implement

1. User Authentication and Authorization
2. Check-in and Check-out system
3. Time calculation and reporting
4. Admin panel for user management and report viewing
5. Invitation system for new users
6. Holiday and vacation management

## Technical Considerations

1. Use Ruby on Rails for the backend
2. Implement RESTful API endpoints
3. Use PostgreSQL for the database
4. Implement proper authentication and authorization (consider using Devise and CanCanCan)
5. Use ActiveRecord for database interactions
6. Implement background jobs for report generation (consider using Sidekiq)
7. Use RSpec for testing

## Next Steps

1. Implement user registration functionality
2. Create the database schema and models
3. Implement user authentication and authorization
4. Develop the core time tracking functionality
5. Create the admin panel and associated features
6. Implement the reporting system
7. Add holiday and vacation management
8. Write comprehensive tests
9. Set up CI/CD pipeline