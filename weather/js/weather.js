// weather.js（专属 Host 修复版）
const WEATHER_API_KEY = 'fd04a64eb4b24538b2d4ad610b6cfeb9'; // 你的有效 Key
const API_HOST = 'kx2x87nf7d.re.qweatherapi.com'; // 你的专属 Host
const CITY_CODE = '101181604'; // 上蔡县

async function fetchWeather() {
  if (!WEATHER_API_KEY) {
    throw new Error('Key 未设置！');
  }

  try {
    // 实时天气（用专属 Host）
    const nowRes = await fetch(`https://${API_HOST}/v7/weather/now?location=${CITY_CODE}&key=${WEATHER_API_KEY}`);
    const now = await nowRes.json();

    // 7 天预报
    const weekRes = await fetch(`https://${API_HOST}/v7/weather/7d?location=${CITY_CODE}&key=${WEATHER_API_KEY}`);
    const week = await weekRes.json();

    if (now.code !== '200' || week.code !== '200') {
      throw new Error(`API 错误: ${now.code || week.code} - ${now.message || week.message}`);
    }

    displayCurrent(now.now);
    displayForecast(week.daily.slice(0, 7));
  } catch (err) {
    console.error('天气 API 错误:', err);
    document.getElementById('current-weather').innerHTML = `<p style="color:#ff9966">⚠️ ${err.message || '天气服务不可用'}</p>`;
  }
}

function displayCurrent(data) {
  const el = document.getElementById('current-weather');
  // 硬编码 Emoji，确保 UTF-8（避免动态注入乱码）
  const tempIcon = '\u{1F321}\u{FE0F}';  // ������️ (体感温度)
  const humidityIcon = '\u{1F4A7}';       // ������ (湿度)
  const windIcon = '\u{1F32C}\u{FE0F}';   // ������ (风向)
  el.innerHTML = `
    <div class="temp">${data.temp}°</div>
    <div class="condition">${data.text}</div>
    <div style="font-size:0.9rem;margin-top:0.5rem;opacity:0.8">
      ${tempIcon} 体感 ${data.feelsLike}° | ${humidityIcon} ${data.humidity}% | ${windIcon} ${data.windDir} ${data.windScale}级
    </div>
    <div style="font-size:0.8rem;opacity:0.7;margin-top:0.3rem">
      更新: ${data.obsTime}
    </div>
  `;
}

function displayForecast(days) {
  const el = document.getElementById('forecast');
  el.innerHTML = days.map(day => `
    <div class="forecast-day">
      <div class="date">${formatDate(day.fxDate)}</div>
      <div style="font-size:0.9rem;">${day.textDay}</div>
      <div><strong>${day.tempMin}° ~ ${day.tempMax}°</strong></div>
    </div>
  `).join('');
}

function formatDate(dateStr) {
  const d = new Date(dateStr);
  const days = ['日', '一', '二', '三', '四', '五', '六'];
  return `${d.getMonth() + 1}/${d.getDate()} 周${days[d.getDay()]}`;
}

// 加载 + 每 30 分钟更新
fetchWeather();
setInterval(fetchWeather, 30 * 60 * 1000);
