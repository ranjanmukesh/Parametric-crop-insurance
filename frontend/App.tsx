import { WagmiProvider } from 'wagmi'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { NavigationContainer } from '@react-navigation/native'
import { createNativeStackNavigator } from '@react-navigation/native-stack'
import { config } from './config/wagmi'
import HomeScreen from './screens/HomeScreen'
import DashboardScreen from './screens/DashboardScreen'

const queryClient = new QueryClient()
const Stack = createNativeStackNavigator()

export default function App() {
 return (
  <WagmiProvider config={config}>
   <QueryClientProvider client={queryClient}>
    <NavigationContainer>
     <Stack.Navigator initialRouteName="Home">
      <Stack.Screen name="Home"
       		    component={HomeScreen}
		    options={{ title: 'Crop Insurance' }}
		    />
      <Stack.Screen
        name="Dashboard"
        component={HomeScreen}
        options={{ title: 'Crop Insurance' }}
        />
        </Stack.Navigator>
      </NavigationContainer>
    </QueryClientProvider>
  </WagmiProvider>

}
