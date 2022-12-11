import axios from 'axios';

const $host = axios.create({
    baseURL: process.env.REACT_APP_API_URL,
});

const $authHost = axios.create({
    baseURL: process.env.REACT_APP_API_URL,
});

const authInterceptor = (config: any) => {
    config.headers.authorization = `Bearer ${localStorage.getItem('token')}`;
    return config;
};

const defaultInterceptor = (config: any) => {
    return config;
};

$authHost.interceptors.request.use(authInterceptor);
//$host.interceptors.request.use(defaultInterceptor);

export { $host, $authHost };
