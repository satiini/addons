local L = LibStub("AceLocale-3.0"):NewLocale("PvPTimer", "zhTW", true, debug)
if not L then return end

-- To help with missing translations please go here:
-- http://wow.curseforge.com/addons/pvptimer/localization/

L["Abilities that interrupt spellcasting or silence, e.g. Kick."] = "Abilities that interrupt spellcasting or silence, e.g. Kick." -- Requires localization
L["Abilities that make you lose control of your character, e.g. Fear or Polymorph."] = "Abilities that make you lose control of your character, e.g. Fear or Polymorph." -- Requires localization
L["Above on left"] = "Above on left" -- Requires localization
L["Above on right"] = "Above on right" -- Requires localization
L["Above or below, centered"] = "Above or below, centered" -- Requires localization
L["Above or below, on left"] = "Above or below, on left" -- Requires localization
L["Above or below, on right"] = "Above or below, on right" -- Requires localization
L["Addon loaded."] = "Addon loaded." -- Requires localization
L["Alert Messages"] = "Alert Messages" -- Requires localization
L["Alert Target"] = "Alert Target" -- Requires localization
L["Anchor point"] = "Anchor point" -- Requires localization
L["Anchors are locations on screen to which timers are added."] = "Anchors are locations on screen to which timers are added." -- Requires localization
L["Anchor Settings"] = "Anchor Settings" -- Requires localization
L["Anchor that shows information about arena opponents."] = "Anchor that shows information about arena opponents." -- Requires localization
L["Anchor that shows information about your current focus target."] = "Anchor that shows information about your current focus target." -- Requires localization
L["Anchor that shows information about your current target."] = "Anchor that shows information about your current target." -- Requires localization
L["Anything else. Spells that don't really fit into other categories."] = "Anything else. Spells that don't really fit into other categories." -- Requires localization
L["Applies settings in memory."] = "Applies settings in memory." -- Requires localization
L["Arenas"] = "Arenas" -- Requires localization
L["Arena Targets"] = "Arena Targets" -- Requires localization
L["Arrange bars into columns."] = "Arrange bars into columns." -- Requires localization
L["Arrange bars into columns. (0: automatic)"] = "Arrange bars into columns. (0: automatic)" -- Requires localization
L["Background color"] = "Background color" -- Requires localization
L["Background texture"] = "Background texture" -- Requires localization
L["Bar color"] = "Bar color" -- Requires localization
L["Bar start point"] = "Bar start point" -- Requires localization
L["Bar texture"] = "Bar texture" -- Requires localization
L["Base cooldown: "] = "Base cooldown: " -- Requires localization
L["Battleground chat"] = "Battleground chat" -- Requires localization
L["Battlegrounds"] = "Battlegrounds" -- Requires localization
L["Be careful when using these alerts, they can send out a lot of messages. People will likely yell at you or /ignore you if you spam alerts in a public channel."] = "Be careful when using these alerts, they can send out a lot of messages. People will likely yell at you or /ignore you if you spam alerts in a public channel." -- Requires localization
L["Below on left"] = "Below on left" -- Requires localization
L["Below on right"] = "Below on right" -- Requires localization
L["Bottom"] = "Bottom" -- Requires localization
L["Bottom Left"] = "Bottom Left" -- Requires localization
L["Bottom Right"] = "Bottom Right" -- Requires localization
L["Category"] = "Category" -- Requires localization
L["Category Color"] = "Category Color" -- Requires localization
L["Category Filter"] = "Category Filter" -- Requires localization
L["CAUTION"] = "CAUTION" -- Requires localization
L["Center"] = "Center" -- Requires localization
L["Changes the background color when the effect begins. Does not apply in icon mode."] = "Changes the background color when the effect begins. Does not apply in icon mode." -- Requires localization
L["Changes the background texture when the effect begins. Does not apply in icon mode."] = "Changes the background texture when the effect begins. Does not apply in icon mode." -- Requires localization
L["Channel"] = "Channel" -- Requires localization
L["Chat"] = "Chat" -- Requires localization
L["Class"] = "Class" -- Requires localization
L["Class Filter"] = "Class Filter" -- Requires localization
L["Click here to enable/disable the glyph of this spell for this talent spec. This should make the cooldown timers more accurate."] = "Click here to enable/disable the glyph of this spell for this talent spec. This should make the cooldown timers more accurate." -- Requires localization
L["Click here to enable/disable the glyph of this spell when the unit's talent spec is unknown. This should make the cooldown timers more accurate."] = "Click here to enable/disable the glyph of this spell when the unit's talent spec is unknown. This should make the cooldown timers more accurate." -- Requires localization
L["Click here to enable/disable this item."] = "Click here to enable/disable this item." -- Requires localization
L["Click here to enable/disable this racial."] = "Click here to enable/disable this racial." -- Requires localization
L["Click here to enable/disable this spell."] = "Click here to enable/disable this spell." -- Requires localization
L["Columns"] = "Columns" -- Requires localization
L["Combat Text"] = "Combat Text" -- Requires localization
L["Cooldown"] = "Cooldown" -- Requires localization
L["Cooldowns that increase damage output, e.g. Recklessness."] = "Cooldowns that increase damage output, e.g. Recklessness." -- Requires localization
L["Copies settings on this page to memory."] = "Copies settings on this page to memory." -- Requires localization
L["Copy Settings"] = "Copy Settings" -- Requires localization
L["Crowd Control"] = "Crowd Control" -- Requires localization
L["Custom Anchor"] = "Custom Anchor" -- Requires localization
L["Customize the message displayed when the alert is triggered. You can use the following tags:"] = "Customize the message displayed when the alert is triggered. You can use the following tags:" -- Requires localization
L["Default Chat Frame"] = "Default Chat Frame" -- Requires localization
L["Default timer bar color."] = "Default timer bar color." -- Requires localization
L["Defensive and healing cooldowns, e.g. Shield Wall or Swiftmend."] = "Defensive and healing cooldowns, e.g. Shield Wall or Swiftmend." -- Requires localization
L["Defensive CDs"] = "Defensive CDs" -- Requires localization
L["- DISABLED -"] = "- DISABLED -" -- Requires localization
L["Distance between frames X"] = "Distance between frames X" -- Requires localization
L["Distance between frames Y"] = "Distance between frames Y" -- Requires localization
L["Duration"] = "Duration" -- Requires localization
L["Enable alerts"] = "Enable alerts" -- Requires localization
L["Enable anchor"] = "Enable anchor" -- Requires localization
L["Enable or disable alerts regardless of other settings."] = "Enable or disable alerts regardless of other settings." -- Requires localization
L["Enable or disable anywhere else not specified above."] = "Enable or disable anywhere else not specified above." -- Requires localization
L["Enable or disable in arenas."] = "Enable or disable in arenas." -- Requires localization
L["Enable or disable in normal, non-rated Battlegrounds."] = "Enable or disable in normal, non-rated Battlegrounds." -- Requires localization
L["Enable or disable in rated Battlegrounds."] = "Enable or disable in rated Battlegrounds." -- Requires localization
L["Enables or disables this anchor."] = "Enables or disables this anchor." -- Requires localization
L["Everywhere else"] = "Everywhere else" -- Requires localization
L["FADED"] = "FADED" -- Requires localization
L["Fade out"] = "Fade out" -- Requires localization
L["Faked RW"] = "Faked RW" -- Requires localization
L["Focus"] = "Focus" -- Requires localization
L["Font"] = "Font" -- Requires localization
L["Font size"] = "Font size" -- Requires localization
L["Format of the label's text. Use |CFF00FF00%spell%|r to substitute the spell name, |CFF00FF00%player%|r for the player's name."] = "Format of the label's text. Use |CFF00FF00%spell%|r to substitute the spell name, |CFF00FF00%player%|r for the player's name." -- Requires localization
L["Ghost"] = "Ghost" -- Requires localization
L["Glyph"] = "Glyph" -- Requires localization
L["Glyph modifier: "] = "Glyph modifier: " -- Requires localization
L["Group"] = "Group" -- Requires localization
L["Group anchors show all spells in a category, grouped together."] = "Group anchors show all spells in a category, grouped together." -- Requires localization
L["Horizontal distance between each arena frame."] = "Horizontal distance between each arena frame." -- Requires localization
L["Horizontal offset."] = "Horizontal offset." -- Requires localization
L["Horizontal space between timers."] = "Horizontal space between timers." -- Requires localization
L["Horizontal spacing"] = "Horizontal spacing" -- Requires localization
L["Icon Mode"] = "Icon Mode" -- Requires localization
L["Icon Size"] = "Icon Size" -- Requires localization
L["Interrupts and Silences"] = "Interrupts and Silences" -- Requires localization
L["Invalid frame. Resetting to default."] = "Invalid frame. Resetting to default." -- Requires localization
L["Item"] = "Item" -- Requires localization
L["Label Format"] = "Label Format" -- Requires localization
L["Left"] = "Left" -- Requires localization
L["Length"] = "Length" -- Requires localization
L["Limit the number of visible bars. (0: no limit)"] = "Limit the number of visible bars. (0: no limit)" -- Requires localization
L["Lock anchors"] = "Lock anchors" -- Requires localization
L["Locks or unlocks anchors so they can be dragged around and resized using the mouse."] = "Locks or unlocks anchors so they can be dragged around and resized using the mouse." -- Requires localization
L["Message"] = "Message" -- Requires localization
L["Messages are sent to this window or addon. You may have to reload your interface (type /rl) to make any changes to other addons like MSBT visible."] = "Messages are sent to this window or addon. You may have to reload your interface (type /rl) to make any changes to other addons like MSBT visible." -- Requires localization
L["MESSAGE_TAG1"] = "|cFF00FF00%spell%|r Name of the spell." -- Requires localization
L["MESSAGE_TAG10"] = "|cFF00FF00%player2%|r Name of the player who cast the spell (with realm name if crossrealm)." -- Requires localization
L["MESSAGE_TAG2"] = "|cFF00FF00%player%|r Name of the player who cast the spell." -- Requires localization
L["MESSAGE_TAG3"] = "|cFF00FF00%spec%|r Talent spec of the player who cast the spell." -- Requires localization
L["MESSAGE_TAG4"] = "|cFF00FF00%icon%|r Icon of the spell." -- Requires localization
L["MESSAGE_TAG5"] = "|cFF00FF00%icon_s%|r Icon of the casting player's talent spec." -- Requires localization
L["MESSAGE_TAG6"] = "|cFF00FF00%color%|r Use the spell category color for the following text." -- Requires localization
L["MESSAGE_TAG7"] = "|cFF00FF00%color_c%|r Use the player's class color for the following text." -- Requires localization
L["MESSAGE_TAG8"] = "|cFF00FF00%color_s%|r Use the talent spec color for the following text." -- Requires localization
L["MESSAGE_TAG9"] = "|cFF00FF00||r|r Return to original color." -- Requires localization
L["Miscellaneous Spells"] = "Miscellaneous Spells" -- Requires localization
L["Move anchors around by dragging their title bar. Resize them by dragging their lower right corner. Click 'Run Test' to add some test timers. Click 'Lock Anchors' when you're done."] = "Move anchors around by dragging their title bar. Resize them by dragging their lower right corner. Click 'Run Test' to add some test timers. Click 'Lock Anchors' when you're done." -- Requires localization
L["Name"] = "Name" -- Requires localization
L["No outline"] = "No outline" -- Requires localization
L["Normal outline"] = "Normal outline" -- Requires localization
L["Offensive CDs"] = "Offensive CDs" -- Requires localization
L["Offset X"] = "Offset X" -- Requires localization
L["Offset Y"] = "Offset Y" -- Requires localization
L["Only target/focus"] = "Only target/focus" -- Requires localization
L["Only trigger alerts if source is the current target or focus."] = "Only trigger alerts if source is the current target or focus." -- Requires localization
L["Opacity"] = "Opacity" -- Requires localization
L["Opens the Spell Configuration window, where you can disable and adjust spells."] = "Opens the Spell Configuration window, where you can disable and adjust spells." -- Requires localization
L["Outline"] = "Outline" -- Requires localization
L["Outline of the font."] = "Outline of the font." -- Requires localization
L["Party chat"] = "Party chat" -- Requires localization
L["Paste Settings"] = "Paste Settings" -- Requires localization
L["Plays a sound when the alert is triggered."] = "Plays a sound when the alert is triggered." -- Requires localization
L["Play Sound"] = "Play Sound" -- Requires localization
L["Position"] = "Position" -- Requires localization
L["Position of the anchor."] = "Position of the anchor." -- Requires localization
L["Position of the icon."] = "Position of the icon." -- Requires localization
L["Position of the timer text."] = "Position of the timer text." -- Requires localization
L["PvPTimer Spell Configuration"] = "PvPTimer Spell Configuration" -- Requires localization
L["Racial"] = "Racial" -- Requires localization
L["Raid chat"] = "Raid chat" -- Requires localization
L["Raid Warning"] = "Raid Warning" -- Requires localization
L["Rated Battlegrounds"] = "Rated Battlegrounds" -- Requires localization
L["READY"] = "READY" -- Requires localization
L["Relative point"] = "Relative point" -- Requires localization
L["Relative to"] = "Relative to" -- Requires localization
L["Right"] = "Right" -- Requires localization
L["Roots and Snares"] = "Roots and Snares" -- Requires localization
L["Run Test"] = "Run Test" -- Requires localization
L["Scale"] = "Scale" -- Requires localization
L["Scale of the anchor."] = "Scale of the anchor." -- Requires localization
L["Select the sound you want played when the alert is triggered."] = "Select the sound you want played when the alert is triggered." -- Requires localization
L["Sets a 'spark' for the bar, which is a bright vertical bar at the end of the timerbar, making it easier to see its progress."] = "Sets a 'spark' for the bar, which is a bright vertical bar at the end of the timerbar, making it easier to see its progress." -- Requires localization
L["Sets the amount of time the timer takes to fade out when it finishes. Set to 0 to disable."] = "Sets the amount of time the timer takes to fade out when it finishes. Set to 0 to disable." -- Requires localization
L["Sets the duration that the timer persists after expiring as a ghost. Set to 0 to disable."] = "Sets the duration that the timer persists after expiring as a ghost. Set to 0 to disable." -- Requires localization
L[ [=[Sets the frame to be anchored to.
Use 'UIParent' for the whole screen.]=] ] = [=[Sets the frame to be anchored to.
Use 'UIParent' for the whole screen.]=] -- Requires localization
L["Sets the opacity (alpha)."] = "Sets the opacity (alpha)." -- Requires localization
L["Sets the point that will be anchored."] = "Sets the point that will be anchored." -- Requires localization
L["Sets the point to be anchored to."] = "Sets the point to be anchored to." -- Requires localization
L["Set the corner and side bars start from."] = "Set the corner and side bars start from." -- Requires localization
L["Settings"] = "Settings" -- Requires localization
L["Show"] = "Show" -- Requires localization
L["Show a message in place of the bar's timer."] = "Show a message in place of the bar's timer." -- Requires localization
L["Show anchor in"] = "Show anchor in" -- Requires localization
L["Show icon on left side"] = "Show icon on left side" -- Requires localization
L["Show icon on right side"] = "Show icon on right side" -- Requires localization
L["Show icons instead of bars."] = "Show icons instead of bars." -- Requires localization
L["Shows an icon that displays the player's talent specialization. Set to 0 to disable."] = "Shows an icon that displays the player's talent specialization. Set to 0 to disable." -- Requires localization
L["Show spark"] = "Show spark" -- Requires localization
L["Shows some test bars."] = "Shows some test bars." -- Requires localization
L["Shows the spell's icon on the left side of the bar."] = "Shows the spell's icon on the left side of the bar." -- Requires localization
L["Shows the spell's icon on the right side of the bar."] = "Shows the spell's icon on the right side of the bar." -- Requires localization
L["Size of the icons."] = "Size of the icons." -- Requires localization
L["Sound"] = "Sound" -- Requires localization
L["Spec 1"] = "Spec 1" -- Requires localization
L["Spec 2"] = "Spec 2" -- Requires localization
L["Spec 3"] = "Spec 3" -- Requires localization
L["SPECCED"] = "SPECCED" -- Requires localization
L["Spec Detection"] = "Spec Detection" -- Requires localization
L["Spec icon size"] = "Spec icon size" -- Requires localization
L["Spell Categories"] = "Spell Categories" -- Requires localization
L["SPELLCONFIG_HELPMSG"] = [=[Click a spell's name to enable or disable it.

To change its category, point at the category name and use the dropdown menu.

Click on the on/off buttons to assume the spell is glyphed for that talent specialization. (? is unknown spec)]=] -- Requires localization
L["Spell Configuration"] = "Spell Configuration" -- Requires localization
L["Spell cooldowns are organized into categories."] = "Spell cooldowns are organized into categories." -- Requires localization
L["Spell Name"] = "Spell Name" -- Requires localization
L["Spells that restrict or prevent movement, e.g. Frost Nova or Hamstring."] = "Spells that restrict or prevent movement, e.g. Frost Nova or Hamstring." -- Requires localization
L["Talent spec detection alerts."] = "Talent spec detection alerts." -- Requires localization
L["Talent specialization icon"] = "Talent specialization icon" -- Requires localization
L["Target"] = "Target" -- Requires localization
L["Texture of timer bars."] = "Texture of timer bars." -- Requires localization
L["Thick outline"] = "Thick outline" -- Requires localization
L["Timer bars"] = "Timer bars" -- Requires localization
L["Timer bar settings."] = "Timer bar settings." -- Requires localization
L["Timer bars for spells in this category will appear in this color."] = "Timer bars for spells in this category will appear in this color." -- Requires localization
L["Time Remaining"] = "Time Remaining" -- Requires localization
L["Top"] = "Top" -- Requires localization
L["Top Left"] = "Top Left" -- Requires localization
L["Top Right"] = "Top Right" -- Requires localization
L["Unknown Spec"] = "Unknown Spec" -- Requires localization
L["Unlock anchors"] = "Unlock anchors" -- Requires localization
L["USED"] = "USED" -- Requires localization
L["Use spell category color"] = "Use spell category color" -- Requires localization
L["Use spell category color (defined in Spell Categories) instead."] = "Use spell category color (defined in Spell Categories) instead." -- Requires localization
L["Vertical distance between each arena frame."] = "Vertical distance between each arena frame." -- Requires localization
L["Vertical offset."] = "Vertical offset." -- Requires localization
L["Vertical space between timers."] = "Vertical space between timers." -- Requires localization
L["Vertical spacing"] = "Vertical spacing" -- Requires localization
L["Visible Bars"] = "Visible Bars" -- Requires localization
L["Width"] = "Width" -- Requires localization
L["Width of the anchor."] = "Width of the anchor." -- Requires localization
L["You can use these to display certain important spells in a separate anchor. Use the Spell Configuration menu to move spells here."] = "You can use these to display certain important spells in a separate anchor. Use the Spell Configuration menu to move spells here." -- Requires localization

