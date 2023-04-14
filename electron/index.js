
const { ipcRenderer } = require("electron");
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
// For Firebase JS SDK v7.20.0 and later, measurementId is optional




// When the button is clicked, send a message to the main process to shutdown the computer

document
  .getElementById("shutdown-button")
  .addEventListener("click", () => {
    ipcRenderer.send("shutdown");
  });
document.getElementById("lock-button").addEventListener("click", () => {
  
  ipcRenderer.send("lock");
});
document.getElementById("get-data").addEventListener("click", () => {
  
  ipcRenderer.send("get-data");
});
document
  .getElementById("bluetooth-button")
  .addEventListener("click", () => {
    ipcRenderer.send("turn-on-bluetooth");
  });
document
  .getElementById("volume-button-up")
  .addEventListener("click", () => {
    ipcRenderer.send("volume-up");
  });
document
  .getElementById("volume-button-down")
  .addEventListener("click", () => {
    ipcRenderer.send("volume-down");
  });
document.getElementById("kill-task").addEventListener("click", () => {
  id = 21448;
  ipcRenderer.send("kill-task", `${id}`);
});
document
  .getElementById("fast-forward-playback")
  .addEventListener("click", () => {
    ipcRenderer.send("fast-forward-playback");
  });

document
  .getElementById("fast-backword-playback")
  .addEventListener("click", () => {
    ipcRenderer.send("fast-backword-playback");
  });

document
  .getElementById("volume-button-mute")
  .addEventListener("click", () => {
    ipcRenderer.send("volume-mute");
  });
document.getElementById("show-tasks").addEventListener("click", () => {
  ipcRenderer.send("tasks-list");
});
document
  .getElementById("show-req-tasks")
  .addEventListener("click", () => {
    ipcRenderer.send("task-list-req-processes");
  });
ipcRenderer.on("get-tasks-reply", (event, tasks) => {
  const taskList = document.getElementById("task-list");
  tasks.forEach((task) => {
    const div = document.createElement("div");
    div.innerHTML = task;
    taskList.appendChild(div);
  });
});
ipcRenderer.on("get-req-tasks-reply", (event, tasks) => {
  const taskList = document.getElementById("task-list-req");
  tasks.forEach((task) => {
    // const div= document.createElement("div");
    // div.innerHTML=task;
    // taskList.appendChild(div)
    console.log(task);
  });
});