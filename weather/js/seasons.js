// seasons.js
const seasonImages = {
  spring: [
    'https://images.unsplash.com/photo-1511895243666-1cb1ef2d3e6c?auto=format&fit=crop&w=1600&q=80', // 樱花树
    'https://images.unsplash.com/photo-1523206489230-6d66b08fd9a0?auto=format&fit=crop&w=1600&q=80'  // 粉色樱花
  ],
  summer: [
    'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1600&q=80', // 热带海滩
    'https://images.unsplash.com/photo-1519046904884-53103b34b206?auto=format&fit=crop&w=1600&q=80' // 蔚蓝海洋
  ],
  autumn: [
    'https://images.unsplash.com/photo-1508698219687-4d3d3d2e8d?auto=format&fit=crop&w=1600&q=80',     // 橙黄落叶（修复）
    'https://images.unsplash.com/photo-1542272209-6d9b5f7a0b0a?auto=format&fit=crop&w=1600&q=80' // 枫叶林
  ],
  winter: [
    'https://images.unsplash.com/photo-1519904981063-b0cf448d479e?auto=format&fit=crop&w=1600&q=80', // 雪覆盖森林
    'https://images.unsplash.com/photo-1504639725590-34d0984388bd?auto=format&fit=crop&w=1600&q=80'  // 冬日雪景
  ]
};

function getCurrentSeason() {
  const month = new Date().getMonth() + 1;
  if (month >= 3 && month <= 5) return 'spring';
  if (month >= 6 && month <= 8) return 'summer';
  if (month >= 9 && month <= 11) return 'autumn';
  return 'winter';
}

function setSeasonBackground() {
  const season = getCurrentSeason();
  const images = seasonImages[season];
  const img = images[Math.floor(Math.random() * images.length)];

  // 预加载 + 错误处理
  const imgObj = new Image();
  imgObj.onload = () => {
    document.body.style.backgroundImage = `url('${img}')`;
  };
  imgObj.onerror = () => {
    // 备用：使用纯色渐变（无需网络）
    document.body.style.backgroundImage = 
      season === 'spring' ? 'linear-gradient(135deg, #f6d365 0%, #fda085 100%)' :
      season === 'summer' ? 'linear-gradient(135deg, #a8edea 0%, #fed6e3 100%)' :
      season === 'autumn' ? 'linear-gradient(135deg, #ff9a9e 0%, #fecfef 100%)' :
      'linear-gradient(135deg, #e0eafc 0%, #cfdef3 100%)';  // 冬季蓝白
  };
  imgObj.src = img;
}

// 首次加载 + 每天切换（当前日期：2025年11月16日，为秋季）
setSeasonBackground();
setInterval(setSeasonBackground, 24 * 60 * 60 * 1000);