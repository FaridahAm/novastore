import React, { useState, useMemo } from 'react';
import { CartProvider } from './context/CartContext';
import Header from './components/Header';
import Hero from './components/Hero';
import ProductFilters from './components/ProductFilters';
import ProductList from './components/ProductList';
import Cart from './components/Cart';
import Footer from './components/Footer';
import { products } from './data/products';
import './App.css';

function App() {
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedCategory, setSelectedCategory] = useState('All');
  const [sortBy, setSortBy] = useState('default');
  const [isCartOpen, setIsCartOpen] = useState(false);
  const [loading] = useState(false);

  // Filter and sort products based on current criteria
  const filteredAndSortedProducts = useMemo(() => {
    let result = [...products];

    // Filter by search term
    if (searchTerm) {
      result = result.filter(product =>
        product.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
        product.description.toLowerCase().includes(searchTerm.toLowerCase()) ||
        product.features.some(feature => 
          feature.toLowerCase().includes(searchTerm.toLowerCase())
        )
      );
    }

    // Filter by category
    if (selectedCategory !== 'All') {
      result = result.filter(product => product.category === selectedCategory);
    }

    // Sort products
    switch (sortBy) {
      case 'price-low':
        result.sort((a, b) => a.price - b.price);
        break;
      case 'price-high':
        result.sort((a, b) => b.price - a.price);
        break;
      case 'rating':
        result.sort((a, b) => b.rating - a.rating);
        break;
      case 'name':
        result.sort((a, b) => a.name.localeCompare(b.name));
        break;
      default:
        // Keep original order
        break;
    }

    return result;
  }, [searchTerm, selectedCategory, sortBy]);

  const handleCartToggle = () => {
    setIsCartOpen(!isCartOpen);
  };

  const handleCartClose = () => {
    setIsCartOpen(false);
  };

  return (
    <CartProvider>
      <div className="App">
        <Header onCartToggle={handleCartToggle} />
        
        <Hero />
        
        <main className="main-content">
          <ProductFilters
            searchTerm={searchTerm}
            onSearchChange={setSearchTerm}
            selectedCategory={selectedCategory}
            onCategoryChange={setSelectedCategory}
            sortBy={sortBy}
            onSortChange={setSortBy}
          />
          
          <ProductList 
            products={filteredAndSortedProducts} 
            loading={loading}
          />
        </main>

        <Footer />
        
        <Cart 
          isOpen={isCartOpen} 
          onClose={handleCartClose} 
        />
      </div>
    </CartProvider>
  );
}

export default App;
