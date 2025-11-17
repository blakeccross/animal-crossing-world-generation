const tiles = {
	"town_entrance_gate": {
		"north": [],
		"south": [],
		"east": [],
		"west": [],
	},
	"pond_to_south": {
		"north": [],
		"south": ["river_north_to_south", "river_north_to_east","river_north_to_west","river_north_div_west_east","river_north_div_east_south"],
		"east": [],
		"west": [],
	},
	"river_north_to_south": {
		"north": ["river_north_to_south", "river_west_to_south","pond_to_south","river_east_to_south","river_north_div_east_south"],
		"south": ["river_north_to_south", "river_north_to_east","river_north_to_west","river_north_div_west_east","river_north_div_east_south"],
		"east": [],
		"west": [],
	},
	"river_north_to_east": {
		"north": ["river_north_to_south","river_west_to_south","pond_to_south","river_north_div_east_south"],
		"south": [],
		"east": ["river_west_to_south","river_west_to_east"],
		"west": [],
	},
	"river_north_div_west_east": {
		"north": ["pond_to_south","river_north_to_south","river_east_to_south","river_west_to_south","river_north_div_east_south"],
		"south": [],
		"east": ["river_west_to_east","river_west_to_south"],
		"west": ["river_east_to_west","river_east_to_south"],
	},
	"river_north_div_east_south": {
		"north": ["pond_to_south","river_north_to_south","river_east_to_south","river_west_to_south"],
		"south": ["river_north_to_south", "river_north_to_east","river_north_to_west","river_north_div_west_east","river_north_div_east_south"],
		"east": ["river_west_to_east","river_west_to_south"],
		"west": [],
	},
	"river_north_to_west": {
		"north": ["river_north_to_south","pond_to_south","river_east_to_south","river_north_div_east_south","river_west_to_south"],
		"south": [],
		"east": [],
		"west": ["river_east_to_west","river_east_to_south"],
	},
	"river_west_to_east": {
		"north": [],
		"south": [],
		"east": ["river_west_to_south","river_west_to_east"],
		"west": ["river_west_to_east","river_north_to_east","river_north_div_west_east","river_north_div_east_south"],
	},
	"river_east_to_west": {
		"north": [],
		"south": [],
		"east": ["river_east_to_west","river_north_to_west","river_north_div_west_east"],
		"west": ["river_east_to_west","river_east_to_south"],
	},
	"river_east_to_south": {
		"north": [],
		"south": ["river_north_to_south","river_north_to_west","river_north_div_west_east"],
		"east": ["river_east_to_west","river_north_to_west","river_north_div_west_east"],
		"west": [],
	},
	"river_west_to_south": {
		"north": [],
		"south": ["river_north_to_south","river_north_to_east","river_north_to_west","river_north_div_west_east","river_north_div_east_south"],
		"east": [],
		"west": ["river_north_to_east","river_west_to_east","river_north_div_west_east","river_north_div_east_south"],
	},
}
