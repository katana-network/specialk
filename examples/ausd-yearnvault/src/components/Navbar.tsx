import React from 'react';
import { useAccount, useConnect, useDisconnect } from 'wagmi';

export const Navbar: React.FC = () => {
  const { address, isConnected } = useAccount();
  const { connect, connectors, status, error } = useConnect();
  const { disconnect } = useDisconnect();
  console.log('connectors', connectors);

  return (
    <nav className="navbar">
      <div className="navbar-content">
        <div className="navbar-brand">
          <h1>YvAUSD Vault</h1>
          <span className="network-badge">Katana Network</span>
          <span className="badge">Yearn Finance AUSD Vaults on Katana Mainnet</span>
        </div>
        <div className="navbar-actions" style={{ display: 'flex', alignItems: 'center', gap: '1rem' }}>
          {isConnected ? (
            <>
              <span className="wallet-address" style={{marginRight: '1rem', fontWeight: 500, color: '#444', background: '#f3f3f3', borderRadius: '6px', padding: '0.25rem 0.75rem'}}>
                {address?.slice(0, 6)}...{address?.slice(-4)}
              </span>
              <button
                onClick={() => {
                  disconnect();
                  localStorage.removeItem('wagmi.connected');
                  localStorage.removeItem('wagmi.wallet');
                  localStorage.removeItem('wagmi.store');
                  window.location.reload();
                }}
                className="action-button"
                style={{background: '#eee', color: '#333', border: '1px solid #ccc', borderRadius: '6px', padding: '0.4rem 1.2rem', fontWeight: 500}}
              >
                Disconnect
              </button>
            </>
          ) : (
            <>
              <button
                disabled={connectors.length === 0}
                onClick={() => connect({ connector: connectors[0] })}
                className="action-button primary"
                style={{background: '#f7f7f7', color: '#222', border: '1px solid #ccc', borderRadius: '6px', padding: '0.4rem 1.2rem', fontWeight: 500}}
              >
                Connect Wallet
              </button>
              {!isConnected && error && (
                <span style={{ color: 'red', marginLeft: 8, fontSize: 13 }}>
                  {error.message || 'Connection failed'}
                </span>
              )}
            </>
          )}
        </div>
      </div>
    </nav>
  );
};