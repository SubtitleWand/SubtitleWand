<!--
 Copyright (C) 2020 Tokenyet
 
 This file is part of subtitle-wand.
 
 subtitle-wand is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 subtitle-wand is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with subtitle-wand.  If not, see <http://www.gnu.org/licenses/>.
-->


lib
* components (any high reusable stuff here)
 * project (for used with project handy widgets, like a styled widgets, general useful dialog, styled)
  * helper
   - snackbar_themer
  * frequents
   - any frequent object, should not be used If possible
  styled_widget
 * common (for used anywhere without project dependency)
  - delayed_dropdown
* design
 - color_palette
 - theme ?
* pages
 * _components (main's component deps, If any)
  - sidenavigator
  - select_language_dialog
 * _blocs (main's bloc deps, If any)
  - i18n_bloc
  - simple_bloc_delegate
 * about_page
  - about_page
 * build_page
  * _components
  * _blocs
  * pages
    * old_build_page
    * new_build_page
  - build_page_intro
 * enviroment_page
  * _components
   * dialog
    - changelog_dialog
   * cards
    base_card
    * cpu_card
     * _blocs
     - cpu_card
  * _blocs
  - enviroment_page
 * server_management_page
  * _components
   * dialog
     * server_settings
     * add_server_dialog
     * confimration_dialog
  * _blocs
  - server_management_page
* datas (datas / models / records)
 - any serilizable datas
* repsitories
 - any_repository
* utilities
 * consts
  - property_collections
 - string_utility
 - validators
main_desktop