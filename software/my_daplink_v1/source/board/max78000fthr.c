/**
 * @file    max78000fthr.c
 * @brief   board ID for the Maxim Integrated's MAX78000FTHR
 *
 * DAPLink Interface Firmware
 * Copyright (C) Maxim Integrated Products, Inc., All Rights Reserved
 * SPDX-License-Identifier: Apache-2.0
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may
 * not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "target_family.h"
#include "target_board.h"

const board_info_t g_board_info = {
    .info_version = kBoardInfoVersion,
    .board_id = "0423",
    .family_id = kMaxim_MAX3266X_FamilyID,
    .flags = kEnablePageErase,
    .target_cfg = &target_device,
    .daplink_url_name = "MAX78000HTM",
    .daplink_target_url = "http://www.maximintegrated.com/max78000fthr",
};
