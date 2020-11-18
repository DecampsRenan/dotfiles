local log = hs.logger.new('slack-status','debug')
log.i('Initializing slack-status')

local userID = hs.settings.get("slack.userID")
local apiKey = hs.settings.get("slack.apiKey")
local isAway = false

local slackStatus = hs.menubar.new()
function setSlackStatusDisplay(state)
  if state then
    slackStatus:setTitle("⛔️")
  else
    slackStatus:setTitle("🟢")
  end
end

function slackStatusUpdated()
  isAway = not isAway
  setSlackStatusDisplay(isAway)
  sendSlackStatusRequest()
end

if slackStatus then
  slackStatus:setClickCallback(slackStatusUpdated)
  setSlackStatusDisplay(isAway)
end

-- if hammerspoon haven't already store homeSSID
if not userID then
  local _, newUserID = hs.dialog.textPrompt("Slack Status Updater", "Please provide your slack user ID")
  hs.settings.set("slack.userID", newUserID)
  userID = newUserID
end

if not apiKey then
  local _, newApiKey = hs.dialog.textPrompt("Slack Status Updater", "Please provide your slack app's OAuth Access Token")
  hs.settings.set("slack.apiKey", newApiKey)
  apiKey = newApiKey
end

function requestCallback(responseCode, responseBody, responseHeaders)
  log.i('Status updated', responseCode, responseBody)
  local res = hs.json.decode(responseBody)
  if responseCode ~= 200 or res.ok ~= true then
    slackStatusUpdated()
    hs.notify
      .new(
        function()
          hs.openConsole()
        end,
        {
          title="Slack Status Updater",
          informativeText="Cannot update your status, check logs for more details."
        }
      )
      :send()
  end
end

function updateSlackStatus(statusText, statusEmoji)
  statusText = statusText or ""
  statusEmoji = statusEmoji or ""

  local body = {
    user = userID,
    profile = {
      ["status_text"] = statusText,
      ["status_emoji"] = statusEmoji
    }
  }

  local headers = {
    Authorization = "Bearer " .. apiKey,
    ["Content-Type"] = "application/json; charset=utf-8"
  }

  local jsonBody = hs.json.encode(body)
  hs.http.asyncPost(
    'https://slack.com/api/users.profile.set',
    jsonBody,
    headers,
    requestCallback
  )
end

function sendSlackStatusRequest()
  if isAway then
    updateSlackStatus("Away", ":door:")
  else
    updateSlackStatus(nil, nil)
  end
end

hs.hotkey.bind(hyper, "a", function()
  slackStatusUpdated()
end)
