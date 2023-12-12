package com.project.service;

import java.util.List;

import com.project.domain.PlannerVO;

public interface PlannerService {

	//전체셀렉트
	public List<PlannerVO> selectMarkers();
	
	//단일셀렉트
	public PlannerVO selectMarker(PlannerVO planner);
	
	//인서트
	public long insertMarker(PlannerVO planner);
	
	//업데이트
	//델리트
	
	//마커아이디부여
	long createPlanner(PlannerVO plannerVO);
	
	//좌측박스관리 - 전체셀렉트와 코드가 같음
	List<PlannerVO> getAllMarkers();
	
}
