const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

app.get('/health', (req, res) => {
    res.status(200).json({ status: "UP", security: "VERIFIED" });
});

app.get('/', (req, res) => {
    res.status(200).json({
        service: "DevSecOps Telemetry API",
        version: "1.0.1",
        timestamp: new Date().toISOString()
    });
});

if (require.main === module) {
    app.listen(PORT, () => {
        console.log(`Telemetry service listening on port ${PORT}`);
    });
}

module.exports = app;
