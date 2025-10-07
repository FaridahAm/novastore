import React from 'react';
import './Hero.css';

const Hero = () => {
  return (
    <section className="hero">
      <div className="hero-content">
        <div className="hero-text">
          <h1 className="hero-title">
            Discover Premium Products at 
            <span className="gradient-text"> NovaStore</span>
          </h1>
          <p className="hero-description">
            Experience the finest selection of electronics, fashion, and home essentials. 
            Quality guaranteed, satisfaction delivered.
          </p>
          <div className="hero-stats">
            <div className="stat">
              <span className="stat-number">10K+</span>
              <span className="stat-label">Happy Customers</span>
            </div>
            <div className="stat">
              <span className="stat-number">500+</span>
              <span className="stat-label">Premium Products</span>
            </div>
            <div className="stat">
              <span className="stat-number">4.8⭐</span>
              <span className="stat-label">Average Rating</span>
            </div>
          </div>
        </div>
        <div className="hero-image">
          <div className="floating-card">
            <img 
              src="https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=400&h=300&fit=crop&crop=center" 
              alt="Premium Shopping" 
            />
          </div>
        </div>
      </div>
    </section>
  );
};

export default Hero;