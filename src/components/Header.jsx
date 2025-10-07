import React from 'react';
import { useCart } from '../context/CartContext';
import './Header.css';

const Header = ({ onCartToggle }) => {
  const { getTotalItems } = useCart();

  return (
    <header className="header">
      <div className="header-container">
        <div className="logo">
          <h1>NovaStore</h1>
          <span className="tagline">Premium Products</span>
        </div>
        
        <nav className="nav">
          <a href="#home" className="nav-link">Home</a>
          <a href="#products" className="nav-link">Products</a>
          <a href="#about" className="nav-link">About</a>
          <a href="#contact" className="nav-link">Contact</a>
        </nav>

        <div className="header-actions">
          <button 
            className="cart-btn"
            onClick={onCartToggle}
          >
            <span className="cart-icon">🛒</span>
            Cart ({getTotalItems()})
          </button>
        </div>
      </div>
    </header>
  );
};

export default Header;