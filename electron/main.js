const {
  app,
  BrowserWindow,
  ipcMain,
  powerMonitor,
  dialog,
} = require("electron");
// Import the functions you need from the SDKs you need
const si = require("systeminformation");
const {
  getFirestore,
  Timestamp,
  FieldValue,
} = require("firebase-admin/firestore");
const firebaseConfig = {
  apiKey: "AIzaSyBR3ZLJB_qCY0hWBE_-lwSUFZKSHVeiL5U",
  authDomain: "demote-91d58.firebaseapp.com",
  databaseURL: "https://demote-91d58-default-rtdb.firebaseio.com",
  projectId: "demote-91d58",
  storageBucket: "demote-91d58.appspot.com",
  messagingSenderId: "1021231368408",
  appId: "1:1021231368408:web:d0eb88b95a39b0a99f2fad",
  measurementId: "G-8QT865YCMW",
};

var admin = require("firebase-admin");
let lock = false;
let bluetooth = false;
let volumeUp = false;
let volumeDown = false;
let skip = false;
let back = false;
let play = false;
let next = false;
let prev = false;

var serviceAccount = require("./demote-91d58-firebase-adminsdk-5v9wv-2e81f26f46.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://demote-91d58-default-rtdb.firebaseio.com",
});

const db = getFirestore();
const path = require("path");
const robot = require("robotjs");
const { spawn } = require("child_process");
function fastForward() {}
function fastBackward() {
  robot.keyTap("shift");
  robot.keyTap("left");
}
function parseUserFromUrl(urlString) {
  const url = new URL(urlString);
  const jsonStartIndex = url.pathname.indexOf("%7B");
  if (jsonStartIndex === -1) {
    console.error("Invalid URL: no JSON string found.");
    return null;
  }
  const jsonString = decodeURIComponent(url.pathname.slice(jsonStartIndex));
  try {
    const userObject = JSON.parse(jsonString);
    return userObject;
  } catch (error) {
    console.error("Failed to parse JSON: ", error);
    return null;
  }
}

function removeElectronFiddlePrefix(urlString) {
  const prefix = "electron-fiddle://";
  if (urlString.startsWith(prefix)) {
    return urlString.slice(prefix.length);
  } else {
    console.error("Invalid URL: does not start with 'electron-fiddle://'");
    return null;
  }
}

function getRunningTasks() {
  return new Promise((resolve, reject) => {
    const wmic = spawn("wmic", [
      "process",
      "get",
      "ProcessId,Name,WorkingSetSize",
      "/format:csv",
    ]);

    let tasks = [];

    wmic.stdout.on("data", (data) => {
      // Parse the output data and extract the task names and memory usage
      const lines = data
        .toString()
        .split("\r\n")
        .filter((line) => line.trim() !== "");
      for (let i = 1; i < lines.length; i++) {
        console.log(lines[i]);
        const [pid, name, memUsage] = lines[i]
          .split(",")
          .map((str) => str.trim());
        tasks.push({ name, pid, memUsage });
      }
    });

    wmic.stderr.on("data", (data) => {
      reject(`stderr: ${data}`);
    });

    wmic.on("close", (code) => {
      if (code === 0) {
        resolve(tasks);
      } else {
        reject(`child process exited with code ${code}`);
      }
    });
  });
}
let mainWindow;
if (process.defaultApp) {
  if (process.argv.length >= 2) {
    app.setAsDefaultProtocolClient("electron-fiddle", process.execPath, [
      path.resolve(process.argv[1]),
    ]);
  }
} else {
  app.setAsDefaultProtocolClient("electron-fiddle");
}
const gotTheLock = app.requestSingleInstanceLock();

