import React from "react";
import './chinease.css';
import { HiOutlinePlusCircle } from "react-icons/hi";
import { useDispatch, useSelector } from "react-redux";
import { bagActions } from "../stores/bagslice";
import { BiMinusCircle } from "react-icons/bi";

function Chinease({ item }) {
  const dispatch = useDispatch();
  const items = useSelector((state) => state.bag.items);
  const existingItem = items.find(i => i.id === item.id);
  const quantity = existingItem ? existingItem.quantity : 0;

  const handleAddToBag = () => {
    dispatch(bagActions.addItemToBag(item));
  };

  const handleRemoveFromBag = () => {
    dispatch(bagActions.removeItemFromBag(item));
  };

  return (
    <div>
      <div className="chinease_card">
        <div className="img_china">
          <img src={item.image} alt={item.item_name} />
        </div>
        <span className="price">Rs: {item.current_price}</span>
        <div className="title">
          <p>{item.item_name}</p>
        </div>
        <p className="food_dis">{item.item_description}</p>
        <div className="quantity_icons">
          <BiMinusCircle className="minus_icons" onClick={handleRemoveFromBag} />
          <span className="order_count">{quantity}</span>
          <HiOutlinePlusCircle className="plus_icons" onClick={handleAddToBag} />
        </div>
      </div>
    </div>
  );
}

export default Chinease;