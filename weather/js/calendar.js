// calendar.js
let currentDate = new Date();

function renderCalendar() {
  const year = currentDate.getFullYear();
  const month = currentDate.getMonth();
  const today = new Date();

  document.getElementById('month-year').textContent = `${year}年 ${month + 1}月`;

  const firstDay = new Date(year, month, 1).getDay();
  const daysInMonth = new Date(year, month + 1, 0).getDate();
  const daysInPrevMonth = new Date(year, month, 0).getDate();

  const calendar = document.getElementById('calendar');
  calendar.innerHTML = `
    ${['日', '一', '二', '三', '四', '五', '六'].map(d => `<div class="day-header">${d}</div>`).join('')}
  `;

  // 上月尾巴
  for (let i = firstDay - 1; i >= 0; i--) {
    const day = daysInPrevMonth - i;
    calendar.innerHTML += `<div class="day other-month">${day}</div>`;
  }

  // 本月
  for (let day = 1; day <= daysInMonth; day++) {
    const isToday = day === today.getDate() && month === today.getMonth() && year === today.getFullYear();
    calendar.innerHTML += `<div class="day ${isToday ? 'today' : ''}">${day}</div>`;
  }

  // 下月开头（补满42格）
  const totalCells = calendar.children.length;
  const remaining = 42 - totalCells;
  for (let i = 1; i <= remaining; i++) {
    calendar.innerHTML += `<div class="day other-month">${i}</div>`;
  }
}

document.getElementById('prev-month').onclick = () => {
  currentDate.setMonth(currentDate.getMonth() - 1);
  renderCalendar();
};

document.getElementById('next-month').onclick = () => {
  currentDate.setMonth(currentDate.getMonth() + 1);
  renderCalendar();
};

renderCalendar();