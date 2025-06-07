import fastify, { FastifyInstance } from 'fastify';
import cors from '@fastify/cors';

// Create Fastify instance
const server: FastifyInstance = fastify({
  logger: true,
});

// Register plugins
server.register(cors, {
  origin: true, // Allow all origins
});

// Define a route
server.get('/', async (request, reply) => {
  return { message: 'Hello from Fastify with TypeScript!' };
});

// Health check endpoint
server.get('/health', async (request, reply) => {
  return { status: 'ok' };
});

// Define the type for the request body
interface GreetRequest {
  name: string;
}

// Update the /greet endpoint to use POST and accept a JSON payload
server.post<{ Body: GreetRequest }>('/greet', async (request, reply) => {
  const { name } = request.body;
  
  // Return a personalized greeting
  return { 
    message: `Hello, ${name}! Welcome to our API.` 
  };
});

// Run the server
const start = async (): Promise<void> => {
  try {
    await server.listen({ port: 8080, host: '0.0.0.0' });
    const address = server.server.address();
    const port = typeof address === 'object' ? address?.port : address;
    console.log(`Server listening on port ${port}`);
  } catch (err) {
    server.log.error(err);
    process.exit(1);
  }
};

start();