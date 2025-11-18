import express from 'express';
import { initDatabase } from './database/db.js';
import userRoutes from './routes/userRoutes.js';
import productRoutes from './routes/productRoutes.js';

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware para parsear JSON
app.use(express.json());

// Middleware para logging básico
app.use((req, res, next) => {
  console.log(`${req.method} ${req.url}`);
  next();
});

// Inicializar base de datos
initDatabase();

// Rutas
app.get('/', (req, res) => {
  res.json({ 
    message: 'API REST con Node.js y SQLite',
    endpoints: {
      users: '/api/users',
      products: '/api/products'
    }
  });
});

app.use('/api/users', userRoutes);
app.use('/api/products', productRoutes);

// Middleware para manejo de errores
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Algo salió mal!' });
});

// Iniciar servidor
app.listen(PORT, () => {
  console.log(`Servidor corriendo en http://localhost:${PORT}`);
});
