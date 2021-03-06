#!/bin/bash

# additional arguments
PSQL='psql -h 127.0.0.1 -U postgres'

# update materialized views
time $PSQL -qc 'REFRESH MATERIALIZED VIEW ethereum_classic_stats'
time $PSQL -qc 'REFRESH MATERIALIZED VIEW cardano_stats'
time $PSQL -qc 'REFRESH MATERIALIZED VIEW ripple_payment_xrp_stats'
time $PSQL -qc 'REFRESH MATERIALIZED VIEW stellar_payment_stats'
time $PSQL -qc 'REFRESH MATERIALIZED VIEW stellar_payment_stats_prep'
time $PSQL -qc 'REFRESH MATERIALIZED VIEW iota_stats'
time $PSQL -qc 'REFRESH MATERIALIZED VIEW monero_stats'
time $PSQL -qc 'REFRESH MATERIALIZED VIEW nem_stats'
time $PSQL -qc 'REFRESH MATERIALIZED VIEW neo_stats'
time $PSQL -qc 'REFRESH MATERIALIZED VIEW lisk.lisk_stats'
time $PSQL -qc 'REFRESH MATERIALIZED VIEW ethereum_classic_short_tx'
time $PSQL -qc 'REFRESH MATERIALIZED VIEW eos_stats'
time $PSQL -qc 'REFRESH MATERIALIZED VIEW waves_stats'

### export csv's

# ethereum classic
$PSQL -qc "\\pset footer off" -c 'SELECT SUBSTRING(e."date"::TEXT FOR 10) "date", e."tx_cnt" "txCount", e."sum_value" "txVolume", e."med_value" "medTxVolume", e."avg_difficulty" "avgDifficulty", e."avg_tx_size" "avgTxSize", e."sum_fee" "sumFee", e."block_cnt" "blockCount", e."sum_size" "totalSize", e."med_fee" "medFee", e."reward" "generatedVolume", e."from_cnt" "fromAddrCount", e."to_cnt" "toAddrCount", e."addr_cnt" "addrCount", e."payment_cnt" "paymentCount", es."cnt" "shortTxCount", es."value" "shortTxValue" FROM ethereum_classic_stats e LEFT JOIN ethereum_classic_short_tx es ON e."date" = es."date" ORDER BY "date"' -A -F ',' -o 'eth_classic_stats.csv'

# cardano
$PSQL -qc "\\pset footer off" -c 'SELECT SUBSTRING("date"::TEXT FOR 10) "date", "cnt" "txCount", "volume" "txVolume", "fees" "fees", "from_cnt" "fromAddrCount", "to_cnt" "toAddrCount", "addr_cnt" "addrCount", "med_volume" "medTxVolume", "med_fees" "medFees", "payment_cnt" "paymentCount", "short_volume" "shortTxVolume" FROM cardano_stats ORDER BY "date"' -A -F ',' -o 'cardano.csv'

# ripple XRP payments
$PSQL -qc "\\pset footer off" -c 'SELECT SUBSTRING("date"::TEXT FOR 10) "date", "cnt" "txCount", "value" "txVolume", "fee" "fees", "from_cnt" "fromAddrCount", "to_cnt" "toAddrCount", "addr_cnt" "addrCount", "block_cnt" "blockCount", "missing_block_cnt" "missingBlockCount", "total_cnt" "totalTxCount", "missing_cnt" "missingTxCount" FROM ripple_payment_xrp_stats ORDER BY "date"' -A -F ',' -o 'ripple_payment_xrp.csv'

# stellar payments
$PSQL -qc "\\pset footer off" -c 'SELECT * FROM stellar_payment_stats_prep ORDER BY "date"' -A -F ',' -o 'stellar_payment.csv'
# stellar XLM payments
$PSQL -qc "\\pset footer off" -c 'SELECT SUBSTRING("date"::TEXT FOR 10) "date", "cnt" "txCount", "value" "txVolume", "fees" "fees", "from_cnt" "fromAddrCount", "to_cnt" "toAddrCount", "addr_cnt" "addrCount" FROM stellar_payment_stats WHERE "asset" = '\'\'' ORDER BY "date"' -A -F ',' -o 'stellar_payment_xlm.csv'

# iota
$PSQL -qc "\\pset footer off" -c 'SELECT SUBSTRING("date"::TEXT FOR 10) "date", "cnt" "txCount", "value" "txVolume", "med_value" "medTxVolume", "from_cnt" "fromAddrCount", "to_cnt" "toAddrCount", "addr_cnt" "addrCount" FROM iota_stats ORDER BY "date"' -A -F ',' -o 'iota.csv'

# monero
$PSQL -qc "\\pset footer off" -c 'SELECT SUBSTRING("date"::TEXT FOR 10) "date", "cnt" "txCount", "reward" - "fees" "generatedCoins", "fees" "fees", "avg_difficulty" "avgDifficulty", "med_fees" "medFees", "io_cnt" "addrCount", "payment_cnt" "paymentCount" FROM monero_stats ORDER BY "date"' -A -F ',' -o 'monero.csv'

# nem
$PSQL -qc "\\pset footer off" -c 'SELECT SUBSTRING("date"::TEXT FOR 10) "date", "cnt" "txCount", "value" "txVolume", "fees" "fees", "from_cnt" "fromAddrCount", "to_cnt" "toAddrCount", "addr_cnt" "addrCount", "med_value" "medTxVolume", "med_fees" "medFees" FROM nem_stats ORDER BY "date"' -A -F ',' -o 'nem.csv'

# neo
$PSQL -qc "\\pset footer off" -c 'SELECT SUBSTRING("date"::TEXT FOR 10) "date", "cnt" "txCount", "value" "txVolume", "fees" "fees", "from_cnt" "fromAddrCount", "to_cnt" "toAddrCount", "addr_cnt" "addrCount", "med_fees" "medFees", "med_value" "medTxVolume" FROM neo_stats WHERE "asset" = '\''\x602c79718b16e442de58778e148d0b1084e3b2dffd5de6b7b16cee7969282de7'\'' ORDER BY "date"' -A -F ',' -o 'neo_gas.csv'
$PSQL -qc "\\pset footer off" -c 'SELECT SUBSTRING("date"::TEXT FOR 10) "date", "cnt" "txCount", "value" "txVolume", "fees" "fees", "from_cnt" "fromAddrCount", "to_cnt" "toAddrCount", "addr_cnt" "addrCount", "med_fees" "medFees", "med_value" "medTxVolume" FROM neo_stats WHERE "asset" = '\''\xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b'\'' ORDER BY "date"' -A -F ',' -o 'neo_neo.csv'

# lisk
$PSQL -qc "\\pset footer off" -c 'SELECT SUBSTRING("date"::TEXT FOR 10) "date", "cnt" "txCount", "value" "txVolume", "fees" "fees", "from_cnt" "fromAddrCount", "to_cnt" "toAddrCount", "addr_cnt" "addrCount", "med_value" "medTxVolume", "med_fees" "medFees", "payment_cnt" "paymentCount" FROM lisk.lisk_stats ORDER BY "date"' -A -F ',' -o 'lisk.csv'

# eos
$PSQL -qc "\\pset footer off" -c 'SELECT SUBSTRING("date"::TEXT FOR 10) "date", "cnt" "txCount", "value" "txVolume", "med_value" "medTxVolume", "from_cnt" "fromAddrCount", "to_cnt" "toAddrCount", "addr_cnt" "addrCount" FROM eos_stats ORDER BY "date"' -A -F ',' -o 'eos.csv'
