import React from 'react';
import './bag.css';
import { BsTrash } from "react-icons/bs";
import { useDispatch } from "react-redux";
import { bagActions } from "../stores/bagslice";
import { BiMinusCircle } from "react-icons/bi";
import { HiOutlinePlusCircle } from "react-icons/hi";
import { useSelector } from 'react-redux';
function Bag({ item }) {
    const dispatch = useDispatch();
    const handleRemoveEntireFromBag = () => {
      console.log("remove to bag " + item.id);
      dispatch(bagActions.removeEntireItemFromBag(item));
    };
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
        <div className="bag_summary">
            <div className="img_d">
                <img src={item.image} alt={item.item_name} />
              
            </div>
               <div className="detail_i">
                <div className='title_trash'>
                  <h3 className="name">{item.item_name}</h3> 
                  <div className="trash"><BsTrash onClick={handleRemoveEntireFromBag}/></div> 
                  </div>
                <p className="description">{item.item_description}</p>
                <p className="price_bag">Rs: {item.current_price * item.quantity}</p>
                <p className="delivery">Delivery within <span>40 minutes</span></p>
                <div className="quantity_icons2">
                      <BiMinusCircle className="minus_icons2" onClick={handleRemoveFromBag} />
                      <span className="order_count2">{quantity}</span>
                      <HiOutlinePlusCircle className="plus_icons2" onClick={handleAddToBag} />
                    </div>
            </div>
             
        </div>
    );
}

export default Bag;
