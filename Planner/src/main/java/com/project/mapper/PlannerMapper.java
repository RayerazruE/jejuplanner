package com.project.mapper;

import java.util.List;

import com.project.domain.PlannerVO;

public interface PlannerMapper {

	public List<PlannerVO> selectMarkers(); //전체셀렉트
	public PlannerVO selectMarker(PlannerVO planner); //단일셀렉트
 	public boolean insertMarker(PlannerVO planner); //인서트
	public boolean updateMarker(PlannerVO planner); //업데이트
	public boolean deleteMarker(PlannerVO planner); //델리트
	
	void insertPlanner(PlannerVO plannerVO); //마커아이디부여
	
	List<PlannerVO> getAllMarkers();
	
}
