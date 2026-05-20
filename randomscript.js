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
    typeCheat("PANZER");
  }
});
