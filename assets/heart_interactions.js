// Initialize hotspot functionality when the document is ready
document.addEventListener("DOMContentLoaded", () => {
	const hotspots = document.querySelectorAll(".hotspot");

	// Track currently selected hotspot
	let activeHotspot = null;

	// Add click handlers to all hotspots
	for (const hotspot of hotspots) {
		// Initialize visibility state
		hotspot.setAttribute("data-visible", "false");

		hotspot.addEventListener("click", (event) => {
			// Prevent event bubbling
			event.stopPropagation();

			// Reset previously active hotspot
			if (activeHotspot && activeHotspot !== hotspot) {
				activeHotspot.setAttribute("data-visible", "false");
			}

			// Toggle current hotspot
			const isVisible = hotspot.getAttribute("data-visible") === "true";
			hotspot.setAttribute("data-visible", (!isVisible).toString());

			// Update active hotspot reference
			activeHotspot = isVisible ? null : hotspot;

			// Send selected part information to Flutter
			const partName = hotspot.getAttribute("data-part");
			if (partName && window.flutterChannel) {
				window.flutterChannel.postMessage(partName);
			}
		});

		// Add hover effects
		hotspot.addEventListener("mouseenter", () => {
			if (hotspot !== activeHotspot) {
				hotspot.style.transform = "scale(1.1)";
			}
		});

		hotspot.addEventListener("mouseleave", () => {
			if (hotspot !== activeHotspot) {
				hotspot.style.transform = "scale(1)";
			}
		});
	}

	// Optional: Click outside to deselect
	document.addEventListener("click", (event) => {
		if (!event.target.closest(".hotspot") && activeHotspot) {
			activeHotspot.setAttribute("data-visible", "false");
			activeHotspot = null;
			// Notify Flutter that selection was cleared
			if (window.flutterChannel) {
				window.flutterChannel.postMessage("");
			}
		}
	});
});
