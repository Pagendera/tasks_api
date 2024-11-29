# Test Task: Tasks Rest API

This project is simple REST API for managing tasks implemented using the Elixir Phoenix framework. Below are the details on how to set up, run, and test the application.

## Overview

This project allows users to managing tasks where users can create, update, and see all available tasks. The API ensures proper validation of requests and handles user management seamlessly.

## Features

- **Tasks Check**: Returns all the tasks that can be filtered using the account_id and status parameters.
- **Taking task**: The user takes a task and assigns it the in_work status and his id.
- **Completing task**: When the task is completed, the user can change the task status to completed.
- **Idempotency**: Ensures that requests can be processed multiple times without unintended side effects.
- **Token based authentication**: Authentication with tokens using the Guardian library, the user can register and log in to perform requests.

## Installation and testing

1. **Clone the Repository**
2. **Run** `docker compose up -d` This will start the necessary database containers in the background.
3. **Run `mix setup` to install and setup dependencies**
4. **Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`**
5. **Test API through Postman (use http://localhost:4000 endpoint)**

## API Endpoints

## Registration

- **Endpoint**: `/api/accounts/register`
- **Method**: `POST`
- **Request Body**:
  ```json
  {
    "email": "email@example.com",
    "password": "password",
    "password_confirm": "password"
  }

## Authentication

- **Endpoint**: `"/api/accounts/sign_in"`
- **Method**: `POST`
- **Request Body**:
  ```json
  {
    "email": "email@example.com",
    "password": "password"
  }

### All Tasks

- **Endpoint**: `/api/task_list`
- **Method**: `GET`

### All Tasks by account_id

- **Endpoint**: `/api/task_list/?account_id=1`
- **Method**: `GET`

### All Tasks by status

- **Endpoint**: `/api/task_list/?status=in_work`
- **Method**: `GET`

### Taking Task

- **Endpoint**: `/api/user/take_task`
- **Method**: `POST`
- **Request Body**:
  ```json
  {
    "id": 1
  }

### Completing task

- **Endpoint**: `/api/user/take_task`
- **Method**: `POST`
- **Request Body**:
  ```json
  {
    "id": 1,
    "status": "completed"
  }

 **Note**: Don't forget to go through authentication to access endpoints. After registration or authentication, you will receive a token to insert as a Bearer Token.

### Testing
To run the test, use: `mix test` command.

