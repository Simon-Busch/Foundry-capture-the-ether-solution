All:
	forge test -vv

GuessTheNumber:
	forge test --match-contract GuessTheNumberTest -vvvv

GuessTheSecretNumber:
	forge test --match-contract GuessTheSecretNumberTest -vvvv

GuessTheRandomNumber:
	forge test --match-contract GuessTheRandomNumberTest -vvvv

GuessTheNewNumber:
	forge test --match-contract GuessTheNewNumberTest -vvvv

PredictTheFuture:
	forge test --match-contract PredictTheFutureTest -vvvv

PredictTheBlochhash:
	forge test --match-contract PredictTheBlochhashTest -vvvv

TokenSale:
	forge test --match-contract TokenSaleTest -vvvv

TokenWhale:
	forge test --match-contract TokenWhaleTest -vvvv

RetirementFund:
	forge test --match-contract RetirementFundTest -vvvv

Mapping:
	forge test --match-contract MappingTest -vvvv

Donation:
	forge test --match-contract DonationTest -vvvv

FiftyYears:
	forge test --match-contract FiftyYearsTest -vvvv
