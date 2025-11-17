extends Node

# Map all acres with tile file variant names

const acres_dictionary = {
	"town_entrance_gate": {
		"tiles": ["c_grd_f_g_1_001","c_grd_f_g_2_001","c_grd_f_g_3_001"]
	},
	"player_home":{
		"tiles": ["c_grd_f_h_1_001","c_grd_f_h_2_001","c_grd_f_h_3_001"],
		"bridge": []
	},
	"town_hall": {
		"tiles": ["c_grd_f_o_1_001","c_grd_f_o_2_001","c_grd_f_o_3_001"],
		"bridge": []
	},
	"shops": {
		"tiles": ["c_grd_f_s_1_001","c_grd_f_s_2_001","c_grd_f_s_3_001"],
		"bridge": []
	},
	"museum": {
		"tiles": ["c_grd_f_m_1_001","c_grd_f_m_2_001","c_grd_f_m_3_001"],
		"bridge": []
	},
	"pond_to_south": {
		"tiles": ["c_grd_r1_f_1_001","c_grd_r1_f_2_001","c_grd_r1_f_3_001","c_grd_r1_f_4_001"],
		"bridge": []
	},
	"river_north_to_south": {
		"tiles": ["c_grd_r1_3_001","c_grd_r1_p_1_001","c_grd_r1_p_2_001"],
		"bridge": ["c_grd_r1_b_1_001","c_grd_r1_b_2_001","c_grd_r1_b_3_001"]
	},
	"river_north_to_east": {
		"tiles": ["c_grd_r4_1_001","c_grd_r4_2_001","c_grd_r4_3_001","c_grd_r4_p_1_001","c_grd_r4_p_2_001"],
		"bridge": ["c_grd_r4_b_1_001","c_grd_r4_b_2_001","c_grd_r4_b_3_001"]
	},
	"river_north_div_west_east": {
		"tiles": ["c_grd_d4_1_001"],
		"bridge": []
	},
	"river_north_div_south_west": {
		"tiles": ["c_grd_d5_1_001","c_grd_d5_1_001"],
		"bridge": []
	},
	"river_north_div_east_south": {
		"tiles": ["c_grd_d1_1_001"],
		"bridge": []
	},
	"river_east_div_south_west": {
		"tiles": ["c_grd_d3_1_001","c_grd_d3_2_001"],
		"bridge": []
	},
	"river_west_div_east_south": {
		"tiles": ["c_grd_d2_1_001","c_grd_d2_2_001"],
		"bridge": []
	},
	"river_north_to_west": {
		"tiles": ["c_grd_r6_1_001","c_grd_r6_2_001","c_grd_r6_3_001","c_grd_r6_p_1_001","c_grd_r6_p_2_001"],
		"bridge": ["c_grd_r6_b_1_001","c_grd_r6_b_2_001","c_grd_r6_b_3_001"]
	},
	"river_west_to_east": {
		"tiles": ["c_grd_r3_1_001","c_grd_r3_2_001","c_grd_r3_3_001","c_grd_r3_p_1_001","c_grd_r3_p_2_001"],
		"bridge": ["c_grd_r3_b_1_001","c_grd_r3_b_2_001","c_grd_r3_b_3_001"]
	},
	"river_east_to_west": {
		"tiles": ["c_grd_r2_1_001","c_grd_r2_2_001","c_grd_r2_3_001","c_grd_r2_p_1_001","c_grd_r2_p_2_001"],
		"bridge": ["c_grd_r2_b_1_001","c_grd_r2_b_2_001","c_grd_r2_b_3_001"]
	},
	"river_east_to_south": {
		"tiles": ["c_grd_r7_1_001","c_grd_r7_2_001","c_grd_r7_3_001","c_grd_r7_p_1_001","c_grd_r7_p_2_001"],
		"bridge": ["c_grd_r7_b_1_001","c_grd_r7_b_2_001","c_grd_r7_b_3_001"]
	},
	"river_west_to_south": {
		"tiles": ["c_grd_r5_1_001","c_grd_r5_2_001","c_grd_r5_3_001","c_grd_r5_p_1_001","c_grd_r5_p_2_001"],
		"bridge": ["c_grd_r5_b_1_001","c_grd_r5_b_2_001","c_grd_r5_b_3_001"]
	},
	"beach_river_north_to_south": {
		"tiles": ["c_grd_m_r1_1_001","c_grd_m_r1_2_001","c_grd_m_r1_3_001"],
		"bridge": ["c_grd_m_r1_b_1_001","c_grd_m_r1_b_2_001","c_grd_m_r1_b_3_001","c_grd_m_r1_b_4_001"]
	},
	"beach_river_north_to_west": {
		"tiles": ["c_grd_m_r6_1_001","c_grd_m_r6_2_001"],
		"bridge": ["c_grd_m_r6_b_1_001","c_grd_m_r6_b_2_001"]
	},
	"beach_river_north_to_east": {
		"tiles": ["c_grd_m_r4_1_001","c_grd_m_r4_2_001"],
		"bridge": ["c_grd_m_r4_b_1_001","c_grd_m_r4_b_2_001"]
	},
	"beach_river_east_to_south": {
		"tiles": ["c_grd_m_r7_1_001","c_grd_m_r7_2_001"],
		"bridge": ["c_grd_m_r7_b_1_001","c_grd_m_r7_b_2_001"]
	},
	"beach_river_west_to_south": {
		"tiles": ["c_grd_m_r5_1_001","c_grd_m_r5_2_001"],
		"bridge": ["c_grd_m_r5_b_1_001","c_grd_m_r5_b_2_001"]
	},
	"beach": {
		"tiles": ["c_grd_m_1_001","c_grd_m_2_001","c_grd_m_3_001","c_grd_m_4_001"],
		"bridge": []
	},
	"grass": {
		"tiles": ["c_grd_f_1_002","c_grd_f_1_003","c_grd_f_2_001","c_grd_f_3_001","c_grd_f_4_001","c_grd_f_5_001","c_grd_f_6_001"],
		"bridge": []
	},
}
