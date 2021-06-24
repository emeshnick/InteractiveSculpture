# InteractiveSculpture

## Overview

This processing program communicates with Max to create an interactive sculpture. The 3D camera tracks the user's hand. In a given area, the space is divided into sections. As the user moves their hand through the space the program sends messages to Max through OSC with the current section that has been triggered. Max can interpret this in a multitude of ways, such as having different sounds played based on the message that is received.

## Requirements

Runs with the Processing Java environment. Requires an XBox Connect connected to the computer. Install the Connect and OSC library in processing.
