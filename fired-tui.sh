#!/bin/bash

# Function to display allowed ports
function show_allowed_ports() {
    allowed_ports=$(sudo firewall-cmd --list-ports)
    dialog --title "Allowed Ports" --msgbox "Currently allowed ports: \n$allowed_ports" 10 50
}

# Function to add a new port
function add_port() {
    port=$(dialog --inputbox "Enter the port number to allow (e.g., 8080/tcp or 5000-6000/udp):" 10 50 3>&1 1>&2 2>&3 3>&-)
    
    # Check if the user provided a port
    if [ -n "$port" ]; then
        sudo firewall-cmd --permanent --add-port=$port
        if [ $? -eq 0 ]; then
            dialog --title "Success" --msgbox "Port $port added successfully!" 6 40
        else
            dialog --title "Error" --msgbox "Failed to add port $port." 6 40
        fi
        # Reload firewall to apply changes
        sudo firewall-cmd --reload
    else
        dialog --title "Error" --msgbox "No port entered. Please try again." 6 40
    fi
}

# Main menu function
function main_menu() {
    while true; do
        choice=$(dialog --clear --backtitle "Firewall Port Manager" \
            --title "Main Menu" \
            --menu "Choose an option:" 15 50 3 \
            1 "Show Allowed Ports" \
            2 "Add New Port" \
            3 "Exit" \
            3>&1 1>&2 2>&3)

        case $choice in
            1) show_allowed_ports ;;
            2) add_port ;;
            3) break ;;
            *) dialog --msgbox "Invalid option. Please try again." 6 40 ;;
        esac
    done
    clear
}

# Run the main menu
main_menu
