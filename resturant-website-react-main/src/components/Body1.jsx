import React from 'react';
import { GoSearch } from "react-icons/go";
import Layout from './Layout';
import { Link } from 'react-router-dom';
function Body1() {
  return (
    <Layout>
    <div>
      <div className="pic_div">
        <h1 className="line1">Indulge in limitless flavors & savor </h1>
        <h1 className="line2"> every bite with love</h1>

        <p className="line3">Discover limitless flavors, relish each </p>
        <p className="line4"> bite & enjoy pure bliss </p>
        <div className="input-wrapper">
      <input type="text" placeholder="Search..." />
      <GoSearch className="search_icon" />
    </div>
      
        <img
          className="main_pic"
          src="pictures/brick-wall-1834784_1920.jpg"
          alt="main_pic"
        />
      </div>
  
  <div className="cards">

    <div className="card1 card">
       <div className="card1_img card_img">
        <img src="pictures\pancakes-2291908_1920.jpg" alt="food" />
        </div>
        <Link to="/desserts" style={{ textDecoration: "none", color: "black" }}>
        <button className='btn_1 btn1'>Enjoy dessert</button>
        </Link>

    </div>
  
    <div className="card2 card">

    <div className="card2_img card_img">
        <img src="pictures\fish-8031138_1920.jpg" alt="food" />

        </div>
        <Link to="/pasta" style={{ textDecoration: "none", color: "black" }}>
        <button className='btn_1 btn2'>Eat pasta</button>
        </Link>
      </div>

      <div className="card3 card">
          <div className="card3_img card_img">
        <img src="pictures\dessert-6006446_1920.jpg" alt="food" />
        </div>
        <Link to="/drinks" style={{ textDecoration: "none", color: "black" }}>
        <button className='btn_1 btn3'>Drink healthy</button>
        </Link>
      </div>
  </div>

  <div className="video_div">
   
   <video src="pictures\2339-157269920_medium.mp4" autoPlay loop muted></video>
  </div>
     

    </div>
    </Layout>
  );
}

export default Body1;