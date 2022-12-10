import express, { Request, Response } from 'express';
import { router } from './routes/index.js';
import cors from 'cors';
import { errorHandler } from './middleware/ErrorHandlingMiddleware.js';

const PORT = process.env.PORT || 8081;
const app = express();

app.use(express.json());
app.use('/api', router);
app.use(errorHandler);

app.get('/', (req: Request, res: Response) => {
    res.send('Hello');
});

const startServer = async () => {
    try {
        app.listen(PORT, () =>
            console.log(`Server is working on port ${PORT}`)
        );
    } catch (e) {
        console.log('Error of creating server:', e);
    }
};

startServer();
