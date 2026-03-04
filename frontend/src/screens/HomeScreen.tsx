import React, { useState } from 'react'
import { View, Text, TextInput, Button, StyleSheet, Alert, ActivityIndicator } from 'react-native'
import { useAccount, useConnect, useWriteContract } from 'wagmi'
import { parseEther } from 'viem'
import { injected } from '@wagmi/connectors'

const CONTRACT_ADDRESS = ''
const ABI =  [{"inputs":[{"internalType":"address","name":"router","type":"address"},{"internalType":"bytes32","name":"_donID","type":"bytes32"},{"internalType":"uint64","name":"_subscriptionId","type":"uint64"}],"stateMutability":"nonpayable","type":"constructor"},{"inputs":[],"name":"EmptyArgs","type":"error"},{"inputs":[],"name":"EmptySource","type":"error"},{"inputs":[],"name":"NoInlineSecrets","type":"error"},{"inputs":[],"name":"OnlyRouterCanFulfill","type":"error"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"from","type":"address"},{"indexed":true,"internalType":"address","name":"to","type":"address"}],"name":"OwnershipTransferRequested","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"from","type":"address"},{"indexed":true,"internalType":"address","name":"to","type":"address"}],"name":"OwnershipTransferred","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"farmer","type":"address"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"}],"name":"PayoutTriggered","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"farmer","type":"address"},{"indexed":false,"internalType":"uint256","name":"premium","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"coverage","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"threshold","type":"uint256"}],"name":"PolicyPurchased","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint256","name":"totalRainfallMm","type":"uint256"}],"name":"RainfallChecked","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"bytes32","name":"id","type":"bytes32"}],"name":"RequestFulfilled","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"bytes32","name":"id","type":"bytes32"}],"name":"RequestSent","type":"event"},{"inputs":[],"name":"acceptOwnership","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"_coverageAmount","type":"uint256"},{"internalType":"uint256","name":"_threshold","type":"uint256"},{"internalType":"string","name":"_seasonStart","type":"string"},{"internalType":"string","name":"_seasonEnd","type":"string"},{"internalType":"uint256","name":"_seasonStartTimestamp","type":"uint256"},{"internalType":"uint256","name":"_seasonEndTimestamp","type":"uint256"}],"name":"buyPolicy","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[],"name":"checkInterval","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"string","name":"javascriptSource","type":"string"},{"internalType":"string","name":"startDate","type":"string"},{"internalType":"string","name":"endDate","type":"string"}],"name":"checkRainfallPeriod","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"bytes","name":"","type":"bytes"}],"name":"checkUpkeep","outputs":[{"internalType":"bool","name":"upkeepNeeded","type":"bool"},{"internalType":"bytes","name":"","type":"bytes"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"coverageAmount","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"donID","outputs":[{"internalType":"bytes32","name":"","type":"bytes32"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"farmer","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"fundPayout","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[],"name":"gasLimit","outputs":[{"internalType":"uint32","name":"","type":"uint32"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"bytes32","name":"requestId","type":"bytes32"},{"internalType":"bytes","name":"response","type":"bytes"},{"internalType":"bytes","name":"err","type":"bytes"}],"name":"handleOracl as const
export default function HomeScreen({ navigation }: any) {
  const { address, isConnected } = useAccount()
  const { connect } = useConnect()
  const { writeContract, isPending } = useWriteContract()
  const [coverage, setCoverage] = useState('')
  const [threshold, setThreshold] = useState('')
  const [startDate, setStartDate] = useState('')
  const [endDate, setEndDate] = useState('')
  const handleBuy = () => {
    if(!coverage || !threshold || !startDate || !endDate) {
      Alert.alert('Error', 'Please fill all fields')
      return
    }
  
  const startTs = Math.floor(new Date(startDate).getTime() / 1000)
  const endTs = Math.floor(new Date(endDate).getTime() / 1000)

  if (isNaN(startTs) || isNaN(endTs) || startTs >= endTs){
    Alert.error('Error', 'Invalid date range')
    return
  }
  const premium = parseEther((Number(coverage) / 10).toFixed(10))

  writeContract(
    {
      address: CONTRACT_ADDRESS,
      abi: ABI,
      functionName: 'buyPolicy',
      args: [

        BigInt(coverage),
        BigInt(threshold),
        startDate,
        endDate,
        BigInt(startTs),
        BigInt(endTs),
      ],

      {
        onSuccess: () => {
          Alert.alert('Success', 'Plicy purchased!')
  nssvigstion.navigate('Dashboard')
        },
        onError: (err) => {
          Alert.alert('Error',err.message || 'Transaction failed')
          },

        }
      }
  )
}

return (
  <View style={styles.container}>
    {!isConnected ? (
      <View>
        <Text style=
          {styles.titke}>Connect your wallet</Texct>
        <Button title="Connect with Metamask / Walletconnect" onPress={() => connect({ connector: injected(0 })} />
        </View>
        ) : (
          <>
            <Text style={style.subtitle}>Connected:{address?.slice(0.6)}...{address?.slice(-4)}</Text>
            <Text style={styles.label}>Coverage Amount (ETH) </Text>
            <TextInput style={styles.input} value={coverage} onChangeText={setCoverage} keyboardType="numeric" placeholder="e.g. 0.1" />
            <Text style={styles.label}> Rainfall Threshold (mm)</Text>
            <TextInput style={styles.input} value={threshold} onChangeText={setThreshold} keyboardType="numberic" placeholder="e.g. 500" />
            <Text style={styles.label}>Season Start(YYYY-MM-DD)</Text>
            <TextInput style={styles.input} value= {startDate} onChangeText={setStartDate} placeholder="2025-06-01"/>
            <Text style={styles.label}>Season End (YYYY-MM-DD)</Text>
            <TextInput style={styles.input} value={endDate} onChangeText={setEndDate} placeholder="2025-09-30" />
            <view style={styles.buttonContainer}>
              {isPending ? ( <ActivityIndicator size="large" color="#00aa00" />
              ) : (
              <Button title="But Policy" onPress={handleBuy} color="#00aa00" />
              )}
            </View>
          </>
        )}
      </View>
    )
  }

const styles = StyleSheet.create({
  container: { flex: 1, padding: 20, backgroundColor: '#f8f9fa' },
  title: { fontSize: 24, fontWeight:'bold', marginBottom: 20, textAlign: 'center' ).
  subtitle: ( fontSize: 16, marginBottom: 20, textAlign: 'center'},
  subtitle: { fontSize:24, fontWeight:'bold', marginBottom: 20, textAlign: 'center' },
  label: { fontSize: 16, marginTop: 12, marginBottom: 4, fontWeight: '600'  },
  input: { borderWidth: 1, bolderColor: '#ccc' , borderRadius: 8, padding: 12, marginBottom: 12, backgroundColor: 'white' },
  buttonContainer: { marginTop: 20 },})
