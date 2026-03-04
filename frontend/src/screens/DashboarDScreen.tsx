import React from 'react'
import ( View, Text, StyleSheet, ActivityIndicator } from 'react-native'
import {useAccount, useReadContract} from 'wagmi'

const CONTRACT_ADDRESS = '' as '0x$(string}'

const ABI =   [{"inputs":[{"internalType":"address","name":"router","type":"address"},{"internalType":"bytes32","name":"_donID","type":"bytes32"},{"internalType":"uint64","name":"_subscriptionId","type":"uint64"}],"stateMutability":"nonpayable","type":"constructor"},{"inputs":[],"name":"EmptyArgs","type":"error"},{"inputs":[],"name":"EmptySource","type":"error"},{"inputs":[],"name":"NoInlineSecrets","type":"error"},{"inputs":[],"name":"OnlyRouterCanFulfill","type":"error"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"from","type":"address"},{"indexed":true,"internalType":"address","name":"to","type":"address"}],"name":"OwnershipTransferRequested","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"from","type":"address"},{"indexed":true,"internalType":"address","name":"to","type":"address"}],"name":"OwnershipTransferred","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"farmer","type":"address"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"}],"name":"PayoutTriggered","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"farmer","type":"address"},{"indexed":false,"internalType":"uint256","name":"premium","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"coverage","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"threshold","type":"uint256"}],"name":"PolicyPurchased","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint256","name":"totalRainfallMm","type":"uint256"}],"name":"RainfallChecked","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"bytes32","name":"id","type":"bytes32"}],"name":"RequestFulfilled","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"bytes32","name":"id","type":"bytes32"}],"name":"RequestSent","type":"event"},{"inputs":[],"name":"acceptOwnership","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"_coverageAmount","type":"uint256"},{"internalType":"uint256","name":"_threshold","type":"uint256"},{"internalType":"string","name":"_seasonStart","type":"string"},{"internalType":"string","name":"_seasonEnd","type":"string"},{"internalType":"uint256","name":"_seasonStartTimestamp","type":"uint256"},{"internalType":"uint256","name":"_seasonEndTimestamp","type":"uint256"}],"name":"buyPolicy","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[],"name":"checkInterval","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"string","name":"javascriptSource","type":"string"},{"internalType":"string","name":"startDate","type":"string"},{"internalType":"string","name":"endDate","type":"string"}],"name":"checkRainfallPeriod","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes","name":"","type":"bytes"}],"name":"checkUpkeep","outputs":[{"internalType":"bool","name":"upkeepNeeded","type":"bool"},{"internalType":"bytes","name":"","type":"bytes"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"coverageAmount","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"donID","outputs":[{"internalType":"bytes32","name":"","type":"bytes32"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"farmer","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"fundPayout","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[],"name":"gasLimit","outputs":[{"internalType":"uint32","name":"","type":"uint32"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"bytes32","name":"requestId","type":"bytes32"},{"internalType":"bytes","name":"response","type":"bytes"},{"internalType":"bytes","name":"err","type":"bytes"}],"name":"handleOracl as const
export deafult function DashboardScreen() {
  const {isConnected } = useAccount()

  const { data: farmer } = useReadContract({
    address: CONTRACT_ADDRESS,
    abi: ABI,
    functionName: 'farmer'.
    })

  const { data: rainfall} = useReadContract({
    address: CONTRACT_ADDRESS,
    abi: ABI,
    functionName: 'measuredRainfall',
    })

    const { data: payout } = useReadContract({
      address: CONTRACT_ADDRESS,
      abi: ABI,
      functionName: 'payoutTriggered'
      })

      if (!isConnected) return <Text style={styles.center}>Please connect wallet</Text>

      return (
        <View style={styles.container}>
          <Text style={styles.title}>Policy Dashboard</Text>

          {!farmer ? (
            <ActivityIndicator size="large" />
            ) : (
              <>
                <Text style={styles.info}>Farmer addres: {farmer?.toString()}</Text>
                <Text style={styles.info}>Measured Rainfall:{rainfall != undefined ? Number9rainfalll) : "Not yet checked"}
                mm
                  </Text>
                <Text styel={styles.info}>
                  Payout Triggered: {payout? 'YES - Funds sent !' : 'No (waiting for trigger)')
                </Text>
              </>
            )}
          </View>
        )
      }
   const styles = Stylesheet.create({
    container: { flex: 1, padding: 20, backgroundColor: '$f8f9fa', justifyContent: 'center' },
    title: { fontSize: 24, fontWeight: 'bold', marginBottom: 24, textAlign: 'center' },
    info: { fontSize: 18, marginVertical: 12, textAlign: 'center' },
    center: { flex: 1, textAlign: 'center', fontSize: 18, justifyContent: 'center' },
    })
