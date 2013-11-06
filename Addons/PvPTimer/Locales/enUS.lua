local L = LibStub("AceLocale-3.0"):NewLocale("PvPTimer", "enUS", true, debug)
if not L then return end

-- To help with missing translations please go here:
-- http://wow.curseforge.com/addons/pvptimer/localization/

L["Addon loaded."] = true

-- Alert Messages
L["SPECCED"] = true
L["USED"] = true
L["FADED"] = true
L["READY"] = true

-- Config window
L["Settings"] = true
L["Invalid frame. Resetting to default."] = true
L["CAUTION"] = true
L["Be careful when using these alerts, they can send out a lot of messages. People will likely yell at you or /ignore you if you spam alerts in a public channel."] = true

L["Enable alerts"] = true
L["Enable or disable alerts regardless of other settings."] = true
L["Alert Target"] = true
L["Battlegrounds"] = true
L["Enable or disable in normal, non-rated Battlegrounds."] = true
L["Only target/focus"] = true
L["Only trigger alerts if source is the current target or focus."] = true
L["Rated Battlegrounds"] = true
L["Enable or disable in rated Battlegrounds."] = true
L["Only target/focus"] = true
L["Only trigger alerts if source is the current target or focus."] = true
L["Enable or disable in arenas."] = true
L["Only target/focus"] = true
L["Only trigger alerts if source is the current target or focus."] = true
L["Everywhere else"] = true
L["Enable or disable anywhere else not specified above."] = true
L["Only target/focus"] = true
L["Only trigger alerts if source is the current target or focus."] = true
L["Enable anchor"] = true
L["Enables or disables this anchor."] = true
L["Width"] = true
L["Width of the anchor."] = true
L["Scale"] = true
L["Scale of the anchor."] = true
L["Show anchor in"] = true
L["Battlegrounds"] = true
L["Enable or disable in normal, non-rated Battlegrounds."] = true
L["Rated Battlegrounds"] = true
L["Enable or disable in rated Battlegrounds."] = true
L["Arenas"] = true
L["Enable or disable in arenas."] = true
L["Everywhere else"] = true
L["Enable or disable anywhere else not specified above."] = true
L["Position"] = true
L["Position of the anchor."] = true
L["Anchor point"] = true
L["Sets the point that will be anchored."] = true
L["Relative to"] = true
L["Sets the frame to be anchored to.\nUse 'UIParent' for the whole screen."] = true
L["Relative point"] = true
L["Sets the point to be anchored to."] = true
L["Offset X"] = true
L["Horizontal offset."] = true
L["Offset Y"] = true
L["Vertical offset."] = true
L["Timer bars"] = true
L["Timer bar settings."] = true
L["Bar color"] = true
L["Default timer bar color."] = true
L["Use spell category color"] = true
L["Use spell category color (defined in Spell Categories) instead."] = true
L["Columns"] = true
L["Arrange bars into columns."] = true
L["Bar texture"] = true
L["Texture of timer bars."] = true
L["Spell Name"] = true
L["Time Remaining"] = true
L["Distance between frames X"] = true
L["Horizontal distance between each arena frame."] = true
L["Distance between frames Y"] = true
L["Vertical distance between each arena frame."] = true
L["Offensive CDs"] = true
L["Cooldowns that increase damage output, e.g. Recklessness."] = true
L["Defensive CDs"] = true
L["Defensive and healing cooldowns, e.g. Shield Wall or Swiftmend."] = true
L["Interrupts and Silences"] = true
L["Abilities that interrupt spellcasting or silence, e.g. Kick."] = true
L["Crowd Control"] = true
L["Abilities that make you lose control of your character, e.g. Fear or Polymorph."] = true
L["Roots and Snares"] = true
L["Spells that restrict or prevent movement, e.g. Frost Nova or Hamstring."] = true
L["Miscellaneous Spells"] = true
L["Anything else. Spells that don't really fit into other categories."] = true
L["Spell Configuration"] = true
L["Opens the Spell Configuration window, where you can disable and adjust spells."] = true
L["Target"] = true
L["Anchor that shows information about your current target."] = true
L["Focus"] = true
L["Anchor that shows information about your current focus target."] = true
L["Arena Targets"] = true
L["Anchor that shows information about arena opponents."] = true
L["Spec Detection"] = true
L["Talent spec detection alerts."] = true

-- Spellconfig
L["Name"] = true
L["Class"] = true
L["Category"] = true
L["Duration"] = true
L["Cooldown"] = true
L["Glyph"] = true
L["Spec 1"] = true
L["Spec 2"] = true
L["Spec 3"] = true
L["Spec 4"] = true
L["Click here to enable/disable the glyph of this spell when the unit's talent spec is unknown. This should make the cooldown timers more accurate."] = true
L["Click here to enable/disable the glyph of this spell for this talent spec. This should make the cooldown timers more accurate."] = true
L["Click here to enable/disable this spell."] = true
L["Click here to enable/disable this item."] = true
L["Click here to enable/disable this racial."] = true
L["Base cooldown: "] = true
L["Glyph modifier: "] = true
L["Unknown Spec"] = true
L["PvPTimer Spell Configuration"] = true

--new in 2.0
L["Lock anchors"] = true
L["Unlock anchors"] = true
L["Locks or unlocks anchors so they can be dragged around and resized using the mouse."] = true
L["Run Test"] = true
L["Shows some test bars."] = true

L["Font"] = true
L["Font size"] = true
L["Bar start point"] = true
L["Set the corner and side bars start from."] = true
L["Arrange bars into columns. (0: automatic)"] = true
L["Icon Mode"] = true
L["Show icons instead of bars."] = true
L["Icon Size"] = true
L["Size of the icons."] = true

