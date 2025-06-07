# Fastify TypeScript Server

A Node.js server built with Fastify, TypeScript, ESLint, and Prettier.

## Features

- Fastify server listening on port 8080
- TypeScript for type safety
- ESLint for code linting
- Prettier for code formatting
- CORS support

## Prerequisites

- Node.js (v16 or later recommended)
- npm or yarn

## Installation

```bash
# Install dependencies
npm install
```

## Development

```bash
# Start development server with hot-reload
npm run dev
```

## Building for production

```bash
# Build the project
npm run build

# Start the production server
npm start
```

## Code Quality

```bash
# Lint the code
npm run lint

# Format the code
npm run format
```

## API Endpoints

- `GET /`: Returns a welcome message
- `GET /health`: Health check endpoint

## Project Structure

```
.
├── src/
│   └── server.ts       # Main server file
├── .eslintrc.js        # ESLint configuration
├── .prettierrc         # Prettier configuration
├── package.json        # Project dependencies and scripts
├── tsconfig.json       # TypeScript configuration
└── README.md           # Project documentation
```