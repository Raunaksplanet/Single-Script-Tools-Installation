javascript:(function(){
  if(document.getElementById('bugbounty-popup')) return;
  const popup = document.createElement('div');
  popup.id = 'bugbounty-popup';
  popup.style.cssText = `
    position: fixed;
    top: 10px;
    left: 10px;
    width: 320px;
    background: #1e1e1e;
    color: #eee;
    border: 2px solid #444;
    z-index: 999999;
    padding: 10px;
    box-shadow: 0 0 12px #00ffcc;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    border-radius: 6px;
    cursor: move;
  `;
  popup.innerHTML = `
    <textarea id="bugbounty-text" placeholder="Write your note..." 
      style="width:100%; height:140px; resize: both; background:#222; color:#eee; border:1px solid #555; padding:6px; font-size:14px; border-radius:4px;"></textarea>
    <button id="bugbounty-send" 
      style="margin-top:8px; width:100%; background:#00bfa5; border:none; color:#fff; padding:8px; font-weight:bold; cursor:pointer; border-radius:4px;">
      Send to Notion
    </button>
    <button id="bugbounty-close" 
      style="margin-top:6px; width:100%; background:#555; border:none; color:#ccc; padding:6px; cursor:pointer; border-radius:4px;">
      Close
    </button>
  `;
  document.body.appendChild(popup);

  let dragging = false, offsetX = 0, offsetY = 0;

  popup.addEventListener('mousedown', e => {
    if(e.target.tagName === 'TEXTAREA' || e.target.tagName === 'BUTTON') return;
    dragging = true;
    const rect = popup.getBoundingClientRect();
    offsetX = e.clientX - rect.left;
    offsetY = e.clientY - rect.top;
    e.preventDefault();
  });

  window.addEventListener('mouseup', () => dragging = false);

  window.addEventListener('mousemove', e => {
    if (!dragging) return;
    let x = e.clientX - offsetX;
    let y = e.clientY - offsetY;
    x = Math.min(window.innerWidth - popup.offsetWidth, Math.max(0, x));
    y = Math.min(window.innerHeight - popup.offsetHeight, Math.max(0, y));
    popup.style.left = x + 'px';
    popup.style.top = y + 'px';
  });

  document.getElementById('bugbounty-send').onclick = () => {
    const text = document.getElementById('bugbounty-text').value.trim();
    if(!text) {
      alert('Please write something before sending.');
      return;
    }
    fetch('https://api.notion.com/v1/pages', {
      method: 'POST',
      headers: {
        'Authorization': 'Bearer YOUR_NOTION_TOKEN',
        'Notion-Version': '2022-06-28',
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        parent: { database_id: 'YOUR_DATABASE_ID' },
        properties: {
          Name: {
            title: [
              { text: { content: text } }
            ]
          }
        }
      })
    }).then(res => {
      if(res.ok){
        alert('Sent successfully to Notion');
        document.getElementById('bugbounty-text').value = '';
      } else {
        alert('Failed to send to Notion');
      }
    }).catch(err => alert('Error: ' + err.message));
  };

  document.getElementById('bugbounty-close').onclick = () => {
    popup.remove();
  };
})();
