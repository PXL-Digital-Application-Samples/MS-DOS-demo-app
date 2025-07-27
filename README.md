# DOS REST API Server

A complete REST API server implementation using pure DOS batch files. This project demonstrates HTTP request processing, JSON response generation, and file-based database operations - all accomplished without any external dependencies beyond standard DOS commands.

## Features

- **Complete HTTP Implementation**: Request parsing, response generation, proper headers
- **JSON Processing**: Parse request bodies, generate JSON responses
- **RESTful API**: GET, POST, PUT, DELETE operations with proper HTTP status codes
- **File-based Database**: JSON file storage with atomic operations
- **Request Routing**: Pattern matching for different endpoints
- **CRUD Operations**: Full user management functionality

## Architecture

The server consists of modular batch files:

- `SERVER.BAT` - HTTP server with networking layer
- `PROCESS.BAT` - Request parser and router
- `HANDLERS/*.BAT` - Individual endpoint implementations
- `DATA/*.TXT` - JSON user database files

## Quick Start

1. Run `SETUP.BAT` to initialize the project
2. Run `SERVER.BAT` to start the HTTP server (requires netcat)

## Project Structure

```text
/
├── SERVER.BAT             # Main HTTP server
├── PROCESS.BAT            # Request parser/router
├── SETUP.BAT              # Project initialization
├── INIT_DB.BAT            # Database setup
├── GETNXTID.BAT           # ID generator
├── EXTRBODY.BAT           # HTTP body parser
├── DATA/                  # User database (JSON files)
├── HANDLERS/              # API endpoint handlers
│   ├── GETUSERS.BAT       # GET /users
│   ├── GETUSER.BAT        # GET /users/{id}
│   ├── CREATUSR.BAT       # POST /users
│   ├── UPDTUSER.BAT       # PUT /users/{id}
│   ├── DELUSER.BAT        # DELETE /users/{id}
│   ├── NOTFOUND.BAT       # 404 handler
│   └── MTHDNTAL.BAT       # 405 handler
└── TEMP/                  # Working directory
```

## Usage

1. Start the server:

   ```batch
   SERVER.BAT
   ```

2. The server will listen on port 5000

3. Test with curl:

   ```bash
   curl http://localhost:5000/users
   curl -X POST -H "Content-Type: application/json" -d "{\"name\":\"Dave\",\"email\":\"dave@example.com\"}" http://localhost:5000/users
   ```

## API Endpoints

- `GET /users` - List all users
- `GET /users/{id}` - Get specific user
- `POST /users` - Create new user (Body: `{"name": "string", "email": "string"}`)
- `PUT /users/{id}` - Update user (Body: `{"name": "string", "email": "string"}`)
- `DELETE /users/{id}` - Delete user

## Data Format

Users are stored as JSON in individual files: `DATA/USER_{id}.TXT`

Example:

```json
{"id": 1, "name": "Alice", "email": "alice@example.com"}
```

## Requirements

- Windows command prompt (cmd.exe)
- netcat (nc.exe) for networking functionality

## Limitations

- Basic JSON parsing (no nested objects)
- No concurrent request handling
- Simple HTTP implementation
- Educational purposes only
