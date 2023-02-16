###########
### ENV ###
###########

# Include `.env` file and export its variables
# (`-include` to ignore any errors if it does not exist)
-include .env

###########
### ALL ###
###########

all: clean install build

#############
### FORGE ###
#############

install:; git submodule update --init --recursive

build:; forge clean && forge build

test:; forge clean && forge test

clean:; forge clean

############
### POCS ###
############

poc-fallback:; forge clean && forge test --match-contract Fallback -vv
poc-fallout:; forge clean && forge test --match-contract Fallout -vv
poc-coinflip:; forge clean && forge test --match-contract CoinFlip -vv
