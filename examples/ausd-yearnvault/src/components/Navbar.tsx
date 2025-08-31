import React from 'react';
import { ConnectKitButton } from 'connectkit';

export const Navbar: React.FC = () => {
  return (
    <nav className="navbar">
      <div className="navbar-content">
        <div className="navbar-brand">
          <h1>YvAUSD Vault</h1>
          <span className="network-badge">Katana Network</span>
          <span className="badge">Yearn Finance AUSD Vaults on Katana Mainnet</span>
        </div>
        <div className="navbar-actions">
          <ConnectKitButton />
        </div>
      </div>
    </nav>
  );
};