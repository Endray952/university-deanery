import express, { Request, Response } from 'express';
import { router } from './routes/index.js';
import * as dotenv from 'dotenv';
import cors from 'cors';

dotenv.config();

const PORT = process.env.PORT || 8081;
const app = express();

app.use(express.json());
app.use('/api', router);

app.get('/', (req: Request, res: Response) => {
    res.send('dhdjhgj');
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
