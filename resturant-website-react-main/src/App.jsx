import './App.css';
import React from 'react';
import Body1 from './components/Body1';
import Bag_r from './router/bag_r';
import Chinese_r from './router/Chinese_r';
import { createBrowserRouter, RouterProvider } from "react-router-dom";

const router = createBrowserRouter([
  {
    path: "/",
    element: <Body1 />
  },
  {
    path: "/bag",
    element: <Bag_r />
  },
  {
    path: "/chineese",
    element: <Chinese_r dish="1" />
  },
  {
    path: "/drinks",
    element: <Chinese_r  dish="2"/>
  },
  {
    path: "/desserts",
    element: <Chinese_r  dish="4"/>
  },
  {
    path: "/local",
    element: <Chinese_r  dish="5"/>
  },
  {
    path: "/pasta",
    element: <Chinese_r dish="3" />
  },

]);

function App() {
  return <RouterProvider router={router}/>;
}

export default App;
