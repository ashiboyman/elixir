// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import topbar from "../vendor/topbar"
let Hooks = {}

// Draggable hook for task cards
// Draggable hook for task cards
Hooks.Draggable = {
  mounted() {
    this.setupDrag();
  },
  updated() {
    this.setupDrag();
  },
  setupDrag() {
    this.el.setAttribute("draggable", true);

    // Remove existing event listeners if any
    this.el.removeEventListener("dragstart", this.dragStartHandler);
    this.el.removeEventListener("dragend", this.dragEndHandler);

    // Define new event handlers
    this.dragStartHandler = event => {
      event.dataTransfer.effectAllowed = "move";
      event.dataTransfer.setData("text/plain", this.el.id);
      this.el.classList.add("opacity-50");
      console.log("Drag started:", this.el.id);
    };

    this.dragEndHandler = event => {
      this.el.classList.remove("opacity-50");
      console.log("Drag ended:", this.el.id);
    };

    // Add new event listeners
    this.el.addEventListener("dragstart", this.dragStartHandler);
    this.el.addEventListener("dragend", this.dragEndHandler);
  }
};

// DropTarget hook for column drop zones
// DropTarget hook for column drop zones
Hooks.DropTarget = {
  mounted() {
    this.setupDrop();
    
    // Listen for task_updated events
    this.handleEvent("task_updated", ({ id, status }) => {
      const taskElement = document.getElementById(`task-${id}`);
      if (!taskElement) return;
      
      // Get the target column based on status
      const targetColumn = document.getElementById(`drop-${status}`);
      if (!targetColumn) return;
      
      // Find the task container in the target column
      const taskContainer = targetColumn.querySelector(".task-container");
      if (!taskContainer) return;
      
      // Move the task element to the new container
      taskContainer.appendChild(taskElement);
      
      console.log(`Moved task ${id} to ${status} column via event`);
    });
  },
  updated() {
    this.setupDrop();
  },
  setupDrop() {
    // Previous implementation remains the same...
    // Remove existing event listeners if any
    this.el.removeEventListener("dragover", this.dragOverHandler);
    this.el.removeEventListener("dragleave", this.dragLeaveHandler);
    this.el.removeEventListener("drop", this.dropHandler);
    
    // Define new event handlers
    this.dragOverHandler = event => {
      event.preventDefault();
      event.dataTransfer.dropEffect = "move";
      this.el.classList.add("bg-gray-100");
    };
    
    this.dragLeaveHandler = event => {
      this.el.classList.remove("bg-gray-100");
    };
    
    this.dropHandler = event => {
      event.preventDefault();
      this.el.classList.remove("bg-gray-100");
      let draggedId = event.dataTransfer.getData("text/plain");
      console.log("Dropped element:", draggedId);
      if (draggedId) {
        let id = draggedId.replace("task-", "");
        let newStatus = this.el.getAttribute("data-status");
        console.log("New status from drop zone:", newStatus);
        
        // Move task immediately in the DOM for instant feedback
        const taskElement = document.getElementById(draggedId);
        const taskContainer = this.el.querySelector(".task-container");
        if (taskElement && taskContainer) {
          taskContainer.appendChild(taskElement);
        }
        
        this.pushEvent("update_status", { id, status: newStatus });
      }
    };
    
    // Add new event listeners
    this.el.addEventListener("dragover", this.dragOverHandler);
    this.el.addEventListener("dragleave", this.dragLeaveHandler);
    this.el.addEventListener("drop", this.dropHandler);
  }
};



let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: { _csrf_token: csrfToken },
  hooks: Hooks
})

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" })
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

