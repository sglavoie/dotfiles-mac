#!/bin/zsh

# https://macos-defaults.com
# Discover:
# defaults domains              # list all preference domains (comma-separated)
# defaults domains | tr ',' '\n' | sort   # readable list
# defaults read                 # dump ALL prefs (huge)
# defaults read com.apple.dock  # dump one domain's current values
# defaults read-type com.apple.dock autohide   # show value type

echo "Setting $(defaults) values..."

# Reset a setting with `defaults delete`
# e.g.: defaults delete com.apple.dock tilesize

##################################
# System settings
# (most changes require a restart)
##################################

defaults write -g NSScrollViewRubberbanding -int 0
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
defaults write NSGlobalDomain NSUseAnimatedFocusRing -bool false
defaults write NSGlobalDomain NSToolbarTitleViewRolloverDelay -float 0

# Window management: make ctrl+cmd with mouse click drag a window
defaults write -g NSWindowShouldDragOnGesture YES

##########
# Keyboard
##########

defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true

# Choose whether to enable moving focus with Tab and Shift Tab.
defaults write NSGlobalDomain AppleKeyboardUIMode -int "2"

# Appearance
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"
defaults write NSGlobalDomain AppleReduceDesktopTinting -bool true

# Scrolling direction (natural = true, traditional = false)
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Disable automatic termination of inactive apps
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

# Disable automatic capitalization as it's annoying when typing code
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

######
# Dock
######

defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -int 48

# Minimize windows into their application's icon
defaults write com.apple.dock minimize-to-application -bool true

# Don't animate opening applications from the Dock
defaults write com.apple.dock launchanim -bool false

# Don't automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Don't show recent applications in Dock
defaults write com.apple.dock show-recents -bool false

# Dock opening delay
defaults write com.apple.dock "autohide-delay" -float "5"

# Scroll up on a Dock icon to show all Space's opened windows for an app, or open stack.
defaults write com.apple.dock "scroll-to-open" -bool "true"

# Group windows by application
defaults write com.apple.dock "expose-group-apps" -bool "true"

########
# Finder
########

defaults write com.apple.desktopservices DSDontWriteNetworkStores true
defaults write com.apple.finder DisableAllAnimations -bool true
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.LaunchServices LSQuarantine -bool false
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathbar -bool true
# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true
# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Automatically open a new Finder window when a volume is mounted
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `glyv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

########
# Safari
########

defaults write com.apple.Safari "ShowFullURLInSmartSearchField" -bool "true"

#############
# Disk images
#############

# Disable disk image verification
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

##################
# Activity monitor
##################

# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

# Sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

defaults write com.apple.ActivityMonitor "UpdatePeriod" -int "1"

# Prevent Photos from opening automatically when devices are plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

######
# Misc
######

Displays have separate Spaces
defaults write com.apple.spaces "spans-displays" -bool "true"

# Screenshots
defaults write com.apple.screencapture type -string "png"

# Clock
defaults write com.apple.menuextra.clock "DateFormat" -string "\"EEE HH:mm:ss\""

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Prevents the OS from asking for "Developer Tools Access"
sudo DevToolsSecurity -enable
sudo dscl . append /Groups/_developer GroupMembership $USER

killall Activity\ Monitor
killall Dock
killall Finder
killall Safari
killall SystemUIServer
