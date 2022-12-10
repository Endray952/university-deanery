import jwt from 'jsonwebtoken';

export const checkRoleMiddleWare = (roles: Array<string>) => {
    return function (req, res, next) {
        if (req.method === 'OPTIONS') {
            next();
        }
        try {
            const token = req.headers.authorization.split(' ')[1]; // Bearer asfasnfkajsfnjk
            if (!token) {
                return res.status(401).json({ message: 'Не авторизован' });
            }
            const decoded: any = jwt.verify(token, process.env.SECRET_KEY);
            //console.log(decoded);
            if (!roles.includes(decoded.role)) {
                return res.status(403).json({ message: 'Нет доступа' });
            }
            req.user = decoded;
            next();
        } catch (e) {
            res.status(401).json({ message: 'Не авторизован' });
        }
    };
};
