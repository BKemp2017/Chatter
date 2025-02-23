// Import Phoenix Socket library
import { Socket } from "phoenix";

// Establish a connection to the socket path
let socket = new Socket("/socket", { params: { user_id: "guest", token: "123" } });
socket.connect();

// Join the chat room channel
let channel = socket.channel("chat_room:lobby", { user_id: "guest" });

document.addEventListener("DOMContentLoaded", function () {
  console.log("✅ DOM loaded, initializing chat...");

  // Get UI elements
  let messageInput = document.getElementById("message-input");
  let sendButton = document.getElementById("send-button");
  let messageList = document.getElementById("messages");

  // Debugging: Ensure UI elements exist
  if (!messageInput || !sendButton || !messageList) {
    console.error("❌ Chat UI elements not found! Check your HTML structure.");
    return;
  }

  console.log("✅ Chat UI elements found, setting up listeners...");

  // Handle successful channel join
  channel
    .join()
    .receive("ok", (resp) => {
      console.log("✅ Joined chat room successfully:", resp);
    })
    .receive("error", (resp) => {
      console.error("❌ Unable to join chat room:", resp);
    });

  // Listen for new messages from the server
  channel.on("new_message", (payload) => {
    console.log(`📩 New message received from ${payload.name}: "${payload.message}"`);

    let newMsg = document.createElement("li");
    newMsg.innerHTML = `<b>${payload.name || "Anonymous"}:</b> ${payload.message}`;
    messageList.appendChild(newMsg);
    messageList.scrollTop = messageList.scrollHeight; // Auto-scroll to the latest message
  });

  // Send message when the button is clicked
  sendButton.addEventListener("click", (event) => {
    event.preventDefault();
    let message = messageInput.value.trim();

    if (message.length > 0) {
      console.log("📤 Sending message:", message);

      channel
        .push("new_message", { message: message, name: "User" })
        .receive("ok", (resp) => console.log("✅ Message sent successfully:", resp))
        .receive("error", (resp) => console.error("❌ Failed to send message:", resp));

      messageInput.value = "";
    } else {
      console.warn("⚠️ Empty message not sent.");
    }
  });
});

// Export socket for use in other files
export default socket;
