import React from 'react';
import './bag.css';
import { useSelector } from "react-redux";
function  bill_detail() 
{
  const items = useSelector((state) => state.bag.items); 

 let total_mri=0;

   for(let i =0;i<items.length;i++)
    {
        let count=items[i].quantity;
       if(count>0)
       total_mri+=(items[i].current_price * count);
    } 
    let plateform_fee=99;
    let discount=0;
    let total_bill= total_mri+plateform_fee;
    total_bill-=discount;

    return (

        <div>
  
            <div className="bill">
            <p className="total_item">Price details ({items.length} items)</p>
              <div className="mrp gap_p">
                <span className="mrp1">Total Mri</span>
                <span className="mrp2 gap_p2">{total_mri}</span>
              </div>
              <div className="discount gap_p">
                <span className="discount1">Total discount</span>
                <span className="discount2 gap_p2">{discount}</span>
              </div>
              <div className="tax gap_p">
                <span className="tax1">Plateform fee</span>
                <span className="tax2 gap_p2">{plateform_fee}</span>
              </div>
              <hr className="thin-light-hr"/>
              <div className="total_bill gap_p">
                <span className="total_bill1">Total Bill</span>
                <span className="total_bill2 gap_p2">Rs {total_bill}</span>
              </div>
              <button className='order'>Place order</button>
            </div>
            </div>
    
    )
}   
export default bill_detail;