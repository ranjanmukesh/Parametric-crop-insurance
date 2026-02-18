const latitude = 19.0760;
const longitude = 72.8777;

const startDate = args(0);
const endDate = args[1];

const url = https://archive-api.open-meteo.com/v1/archive?latitude=${latitude}&longitude=${longitude}&start_date=${startDate}&end_date=${endDate}&daily=precipitation_sum&timezone=Asia%2FKolkata;

const response = await Functions.makeHttpRequest({ url: url });

if(response.error) {
	throw Error("Weather API request failed");
}

const dailyData = response.data.daily;
if(!dailyData || !dailyData.precipitation_sum) {
	throw Error("No precipitation data");
}

let totalrainfallMm = 0;

for (const dailySum of dailyData.precipitation_sum) {
	if(dailySum !== null) {
		totalRainfallMm += dailySum;
	}
}

return Functions.encodeUint256(Math.round(totalRainfallMm);

