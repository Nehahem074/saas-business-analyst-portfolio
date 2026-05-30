let currentTab = "";
let startTime = Date.now();

chrome.tabs.onActivated.addListener(async (activeInfo) => {
  const tab = await chrome.tabs.get(activeInfo.tabId);

  trackActivity(tab);
});

chrome.tabs.onUpdated.addListener((tabId, changeInfo, tab) => {
  if (changeInfo.status === "complete") {
    trackActivity(tab);
  }
});

async function trackActivity(tab) {
  if (!tab.url) return;

  const endTime = Date.now();

  const timeSpent = Math.floor((endTime - startTime) / 1000);
   if (currentTab !== "") {
    sendActivity({
      website: currentTab,
      title: tab.title,
      timeSpent,
    });
  }

  currentTab = tab.url;
  startTime = Date.now();
}

async function sendActivity(data) {
  try {
    await fetch("https://ai-productivity-tracker-backend.onrender.com/api/activity/save", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Authorization": token
      },
      body: JSON.stringify(data),
    });
  } catch (error) {
    console.log(error);
  }
}