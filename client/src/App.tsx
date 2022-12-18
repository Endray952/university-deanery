import userEvent from '@testing-library/user-event';
import { observer } from 'mobx-react-lite';
import React, { useEffect, useState } from 'react';
import { BrowserRouter } from 'react-router-dom';
import { AppRouter } from './components/AppRouter';
import Footer from './components/Footer';
import { NavBar } from './components/NavBar';
import Spinner from './components/Spinner';
import { check } from './http/userAPI';
import UserStore from './store/UserStore';

export const App = observer(() => {
    const [loading, setLoading] = useState(true);
    useEffect(() => {
        check()
            .then((data) => {
                UserStore.setUser(data);
                UserStore.setIsAuth(true);
            })
            .finally(() => setLoading(false));
        console.log(JSON.stringify(UserStore.user));
    }, []);

    if (loading) {
        return <Spinner />;
    }

    return (
        <BrowserRouter>
            <NavBar />

            <AppRouter />
            {/* <Footer /> */}
        </BrowserRouter>
    );
});
