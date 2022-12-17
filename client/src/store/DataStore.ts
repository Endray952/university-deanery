import { makeAutoObservable } from 'mobx';
import { userType } from '../utils/consts';

class DataStore {
    listItems: any = [];
    isLoading: boolean = true;
    config: any;
    constructor() {
        makeAutoObservable(this);
    }
}
export default new DataStore();
