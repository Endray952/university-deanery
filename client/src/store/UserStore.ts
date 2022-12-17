import { makeAutoObservable } from 'mobx';
import { userType } from '../utils/consts';

class UserStore {
    private _isAuth: boolean;
    private _user: userType | null;
    constructor() {
        this._isAuth = false;
        this._user = null;
        makeAutoObservable(this);
    }

    setIsAuth(bool: boolean) {
        this._isAuth = bool;
    }
    setUser(user: userType | null) {
        this._user = user;
    }

    get isAuth() {
        return this._isAuth;
    }
    get user() {
        return this._user;
    }
}
export default new UserStore();
