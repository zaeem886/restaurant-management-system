import React from "react";



const Footer = () => {
  return (
    <footer className="footer">
      <div className="footer-container">
        <div className="footer-section">
          <h2 className="footer-title">Grubify</h2>
          <p className="footer-subtitle">Customer Support</p>
          <p>Monday to Saturday 9:00 AM to 2:00 AM</p>
          <p>Sunday 12:00 PM to 12:00 AM</p>
          <p className="footer-subtitle">Contact Information</p>
          <p>Landline: 042-32301484</p>
          <p>Email: info@Grubify.com.pk</p>
        </div>
  
        <div className="footer-section">
          <h3 className="footer-subtitle">Information</h3>
          <ul>
            <li><a href="#">Blogs</a></li>
            <li><a href="#">Terms & Conditions</a></li>
            <li><a href="#">Store Locator</a></li>
          </ul>
        </div>

        <div className="footer-section">
          <h3 className="footer-subtitle">Customer Care</h3>
          <ul>
            <li><a href="#">Contact Us</a></li>
            <li><a href="#">FAQs</a></li>
            <li><a href="#">Feedback/Complaint</a></li>
            <li><a href="#">Track your order</a></li>
            <li><a href="#">Privacy Policy</a></li>
          </ul>
        </div>

        <div className="footer-section">
          <h3 className="footer-subtitle">Sign up and save</h3>
          <input type="email" placeholder="Email" className="email-input" />
          <div className="social-icons">
            <a href="#"><img src="FaFacebook" alt="Facebook" /></a>
            <a href="#"><img src="instagram-icon.png" alt="Instagram" /></a>
            <a href="#"><img src="email-icon.png" alt="Email" /></a>
            <a href="#"><img src="pinterest-icon.png" alt="Pinterest" /></a>
            <a href="#"><img src="youtube-icon.png" alt="YouTube" /></a>
            <a href="#"><img src="snapchat-icon.png" alt="Snapchat" /></a>
          </div>
        </div>
      </div>
      <div className="footer-bottom">
        <p>© 2025, Grubify Furniture - Powered by mrehenkarim</p>
      </div>
    </footer>
   
  );
};

export default Footer;
