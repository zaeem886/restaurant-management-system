import { createSlice } from '@reduxjs/toolkit';

const initialState = {
  items: [],
};

const bagSlice = createSlice({
  name: 'bag',
  initialState,
  reducers: {
    addItemToBag: (state, action) => {
      const existingItem = state.items.find(item => item.id === action.payload.id);
      if (existingItem) {
        existingItem.quantity++;
      } else {
        state.items.push({ ...action.payload, quantity: 1 });
      }
    },
    removeItemFromBag: (state, action) => {
      const existingItem = state.items.find(item => item.id === action.payload.id);
      if (existingItem && existingItem.quantity > 1) {
        existingItem.quantity--;
      } else {
        state.items = state.items.filter(item => item.id !== action.payload.id);
      }
    },
    removeEntireItemFromBag: (state, action) => {
      
        state.items = state.items.filter(item => item.id !== action.payload.id);
      
    },
  },
});

export const bagActions = bagSlice.actions;
export default bagSlice.reducer;