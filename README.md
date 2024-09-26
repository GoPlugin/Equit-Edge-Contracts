# EquitEdge Smart Token Contract

## Scope of this Contract:
This contract is designed to mint a total of 500 million tokens (cap). Upon deployment, it will initially mint 200 million tokens, which will be distributed among five specified addresses. For any future minting, the request to mint additional tokens must be initiated by the contract deployer, and approval from a designated number of approvers is required before the minting can proceed.

Only the owner and designated approvers will be authorized to initiate and approve minting requests. Minting by other users will be strictly prohibited.

The owner will also have the ability to pause and unpause the contract when necessary.

The required number of approvals for minting should be set to 3 or 4. Minting will not be permitted unless this threshold of approvals is met.


## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/EquitEdge.s.sol:EquitEdgeScript --legacy  --rpc-url https://erpc.xinfin.network --private-key <> --broadcast

```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
