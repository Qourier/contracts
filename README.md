# Qourier Smart Contracts

## Deploy

```
RPC_URL="https://api.hyperspace.node.glif.io/rpc/v1"
PRIVATE_KEY="key"
```

```bash
source .env
forge script script/Factory.s.sol:FactoryScript --rpc-url $RPC_URL --broadcast --verify -vvvv
```

## Test

```bash
forge test
```