if (!gotTheLock) {
  app.quit();
} else {
  app.on("second-instance", (event, commandLine, workingDirectory) => {
    // Someone tried to run a second instance, we should focus our window.
    if (mainWindow) {
      const deepLinkingUrl = commandLine.find((ar) =>
        ar.startsWith("electron-fiddle://")
      );
      const decodedJson = decodeURIComponent(
        removeElectronFiddlePrefix(deepLinkingUrl)
      );
      const parsedJson = JSON.parse(decodedJson);
      console.log(parsedJson);
      if (mainWindow.isMinimized()) mainWindow.restore();
      else {
        mainWindow.focus();
      }
    }
    // the commandLine is array of strings in which last element is deep link url
    // the url str ends with /
    dialog.showErrorBox(
      "Welcome Back",
      `You arrived from: ${commandLine.pop().slice(0, -1)}`
    );
  });

  // Create mainWindow, load the rest of the app, etc...
  app.whenReady().then(() => {
    createWindow();
  });
}
function createWindow() {
  mainWindow = new BrowserWindow({
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
  });

  ipcMain.on("lock", () => {});

  ipcMain.on("get-data", async () => {});

  ipcMain.on("kill-task", (event, arg) => {
    console.log("Argument is", arg);
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
    const wmic = spawn("wmic", [
      "process",
      "get",
      "processid,Name",
      "/format:csv",
    ]);

    console.log("list coming");
    wmic.stdout.on("data", (data) => {
      let that = [];
      const tasks = data
        .toString()
        .split("\r\n")
        .filter((line) => line.trim() !== "");
      for (let i = 1; i < tasks.length; i++) {
        console.log(tasks[i]);
        const [pid, name, memUsage] = tasks[i]
          .split(",")
          .map((str) => str.trim());
        that.push({ name, pid, memUsage });
      }
      console.log(that);
      // Send the task names back to the renderer process
      event.reply("get-tasks-reply", that);
    });

    tasklist.stderr.on("data", (data) => {
      console.error(`stderr: ${data}`);
    });

    tasklist.on("close", (code) => {
      console.log(`child process exited with code ${code}`);
    });
    //-----------------
  });
  ipcMain.on("fast-forward-playback", (event) => {
    console.log("forwarding");
    robot.keyTap("shift");
    robot.keyTap("right");
  });
  ipcMain.on("fast-backword-playback", (event) => {
    console.log("backwarding");
    robot.keyTap("shift");
    robot.keyTap("left");
  });
  ipcMain.on("volume-up", () => {
    console.log("Volume up button clicked");
    robot.keyTap("audio_vol_up");
  });
  ipcMain.on("task-list-req-processes", (event) => {
    getRunningTasks()
      .then((tasks) => {
        event.reply("get-req-tasks-reply", tasks);
      })
      .catch((error) => {
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

app.whenReady().then(async () => {
  try {
    si.processes().then((data) => {
      let processes = [];
      data.list.forEach((process) => {
        //update processes array
        var index = processes.findIndex((el) => el.name === process.name);
        // process = process.map(el => el.name === item.name ? item : el);
        let p = {
          name: process.name,
          pid: process.pid,
        };
        if (index !== -1) {
          p.mem = p.mem + processes[index].mem;
          processes.slice(index,1,p);
        } else {
          processes.push({
            name: process.name,
            pid: process.pid,
          });
        }
      });
    });
    const doc = db
      .collection("USERS")
      .doc("9Mcu0QPA6kXBNQcfnv4o")
      .collection("DEVICES")
      .doc("pUjCYwqeY8u7EXYQnoYT");
    const observer = doc.onSnapshot(
      (docSnapshot) => {
        lock = docSnapshot._fieldsProto.lock.booleanValue;
        power = docSnapshot._fieldsProto.power.booleanValue;
        skip = docSnapshot._fieldsProto.skip.booleanValue;
        bluetooth = docSnapshot._fieldsProto.bluetooth.booleanValue;
        volumeUp = docSnapshot._fieldsProto.volumeUp.booleanValue;
        volumeDown = docSnapshot._fieldsProto.volumeDown.booleanValue;
        back = docSnapshot._fieldsProto.back.booleanValue;
        play = docSnapshot._fieldsProto.play.booleanValue;
        next = docSnapshot._fieldsProto.next.booleanValue;
        previous = docSnapshot._fieldsProto.prev.booleanValue;

        if (lock) {
          db.collection("USERS")
            .doc("9Mcu0QPA6kXBNQcfnv4o")
            .collection("DEVICES")
            .doc("pUjCYwqeY8u7EXYQnoYT")
            .update({ lock: false })
            .then(() => {
              require("child_process").exec(
                "rundll32.exe user32.dll,LockWorkStation"
              );
            });
        } else if (!power) {
          db.collection("USERS")
            .doc("9Mcu0QPA6kXBNQcfnv4o")
            .collection("DEVICES")
            .doc("pUjCYwqeY8u7EXYQnoYT")
            .update({ power: true })
            .then(() => {
              require("child_process").exec("shutdown /s /t 0");
            });
        } else if (bluetooth) {
          db.collection("USERS")
            .doc("9Mcu0QPA6kXBNQcfnv4o")
            .collection("DEVICES")
            .doc("pUjCYwqeY8u7EXYQnoYT")
            .update({ bluetooth: false })
            .then(() => {
              require("child_process").exec("rfkill unblock bluetooth");
            });
        } else if (volumeUp) {
          db.collection("USERS")
            .doc("9Mcu0QPA6kXBNQcfnv4o")
            .collection("DEVICES")
            .doc("pUjCYwqeY8u7EXYQnoYT")
            .update({ volumeUp: false })
            .then(() => {
              robot.keyTap("audio_vol_up");
            });
        } else if (volumeDown) {
          db.collection("USERS")
            .doc("9Mcu0QPA6kXBNQcfnv4o")
            .collection("DEVICES")
            .doc("pUjCYwqeY8u7EXYQnoYT")
            .update({ volumeDown: false })
            .then(() => {
              robot.keyTap("audio_vol_down");
            });
        } else if (skip) {
          db.collection("USERS")
            .doc("9Mcu0QPA6kXBNQcfnv4o")
            .collection("DEVICES")
            .doc("pUjCYwqeY8u7EXYQnoYT")
            .update({ skip: false })
            .then(() => {
              robot.keyTap("shift");
              robot.keyTap("right");
            });
        } else if (back) {
          db.collection("USERS")
            .doc("9Mcu0QPA6kXBNQcfnv4o")
            .collection("DEVICES")
            .doc("pUjCYwqeY8u7EXYQnoYT")
            .update({ back: false })
            .then(() => {
              robot.keyTap("shift");
              robot.keyTap("left");
            });
        } else if (play) {
          db.collection("USERS")
            .doc("9Mcu0QPA6kXBNQcfnv4o")
            .collection("DEVICES")
            .doc("pUjCYwqeY8u7EXYQnoYT")
            .update({ play: false })
            .then(() => {
              robot.keyTap("space");
            });
        } else if (next) {
          db.collection("USERS")
            .doc("9Mcu0QPA6kXBNQcfnv4o")
            .collection("DEVICES")
            .doc("pUjCYwqeY8u7EXYQnoYT")
            .update({ next: false })
            .then(() => {
              robot.keyTap("n",'shift');
            });
        } else if (prev) {
          db.collection("USERS")
            .doc("9Mcu0QPA6kXBNQcfnv4o")
            .collection("DEVICES")
            .doc("pUjCYwqeY8u7EXYQnoYT")
            .update({ prev: false })
            .then(() => {
              robot.keyTap("p",'shift');
            });
        } else {
          console.log("lock is not true");
        }
      },
      (err) => {
        console.log(`Encountered error: ${err}`);
      }
    );
  } catch (error) {
    console.log(error);
  }
  createWindow();
});

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
