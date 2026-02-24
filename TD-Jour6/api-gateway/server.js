import express from 'express';
import { createProxyMiddleware } from 'http-proxy-middleware';

const app = express();
const PORT = 8080;

// Health check
app.get('/health', (req, res) => {
    res.json({ status: 'ok' });
});

// Proxy routes to backend services
app.use('/api/orders', createProxyMiddleware({
    target: process.env.ORDERS_SERVICE_URL || 'http://orders-api:8083',
    changeOrigin: true,
    pathRewrite: { '^/api/orders': '/orders' },
}));

app.use('/api/auth', createProxyMiddleware({
    target: process.env.AUTH_SERVICE_URL || 'http://auth-service:8000',
    changeOrigin: true,
    pathRewrite: { '^/api/auth': '' },
}));

app.listen(PORT, () => {
    console.log(`API Gateway listening on port ${PORT}`);
});
