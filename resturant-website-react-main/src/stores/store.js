import { configureStore } from '@reduxjs/toolkit';
import bagReducer from './bagslice';

const store = configureStore({
  reducer: {
    bag: bagReducer,
  },
});

export default store;