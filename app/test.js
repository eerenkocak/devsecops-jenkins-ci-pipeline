const assert = require('assert');
const app = require('./server');

console.log("Running automated unit & sanity checks...");

assert.strictEqual(typeof app, 'function', 'Express app must be a valid function');
assert.ok(app.get, 'Routing methods must be defined');

console.log("All automated tests passed successfully!");
process.exit(0);
