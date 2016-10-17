/*
 * Copyright@ Samsung Electronics Co. LTD
 *
 * This software is proprietary of Samsung Electronics.
 * No part of this software, either material or conceptual may be copied or distributed, transmitted,
 * transcribed, stored in a retrieval system or translated into any human or computer language in any form by any means,
 * electronic, mechanical, manual or otherwise, or disclosed
 * to third parties without the express written permission of Samsung Electronics.

 * Alternatively, this program is free software in case of open source projec;
 * you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.

 */


#ifndef __DECON_LCD__
#define __DECON_LCD__

enum decon_psr_mode {
	DECON_VIDEO_MODE = 0,
	DECON_DP_PSR_MODE = 1,
	DECON_MIPI_COMMAND_MODE = 2,
};

/* Mic ratio: 0: 1/2 ratio, 1: 1/3 ratio */
enum decon_mic_comp_ratio {
	MIC_COMP_RATIO_1_2 = 0,
	MIC_COMP_RATIO_1_3 = 1,
	MIC_COMP_BYPASS
};

enum mic_ver {
	MIC_VER_1_1,
	MIC_VER_1_2,
	MIC_VER_2_0,
};

enum type_of_ddi {
	TYPE_OF_SM_DDI = 0,
	TYPE_OF_MAGNA_DDI,
	TYPE_OF_NORMAL_DDI,
};

struct stdphy_pms {
	unsigned int p;
	unsigned int m;
	unsigned int s;
};

struct decon_lcd {
	enum decon_psr_mode mode;
	unsigned int vfp;
	unsigned int vbp;
	unsigned int hfp;
	unsigned int hbp;

	unsigned int vsa;
	unsigned int hsa;

	unsigned int xres;
	unsigned int yres;

	unsigned int width;
	unsigned int height;

	unsigned int hs_clk;
	struct stdphy_pms dphy_pms;
	unsigned int esc_clk;

	unsigned int fps;
	unsigned int mic_enabled;
	enum decon_mic_comp_ratio mic_ratio;
	unsigned int dsc_enabled;
	unsigned int dsc_cnt;
	unsigned int dsc_slice_num;
	enum mic_ver mic_ver;
	enum type_of_ddi ddi_type;
	unsigned int partial_range[2];
};

#endif
