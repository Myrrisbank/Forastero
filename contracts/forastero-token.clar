(impl-trait 'SP3FBR2AGK5H9QBDH3EEN6DF8EK8JY7RX8QJ5SVTE.sip-010-trait-ft-standard)

(define-constant token-name (some "Forastero Token"))
(define-constant token-symbol (some "FST"))
(define-constant token-decimals u8)
(define-constant token-supply u10000000) ;; 10,000,000 total supply
(define-constant contract-owner tx-sender) ;; Owner is the deployer

(define-map balances {owner: principal} {balance: uint})

(begin
  ;; Mint total supply to contract owner at deployment
  (map-insert balances {owner: contract-owner} {balance: token-supply})
)

(define-read-only (get-name) (ok token-name))
(define-read-only (get-symbol) (ok token-symbol))
(define-read-only (get-decimals) (ok token-decimals))
(define-read-only (get-total-supply) (ok token-supply))
(define-read-only (get-balance-of (owner principal)) 
  (ok (unwrap! (map-get? balances {owner: owner}) u0))
)

(define-public (transfer (amount uint) (sender principal) (recipient principal))
  (begin
    (asserts! (<= amount (unwrap! (map-get? balances {owner: sender}) u0)) (err u1)) ;; Check balance
    (map-set balances {owner: sender} {balance: (- (unwrap! (map-get? balances {owner: sender}) u0) amount)})
    (map-set balances {owner: recipient} {balance: (+ (unwrap! (map-get? balances {owner: recipient}) u0) amount)})
    (ok true)
  )
) 

;; Token metadata function (for wallets & explorers)
(define-read-only (get-token-metadata)
  (ok {
    name: token-name,
    symbol: token-symbol,
    decimals: token-decimals,
    description: "A fixed-supply fungible token backed by real-world cocoa farming.",
    image: "https://forastero.xyz/images/vite.svg",
    contractAddress: tx-sender
  })
)