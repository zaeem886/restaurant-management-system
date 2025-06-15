import React from "react";
import Layout from "../components/Layout";
import Bag from "../components/bag";
import Bill_detail from "../components/bill_detail";
import '../components/bag.css';
import { useSelector } from "react-redux";

const bag_r = () => {
  
    const items = useSelector((state) => state.bag.items);  

   

    return (
        <Layout>
            <div className="bag_div">
                <div className="bag_container">
                    {items.map((item) => (
                        <Bag key={item.id} item={item} />
                    ))}
                </div>
                <Bill_detail />
            </div>
        </Layout>
    );
};

export default bag_r;
