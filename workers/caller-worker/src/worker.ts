import { registerWorker, Logger } from 'iii-sdk';
const worker = registerWorker(process.env.III_URL ?? 'ws://localhost:49134');
const logger = new Logger();

worker.registerFunction(
  'math::add_two_numbers',
  async (payload: { a: number; b: number }) => {
    logger.info('math::add_two_numbers called in TypeScript', payload);
    const result = await worker.trigger({
      function_id: 'math::add',
      payload,
    });
    return {
      ...result,
      success: "Workers interoperating seamlessly.",
    };
  },
);

worker.registerFunction(
  'http::add_two_numbers',
  async (payload: { body: { a: number; b: number } }) => {
    const result = await worker.trigger({
      function_id: 'math::add_two_numbers',
      payload: payload.body,
    });
    return {
      status_code: 200,
      body: { c: result.c },
      headers: { 'Content-Type': 'application/json' },
    };
  },
);

worker.registerTrigger({
  type: 'http',
  function_id: 'http::add_two_numbers',
  config: { api_path: '/math/add-two-numbers', http_method: 'POST' },
});

console.log('Caller worker started - listening for calls');
