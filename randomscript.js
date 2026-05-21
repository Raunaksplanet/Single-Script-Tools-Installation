function typeCheat(code) {
  for (const ch of code.toLowerCase()) {
    window.dispatchEvent(new KeyboardEvent("keydown", {
      key: ch,
      code: "Key" + ch.toUpperCase(),
      bubbles: true
    }));

    window.dispatchEvent(new KeyboardEvent("keyup", {
      key: ch,
      code: "Key" + ch.toUpperCase(),
      bubbles: true
    }));
  }
}

document.addEventListener("keydown", (e) => {

  if (e.key === "]") {
    typeCheat("GETTHEREVERYFASTINDEED");
  }

  // h = Full health
  if (e.key === "[") {
    typeCheat("ASPIRINEPRECIOUSPROTECTION");
  }

  // j = Weapons
  if (e.key === ";") {
    typeCheat("NUTTERTOOLS");
  }
  // l = Fast car
  if (e.key === "'") {
    typeCheat("bigbang");
  }

  if (e.key === "/") {
    typeCheat("leavemealone");
  }

if (e.key === ",") {
    typeCheat("onspeed");
  }

if (e.key === ".") {
    typeCheat("booooooring");
  }
  
});

