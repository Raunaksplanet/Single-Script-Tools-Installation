javascript:(function(){
  if(document.getElementById('bugbounty-popup')) return;
  let popup = document.createElement('div');
  popup.id = 'bugbounty-popup';
  popup.style.position = 'fixed';
  popup.style.bottom = '10px';
  popup.style.right = '10px';
  popup.style.width = '320px';
  popup.style.background = '#1e1e1e';
  popup.style.color = '#eee';
  popup.style.border = '2px solid #444';
  popup.style.zIndex = 99999;
  popup.style.padding = '10px';
  popup.style.boxShadow = '0 0 12px #00ffcc';
  popup.style.fontFamily = 'Segoe UI, Tahoma, Geneva, Verdana, sans-serif';
  popup.style.borderRadius = '6px';

  popup.innerHTML = `
    <textarea id="bugbounty-text" placeholder="Write your note..." style="width:100%; height:140px; resize: both; background:#222; color:#eee; border:1px solid #555; padding:6px; font-size:14px; border-radius:4px;"></textarea>
    <button id="bugbounty-send" style="margin-top:8px; width:100%; background:#00bfa5; border:none; color:#fff; padding:8px; font-weight:bold; cursor:pointer; border-radius:4px;">Send to Discord</button>
    <button id="bugbounty-close" style="margin-top:6px; width:100%; background:#555; border:none; color:#ccc; padding:6px; cursor:pointer; border-radius:4px;">Close</button>
  `;

  document.body.appendChild(popup);

  document.getElementById('bugbounty-send').onclick = function(){
    let text = document.getElementById('bugbounty-text').value.trim();
    if(!text) {
      alert('Please write something before sending.');
      return;
    }
    fetch('', {
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: JSON.stringify({content: text})
    }).then(res => {
      if(res.ok){
        alert('Sent successfully');
        document.getElementById('bugbounty-text').value = '';
      } else {
        alert('Failed to send');
      }
    }).catch(e => alert('Error: '+e.message));
  };

  document.getElementById('bugbounty-close').onclick = function(){
    popup.remove();
  };
})();
