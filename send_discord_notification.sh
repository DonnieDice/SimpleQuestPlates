#!/bin/bash

# Discord webhook URL - replace with your actual webhook
DISCORD_WEBHOOK="${1:-YOUR_WEBHOOK_HERE}"

# Full release notes content
curl -H "Content-Type: application/json" \
     -X POST \
     -d '{
       "content": "",
       "username": "SQP Update",
       "avatar_url": "https://raw.githubusercontent.com/donniedice/SimpleQuestPlates/main/images/logo.png",
       "embeds": [{
         "title": "🎯 SimpleQuestPlates - v1.1.0-alpha",
         "description": "**Clean. Simple. Effective.** - A new version of SimpleQuestPlates has been released!\n\n**🎮 Alpha Release - MoP Classic Support**\n\nThis alpha release adds full support for Mists of Pandaria Classic with performance optimizations.\n\n**✨ New Features**\n• **MoP Classic Compatibility**: Full nameplate quest tracking support for MoP Classic\n• **Performance Optimizations**: Reduced lag from icon position updates\n• **Smart Update System**: Adaptive update intervals (faster out of combat, slower in combat)\n• **Nameplate Caching**: Improved performance through intelligent caching\n\n**🔧 Technical Improvements**\n• Created `compat_mop.lua` for MoP-specific nameplate handling\n• Implemented OnUpdate polling system for older nameplate API\n• Added UnitIsQuestBoss support for MoP quest detection\n• Fixed C_TaskQuest API compatibility issues\n\n**⚡ Performance Enhancements**\n• Update interval: 0.2s (normal) / 0.5s (combat)\n• Nameplate lookup caching reduces CPU usage\n• Skip redundant scans when nameplate count unchanged",
         "url": "https://github.com/donniedice/SimpleQuestPlates/releases/tag/v1.1.0-alpha",
         "color": 5820057,
         "thumbnail": {
           "url": "https://raw.githubusercontent.com/donniedice/SimpleQuestPlates/main/images/logo.png"
         },
         "fields": [
           {
             "name": "📥 Downloads",
             "value": "[CurseForge](https://www.curseforge.com/wow/addons/simple-quest-plates)\n[Wago.io](https://addons.wago.io/addons/simple-quest-plates)\n[GitHub](https://github.com/donniedice/SimpleQuestPlates)",
             "inline": true
           },
           {
             "name": "🎮 Compatibility",
             "value": "✅ The War Within\n✅ Classic Era\n✅ Cataclysm\n✅ MoP",
             "inline": true
           },
           {
             "name": "💬 Support",
             "value": "[Join Discord](https://discord.gg/N7kdKAHVVF)\n[Report Issues](https://github.com/donniedice/SimpleQuestPlates/issues)",
             "inline": true
           }
         ],
         "footer": {
           "text": "RGX Mods - RealmGX Community | ⚠️ Alpha Release - Please report any issues!",
           "icon_url": "https://raw.githubusercontent.com/donniedice/SimpleQuestPlates/main/images/kiwi.gif"
         },
         "timestamp": "'"$(date -u +%Y-%m-%dT%H:%M:%S.000Z)"'"
       }]
     }' \
     "$DISCORD_WEBHOOK"

echo "Discord notification sent!"