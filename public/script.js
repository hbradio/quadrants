console.log("Hello, there...");

function copyToClipboard() {
  html2canvas(document.querySelector("#capture")).then(canvas => {
    canvas.toBlob(function(blob) {
      const item = new ClipboardItem({ "image/png": blob });
      navigator.clipboard.write([item]);
    });
  });
}

function download() {
  html2canvas(document.querySelector("#capture")).then(canvas => {
    canvas.toBlob(function(blob) {
      var link = document.createElement("a");
      link.download = "nametag.png";
      link.href = canvas.toDataURL("image/png");
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
      delete link;
    });
  });
}