L["Anchor Settings"] = true
L["Anchors are locations on screen to which timers are added."] = true
L["Alert Messages"] = true
L["Spell Categories"] = true
L["Spell cooldowns are organized into categories."] = true

L["Ghost"] = true
L["Duration"] = true
L["Sets the duration that the timer persists after expiring as a ghost. Set to 0 to disable."] = true
L["Background color"] = true
L["Changes the background color when the effect begins. Does not apply in icon mode."] = true
L["Message"] = true
L["Show a message in place of the bar's timer."] = true

L["Fade out"] = true
L["Length"] = true
L["Sets the amount of time the timer takes to fade out when it finishes. Set to 0 to disable."] = true
L["Position of the icon."] = true

L["Talent specialization icon"] = true
L["Spec icon size"] = true
L["Shows an icon that displays the player's talent specialization. Set to 0 to disable."] = true

L["Visible Bars"] = true
L["Limit the number of visible bars. (0: no limit)"] = true

L["Default Chat Frame"] = true
L["Faked RW"] = true
L["Party chat"] = true
L["Raid chat"] = true
L["Battleground chat"] = true
L["Raid Warning"] = true

L["Top Left"] = true
L["Top"] = true
L["Top Right"] = true
L["Left"] = true
L["Center"] = true
L["Right"] = true
L["Bottom Left"] = true
L["Bottom"] = true
L["Bottom Right"] = true

L["Above or below, on left"] = true
L["Above or below, centered"] = true
L["Above or below, on right"] = true

L["Below on right"] = true
L["Below on left"] = true
L["Above on right"] = true
L["Above on left"] = true

-- new in 2.1
L["- DISABLED -"] = true
L["Messages are sent to this window or addon. You may have to reload your interface (type /rl) to make any changes to other addons like MSBT visible."] = true

L["Message"] = true
L["Customize the message displayed when the alert is triggered. You can use the following tags:"] = true
L["Play Sound"] = true
L["Plays a sound when the alert is triggered."] = true
L["Sound"] = true
L["Select the sound you want played when the alert is triggered."] = true

L["MESSAGE_TAG1"] = "|cFF00FF00%spell%|r Name of the spell."
L["MESSAGE_TAG2"] = "|cFF00FF00%player%|r Name of the player who cast the spell."
L["MESSAGE_TAG3"] = "|cFF00FF00%spec%|r Talent spec of the player who cast the spell."
L["MESSAGE_TAG4"] = "|cFF00FF00%icon%|r Icon of the spell."
L["MESSAGE_TAG5"] = "|cFF00FF00%icon_s%|r Icon of the casting player's talent spec."
L["MESSAGE_TAG6"] = "|cFF00FF00%color%|r Use the spell category color for the following text."
L["MESSAGE_TAG7"] = "|cFF00FF00%color_c%|r Use the player's class color for the following text."
L["MESSAGE_TAG8"] = "|cFF00FF00%color_s%|r Use the talent spec color for the following text."
L["MESSAGE_TAG9"] = "|cFF00FF00||r|r Return to original color."
L["MESSAGE_TAG10"] = "|cFF00FF00%player2%|r Name of the player who cast the spell (with realm name if crossrealm)."

L["Move anchors around by dragging their title bar. Resize them by dragging their lower right corner. Click 'Run Test' to add some test timers. Click 'Lock Anchors' when you're done."] = true

-- new in 2.1.1

L["Show icon on left side"] = true
L["Shows the spell's icon on the left side of the bar."] = true
L["Show icon on right side"] = true
L["Shows the spell's icon on the right side of the bar."] = true
L["Show spark"] = true
L["Sets a 'spark' for the bar, which is a bright vertical bar at the end of the timerbar, making it easier to see its progress."] = true
L["Show"] = true

-- new in 2.2

L["Group"] = true
L["Label Format"] = true
L["Format of the label's text. Use |CFF00FF00%spell%|r to substitute the spell name, |CFF00FF00%player%|r for the player's name."] = true

-- new in 2.2.1

L["Opacity"] = true
L["Sets the opacity (alpha)."] = true

-- new in 2.2.3

L["Chat"] = true
L["Channel"] = true
L["Combat Text"] = true

L["Horizontal spacing"] = true
L["Horizontal space between timers."] = true
L["Vertical spacing"] = true
L["Vertical space between timers."] = true
L["Position of the timer text."] = true

L["No outline"] = true
L["Normal outline"] = true
L["Thick outline"] = true
L["Outline"] = true
L["Outline of the font."] = true

L["Copy Settings"] = true
L["Copies settings on this page to memory."] = true
L["Paste Settings"] = true
L["Applies settings in memory."] = true

-- new in 2.2.4

L["Background texture"] = true
L["Changes the background texture when the effect begins. Does not apply in icon mode."] = true

-- new in 2.2.7
L["Class Filter"] = true
L["Category Filter"] = true
L["Racial"] = true
L["Item"] = true
L["Custom Anchor"] = true
L["You can use these to display certain important spells in a separate anchor. Use the Spell Configuration menu to move spells here."] = true
L["Group anchors show all spells in a category, grouped together."] = true
L["Category Color"] = true
L["Timer bars for spells in this category will appear in this color."] = true
L["SPELLCONFIG_HELPMSG"] = [=[Click a spell's name to enable or disable it.

To change its category, point at the category name and use the dropdown menu.

Click on the on/off buttons to assume the spell is glyphed for that talent specialization. (? is unknown spec)]=]
