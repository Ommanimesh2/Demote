const { app, BrowserWindow, ipcMain, powerMonitor } = require("electron");
const path = require("path");
const robot = require("robotjs");
const { spawn } = require("child_process");
function getRunningTasks() {
  return new Promise((resolve, reject) => {
    const wmic = spawn('wmic', ['process', 'get', 'ProcessId,Name,WorkingSetSize', '/format:csv']);

    let tasks = [];

    wmic.stdout.on('data', (data) => {
      // Parse the output data and extract the task names and memory usage
      const lines = data.toString().split('\r\n').filter(line => line.trim() !== '');
      for (let i = 1; i < lines.length; i++) {
        console.log(lines[i])
        const [pid, name, memUsage] = lines[i].split(',').map(str => str.trim());
        tasks.push({ name, pid, memUsage });
      }
    });

    wmic.stderr.on('data', (data) => {
      reject(`stderr: ${data}`);
    });

    wmic.on('close', (code) => {
      if (code === 0) {
        resolve(tasks);
      } else {
        reject(`child process exited with code ${code}`);
      }
    });
  });
}


function createWindow() {
  const mainWindow = new BrowserWindow({
    width: 800,
    height: 600,
    webPreferences: {
      nodeIntegration: true,
      contextIsolation: false,
      enableRemoteModule: true,
    },
  });

  mainWindow.loadFile(path.join(__dirname, "index.html"));

  mainWindow.webContents.openDevTools();

  ipcMain.on("shutdown", () => {
    console.log("Shutdown button clicked");
    require("child_process").exec("shutdown /s /t 0");
  });

  ipcMain.on("lock", () => {
    console.log("Lock button clicked");
    require("child_process").exec("rundll32.exe user32.dll,LockWorkStation");
  });

  ipcMain.on("kill-task",(event,arg) => {
    console.log("Argument is" , arg)
    console.log("kill button clicked");
    require("child_process").exec(`taskkill /F /PID ${arg}`);
  });

  ipcMain.on("turn-on-bluetooth", () => {
    console.log("Turn on Bluetooth button clicked");
    require("child_process").exec("fsquirt.exe");
  });
  ipcMain.on("tasks-list", (event) => {
    // get all the tasks-----
const tasklist = spawn("tasklist", ["/fo", "csv", "/nh"]);
const wmic = spawn('wmic', ['process', 'get', 'processid,Name', '/format:csv']);

    console.log("list coming")
    wmic.stdout.on("data", (data) => {
      let that=[]
      const tasks = data.toString().split('\r\n').filter(line => line.trim() !== '');
      for (let i = 1; i < tasks.length; i++) {
        console.log(tasks[i])
        const [pid, name, memUsage] = tasks[i].split(',').map(str => str.trim());
        that.push({ name, pid, memUsage });
      }
    console.log(that)
    // Send the task names back to the renderer process
    event.reply('get-tasks-reply', that);
    });

    tasklist.stderr.on("data", (data) => {
      console.error(`stderr: ${data}`);
    });

    tasklist.on("close", (code) => {
      console.log(`child process exited with code ${code}`);
    });
    //-----------------
  });

  ipcMain.on("volume-up", () => {
    console.log("Volume up button clicked");
    robot.keyTap("audio_vol_up");
  });
  ipcMain.on("task-list-req-processes", (event) => {
    getRunningTasks()
    .then(tasks => {
      event.reply('get-req-tasks-reply', tasks);
    })
    .catch(error => {
      console.error(error);
    });
  });

  ipcMain.on("volume-down", () => {
    console.log("Volume down button clicked");
    robot.keyTap("audio_vol_down");
  });

  ipcMain.on("volume-mute", () => {
    console.log("Volume mute button clicked");
    robot.keyTap("audio_mute");
  });
}

app.whenReady().then(createWindow);

app.on("window-all-closed", () => {
  if (process.platform !== "darwin") {
    app.quit();
  }
});

app.on("activate", () => {
  if (BrowserWindow.getAllWindows().length === 0) {
    createWindow();
  }
});
