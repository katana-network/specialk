import React from 'react';
import { Web3Provider } from './Web3Provider';
import { Navbar } from './components/Navbar';
import { VaultInterface } from './components/VaultInterface';
import './App.css';

function App() {
  return (
    <Web3Provider>
      <div className="app">
        <Navbar />
        <main className="main-content">
          <VaultInterface />
        </main>
      </div>
    </Web3Provider>
  );
}

export default App;