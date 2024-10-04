

# Journey Towards The Deep

## A Strategy Game for NASA Space Apps Challenge Bangladesh 2024

### Description:

Journey Towards The Deep is a strategy game set on a distant planet where the Sun never shines. In this harsh environment, life depends on chemosynthesis—the process of using chemical reactions to produce energy. Your objective is to build a self-sustaining ecosystem by gathering resources, evolving creatures, and expanding your environment. From methane volcanoes to thriving fish ponds, manage resources wisely to ensure survival.

# Game Concept
A world without sunlight requires innovation. Start small, with a methane volcano as your base, and expand by unlocking and upgrading new elements. As you gather more resources, you can purchase more advanced structures and lifeforms, evolving them to adapt to the darkness.

# Screenshots:
![Screenshot 5](s5.png)
![Screenshot 1](s1.png)
![Screenshot 2](s2.png)
![Screenshot 3](s3.png)
![Screenshot 4](s4.png)

# Gameplay Video On Google Drive:
[Gameplay Video](https://drive.google.com/file/d/1l2y-fy7YMc7H8UaOGIPVWYfgTGFzPOn1/view?usp=sharing)

# Team Space Survivors
## Team Leader: Mohammed Hasan
## App Developer: Md. Saiful Hossain
## Researcher: Afia saiara and Mohammed Hasan
## Level Designer: Gazi Shaharabi Anwar Tuhin and Shuvo Nath

# Core Mechanics
## Resource Management

Each element you unlock produces a specific resource (e.g., methane, hydrogen sulfide, ammonia).
These resources are used to purchase and upgrade additional elements.
Resources are limited, so managing them efficiently is crucial for expansion.
Element Interaction

Double-click on elements like volcanoes to generate their associated resource.
Use these resources to unlock more complex systems and evolve lifeforms.
Creature Evolution

As you progress, unlock new creatures that adapt to the planet’s dark conditions.
The ecosystem must evolve from bacteria to more complex organisms like fish, requiring a balance of resources.
Gameplay Progression
Methane Volcano

Produces: Methane
Use: Unlock the next element—Hydrogen Sulfide Volcano.
Hydrogen Sulfide Volcano

Produces: Hydrogen Sulfide
Use: Combine with methane to unlock the Ammonia Volcano.
Ammonia Volcano

Produces: Ammonia
Use: Unlock the Water Generator by combining ammonia, hydrogen sulfide, and methane.
Water Generator

Produces: Water
Use: Essential for life. Unlock the Bacteria Pond with water and previous resources.
Bacteria Pond

Produces: Bacteria
Use: Unlock the Fish Pond to create more advanced life.
Fish Pond

Produces: Fish
Use: Expand your ecosystem and ensure life can thrive.
Advanced Gameplay
Trading System

Trade between volcanic elements and upgrade their production rates to build a more efficient ecosystem.
E.g., Trade methane and ammonia to improve methane production.
Upgrades and Resource Balancing

Upgraded volcanoes and generators produce resources faster, allowing you to advance quicker.
Balance resource production to avoid ecosystem collapse.
Goal of the Game
Build a complex and self-sustaining ecosystem that thrives in complete darkness. Adapt creatures, manage resources, and evolve life on the planet to reach the highest stage of evolution.

# Features:

## No Sunlight Gameplay: Rely on chemical energy for survival.
## Ecosystem Evolution: Manage evolving lifeforms and expanding systems.
## Strategic Resource Management: Trade and upgrade volcanic elements to optimize resource generation.

# How to run the project
simply clone the project and run "flutter pub get" in the terminal on the root project directory
then run the project from the terminal by running the command "flutter run  lib/main_dev.dart or flutter run  lib/main_prod.dart"

# Technologies
1. Flutter
2. Dart
3. sqflite
4. getx

# Architecture and Project Structure
# MVVM
'''bash 
.
├── app
│   ├── bindings
│   │   └── initial_binding.dart
│   ├── core
│   │   ├── base
│   │   │   ├── base_controller.dart
│   │   │   ├── base_view.dart
│   │   │   ├── base_widget_mixin.dart
│   │   │   └── paging_controller.dart
│   │   ├── core_model
│   │   │   ├── audio_player_singleton.dart
│   │   │   ├── entity_manager.dart
│   │   │   ├── logged_user.dart
│   │   │   └── page_state.dart
│   │   ├── db_helper
│   │   │   ├── db_helper.dart
│   │   │   └── db_tables.dart
│   │   ├── exporter.dart
│   │   ├── session_manager
│   │   │   ├── prefs_keys.dart
│   │   │   └── session_manager.dart
│   │   ├── utils
│   │   │   ├── confirmation.dart
│   │   │   ├── debouncer.dart
│   │   │   ├── parser.dart
│   │   │   └── validators.dart
│   │   ├── values
│   │   │   ├── app_assets.dart
│   │   │   ├── app_colors.dart
│   │   │   ├── app_strings.dart
│   │   │   ├── app_values.dart
│   │   │   ├── final_values.dart
│   │   │   ├── global_vars.dart
│   │   │   ├── shorter_enum.dart
│   │   │   └── text_styles.dart
│   │   └── widget
│   │       ├── app_bar_title.dart
│   │       ├── asset_image_view.dart
│   │       ├── custom_app_bar.dart
│   │       ├── dialog_pattern.dart
│   │       ├── draggableobject.dart
│   │       ├── elevated_container.dart
│   │       ├── error_screen.dart
│   │       ├── icon_text_button.dart
│   │       ├── icon_text_widgets.dart
│   │       ├── loaders
│   │       │   ├── color_loader_2.dart
│   │       │   ├── color_loader_5.dart
│   │       │   └── loader_screen.dart
│   │       ├── ripple.dart
│   │       ├── selective_button.dart
│   │       └── zoomablesurface.dart
│   ├── entity
│   │   ├── draggable_object.dart
│   │   ├── particle.dart
│   │   ├── resource.dart
│   │   ├── resource_building.dart
│   │   └── user.dart
│   ├── global_widget
│   │   ├── building_view.dart
│   │   ├── count_view.dart
│   │   ├── resource_upgrader_dialoge.dart
│   │   └── test_global_widget.dart
│   ├── my_app.dart
│   ├── pages
│   │   ├── planet
│   │   │   ├── bindings
│   │   │   │   └── planet_binding.dart
│   │   │   ├── controllers
│   │   │   │   └── planet_controller.dart
│   │   │   └── views
│   │   │       └── planet_view.dart
│   │   ├── shop_page
│   │   │   ├── bindings
│   │   │   │   └── shop_page_binding.dart
│   │   │   ├── controllers
│   │   │   │   └── shop_page_controller.dart
│   │   │   └── views
│   │   │       └── shop_page_view.dart
│   │   └── splash_page
│   │       ├── bindings
│   │       │   └── splash_page_binding.dart
│   │       ├── controllers
│   │       │   └── splash_page_controller.dart
│   │       └── views
│   │           └── splash_page_view.dart
│   ├── routes
│   │   ├── app_pages.dart
│   │   └── app_routes.dart
│   └── service
│       ├── client
│       │   ├── api_options.dart
│       │   ├── error_catcher.dart
│       │   ├── rest_client.dart
│       │   └── utils
│       │       ├── exception_message.dart
│       │       ├── failures.dart
│       │       └── pretty_dio_logger.dart
│       └── services.dart
├── flavors
│   ├── build_config.dart
│   ├── env_config.dart
│   └── environment.dart
├── l10n
│   ├── app_bn.arb
│   └── app_en.arb
├── main_dev.dart
└── main_prod.dart
'''
## State Management

This project uses **GetX** for state management. The relevant files are located in the `lib/app/core/base` directory:

## Libraries Used

- **[get](https://pub.dev/packages/get)**: State management library for Flutter with a focus on simplicity and performance.
- **[nb_utils](https://pub.dev/packages/nb_utils)**: A package for common utility methods and widgets.

# Play Now
Embark on your Journey Towards The Deep today and experience the thrill of building a self-sustaining ecosystem in a world without sunlight.

# Feedback and Support
We value your feedback! If you have any questions, suggestions, or encounter any issues while playing Journey Towards The Deep, please reach out to us. Your input helps us improve the game and provide a better gaming experience.





