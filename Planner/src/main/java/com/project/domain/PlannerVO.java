package com.project.domain;

import lombok.Data;
import lombok.Getter;

@Getter
@Data
public class PlannerVO {
	private long marker_id;
	private String marker_title;
	private String marker_cost;
	private String marker_time;
	private String marker_page;
}
