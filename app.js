const express = require('express');
const app = express();
const port = 8080;

// Secret is securely injected as an environment variable
const mySecret = process.env.MY_SECRET || 'Default Value (Secret Not Found!)';

app.get('/', (req, res) => {
  res.send(`Hello from the container! The secret value is: ${mySecret}`);
});

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).send('OK');
});

app.listen(port, () => {
  console.log(`App listening on port ${port}`);
});